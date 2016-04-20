package Store::Qual;

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

	$self->{data}->setDB($self->const->get('Md_db'))->setColl($self->const->get('Md_qual_coll'));

	$self->log->info('Qual Coll: initialized.');
	return $self;
}


1;