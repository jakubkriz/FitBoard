# twiggy -r --workers 4 -l :6060 server.psgi

use strict;
use warnings;

use File::Basename qw(dirname);
use HTTP::Exception;

use Plack::Builder;
use Plack::App::File;

use Plack::Session;
use Plack::Session::Store::MongoDB;
use Plack::Session::State::Cookie;

use File::ShareDir;

# My own modules
use lib qw(./lib server/lib ../common/lib ./common/lib);
#use lib qw(../../Rest-HtmlVis/lib/ ../../framework/Rest-HtmlVis/lib/);
#use lib qw(../../Plack-Middleware-FormatOutput/lib/ ../../framework/Plack-Middleware-FormatOutput/lib/);
#use lib qw(../../Plack-Middleware-ParseContent/lib/ ../../framework/Plack-Middleware-ParseContent/lib/);
#use lib qw(../../Plack-App-REST/lib/ ../../framework/Plack-App-REST/lib/);
use Const;
use Log;
use Version;
use Store::Auth;
use Event::Store;

# Auth visualiser
use Rest::HtmlVis::Login;
use Rest::HtmlVis::Logout;

use Plack::App::URLMapMatch;
use Storable qw(dclone);

#----------------------------------------------------------------------
### Directory and config file
my $myDir = dirname(__FILE__);
my $dirOfCode = "$myDir/..";
my $dirOfConst = $ENV{CONSTDIR} ? $ENV{CONSTDIR} : $dirOfCode;

### Init Log Dispatch
my $log = Log::log();

### Init Const
my $const = Const::GetConfig($dirOfConst,$dirOfCode, 'server');

### Set env
my $plackEnv = $const->get('PlackEnv');
if (exists $ENV{PLACK_ENV}) {
	if (lc($ENV{PLACK_ENV}) =~ /^(development|test|deployment)$/) {
		$plackEnv = $1;
	} else {
		$log->warn("PLACK_ENV should be either of 'development', 'test' or 'deployment', default '$plackEnv' will be used.");
	}
}
$log->info("Set Plack Env.");

### Set Version
$const->set('version', Version::readFromFile("$myDir/../VERSION"));

# Prepare cache of urlmap
my $refToUrl = {};
prepareCache($refToUrl, $const->get("RestMap"));

$const->set('RefToUrl', $refToUrl);

#----------------------------------------------------------------------
$log->info("Server starting...");
builder {

	### Log
	enable "LogDispatch", logger => $log;
	
	### AccessLog
	enable_if {$plackEnv eq 'development'} "Plack::Middleware::AccessLog",
	  logger => sub { $log->log(level => 'debug', message => @_) };

	### StackTrace
	enable_if {$plackEnv eq 'development'} "Plack::Middleware::StackTrace",
	  force => 1;

	### URL mapping
	my $urlmap = Plack::App::URLMapMatch->new;

	### Favicon
	$urlmap->mount('/favicon.ico' => Plack::App::File->new( file => "$myDir/static/favicon.ico" )->to_app );

	### Set static directory
	$urlmap->mount('/localstatic' => Plack::App::File->new(root => $myDir."/static")->to_app, const=>{nostrict=>1});

	### Mount htmlvis static files
	my $share = File::ShareDir::dist_dir('Rest-HtmlVis') || "../Rest-HtmlVis/share/";
	$urlmap->mount("/cs/vendor/" => Plack::App::File->new(root => $share)->to_app, const=>{nostrict=>1});

	### Session info
	enable 'Session',
		state => Plack::Session::State::Cookie->new(
			session_key => $const->get("SecureSessionKey")
		),
		store => Plack::Session::Store::MongoDB->new(
			session_db_name => $const->get('SecureSessionDB'),
			coll_name => $const->get('SecureSessionColl'),
			host => $const->get('Md_IP'),
			port => $const->get('Md_Port'),
	);

	### Mount resources
	my $restMap = $const->get('RestMap');
	restMount($const, $urlmap, '', $restMap);


	$log->info("Server started.");
	$urlmap->to_app;
};

