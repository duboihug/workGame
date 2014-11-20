 #!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use HTML::Form;
use HTTP::Cookies;
use Getopt::Std;

# Retire les . dans les nombres
sub traitement_number {
	my ($number) = @_;
	#print "\nInit : ".$number." ";
	
	#traitement "."
	$number=~s/[.]+//g;
	
	#print "End : ".$number;

	return $number;
}

1;