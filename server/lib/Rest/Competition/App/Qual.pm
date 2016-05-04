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

			if ($users_reserved && @$users_reserved && $users_reserved->[0]{judge}){
				$users_reserved = [];
			}

			if (!@$users_reserved){
				my $all = $self->qual->getAllUsers($env);
				my $users_cat1 = [];
				foreach my $q (@$all){
					next if $q->{judge} || $q->{reserved};
					my $u = $self->auth->getUser($env, $q->{login});
					if ($login_info->{judge} eq 'em'){
						push (@$users_cat1, $q) if ($u->{category} eq 'masters' || $u->{category} eq 'elite');
					}elsif($login_info->{judge} eq 'o'){
						push (@$users_cat1, $q) if ($u->{category} eq 'open');
					}
				}
				if (@$users_cat1){
					my $pos = int(rand(scalar @$users_cat1 - 1));
					$users_reserved = [$users_cat1->[$pos]];
				}
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
			my $u_info = $self->auth->getUser($env, $u->{login});
			push (@$user_qual, {
				href => $self->refToUrl($env, 'Rest::Competition::Qual::UserId', {'rest.userid'=>($u->{login}||'')}),
				login => $u->{login},
				video => $u->{video},
				pointsA => $u->{pointsA},
				pointsB => $u->{pointsB},
				pointsA_j => $u->{pointsA_j},
				pointsA_j_norep => $u->{pointsA_j_norep},
				pointsB_j => $u->{pointsB_j},
				overallA => $u->{overallA},
				judge => ($u->{judge}||''),
				firstName => $u_info->{firstName},
				lastName => $u_info->{lastName},
				category => $u_info->{category},
				sex => $u_info->{sex},
			});
		}
		my $users_res;
		foreach my $u (@$users_reserved) {
			my $u_info = $self->auth->getUser($env, $u->{login});
			push (@$users_res, {
				href => $self->refToUrl($env, 'Rest::Competition::Qual::UserId', {'rest.userid'=>($u->{login}||'')}),
				login => $u->{login},
				video => $u->{video},
				pointsA => $u->{pointsA},
				pointsB => $u->{pointsB},
				pointsA_j => $u->{pointsA_j},
				pointsA_j_norep => $u->{pointsA_j_norep},
				pointsB_j => $u->{pointsB_j},
				overallA => $u->{overallA},
				reserved => ($u->{reserved}||''),
				firstName => $u_info->{firstName},
				lastName => $u_info->{lastName},
				category => $u_info->{category},
				sex => $u_info->{sex},
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

		return {link => $link, usersQual=>$user_qual, usersReserved=>$users_res};
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
			if (!$user->{reserved} && !$user->{judge}){
				### Update user
				$self->qual->updateUser($env, $qual_login, { '$set' => {'reserved' => $login} });
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
			if ($user->{reserved} eq $login){
				$data->{'reserved'} = '';
				$data->{'judge'} = $login;

				### Update user
				$self->qual->updateUser($env, $qual_login, { '$set' => $data });
			}else{
				HTTP::Exception::400->throw(message=>"Judge not reserved for this qual");
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

	if ($env->{'rest.qualtype'} eq 'reserve'){
		my $users = $self->qual->getAllUsers($env, {reserved => $login});
		if ($users && @$users && $users->[0]->{reserved} && $users->[0]->{reserved} eq $login){
			my $ret = $self->qual->updateUser($env, $users->[0]->{login}, {'$set'=>{reserved=>''}});
			return $ret;
		}else{
			return {};
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
			delete => { params => {} },
			post => {
				params => {
					DATA => {
						type => 'textarea',
						name => 'DATA',
						default => join("\n", '---',"login: login")
					}					
				}
			}
		}
	}elsif ($env->{'rest.qualtype'} eq 'judge'){
		return {
			get => undef,
			post => {
				params => {
					DATA => {
						type => 'textarea',
						name => 'DATA',
						default => join("\n", '---',"login: login","pointsA_j: 0","pointsA_j_norep: 0","pointsB_j: 0")
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