#!/usr/bin/perl

use ITA::LDAP 1.01 qw(new);
use ITA::DB 1.00 qw(new);
use ITA::Util;
use Config::Simple;

Config::Simple->import_from('./.config/ext-vpn-users/main.conf', \%CONFIG);

my $ldap = ITA::LDAP->new($CONFIG{'LDAP.url'}, $CONFIG{'LDAP.base_dn'}, $CONFIG{'LDAP.principal'}, $CONFIG{'LDAP.password'});
my $db = ITA::DB->new($CONFIG{'DB.hostname'}, $CONFIG{'DB.username'}, $CONFIG{'DB.password'}, $CONFIG{'DB.dbname'}, $CONFIG{'DB.driver'});

my $res = $ldap->search('(CN=sap-user-*)');
my @attributes = qw(distinguishedName displayName name memberof whencreated whenchanged logoncount lastlogontimestamp accountExpires);

foreach $entry (@$res) {
	my %attr = map {
		$_ => $entry->get_value($_)
	} @attributes;
	
	my $accountexpires = ($attr{accountExpires}) ? ITA::Util->ldapTimeToUnixTime($attr{accountExpires}) : undef;
	my $lastlogontimestamp = ($attr{lastlogontimestamp}) ? ITA::Util->ldapTimeToUnixTime($attr{lastlogontimestamp}) : undef;
	my $active = ($attr{memberof} =~ /CN=Active Ext SAP Users/i) ? 1 : 0;
	
	my @data = (
		$attr{distinguishedName}, $attr{name}, $attr{displayName},
		($attr{whencreated}) ? ITA::Util->YMDTimeToUnixTime($attr{whencreated}) : undef,
		($attr{whenchanged}) ? ITA::Util->YMDTimeToUnixTime($attr{whenchanged}) : undef,
		$accountexpires, $accountexpires,
		$attr{logoncount},
		$lastlogontimestamp, $lastlogontimestamp,
		$active
	);
	
	$db->update_user(\@data);
}
