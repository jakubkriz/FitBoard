#!/usr/bin/perl -T

use v5.10.0;
use strict;
use warnings;

use lib qw(common/lib);

# --- tests initialisation -----------------------------------------------------

my $test = new Test::IDGen;

# --- run tests ----------------------------------------------------------------

$test->runtests();

# --- add tests ----------------------------------------------------------------

package Test::IDGen;
use base 'Test::Class';
use Test::More;
use IDGen;

sub test1_random : Test(2) {
	can_ok('IDGen', 'GetID');

	my %id;
	my $i;
	my $n = 10000;
	for (1..$n) {
		$i = IDGen::GetID();
		if ($i !~ /^[0-9A-Za-z]{8,19}$/) {
			diag("Wrong form of GetID result '$i' in $_ pass");
			undef $i;
			last;
		} elsif (exists $id{$i}) {
			diag("Duplicate GetID result '$i' in $_ pass");
			undef $i;
			last;
		} else {
			$id{$i} = undef;
		}
	}
	ok($i, "test GetID() ($n passes)");
}

__END__
