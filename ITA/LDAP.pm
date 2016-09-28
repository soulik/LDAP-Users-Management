package ITA::LDAP;

use strict;
use warnings;

use Net::LDAP;

our $VERSION = "1.01";

sub new {
	my $class = shift;
	my ($url, $basedn, $principal, $pwd) = @_;
	
	my $self = {
		url => $url,
		basedn => $basedn,
		principal => $principal,
		pwd => $pwd,
	};
	
	bless $self, $class;
	$self->init;
	return $self;
};

sub init {
	my $self = shift;
	my $conn = Net::LDAP->new($self->{url}) or die "$@";
	
	my $msg = $conn->bind( $self->{principal}, password => $self->{pwd});
	
	$msg->code && die $msg->error;
	$self->{conn} = $conn;
};

sub search {
	my $self = shift;
	my ($filter) = @_;
	my $conn = $self->{conn};
	
	my $msg = $conn->search(
		base => $self->{basedn},
		filter => $filter,
	);
	
	$msg->code && die $msg->error;
	
	return $msg->{entries};
};

sub DESTROY {
	my $self = shift;
	my $conn = $self->{conn};
	$conn->unbind;
};

1;
