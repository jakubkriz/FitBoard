package Rest::Const;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

sub GET {
	my ($self, $env, $params) = @_;

	### Get all links
	my $links = $self->returnResourcesLinks($env);

	return {
		link => $links,
		ApiVersion => $env->{'rest.apiversion'},
		user => $env->{'rest.login'},
	};
}

1;