sub restMount {
	my ($const, $urlmap, $uri, $rMap, $htmlvis) = @_;
	foreach my $key (sort keys %{$rMap}) {
		if (exists $rMap->{$key}{file}){
			my $staticPath = '';
			if(ref $rMap->{$key}{file} eq "HASH"){
				next unless exists $rMap->{$key}{file}{$plackEnv};
				$staticPath = $rMap->{$key}{file}{$plackEnv}; 
			}else{
				$staticPath = $rMap->{$key}{file};
			}
			my $path = $uri.$key;
			my $absDir = $staticPath =~/^\//?$staticPath:$myDir.'/'.$staticPath;

			if(exists $rMap->{$key}{index}){

				### Map app resources
				$urlmap->mount($path => 	builder {
					enable 'Plack::Middleware::ConditionalGET';
					enable 'Plack::Middleware::ETag', cache_control => 'public, max-age=3600';
					enable 'Plack::Middleware::Static',
						path => sub {
							# Rewrite / to index.html
							if ($_[0] =~ /\/$/){ $_[0] .= $rMap->{$key}{index}; }
							return 1;
						},
						root => $absDir,
						pass_through => 0;
					},
				const=>$rMap->{$key}
				);
			}else{
				#print STDERR "mounting $rMap->{$key}{ref} to $path as static at $absDir\n" if $rMap->{$key}{ref};
				$urlmap->mount($path => builder {
					enable 'Plack::Middleware::ConditionalGET';
					enable '+Rest::Middleware::ETag', cache_control => 'public, max-age=3600';
					Plack::App::File->new('root' => $absDir)->to_app;
					},
					const=>$rMap->{$key}
				);
			}
		}elsif (exists $rMap->{$key}{class} or exists $rMap->{$key}{ref} or exists $rMap->{$key}{resources} ){
			my $mainKey = 'api';
			my $path = $uri."".$key;

			### Set format output by config
			my $htmlvis_local = defined $htmlvis ? dclone($htmlvis) : {
				'default.baseurl' => '/cs/vendor/',
			};
			if (exists $rMap->{$key}{"~FormatOutput"}){
				$htmlvis_local = $rMap->{$key}{"~FormatOutput"};
			}
			if (exists $rMap->{$key}{"FormatOutput"}){
				for my $viskey (keys %{$rMap->{$key}{"FormatOutput"}}){
					$htmlvis_local->{$viskey} = $rMap->{$key}{"FormatOutput"}{$viskey};	
				}
			}

			if($rMap->{$key}{class}){
				#print STDERR "mounting $rMap->{$key}{class} to $path\n";
				die "Path $path ends with slash which can prevent correct function of Rest::Client" if $path =~ /.\/$/; # problem: looking for '/app/aql/' in 'http://host/app/aql' would fail
				my $module = $rMap->{$key}{class};
				next unless $module;
				eval "require $module";
				if($@){
					die $@;
				}
				### Url map for apiprefix
					my $params = $rMap->{$key};
					$params->{strict} = 1;
					$urlmap->mount($path => builder {
#						enable_if {!$rMap->{$key}{unauthorized}} '+Rest::Middleware::Authen', zeromq => Const::Get('Auth0mq'), auth_uri=> Const::Get('ImaAuthUri'), token_name=> Const::Get('ImaCookieKey');
						# Check user 
						enable_if {!$rMap->{$key}{unauthorized}} '+Plack::Middleware::CheckUserAccess', login_url => '/api/v1/auth/login';
						enable 'Plack::Middleware::ParseContent';
						enable 'Plack::Middleware::FormatOutput', htmlvis => $htmlvis_local;
						enable "Runtime";

						$module->new($const, $rMap->{$key})->to_app;
					},
					const=>$params,
				);


			}
				if(exists $rMap->{$key}{resources} ) {
					restMount($const, $urlmap,$path,$rMap->{$key}{resources},$htmlvis);		
			}
			
		}
	}
}

sub prepareCache {
	my ($refToUrl, $restMap, $path, $placeholders) = @_;

	foreach my $url (sort keys %$restMap){
		my $nexturl = ($path||'').$url;

		# Check placeholders
		if ($url =~ /^\/\*$/ || exists $restMap->{$url}{env}){
			if ($restMap->{$url}{env}){
				my $pn = sprintf('__%s__',$restMap->{$url}{env});
				$placeholders->{$restMap->{$url}{env}} = $pn;
				$nexturl = ($path||'').'/'.$pn;
			}else{
				die 'Not env variable in const for '.$path.$url.'. Please set name of placeholder in const.';
			}
		}

		# Set ref to url
		my $ref = ($restMap->{$url}{ref}||$restMap->{$url}{class});
		if ($ref){
			$refToUrl->{$ref} = {url => $nexturl, placeholders => $placeholders};
		}

		# Continue down in tree
		if (exists $restMap->{$url}{resources}){
			my %plach = %$placeholders if $placeholders;
			prepareCache($refToUrl, $restMap->{$url}{resources}, $nexturl, \%plach);
		}
	}
}

__END__

