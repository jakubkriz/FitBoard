package Rest::Competition;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';
use Event::Store;

use HTTP::Exception;

sub GET {
	my ($self, $env) = @_;

	my $id = exists $env->{'rest.competitionid'}?$env->{'rest.competitionid'}:undef;

	### todo: set competitons from db

	my $link = $self->returnResourcesLinks($env);

	if ($id){
		return {title => $id, link=>$link};
	}else{

		foreach my $u ('fitmonster2016') {
			push (@$link, {
				href => $self->refToUrl($env, 'Rest::Competition::Id', {'rest.competitionid' => $u}),
				title => $u,
				rel => 'Rest::Competition::Id'
			});
		}
		return {link => $link};
	}	
}

1;