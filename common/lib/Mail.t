#!/usr/bin/env perl
use 5.008003;
use strict;
use warnings;

use lib qw(server/lib common/lib .);

# --- tests initialisation -----------------------------------------------------

my $test = new Test::Mail;

# --- run tests ----------------------------------------------------------------

$test->runtests();

# --- add tests ----------------------------------------------------------------

package Test::Mail;
use base 'Test::Class';
use Test::More;
use Test::Exception;
use IDGen;
use YAML::AppConfig;
use Mail;
use File::Path;

sub init_const : Test(startup) {
	my($self) = @_;
	my $id = IDGen::GetID();
	my $const_str = <<END;
---

Dir: /tmp/FitBoard_$id/
DataDir: \$Dir/data
Md_IP: 127.0.0.1
Md_Port: 27017
Md_mail_db: fitmonster_$id
Md_mail_coll: mail
EmailBcc: info\@fitmonster.cz
Domain: fitmonster.cz

END
	my $const = YAML::AppConfig->new(string => $const_str);
	$self->{const} = $const;
	mkdir($self->{const}->get("Dir"));
	mkdir($self->{const}->get("DataDir"));
}

sub shutdown_const : Test(shutdown) {
	my ($self) = @_;
	rmtree($self->{const}->get("Dir")) if $self && $self->{const} && $self->{const}->get("Dir");
}

sub test1_mail : Test(2) {
	my ($self) = @_;
	my $mail = Mail->new($self->{const});
	my $rtrn = $mail->sendMail({
		merge_keys => [qw(BULK_EMAIL {{athlete.firstName}} {{athlete.lastName}} {{athlete.email}} {{athlete.phone}} {{athlete.bDay}} {{athlete.category}} {{athlete.sex}} {{athlete.shirt}} {{athlete.gym}})],
		list => [ "test\@test.com::Václav::Dovrtěl::test\@test.com::4794297::08/04/2016::elite::male::m::testGym", "test1\@test1.com::Václav::Dovrtěl::test\@test.com::4794297::08/04/2016::elite::male::m::testGym" ],
		from => $self->{const}->get("EmailBcc"),
		subject => 'Registrace Fit Monster 2016',
		message => '{{athlete.firstName}} {{athlete.lastName}} {{athlete.email}} {{athlete.phone}} {{athlete.bDay}} {{athlete.category}} {{athlete.sex}} {{athlete.shirt}} {{athlete.gym}}'
	}, 'dryrun');

	my $err;
	open(FILE, $self->{const}->get("DataDir").'/maillog/err');
	foreach my $line (<FILE>) {
		$err .= $line;
	}

	is($rtrn, 1, 'email send');
	is($err, undef, 'email send without err');
}

no warnings;
package Event::Store;

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
	return $self;
}

sub setDB {
	my ($self, $DB) = @_;
	$_[0]->db('test');
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
	$self->conn('test');
	return $self
}

sub store {
	my ($self, $data) = @_;
	return 1;
}

sub update {
	my ($self, $constr, $data) = @_;
	return 1;
}

sub get {
	my ($self, $id, $c) = @_;
	return 1;
}

sub getAll {
	my ($self, $constr, $sort) = @_;
	return 1;
}

sub delete {
	my ($self, $id, $constr) = @_;
	return 1;
}

sub deleteAll {
	my ($data) = @_;
	return 1;
}


__END__
