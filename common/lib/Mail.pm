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

sub sendMail {
	my ($self, $data) = @_;

	$data->{start} = Time::HiRes::time();

	# Update START
	my $id = eval {$self->data->store($data)};

	my $mailserver = Mail::Bulkmail::Server->new(
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
		use Data::Dumper;
		print STDERR "ERROR: ".Dumper(Mail::Bulkmail::Server->error());
		die Mail::Bulkmail::Server->error();
	}

	$mailserver->connect() || die "Could not connect : " . $mailserver->error;
#	$mailserver->CONVERSATION($dataDir."/preview/conversation");

	my ($bulk, $err) = $self->_prepareBulk($data);
	if (!$bulk){
		$data->{status} = 'ERROR';
		$data->{msg} = $err;
		$data->{end} = Time::HiRes::time();;
		eval {$self->data->update($id, $data)};
		return 0;		
	}
	$bulk->servers([$mailserver]);

	my $st = $bulk->bulkmail();

	if (!$st){
		$data->{status} = 'ERROR';
		$data->{msg} = $bulk->error;
		$data->{end} = Time::HiRes::time();;
		eval {$self->data->update($id, $data)};
		return 0;
	}

	$data->{status} = 'OK';
	$data->{end} = Time::HiRes::time();;
	eval {$self->data->update($id, $data)};
	my $error = $@ if $@;
	if ($error) {
		return 0;
	}

	return 1;
}

sub _prepareBulk {
	my ($self, $data) = @_;

	my $dataDir = $self->const->get("DataDir");
	my $logDir = $dataDir.'/maillog';
	mkdir ($logDir);
	my $errfile = $logDir.'/err';
	my $badfile = $logDir.'/bad';
	my $goodfile = $logDir.'/good';

	my $bulk = Mail::Bulkmail::Dynamic->new(
		"merge_keys"    => [qw(BULK_EMAIL {{athlete.firstName}} {{athlete.lastName}} {{athlete.email}} {{athlete.phone}} {{athlete.bDay}} {{athlete.category}} {{athlete.sex}} {{athlete.shirt}})],
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

=old
	my $bulk = Mail::Bulkmail->new(
			"LIST"          => $data->{list},
			"From"          => $data->{from},
			"Subject"       => $data->{subject},
			"Message"       => $data->{message},
			"ERRFILE"       => $errfile,
			"BAD"           => $badfile,
			"GOOD"          => $goodfile,
	);
=cut

	if (!$bulk){
		use Data::Dumper;
		print STDERR "ERROR: ".Dumper(Mail::Bulkmail::Dynamic->error());
		return +(0, Mail::Bulkmail::Dynamic->error())
	}

	$bulk->HTML(1);

	return $bulk;
}

1;

__END__
