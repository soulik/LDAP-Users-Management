package ITA::Util;

use strict;
use warnings;
our $version = '1.00';

use Time::Piece;

my $ADToUnixConverter = ((1970 - 1601) * 365 - 3 + int((1970 - 1601) / 4) + 0.5) * 86400;

my $YMDpattern = '%Y%m%d%H%M%S.0Z';

sub ldapTimeToUnixTime {
	my $ldapTime = $_[1];
	my $secsAfterADEpoch = $ldapTime / 10000000;
	return int($secsAfterADEpoch - $ADToUnixConverter);
};

sub unixTimeToLdapTime {
	my $unixTime = $_[1];
	my $secsAfterADEpoch = $ADToUnixConverter + $unixTime;
	return int($secsAfterADEpoch * 10000000);
};

sub YMDTimeToUnixTime {
	my $YMD_time = $_[1];
	return Time::Piece->strptime($YMD_time, $YMDpattern)->epoch;
};

1;
