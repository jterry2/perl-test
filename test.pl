use strict;
use Template;
use DBI;
use CGI;

use constant TEMPLATE => 'results.tt2';
use constant TEMPLATELIB => '.';

my %config=(
        INCLUDE_PATH => [ TEMPLATELIB ],
    );

my $ttObject = Template->new( \%config );

my $cgiObject=new CGI; #$cgiObject=CGI->new();
print STDOUT $cgiObject->header('text/html');

my $dbName = $ENV{'MYSQL_DATABASE'};
my $user = $ENV{'MYSQL_USER'};
my $dbPassword = $ENV{'MYSQL_PASSWORD'};
my $host = $ENV{'MYSQL_HOST'};

my $dsn = "DBI:mysql:$dbName:$host";

my $dbObject = DBI->connect($dsn, $user, $dbPassword)
or print ("Can't connect user $user to database $host:$dbName");

my $query = "SELECT country.Name, city.Name as Capital from country left JOIN city on country.Capital = city.ID";
my $sth = $dbObject->prepare ($query);
$sth->execute() or print "error executing";

my @table;
while (my $ref = $sth->fetchrow_hashref()) {
        push(@table, $ref);
}

my $vars = {
        countries => \@table
};

$ttObject->process ( TEMPLATE, $vars )
        or die( $ttObject->error() );
