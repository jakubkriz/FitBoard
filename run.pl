#!/usr/bin/env perl

### MAIN
use strict;
use warnings;
use FindBin;
use Cwd;

use lib ("$FindBin::Bin/common/lib");
use Const;

use Proc::Simple;
use Proc::ProcessTable;
use AnyEvent;
use AnyEvent::Filesys::Notify;

my $path = $ARGV[0] ? $ARGV[0] : $FindBin::Bin;
$path .= '/' unless $path =~ /\/$/;

my $dirOfConst = $ARGV[1] ? $ARGV[1] : "$FindBin::Bin";
$dirOfConst = Cwd::abs_path($dirOfConst) unless $dirOfConst =~ /^\//;
$dirOfConst =~ s/\/$//;

my $dirOfCode = "$FindBin::Bin";

warn "Directory containing default configuration: $dirOfCode\n";
warn "Directory containing user configuration: $dirOfConst\n";

### Read default conf for list of Run components
my $const = Const::GetConfig($dirOfConst, $dirOfCode);

# Read run
my $run = $const->get('Run');
my $comp = $const->get('Components');

### Load config for each component

my $proc;
foreach my $c (@$run){
	my $type = $c->{type};
	my $addr = $comp->{$type}{addr};
	my $dirl = $dirOfCode.'/'.$addr;
	my $dirC = $dirOfConst.'/'.$addr;

	my $constlocal = Const::GetConfig($dirOfConst, $dirOfCode, $type);
	my $obj = $comp->{$type};
	$obj->{type} = $type;

	$obj->{exec} =~ s/_DIR_/$dirl/g; # Switch default configuration
	$obj->{exec} =~ s/_CONSTDIR_/$dirC/g; # Switch default configuration
	if (exists $obj->{preexec}){
		$obj->{preexec}[0] =~ s/_DIR_/$dirl/g;
		$obj->{preexec}[1] =~ s/_DIR_/$dirl/g;
		$obj->{preexec}[0] =~ s/_CONSTDIR_/$dirC/g;
		$obj->{preexec}[1] =~ s/_CONSTDIR_/$dirC/g;

		foreach my $par (@{$obj->{preexec}[2]}){
			$par->[1] = $constlocal->resolve($par->[1]);
		};
	}

	push @$proc, $obj;
}

### Run prepare
foreach my $p (@$proc){
	next unless exists $p->{preexec};

	open (FILEIN, "<".$p->{preexec}[0]);
	open (FILEOUT, ">".$p->{preexec}[1]);
	foreach my $line (<FILEIN>){
		foreach (@{$p->{preexec}[2]}){
			$line =~ s/_$_->[0]_/$_->[1]/g;
		}
		print FILEOUT $line;
	}
	close(FILEOUT);
	close(FILEIN);
}

### MAIN

# transform watchers
my %watcher;
foreach my $p (@$proc){
	next unless defined $p->{watch};

	foreach my $w (@{$p->{watch}}){
		push(@{$watcher{$w}}, $p);
	}
	push(@{$watcher{'common'}}, $p);
}

my @dirs;
{
	my %d;
	map ( $d{$path.$_} = undef, keys %watcher ); 
	@dirs = keys %d;
}
warn sprintf "Directory to watch for file changes: '%s'\n", join "', '", @dirs;

my $pid = {};

foreach my $p (@$proc){
	start_proc($pid, $p);
}

my $cv = AE->cv;

my $sigInt = AE::signal INT => sub { ctrlc($cv) };
my $sigHup = AE::signal HUP => sub { 
	foreach my $p (reverse @$proc){
		kill_proc($pid, $p);
	}
	foreach my $p (@$proc){
		start_proc($pid, $p);
	}
	print "RESTARTED\n";
};

my $notifier = AnyEvent::Filesys::Notify->new(
        dirs     => [@dirs],
        filter => sub { my $dir = shift; return 1 if ($dir !~ /\.(swp|tmp|pid|sock)$/ && $dir !~ /(log|tmp|test_project)/) },
        cb       => sub {
            my (@events) = @_;
            foreach my $ev (@events){
            	# Find watcher
            	foreach my $w (keys %watcher){
            		next unless $ev->path() =~ /\/$w\//;

            		# Kill processes
            		foreach my $p ( @{$watcher{$w}} ){
    	        		kill_proc($pid, $p);
    	        		start_proc($pid, $p);
    	        	}
    	        }
    	     	last;
            }
        },
);

$cv->recv;
print "FINISHED\n";

# --------------------

sub kill_proc {
	my ($pid, $p) = @_;

	foreach my $c (1..$p->{workers}){
		print STDOUT "\nkilling $p->{type}_$c. ..\n";

		if($p->{kill} eq 'grizzly'){
			kill_grizzly($pid->{ $p->{exec}.'_'.$c });
		}else{
			kill_normal($pid->{ $p->{exec}.'_'.$c });
		}

		print STDOUT "\nKilled.$p->{type}_$c..\n";
	}
}

sub start_proc {
	my ($pid, $p) = @_;

	next unless ref $p eq 'HASH';

	$p->{workers} = 1 unless defined $p->{workers};

	foreach my $c (1..$p->{workers}){
		start_proc_worker($pid, $p, $c);
	}
}

sub start_proc_worker {
	my ($pid, $p, $c) = @_;

	next unless ref $p eq 'HASH';

	my $name = $p->{exec}.'_'.$c;
	$pid->{$name} = Proc::Simple->new();
	$pid->{$name}->start( $p->{exec} );

	return;
}


sub ctrlc {
	my ($cv) = @_;

	foreach my $p (reverse @$proc){
		kill_proc($pid, $p);
	}

	$cv->send;
}

# --------------------

sub kill_normal {
	my ($p) = @_;

	my $sleep = 3;
	while ($p->poll() && $sleep ){
		$p->kill();
		$sleep --;
		sleep 1;
	}

	while ($p->poll()){
		kill 9, $p->pid;
	}
}

sub kill_starman {
	my ($pr) = @_;

	# Kill Starman
	my $starmanMaster;
	for my $p (@{new Proc::ProcessTable->table()}){
		$starmanMaster = $p->pid if($p->ppid == $pr->pid());
	}

	my @starmanWorker;
	if ($starmanMaster){
		for my $p (@{new Proc::ProcessTable->table()}){
			push( @starmanWorker, $p->pid) if ($p->ppid == $starmanMaster);
		}
	}

	while ($pr->poll()){
		kill 3, $starmanMaster;
		sleep 1;
		foreach (@starmanWorker) {
			if (kill(0, $_)){
				kill 9, $_;
			}
		}
		$pr->kill();
	}

}
