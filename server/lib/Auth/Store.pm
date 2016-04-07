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
	my ($self, $env, $login, $passwd_nc, $data) = @_;

	# Crypt passwd
	my $password = $self->getPasswd($passwd_nc);

	$data->{login} = $login;
	$data->{password} = $password;

	my ($e) = $self->data->store($data);
	return ($e ? $login : 0);
}

sub updateUser {
	my ($self, $env, $login, $data) = @_;

	$data->{login} = $login;

	my ($e) = $self->data->update({login => $login}, $data);
	return ($e ? $login : 0);
}

sub getUser {
	my ($self, $env, $user) = @_;

	# Check user
	my $resp = $self->data->get( undef, {login => $user} );

	if ( $resp ){
		return $resp;
	}else{
		return 0;
	}
}

sub getAllUsers {
	my ($self, $env, $constr, $proj, $sort) = @_;

	# Check user
	my $resp = $self->data->getAll( $constr, $proj, $sort );

	return $resp;
}

sub getUsers {
	my ($self, $env) = @_;

	my @e = $self->data->getAll();
	return \@e;
}

sub checkUser {
	my ($self, $env, $login, $passwd_nc) = @_;

	return 0 unless $login;

	# Crypt passwd
	my $password = $self->getPasswd($passwd_nc);

	# Check user
	my $user = $self->data->get( undef, {login => $login, password => $password} );

	if ( $user ){
		return $user->{login};
	}else{
		return 0;
	}
}

sub checkAdminUser {
	my ($self, $env, $login) = @_;

	return 0 unless $login;

	# Check user
	my $user = $self->data->get( undef, {'$and' => [{login => $login},{admin => 1}]}  );

	if ( $user ){
		return 1;
	}else{
		return 0;
	}
}

sub checkUserExistence {
	my ($self, $env, $login) = @_;

	return 0 unless $login;
	# Check user
	my $user = $self->data->get( undef, {login => $login} );

	return $user?1:0;
}

sub getPasswd {
	return md5_base64($_[1]);
}

1;