package Auth::User;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw(auth);
use Plack::Session;
use MIME::Base64;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use YAML::Syck;
$YAML::Syck::ImplicitUnicode = 1;

sub GET {
	my ($self, $env, $id) = @_;

	my $login = $env->{'psgix.session'}{user_id};
	my $login_info = $self->auth->getUser($env, $login);

	my $userid = $env->{'rest.userid'};

	if ($userid){
		my $user;
		if (defined $login_info->{admin} || $userid eq $login){
			$user = $self->auth->getUser($env, $userid);
		}

		if ($user){
			return $user;
		}else{
			HTTP::Exception::404->throw(message=>"Not found");
		}
	}else{

		my $users = [];
		if ($login_info->{admin}){
			$users = $self->auth->getAllUsers($env);
		}else{
			$users = $self->auth->getAllUsers($env,{login=>$login});
		}
		
		my $link = ();
		my $qualFee; my $registred; my $user_list;
		foreach my $u (@$users) {
			push (@$user_list, {
				href => '/api/v1/auth/user/'.($u->{login}||''),
				firstName => $u->{firstName},
				lastName => $u->{lastName},
				login => $u->{login},
				bDay => $u->{bDay},
				qualFee => $u->{qualFee},
				registred => $u->{registred},
				gym => $u->{gym},
				category => $u->{category},
				phone => $u->{phone},
				sex => $u->{sex},
				shirt => $u->{shirt}
			});
			push (@$link, {
				href => '/api/v1/auth/user/'.($u->{login}||''),
				title => $u->{login}.' - '.$u->{firstName}.' '.$u->{lastName},
				rel => 'Auth::User::Id'
			});
			$qualFee++ if $u->{qualFee} && $u->{registred};
			$registred++ if $u->{registred};
		}
	
		return {link => $link, count=>scalar @$users, 'qualFee(registred)' => $qualFee, registred => $registred, users=>$user_list};
	}
}

sub PUT {
	my ($self, $env, $params, $data) = @_;

	my $userid = $env->{'rest.userid'};
	return HTTP::Exception::405->throw(message=>"Bad request") unless $userid;

	if ($data->{login} ne $userid){
		HTTP::Exception::400->throw(message=>"Login can't be changed. Drop and create new user.");
	}

	my $pswd = delete $data->{password};

	### Update user data
	$self->auth->updateUser($env, $userid, { '$set' => $data });

	$data->{password} = $pswd;
	return $data
}

sub DELETE {
	my ($self, $env, $params, $data) = @_;

	my $userid = $env->{'rest.userid'};
	return HTTP::Exception::405->throw(message=>"Bad request") unless $userid;

	my $ret = $self->auth->removeUser($env, $userid);

	return $ret;
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $content, $par) = @_;

	if ($env->{'rest.userid'}){
		return {
			get => undef,
			delete => {
				params => {}
			},
			put => {
				params => {
					DATA => {
						type => 'textarea',
						name => 'DATA',
						default => $content
					}
				}
			}
		}
	}
}

1;