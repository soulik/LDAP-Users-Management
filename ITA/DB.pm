package ITA::DB;

use strict;
use warnings;

use DBI;
use Util::Any -all;

our $VERSION = "1.00";

sub new {
	my $class = shift;
	my ($hostname, $username, $pwd, $dbname, $driver) = @_;
	
	my $self = {
		hostname => $hostname,
		username => $username,
		pwd => $pwd,
		dbname => $dbname,
		driver => $driver || 'mysql',
	};
	bless $self, $class;
	$self->init;
	return $self;
};

sub init {
	my $self = shift;
	my @drivers = DBI->available_drivers;
	
	die "Driver: $self->{driver} not installed!" unless  any {$_ eq $self->{driver}} @drivers;
	
	my $handle = DBI->connect(
		"dbi:$self->{driver}:$self->{dbname}:".$self->{hostname},
		$self->{username}, $self->{pwd})
		or die $DBI::errstr;
	$self->{handle} = $handle;
	$self->{update_user_statement} = <<SQL
REPLACE users
SET
	dn = ?,
	name = ?,
	displayname = ?,
	whencreated = FROM_UNIXTIME(?),
	whenchanged = FROM_UNIXTIME(?),
	accountexpires = CASE WHEN ? IS NOT NULL THEN FROM_UNIXTIME(?) ELSE NULL END,
	logoncount = ?,
	lastlogontimestamp = CASE WHEN ? IS NOT NULL THEN FROM_UNIXTIME(?) ELSE NULL END,
	active = ?;
SQL
;
}

sub update_user {
	my $self = shift;
	my ($user_data) = @_;
	
	my $statement = $self->{handle}->prepare_cached($self->{update_user_statement});
	return $statement->execute(@$user_data);
};

1;
