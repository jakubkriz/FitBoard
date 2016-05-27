package Rest::Competition::App::Start;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use MIME::Base64;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use Store::Qual;

use utf8;

use open IO => ':encoding(utf8)';

use Rest::Competition::App::SBoard;

use YAML::Syck;
$YAML::Syck::ImplicitUnicode = 1;

sub GET {
	return { WARNING => 'Rewrite all users in competition from qualification.' }
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	my $login = $env->{'psgix.session'}{user_id};
	HTTP::Exception::403->throw(message=>"Forbidden") unless $login;
	my $login_info = $self->auth->getUser($env, $login);

	HTTP::Exception::403->throw(message=>"Forbidden") unless $login_info->{admin};

	if (!$data || ref $data ne 'HASH'){
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	if ($data->{saveAllFromQual}){
		my $data = Rest::Competition::App::SBoard::GET($self, $env);
		my $n = 0;
		if ($data && $data->{sb} && @{$data->{sb}}){
			foreach my $user (@{$data->{sb}}){
				next if (!$user->{qualified} || !$user->{startFee});
        		my $data;
        		foreach my $k (qw/startN login/){
	        		$data->{$k} = $user->{$k};
        		};

				my $saved = eval{ Rest::Competition::User::POST($self, $env, $params, $data) };
				$n++ if $saved;
			}
		}


		return { saved => $n };
	}

	return { saved => 0 };
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $content, $par) = @_;

	return {
		get => undef,
		post => {
			params => {
				saveAllFromQual => {
					type => 'radio',
					name => 'saveAllFromQual',
					description => 'saveAllFromQual',
					options => ['1', '0']
				}
			}
		}
	}
}

1;