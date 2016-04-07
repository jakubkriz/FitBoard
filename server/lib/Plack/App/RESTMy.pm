package Plack::App::RESTMy;

use strict;
use warnings;

use parent 'Plack::App::REST';

use Plack::Util::Accessor qw(const auth data);

use Auth::Store;

sub new {
	my ($class, $const) = @_;
	my $self = $class->SUPER::new();

	$self->{const} = $const;
	$self->{auth} = Auth::Store->new( $const );
	$self->{data} = Event::Store->new( $const );

	return $self;
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