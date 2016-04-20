package Rest::Competition::User;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw(auth);
use Plack::Session;
use MIME::Base64;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use YAML::Syck;
$YAML::Syck::ImplicitUnicode = 1;

### TODO - preprepare

sub GET {
	my ($self, $env, $id) = @_;

	my $login = $env->{'psgix.session'}{user_id};
	my $login_info = $self->auth->getUser($env, $login);

	my $userid = $env->{'rest.userid'};
	my $compid = $env->{'rest.competitionid'};

	return {}
}

sub PUT {
	my ($self, $env, $params, $data) = @_;
	return {}
}

sub DELETE {
	my ($self, $env, $params, $data) = @_;
	return {};
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $content, $par) = @_;

	if ($env->{'rest.userid'}){
		return {
			get => undef,
			delete => {
				params => {}
			},
			put => {
				params => {
					DATA => {
						type => 'textarea',
						name => 'DATA',
						default => $content
					}
				}
			}
		}
	}
}

1;