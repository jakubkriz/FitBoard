package Event::Store;

use IDGen;
use MongoDB;

use Log;

use strict;
use warnings;

use Plack::Util::Accessor qw(log mongo db conn const);

# MongoDB
my $mongo;

sub new {
	my ($class, $const) = @_;

	### Init Log Dispatch
	my $log = Log::log();

	my $self = bless {
		log => $log,
		const => $const,
		conn => undef,
		db => undef,

	}, $class;

	$self->init();

	return $self;
}

sub init {
	my ($self) = @_;
	return $self if $mongo;
	$mongo = MongoDB::MongoClient->new(host => ($self->const->get('Md_IP').':'.$self->const->get('Md_Port')));
}

sub setDB {
	my ($self, $DB) = @_;

	$_[0]->db($mongo->get_database($DB));
	return $self
}

sub setColl {
	my ($self, $Coll, $DB) = @_;
	if (!$self->db){
		if ($DB){
			$self->setDB($DB);
		}else{
			die 'Not DB set';
		}
	}
	$self->conn($self->db->get_collection($Coll));
	return $self
}

sub getColls {
	my ($self) = @_;
	if (!$self->db){
		die 'No database set.';
	}
	return $self->db->collection_names;
}

sub getConn {
	my ($self) = @_;
	if (!$self->conn){
		die 'No collection set.';
	}
	return $self->conn;
}

#################### Main Functions ##########################

sub store {
	my ($self, $data) = @_;

	$data->{modified} = time();
	$data->{date} = time() unless defined $data->{date};

	return $_[0]->getConn->insert($data, {safe => 1});
}

sub update {
	my ($self, $constr, $data) = @_;

	return unless $constr;

	$data->{modified} = time();

#	$constr->{_id} = $id;

	return $_[0]->getConn->update($constr, $data, {safe => 1});
}

sub get {
	my ($self, $id, $c) = @_;

	my $constr;
	if ($id){
		$constr->{_id} = $id;
	}else{
		$constr = $c;
	}

	my $user = $_[0]->getConn->find_one( $constr, {_id=>0} );

	return $user;
}

sub getAll {
	my ($self, $constr, $sort) = @_;

	$sort = $sort ? $sort : {};

	if ($constr){
		return $_[0]->getConn->find($constr, {_id=>0})->sort($sort)->all;
	}else{
		return $_[0]->getConn->find({}, {_id=>0})->all;
	}
}

sub delete {
	my ($self, $id, $constr) = @_;

	if ($id) {
		return $_[0]->getConn->remove( { "_id" => $id }, {safe => 1} );
	}elsif($constr && ref $constr eq 'HASH' &&  keys %$constr){
		return $_[0]->getConn->remove( $constr, {safe => 1} );
	}
}

sub deleteAll {
	my ($data) = @_;

	return $_[0]->getConn->remove;
}

##################3
sub run_command {
	my ($self, $cmd) = @_;

	return $_[0]->getConn->run_command($cmd)->all;
}


1;