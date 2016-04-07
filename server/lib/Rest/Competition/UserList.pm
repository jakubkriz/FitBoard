package Rest::Competition::UserList;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw();
use Plack::Session;
use MIME::Base64;
use IDGen;

use utf8;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

sub GET {
	my ($self, $env) = @_;
	
	my $link = $self->returnResourcesLinks($env);

	return { link => $link };
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	return {}
}

1;