# LDAP-Users-Management
Helper tool to export and synchronize certain group of users from Active Directory with database.

## Dependencies
* Database Server - MySQL/MariaDB preferred
* Config::Simple
* DBI
* Net::LDAP
* Time::Piece
* Util::Any

## Usage
* Please edit included config template to accomodate your environment.
* Import database schema from doc/schema.sql file into your database.
* You can run _sync.pl_ without any other parameters.
