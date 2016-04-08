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
			$user->{form} = GET_FORM($env, $user);
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
		foreach my $u (@$users) {
			push (@$link, {
				href => '/api/v1/auth/user/'.($u->{login}||''),
				title => $u->{login},
				rel => 'Auth::User::Id'
			});
		}
	
		return {link => $link};
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

### Return form for gray pages
sub GET_FORM {
	my ($env, $content) = @_;

	if ($env->{'rest.userid'}){
		return {
			get => undef,
			put => {
				params => [{
					type => 'textarea',
					name => 'DATA',
					default => $content
				}]
			}
		}
	}
}

1;