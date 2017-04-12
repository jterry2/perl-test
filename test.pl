#!/usr/bin/perl
use strict; 
use Template;
use DBI;
use CGI;

my $cgiObject=new CGI; #$cgiObject=CGI->new();
print STDOUT $cgiObject->header('text/html');

print "<p>hello world</p>";

my $dbName = $ENV{'MYSQL_DATABASE'};
my $user = $ENV{'MYSQL_USER'};
my $dbPassword = $ENV{'MYSQL_PASSWORD'};
my $host = $ENV{'MYSQL_HOST'};

my $dsn = "DBI:mysql:$dbName:$host";

my $dbObject = DBI->connect($dsn, $user, $dbPassword)
or print ("Can't connect user $user to database $host:$dbName");
my $query = "SELECT * from apps_countries";
my $sth = $dbObject->prepare ($query);
$sth->execute() or print "error executing";
while (my $ref = $sth->fetchrow_hashref()) {
	print $ref;
}

