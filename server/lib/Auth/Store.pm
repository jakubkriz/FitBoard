package Auth::Store;

#use Authen::Simple::DBI;
use DBI;
use DBD::SQLite;

use Log;

use strict;
use warnings;

use Digest::MD5 1.0 qw(md5_base64);

use Plack::Util::Accessor qw(data log const);

use Event::Store;

sub new {
	my ($class, $const) = @_;

	### Init Log Dispatch
	my $log = Log::log();
	my $data = Event::Store->new( $const );

	my $self = bless {
		log => $log,
		data => $data,
		const => $const
	}, $_[0];

	$self->init();

	return $self;
}

sub init {
	my ($self) = shift;

	$self->{data}->setDB($self->const->get('Md_auth_db'))->setColl($self->const->get('Md_auth_user_coll'));

	$self->log->info('Auth server: initialized.');
	return $self;
}

sub addUser {
	my ($self, $login, $passwd_nc, $email) = @_;

	# Crypt passwd
	my $password = $self->getPasswd($passwd_nc);

	my ($e) = $self->data->store({login => $login, password => $password, email => $email});
	return ($e ? $login : 0);
}

sub checkUser {
	my ($self, $env, $login, $passwd_nc) = @_;

	return 0 unless $login;

	# Crypt passwd
	my $password = $self->getPasswd($passwd_nc);

	# Check user
	my $user = $self->data->get( undef, {login => $login, password => $password} );

	if ( $user ){
		return $user->{projects};
	}else{
		return 0;
	}
}

sub getPasswd {
	return md5_base64($_[1]);
}

1;