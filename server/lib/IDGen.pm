#-----------------------------------------------------
#  IDGen
#-----------------------------------------------------
# To see COPYRIGHT, LICENSE and WARRANTY information read the perldoc documentation bellow.


package IDGen;

use strict;
use warnings;
use Time::HiRes;

#-------------------------------------------------------------------------------

my $IDGen=0;
my $IDSt;
my $IDa='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';	# lenght 52 B
my $IDb=$IDa.'0123456789';	# lenght 62 B

#-------------------------------------------------------------------------------
# Method: GetID
#  Singular ID generator
#
# Parameters:
#  none
#
# Returns:
#  string - singular string (starting with letter) containing:
#     - 3 chars are representing sequence of ID (with period 199888)
#     - 4 chars are representing time (with period 171 days)
#     - 3 chars are representing PID (PID will be used modulo 238328)
#     - 1 char is random
#
# Author:
#  michald
#-------------------------------------------------------------------------------
sub GetID # ()
{
	if (!$IDGen) {
		$IDSt = '';
		my $t=time%62**4;	# we are using only part of time information to save string space; resulting 171 days period seems enough to ensure ID singularity
		foreach (62**3, 62**2, 62) {	# we are setting 4 chars string depending on time
			$IDSt .= substr($IDb, int($t/$_), 1);
			$t = $t%$_;
		}
		$IDSt .= substr($IDb, $t, 1);
		$t=$$%62**3;
		foreach (62**2, 62) {	# we are setting 3 chars string depending on PID
			$IDSt .= substr($IDb, int($t/$_), 1);
			$t = $t%$_;
		}
		$IDSt .= substr($IDb, $t, 1);
		$IDSt .= substr($IDb, int(rand(62)), 1);
	}
	if ($IDGen==199888) {$IDGen=0} else {$IDGen++};	# 199888=52*62*62; we are returning about 100000 IDs/s on P4/1.6 GHz into empty loop, so such 3 chars string seems enough to keep sequence

	my $i1 = int($IDGen/3844);	# 3844=62*62
	my $i2 = $IDGen%3844;
	return substr($IDa, $i1, 1).substr($IDb, int($i2/62), 1).substr($IDb, $i2%62, 1).$IDSt;	# we are converting $IDGen to 3 char string in space 'aaa','aab',...,'ZZZ'; returning string is starting with this string to ensure ID is not starting with number

}

#-------------------------------------------------------------------------------

my $IDGenC=0;
my $IDStC;
my $IDaC='abcdefghijklmnopqrstuvwxyz';	# lenght 26 B
my $IDbC=$IDaC.'0123456789';	# lenght 36 B

#-------------------------------------------------------------------------------
# Method: GetIDC
#  Singular ID generator (Upper Case Letters)
#
# Parameters:
#  none
#
# Returns:
#  string - returns singular string (starting with letter) containing Upper Case Letters only:
#     - 4 chars are representing sequence of ID (with period 1213056)
#     - 5 chars are representing time (with period 699 days)
#     - 4 chars are representing PID (PID will be used modulo 1679616)
#     - 1 char is random
#
# Author:
#  michald
#-------------------------------------------------------------------------------
sub GetIDC # ()
{
	if (!$IDGenC) {
		$IDStC = '';
		my $t=time%36**5;	# we are using only part of time information to save string space; resulting 699 days period seems enough to ensure ID singularity
		foreach (36**4, 36**3, 36**2, 36) {	# we are setting 5 chars string depending on time
			$IDStC .= substr($IDbC, int($t/$_), 1);
			$t = $t%$_;
		}
		$IDStC .= substr($IDbC, $t, 1);
		$t=$$%36**4;
		foreach (36**3, 36**2, 36) {	# we are setting 3 chars string depending on PID
			$IDStC .= substr($IDbC, int($t/$_), 1);
			$t = $t%$_;
		}
		$IDStC .= substr($IDbC, $t, 1);
		$IDStC .= substr($IDbC, int(rand(36)), 1);
	}
	if ($IDGenC==1213056) {$IDGenC=0} else {$IDGenC++};	# 1213056=26*36**3; we are returning about 100000 IDs/s on P4/1.6 GHz into empty loop, so such 4 chars string seems enough to keep sequence

	# we will convert $IDGenC to 4 char string in space 'AAAA','AAAB',...,'ZZZZ'; returning string is starting with this string to ensure ID is not starting with number
	my $t=$IDGenC;
	my $s .= substr($IDaC, int($t/46656), 1); $t = $t%46656;	# 36**3 = 46656
	$s .= substr($IDbC, int($t/1296), 1); $t = $t%1296;	# 36**2 = 1296
	$s .= substr($IDbC, int($t/36), 1); $t = $t%36;
	$s .= substr($IDbC, int($t), 1);
	return $s.$IDStC;

}

#-------------------------------------------------------------------------------

1

__END__


