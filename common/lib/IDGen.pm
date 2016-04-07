#-----------------------------------------------------
#  IDGen
#-----------------------------------------------------
package IDGen;

use strict;
use warnings;
use Time::HiRes;

my $IDGen=0;
my $IDSt;
my $IDa='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'; # lenght 52 B
my $IDb=$IDa.'0123456789';      # lenght 62 B

sub GetID {     # singular ID generator

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

1

__END__


