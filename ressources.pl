 #!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use HTML::Form;
use HTTP::Cookies;
use Getopt::Std;

require "connexion.pl" ;
require "functions.pl" ;

sub get_ressouces {
	my ($id_planet) = @_; 

	my $urlGen="http://s127-fr.ogame.gameforge.com/game/index.php?cp=".$id_planet;
	my $reqGen = HTTP::Request->new( GET => "$urlGen" );
	my $ua = agent_connect();
    my $resGen = $ua->request($reqGen);

    my $HTMLpage = $resGen->content();

	my $metal=0;
	my $cristal=0;
	my $deuterium=0;

	if ($HTMLpage =~/<span id="resources_metal" class="">\n*\s*(.*?)\s*<\/span>/) {
		$metal=traitement_number($1);
	}

	if ($HTMLpage =~/<span id="resources_crystal" class="">\n*\s*(.*?)\s*<\/span>/) {
		$cristal=traitement_number($1);
	}

	if ($HTMLpage =~/<span id="resources_deuterium" class="">\n*\s*(.*?)\s*<\/span>/) {
		$deuterium=traitement_number($1);
	}

	my %res = ("metal" => $metal,
				"cristal" => $cristal,
				"deuterium" => $deuterium);

	return %res;
}

sub get_planetes {
	my $urlGen="http://s127-fr.ogame.gameforge.com/game/index.php";
	my $reqGen = HTTP::Request->new( GET => "$urlGen" );
	my $ua = agent_connect();
    my $resGen = $ua->request($reqGen);

    my $HTMLpage = $resGen->content();

    my @planet =();
	if ($HTMLpage=~/<div class="smallplanet" id="planet-(.*?)">/) {
		@planet=($HTMLpage=~/<div class="smallplanet" id="planet-(.*?)">/g);
	}

	return @planet;
}
1;