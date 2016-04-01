package Auth::User;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw(auth);
use Plack::Session;
use MIME::Base64;

use HTTP::Exception qw(3XX);

sub GET {
	my ($self, $env) = @_;

	my $users = $self->auth->getUsers($env);
	
	my $link = ();
	foreach my $u (@$users) {
		push (@$link, {
			href => '/api/v1/auth/user/'.$u->{login},
			title => $u->{login},
			rel => 'Auth::User::Id'
		});
	}
	
	return {link => $link};
}

sub POST {
	my ($self, $env, $params, $data) = @_;
}

1;