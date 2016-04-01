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
}

sub POST {
	my ($self, $env, $params, $data) = @_;
}

1;