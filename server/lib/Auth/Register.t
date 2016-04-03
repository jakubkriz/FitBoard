#!/usr/bin/env perl
use 5.008003;
use strict;
use warnings;

use lib qw(server/lib common/lib .);

# --- tests initialisation -----------------------------------------------------

my $test = new Test::Register;

# --- run tests ----------------------------------------------------------------

$test->runtests();

# --- add tests ----------------------------------------------------------------

package Test::Register;
use base 'Test::Class';
use Test::More;
use Test::Exception;
use Auth::Register;

sub test1_email : Test(6) {
	throws_ok {Auth::Register::clean_email('')} qr/Bad email/, 'empty email';
	throws_ok {Auth::Register::clean_email('test.sdfemail.cz')} qr/Bad email/, 'email without @';
	throws_ok {Auth::Register::clean_email('1.0')} qr/Bad email/, 'number';
	throws_ok {Auth::Register::clean_email('       ')} qr/Bad email/, 'empty email 2';
	is(Auth::Register::clean_email('email@test.cz   '), 'email@test.cz', 'with whitespace');
	is(Auth::Register::clean_email('email@@test.cz'), 'email@test.cz', 'with two @');
}

__END__
