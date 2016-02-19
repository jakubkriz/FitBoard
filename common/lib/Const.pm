package Const;

use strict;
use warnings;

use YAML::AppConfig;

sub GetConfig {
	my ($dirOfConst, $dirOfCode, $server) = @_;

	printf("Read Configuration For: '%s'\n",$server) if $server;

	my @confFiles = GetConfFiles($dirOfConst, $dirOfCode, $server);
	my $first = shift @confFiles;
	my $const = YAML::AppConfig->new(file => $first);
	printf("Read Default Configuration file: '%s'\n",$first);

	### Get project configuration
	foreach my $f (@confFiles){
		$const->merge(file => $f);
		printf("Read Configuration file: '%s'\n",$f);
	}

	return $const;
}

sub GetConfFiles {
	my ($dirOfConst, $dirOfCode, $server) = @_;
	my @dirs;
	push @dirs, $dirOfCode.'/default.conf' if -f $dirOfCode.'/default.conf';
	push @dirs, $dirOfCode.'/'.$server.'/default.conf' if $server and -f $dirOfCode.'/'.$server.'/default.conf';
	push @dirs, $dirOfConst.'/default.conf' if ($dirOfConst ne $dirOfCode) and -f $dirOfConst.'/default.conf';
	push @dirs, $dirOfConst.'/'.$server.'.conf' if $server and ($dirOfConst ne $dirOfCode) and (-f $dirOfConst.'/'.$server.'.conf');

	return @dirs;
}

#-------------------------------------------------------------------------------

1;

__END__

