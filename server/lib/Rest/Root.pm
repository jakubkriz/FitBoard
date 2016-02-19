package Rest::Root;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

sub GET {
	my ($self, $env, $params) = @_;

	### Get all links
	my $links;
	my $map = $self->const->get("RestMap");
	my $prefix = $self->const->get("ApiPrefix");
	my $version = $env->{'rest.apiversion'};
	my $restNewMap = {};
	my $mapByApi = $map->{'/api'}{resources}{'/'.$version}{'resources'};
	$self->restMount('',$mapByApi,$restNewMap);
	foreach my $resource (sort {($restNewMap->{$a}{class}||$restNewMap->{$a}{ref}) cmp ($restNewMap->{$b}{class}||$restNewMap->{$b}{ref})}  keys %{$restNewMap}) {
		my $mod = $restNewMap->{$resource}{ref} || $restNewMap->{$resource}{class}||"NONE";
		eval "require $mod";
		if ($@){
			$mod = "*". $mod;
		}
			push @$links, {
				href => '/api/'.$version.$resource,
				title => $mod,
				rel => $mod,
			}
	}

	return {
		link => $links,
		ApiVersion => $version,
		user => $env->{'rest.login'},
	};
}

##should be in Middleware
sub restMount {
	my ($self, $uri,$rMap,$restNewMap) = @_;
	my $staticEnv = $self->const->get("PlackEnv") ne "deployment"?"development":$self->const->get("PlackEnv");
	foreach my $key (keys %{$rMap}) {
		next if ( $key =~ /^\/\*$/ );
		if (exists $rMap->{$key}{class} or exists $rMap->{$key}{ref} or exists $rMap->{$key}{resources} ){
			my $stat = $uri."".$key;
			$restNewMap->{$stat}{ref} = $rMap->{$key}{ref} if  $rMap->{$key}{ref};
			$restNewMap->{$stat}{class} = $rMap->{$key}{class} if  $rMap->{$key}{class};
			$restNewMap->{$stat}{unauthorized} = $rMap->{$key}{unauthorized} if $rMap->{$key}{unauthorized};
			if(exists $rMap->{$key}{resources}){
				$self->restMount($stat,$rMap->{$key}{resources},$restNewMap);		
			}
		}
	}
}

1;