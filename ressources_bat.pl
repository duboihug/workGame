 #!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use HTML::Form;
use HTTP::Cookies;
use Getopt::Std;

require "connexion.pl" ;
require "functions.pl" ;

# Récupére la page de description des infras
# Argument id_planete,$id_batiment
# Retourne le code HTML de la page
sub get_info_generic {
	my ($id_planet,$id_batiment) = @_;
	my $urlGen="http://s127-fr.ogame.gameforge.com/game/index.php?page=resources&cp=".$id_planet."&ajax=1&type=".$id_batiment;
	my $reqGen = HTTP::Request->new( GET => "$urlGen" );
	my $ua = agent_connect();
    my $resGen = $ua->request($reqGen);

    return $resGen->content();
}

#Récupére les infos sur le prochain niveau de la mine de métal
sub get_metal_info {
	my ($id_planet) = @_;
	print "\nPlanet_id = ".$id_planet;
	my $resMineHTML = get_info_generic($id_planet,1);

	#print "\n".$resMineHTML;

	$resMineHTML =~/Nécessaire pour le niveau (.*?) :/ ;
	my $level = $1;

	$resMineHTML =~/<li class="metal tooltip" title="(.*?) M/ ;
	my $metal = traitement_number($1);

	$resMineHTML =~/<li class="crystal tooltip" title="(.*?) C/ ;
	my $cristal = traitement_number($1);

	my $deut = 0;

	$resMineHTML =~/<span class="time">(.*?)<\/span>/ ;
	my $energie = traitement_number($1);

	print "\n level : ".$level." metal : ".$metal." cristal : ".$cristal." deut : ".$deut." energie : ".$energie."\n";
	

    #print $resMine->content();

}

1;