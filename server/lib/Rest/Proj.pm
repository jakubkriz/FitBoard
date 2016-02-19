package Rest::Proj;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

sub GET {
	my ($self, $env, $params) = @_;

	my $session = Plack::Session->new($env);

	my $id = $env->{'rest.projectid'};

	my $links;

	if ($id){
		$self->data->setColl($self->const->get('Md_project_coll'), $self->const->get('Md_project_db'));

		my $content = $self->data->get($id);

		return {
			link => $self->getLinksForResource("Rest::Proj::Id", {'rest.projectid'=>$id, 'rest.apiversion'=>$env->{'rest.apiversion'}}),
			project => $content,
		};
		
	}else{
		### Get all links
		foreach my $proj (@{$session->get("projects")}) {
			push @$links, {
				href => $self->refToUrl("Rest::Proj::Id",{'rest.projectid'=>$proj, 'rest.apiversion'=>$env->{'rest.apiversion'}}),
				title => $proj,
				rel => 'Rest::Proj::Id',
			}
		}
	}

	return {
		link => $links,
	};
}

1;