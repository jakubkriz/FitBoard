package Plack::App::URLMapMatch;
use strict;
use warnings;
use parent qw(Plack::Component);
use constant DEBUG => $ENV{PLACK_URLMAP_DEBUG};

use Carp ();

sub mount { shift->map(@_) }

sub map {
		my $self = shift;
		my (%params) = @_;

		my $const = delete $params{const};
		my($location, $app) = %params;

		my @path = split ('/',$location);
		shift @path; # delete first empty slash
		my $hash = {};
		$self->{apiUrl} = {} unless exists $self->{apiUrl};
		my $apiUrl = $self->{apiUrl};
		foreach my $key (@path){
				if ($key =~ /^\*$/){
					$key = '_VARIABLE_';
				}
				unless (exists $apiUrl->{$key}){
					$apiUrl->{$key} = {} ;
				}
#				$apiUrl->{$key} = {} unless exists $apiUrl->{$key};
				$apiUrl = $apiUrl->{$key};
		}
		$apiUrl->{'_NOSTRICT_'} = 1 if ($const->{nostrict});
		$apiUrl->{'_PARAM_'} = 1 if(exists $const->{class} and exists $const->{ref} and ($const->{ref} ne $const->{class}) and !$const->{env});
		$apiUrl->{'_STRICT_'} = $const->{strict} if $const->{strict};
		$apiUrl->{'_ENV_'} = $const->{env} if exists $const->{env};
		$apiUrl->{_APP_} = $app;

}

sub call {
		my ($self, $env) = @_;
		my @path = split ('/',$env->{PATH_INFO});
		shift @path; 
		my @pathinfo = @path;
		my $apiUrl = $self->{apiUrl};
		my @last_path;
		foreach my $key (@path){
			if(exists $apiUrl->{$key}){
				$apiUrl = $apiUrl->{$key};
				$env->{$apiUrl->{'_ENV_'}}=$key if $apiUrl->{'_ENV_'};
				if($apiUrl->{"_PARAM_"}){
					push @last_path ,shift @pathinfo;	
				}else{
					shift @pathinfo;
				}
			}elsif (exists $apiUrl->{"_VARIABLE_"}){
				$apiUrl = $apiUrl->{"_VARIABLE_"};
				$env->{$apiUrl->{'_ENV_'}}=$key if $apiUrl->{'_ENV_'};
				if($apiUrl->{"_PARAM_"}){
					push @last_path ,shift @pathinfo;	
				}else{
					shift @pathinfo;
				}
			}else{
				if (exists $apiUrl->{'_NOSTRICT_'} ){
					last;	
				}else{
					return [404, [ 'Content-Type' => 'text/plain' ], [ "Not Found" ]];	
				}
			}
		}
		if ($apiUrl->{_APP_}){
			#@last_path = undef unless $apiUrl->{"_PARAM_"};
			my $orig_path_info = (@path)?'/'.join "/",@path:'/';
			$env->{PATH_INFO} = '/'. (@last_path?join "/",@last_path:'') . join "/",@pathinfo;
			$env->{SCRIPT_NAME} = (@path)?'/'.join "/",@path:'/';
#			return $apiUrl->{_APP_}->($env);
			return $self->response_cb($apiUrl->{_APP_}->($env), sub {
						$env->{PATH_INFO} = $orig_path_info;
						});

		}else{
			return [404, [ 'Content-Type' => 'text/plain' ], [ "Not Found" ]];
		}
}

1;

__END__

=head1 NAME

Plack::App::URLMapMatch - Map multiple apps in different paths + add posibbility to match placeholders in url
Map directly and add env variable with value from placeholder in url.
ex. /foo/*/app/test map /foo/bar/app/test directly and set "bar" to env.

Is a little faster for short url than URLMap.

=head1 SYNOPSIS

	use Plack::App::URLMapMatch;

	my $app1 = sub { ... };
	my $app2 = sub { ... };

	my $urlmap = Plack::App::URLMapMatch->new;
	$urlmap->map("/" => $app1);
	$urlmap->map("/foo/*/bar" => $app2, const=>{ env=>'myapp.url.var1' });

	my $app = $urlmap->to_app;

=head1 DESCRIPTION

Plack::App::URLMapMatch is a PSGI application that can dispatch multiple
applications based on URL path and host names (a.k.a "virtual hosting")
and takes care of rewriting C<SCRIPT_NAME> and C<PATH_INFO> (See
L</"HOW THIS WORKS"> for details). This module is inspired by
Ruby's Rack::URLMap.

=head1 METHODS

=over 4

=item map

	$urlmap->map("/foo" => $app);
	$urlmap->map("http://bar.example.com/" => $another_app);

Maps URL path or an absolute URL to a PSGI application. The match
order is sorted by host name length and then path length (longest strings
first).

URL paths need to match from the beginning and should match completely
until the path separator (or the end of the path). For example, if you
register the path C</foo>, it I<will> match with the request C</foo>,
C</foo/> or C</foo/bar> but it I<won't> match with C</foox>.

Mapping URLs with host names is also possible, and in that case the URL
mapping works like a virtual host.

Mappings will nest.  If $app is already mapped to C</baz> it will
match a request for C</foo/baz> but not C</foo>. See L</"HOW THIS
WORKS"> for more details.

=item mount

Alias for C<map>.

=item to_app

	my $handler = $urlmap->to_app;

Returns the PSGI application code reference. Note that the
Plack::App::URLMap object is callable (by overloading the code
dereference), so returning the object itself as a PSGI application
should also work.

=back

=head1 PERFORMANCE

If you C<map> (or C<mount> with Plack::Builder) N applications,
Plack::App::URLMap will need to at most iterate through N paths to
match incoming requests.

It is a good idea to use C<map> only for a known, limited amount of
applications, since mounting hundreds of applications could affect
runtime request performance.

=head1 DEBUGGING

You can set the environment variable C<PLACK_URLMAP_DEBUG> to see how
this application matches with the incoming request host names and
paths.

=head1 HOW THIS WORKS

This application works by I<fixing> C<SCRIPT_NAME> and C<PATH_INFO>
before dispatching the incoming request to the relocated
applications.

Say you have a Wiki application that takes C</index> and C</page/*>
and makes a PSGI application C<$wiki_app> out of it, using one of
supported web frameworks, you can put the whole application under
C</wiki> by:

	# MyWikiApp looks at PATH_INFO and handles /index and /page/*
	my $wiki_app = sub { MyWikiApp->run(@_) };
	
	use Plack::App::URLMap;
	my $app = Plack::App::URLMap->new;
	$app->mount("/wiki" => $wiki_app);

When a request comes in with C<PATH_INFO> set to C</wiki/page/foo>,
the URLMap application C<$app> strips the C</wiki> part from
C<PATH_INFO> and B<appends> that to C<SCRIPT_NAME>.

That way, if the C<$app> is mounted under the root
(i.e. C<SCRIPT_NAME> is C<"">) with standalone web servers like
L<Starman>, C<SCRIPT_NAME> is now locally set to C</wiki> and
C<PATH_INFO> is changed to C</page/foo> when C<$wiki_app> gets called.

=head1 AUTHOR

Tatsuhiko Miyagawa

=head1 SEE ALSO

L<Plack::Builder>

=cut
