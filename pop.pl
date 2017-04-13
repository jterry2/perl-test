use strict;
use Template;
use DBI;
use CGI;

use constant TEMPLATE => 'pop.tt2';
use constant TEMPLATELIB => '.';

my %config=(
        INCLUDE_PATH => [ TEMPLATELIB ],
    );

my $ttObject = Template->new( \%config );

my $cgiObject=new CGI;
print STDOUT $cgiObject->header('text/html');

my $dbName = $ENV{'MYSQL_DATABASE'};
my $user = $ENV{'MYSQL_USER'};
my $dbPassword = $ENV{'MYSQL_PASSWORD'};
my $host = $ENV{'MYSQL_HOST'};

my $dsn = "DBI:mysql:$dbName:$host";

my $dbObject = DBI->connect($dsn, $user, $dbPassword)
or print ("Can't connect user $user to database $host:$dbName");

my $city = $ENV{'QUERY_STRING'};
$city =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

my $query = "SELECT Name, Population FROM city WHERE ID = $city";

my $sth = $dbObject->prepare ($query);
$sth->execute() or print "error executing";
my @table;
while (my $ref = $sth->fetchrow_hashref()) {
        push(@table, $ref);
}

my $vars = {
        cities => \@table
};

$ttObject->process ( TEMPLATE, $vars )
        or die( $ttObject->error() );

