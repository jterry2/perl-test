#!/usr/bin/perl
use strict;
use Template;
use DBI;
use CGI;
use Apache::Session::MySQL;
use constant TEMPLATELIB => '/export/srv/www/vhosts/main/tt2';

$cgiObject=new CGI; #$cgiObject=CGI->new();
print STDOUT $cgiObject->header('text/html');

print "<p>hello world</p>";
