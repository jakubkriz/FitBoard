package Mail;

use v5.10.0;

use Log;

use strict;
use warnings;

use Event::Store;
use JSON::XS;

use lib ("common/lib");

use Data::Dumper;
use Time::HiRes qw/gettimeofday tv_interval/;

use IDGen;

use Plack::Util::Accessor qw(data log const);

use Mail::Bulkmail;
use Mail::Bulkmail::Server;
use Mail::Bulkmail::DummyServer;
use Mail::Bulkmail::Dynamic;

use utf8;
use Data::Dumper;

my $dataDir;

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

	$self->{data}->setDB($self->const->get('Md_mail_db'))->setColl($self->const->get('Md_mail_coll'));

	$self->log->info('Mail db: initialized.');
	return $self;
}

sub setError {
	my ($self, $id, $data, $error) = @_;

	print STDERR "ERROR: ".Dumper($error);
	$data->{status} = 'ERROR';
	$data->{msg} = $error;
	$data->{end} = Time::HiRes::time();;
	eval {$self->data->update({'_id'=>$id}, {'$set' => $data})};
	my $serr = $@ if $@;
	if ($serr) {
		# Just print error, bacause save the status is not so importent
		print STDERR "SAVE EMAIL STATUS ERROR: ".$serr."\n".$error."\n".Dumper($data);
	}

	return 0
}

sub sendMail {
	my ($self, $data, $dryrun) = @_;

	$data->{start} = Time::HiRes::time();

	# Update START
	$data->{status} = 'SENDING';
	my $id = eval {$self->data->store($data)};
	my $error = $@ if $@;
	if ($error) {
		# Just print error, bacause save the status is not so importent
		print STDERR "SAVE EMAIL STATUS ERROR: ".$error."\n".Dumper($data)."\n";
	}

	$data->{start} = Time::HiRes::time();

	my $mailserver;
	if ($dryrun){
		my $id = IDGen::GetID();
		my $dataDir = $self->const->get("DataDir").'/preview/';
		my $file = $dataDir.$id;

		mkdir($dataDir);
		$mailserver = Mail::Bulkmail::DummyServer->new(
			"dummy_file"    => $file,
	        'Domain' => $self->const->get('Domain'),
		);

		if (!$mailserver){
			return $self->setError($id, $data, Mail::Bulkmail::DummyServer->error())
		}
	}else{
		$mailserver = Mail::Bulkmail::Server->new(
	        'Smtp' => $self->const->get('SmtpServer'),
	        'Port' => $self->const->get('SmtpPort'),
	        'Domain' => $self->const->get('Domain'),
	        'Tries' => 5,
	        'max_connection_attempts' => 5,
	        'envelope_limit' => 100,
	        'max_messages_per_robin' => 0,
	        'max_messages_per_connection' => 0,
			'max_messages' => 0,
			'max_messages_while_awake' => 0,
		);

		if (!$mailserver){
			return $self->setError($id, $data, Mail::Bulkmail::Server->error())
		}
	}

	if (!$mailserver->connect()){
		return $self->setError($id, $data, "Could not connect : " . $mailserver->error)
	}

	my ($bulk) = $self->_prepareBulk($id, $data);
	if (!$bulk){
		return $self->setError($id, $data, 'Not prepared Bulk message')
	}
	$bulk->servers([$mailserver]);

	my $st = $bulk->bulkmail();

	if (!$st){
		return $self->setError($id, $data, $bulk->error)
	}

	$data->{status} = 'OK';
	$data->{end} = Time::HiRes::time();;
	eval {$self->data->update({'_id'=>$id}, {'$set' => $data})};
	my $se = $@ if $@;
	if ($se) {
		# Just print error, bacause save the status is not so importent
		# and email has beeen already sent.
		print STDERR "SAVE EMAIL STATUS ERROR: ".$se."\n".Dumper($data);
	}

	return 1;
}

sub _prepareBulk {
	my ($self, $id, $data) = @_;

	my $dataDir = $self->const->get("DataDir");
	my $logDir = $dataDir.'/maillog';
	mkdir ($logDir);
	my $errfile = $logDir.'/err';
	my $badfile = $logDir.'/bad';
	my $goodfile = $logDir.'/good';

	my $bulk = Mail::Bulkmail::Dynamic->new(
		"merge_keys"    => $data->{merge_keys},
		"global_merge"  => {
#			'{{dashboards}}' => $data->{dashboardList},
		},
		"merge_delimiter" => "::",
		"LIST"          => $data->{list},
		"From"          => $data->{from},
		"Subject"       => $data->{subject},
		"Message"       => $data->{message},
		"ERRFILE"       => $errfile,
		"BAD"           => $badfile,
		"GOOD"          => $goodfile,
	);
	$bulk->Trusting('email' => 1);
	$bulk->Trusting('duplicates' => 1);

	if (!$bulk){
		return $self->setError($id, $data, Mail::Bulkmail::Dynamic->error())
	}

	$bulk->HTML(1);

	return $bulk;
}

1;

__END__
