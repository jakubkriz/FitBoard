#!/usr/bin/perl -T
#-----------------------------------------------------
#  The BEE Project test environment
#-----------------------------------------------------
# To see COPYRIGHT, LICENSE and WARRANTY information read the perldoc documentation bellow.

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

sub test1_random : Test(3) {
	can_ok('IDGen', 'GetID', 'GetIDC');

	my %id;
	my $i;
	my $n = 10000;
	for (1..$n) {
		$i = IDGen::GetID();
		if ($i !~ /^[A-Za-z][0-9A-Za-z]{8,12}$/) {
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
	
	for (1..$n) {
		$i = IDGen::GetIDC();
		if ($i !~ /^[a-z][0-9a-z]{10,20}$/) {
			diag("Wrong form of GetID result '$i' in $_ pass");
			undef $i;
			last;
		} elsif (exists $id{lc($i)}) {
			diag("Duplicate GetID result '$i' in $_ pass");
			undef $i;
			last;
		} else {
			$id{lc($i)} = undef;
		}
	}
	ok($i, "test GetID() ($n passes)");
}

__END__
