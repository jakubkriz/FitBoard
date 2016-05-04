package Rest::Competition::App::Qual;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use MIME::Base64;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use Store::Qual;

use utf8;

use open IO => ':encoding(utf8)';

use YAML::Syck;
$YAML::Syck::ImplicitUnicode = 1;

sub GET {
	my ($self, $env, $id) = @_;

	# get login
	my $login = $env->{'psgix.session'}{user_id};
	HTTP::Exception::403->throw(message=>"Forbidden") unless $login;
	my $login_info = $self->auth->getUser($env, $login);

	my $type = $env->{'rest.qualtype'} ? lc($env->{'rest.qualtype'}) : '';
	my $compid = $env->{'rest.competitionid'};

	if ($type eq 'reserve'){
		return {'reserve by post' => 1};
	}elsif ($type eq 'judge'){
		return {'judge by post' => 1};
	}else{

		my $users = []; my $users_reserved = [];
		if($login_info->{judge}){
			$users = $self->qual->getAllUsers($env,{judge=>$login});
			$users_reserved = $self->qual->getAllUsers($env,{reserved=>$login});
			if (!@$users_reserved){
				my $all = $self->qual->getAllUsers($env, {
					'$and' => [{
						'$or'=>[
							{judge=>''},
							{judge=>'null'}, 
							{judge=>{'$exists'=>'false'}},
						]},
						{'$or'=>[
							{reserved=>''},
							{reserved=>'null'}, 
							{reserved=>{'$exists'=>'false'}}
						]
					}]
				});
				my $pos = int(rand(scalar @$all - 1));
				$users_reserved = [$all->[$pos]];
			}
		}elsif ($login_info->{admin}){
			$users = $self->qual->getAllUsers($env, {
				'$and'=>[
					{judge=>{'$ne'=>''}}, 
					{judge=>{'$ne'=>'null'}}, 
					{judge=>{'$exists'=>'true'}}
				]
			});
			$users_reserved = $self->qual->getAllUsers($env,{
				'$and'=>[
					{reserved=>{'$ne'=>''}}, 
					{reserved=>{'$ne'=>'null'}},
					{reserved=>{'$exists'=>'true'}}
				]
			});
		}else{
			HTTP::Exception::403->throw(message=>"Forbidden");
		}
		
		my $user_qual;
		foreach my $u (@$users) {
			push (@$user_qual, {
				href => $self->refToUrl($env, 'Rest::Competition::Qual::UserId', {'rest.userid'=>($u->{login}||'')}),
				login => $u->{login},
				video => $u->{video},
				points => $u->{points},
				pointsA => $u->{pointsA},
				pointsB => $u->{pointsB},
				judge => ($u->{judge}||'')
			});
		}
		my $users_res;
		foreach my $u (@$users_reserved) {
			push (@$users_res, {
				href => $self->refToUrl($env, 'Rest::Competition::Qual::UserId', {'rest.userid'=>($u->{login}||'')}),
				login => $u->{login},
				video => $u->{video},
				points => $u->{points},
				pointsA => $u->{pointsA},
				pointsB => $u->{pointsB},
				reserved => ($u->{reserved}||'')
			});
		}
		my $link = ();
		push (@$link,
		{
			href => $self->refToUrl($env, 'Rest::Competition::App::Qual::Type', {'rest.qualtype'=>'reserve'}),
			title => 'Reserve qualification',
			rel => 'Rest::Competition::App::Qual::Type'
		},
		{
			href => $self->refToUrl($env, 'Rest::Competition::App::Qual::Type', {'rest.qualtype'=>'judge'}),
			title => 'Judge qualification',
			rel => 'Rest::Competition::App::Qual::Type'
		});

		return {link => $link, users_qual=>$user_qual, users_reserved=>$users_res};
	}
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	if (!$data || ref $data ne 'HASH'){
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	if (! $data->{login}){
		HTTP::Exception::400->throw(message=>"Login has to be defined");
	}

	# Get login
	my $login = $env->{'psgix.session'}{user_id};
	HTTP::Exception::403->throw(message=>"Forbidden") unless $login;
	my $login_info = $self->auth->getUser($env, $login);

	if (!$login_info->{admin} || !$login_info->{judge}){
		HTTP::Exception::403->throw(message=>"Forbidden");
	}

	my $type = $env->{'rest.qualtype'} ? lc($env->{'rest.qualtype'}) : '';
	my $compid = $env->{'rest.competitionid'};

	if ($type eq 'reserve'){
		my $qual_login = $data->{login};
		if ($self->qual->checkUserExistence($env, $qual_login)){
			my $user = $self->qual->getUser($env, $qual_login);
			if (!$user->{reserved}){
				### Update user
				$self->qual->updateUser($env, $qual_login, { '$set' => {'reserved' => $qual_login} });
			}else{
				HTTP::Exception::400->throw(message=>"Qual taken by another judge");
			}
		}else{
			HTTP::Exception::400->throw(message=>"Qual for user doesn't exists");
		}
		
	}elsif ($type eq 'judge'){
		my $qual_login = $data->{login};
		if ($self->qual->checkUserExistence($env, $qual_login)){
			my $user = $self->qual->getUser($env, $qual_login);
			if ($user->{reserved} eq $qual_login){
				$data->{'reserved'} = '';
				$data->{'judge'} = $qual_login;

				### Update user
				$self->qual->updateUser($env, $qual_login, { '$set' => $data });
			}else{
				HTTP::Exception::400->throw(message=>"Judge not reserved qual");
			}
		}else{
			HTTP::Exception::400->throw(message=>"Qual for user doesn't exists");
		}

	}else{
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	return { qual => undef };
}

sub DELETE {
	my ($self, $env, $params, $data) = @_;

	# Get login
	my $login = $env->{'psgix.session'}{user_id};
	HTTP::Exception::403->throw(message=>"Forbidden") unless $login;
	my $login_info = $self->auth->getUser($env, $login);

	if (!$login_info->{admin} || !$login_info->{judge}){
		HTTP::Exception::403->throw(message=>"Forbidden");
	}

	if ($env->{'rest.qualtype'} eq 'reserve' && $data->{login}){
		my $user = $self->qual->getUser($env, $data->{login});
		if ($user && $user->{reserved} && $user->{reserved} eq $login){
			my $ret = $self->qual->removeUser($env, $data->{login});
			return $ret;
		}else{
			return HTTP::Exception::405->throw(message=>"Login not reserved for this judge");
		}

	}else{
		return HTTP::Exception::405->throw(message=>"Bad request");
	}
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $content, $par) = @_;

	if ($env->{'rest.qualtype'} eq 'reserve'){
		return {
			get => undef,
			delete => {
				params => {}
			},
			post => {
				params => {
					login => {
						type => 'text',
						name => 'login',
						default => ''
					}					
				}
			}
		}
	}else{
		return {
			get => undef
		}
	}
}

1;