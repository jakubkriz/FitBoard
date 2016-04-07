package Plack::App::RESTMy;

use strict;
use warnings;

use parent 'Plack::App::REST';

use Plack::Util::Accessor qw(const rmap auth data);

use Auth::Store;

sub new {
	my ($class, $const, $rmap) = @_;
	my $self = $class->SUPER::new();

	$self->{const} = $const;
	$self->{auth} = Auth::Store->new( $const );
	$self->{data} = Event::Store->new( $const );
	$self->{rmap} = $rmap;

	return $self;
}

sub returnResourcesLinks {
	my ($self, $env, $rMap) = @_;

	my $restMap = $rMap ? $rMap : $self->rmap->{resources};

	my $links;
	my $restNewMap = {};
	$self->restMount('',$restMap,$restNewMap);
	foreach my $resource (sort {($restNewMap->{$a}{class}||$restNewMap->{$a}{ref}) cmp ($restNewMap->{$b}{class}||$restNewMap->{$b}{ref})}  keys %{$restNewMap}) {
		my $mod = $restNewMap->{$resource}{ref} || $restNewMap->{$resource}{class}||undef;
		next unless $mod;
		push @$links, {
			href => $self->refToUrl($env, $mod, {}),
			title => $mod,
			rel => $mod,
		}
	}
	return $links;
}

sub restMount {
	my ($self, $uri,$rMap,$restNewMap) = @_;
	my $staticEnv = $self->const->get("PlackEnv") ne "deployment"?"development":$self->const->get("PlackEnv");
	foreach my $key (keys %{$rMap}) {
		next if ( $key =~ /^\/\*$/ );
		if (exists $rMap->{$key}{class} or exists $rMap->{$key}{ref} or exists $rMap->{$key}{resources} ){
			my $stat = $uri."".$key;
			if (exists $rMap->{$key}{class} or exists $rMap->{$key}{ref}){
				$restNewMap->{$stat}{ref} = $rMap->{$key}{ref} if  $rMap->{$key}{ref};
				$restNewMap->{$stat}{class} = $rMap->{$key}{class} if  $rMap->{$key}{class};
				$restNewMap->{$stat}{unauthorized} = $rMap->{$key}{unauthorized} if $rMap->{$key}{unauthorized};
			}
			if(exists $rMap->{$key}{resources}){
				$self->restMount($stat,$rMap->{$key}{resources},$restNewMap);
			}
		}
	}
}

sub structToLinksByType {
	my ($self, $rel, $base, $data) = @_;

	my @links;
	foreach my $type (sort keys %$data) {
		foreach my $key (sort keys %{$data->{$type}}){
			my $val = $data->{$type}{$key};
			push @links, $self->idToLink($rel, $base.'/'.$type, $val->{id}, $val->{name});
		}
	}

	return \@links;
}

sub structToLinks {
	my ($self, $rel, $base, $data) = @_;

	my @links;
	foreach my $key (sort keys %$data) {
		push @links, $self->idToLink($rel, $base, $data->{$key}{id}, $data->{$key}{name});
	}

	return \@links;
}

sub idToLink {
	my ($self, $rel, $base, $id, $name) = @_;

	return {
		href => $base.'/'.$id,
		title => ($name||$id),
		rel => $rel
	}
}

sub refToUrl {
	my ($self, $env, $ref, $params) = @_;
	my $refToUrl = $self->const->get("RefToUrl");
	if (exists $refToUrl->{$ref}){
		my $pl = $refToUrl->{$ref}{placeholders};
		my $url = $refToUrl->{$ref}{url};
		if ($pl && %$pl){
			foreach my $key (keys %$pl){
				if ($params->{$key}){
					$url =~ s/$pl->{$key}/$params->{$key}/;
				}elsif ($env->{$key}){
					$url =~ s/$pl->{$key}/$env->{$key}/;
				}else{
					die 'Set placeholder '.$key;
				}
			}
		}
		return $url;
	}
	return undef;
}

sub getRestMap {
	my ($self, $ref, $restMap) = @_;

	my $return;

	$restMap = $self->const->get("RestMap") unless $restMap;

	foreach my $url (sort keys %$restMap){
		my $rc = ($restMap->{$url}{ref}||$restMap->{$url}{class});
		return $restMap->{$url} if ($rc && ($rc eq $ref));

		if (exists $restMap->{$url}{resources}){
			$return = $self->getRestMap($ref, $restMap->{$url}{resources});
			return $return if $return;
		}
	}
}

sub getLinksForResource {
	my ($self, $resource, $params) = @_;
	my $RestMap = $self->getRestMap($resource);

	my $links;
	foreach my $url (sort keys %{$RestMap->{resources}}){
		my $rm = $RestMap->{resources}{$url};
		push @$links, {
			href => $self->refToUrl(($rm->{ref}||$rm->{class}),$params),
			title => ($rm->{ref}||$rm->{class}),
			rel => ($rm->{ref}||$rm->{class}),
		}
	}
	return $links;
}

1;