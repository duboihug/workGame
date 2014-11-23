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
sub get_info_generic_batiment {
	my ($id_planet,$id_batiment) = @_;
	my $urlGen="http://s127-fr.ogame.gameforge.com/game/index.php?page=resources&cp=".$id_planet."&ajax=1&type=".$id_batiment;
	my $reqGen = HTTP::Request->new( GET => "$urlGen" );
	my $ua = agent_connect();
    my $resGen = $ua->request($reqGen);

    return $resGen->content();
}

#Récupére les infos sur les batiments
sub get_bat_info_niveau_sup {
	my ($id_planet, $id_batiment) = @_;
	print "\nPlanet_id = ".$id_planet."\n";
	my $resMineHTML = get_info_generic_batiment($id_planet,$id_batiment);

	#print "\n".$resMineHTML;
	my $level = 0;
	my $metal = 0;
	my $cristal = 0;
	my $deut = 0;
	my $energie = 0;

	if ($resMineHTML =~/Nécessaire pour le niveau (.*?) :/) {
		$level = $1;
	}

	if ($resMineHTML =~/<li class="metal tooltip" title="(.*?) M/) {
		$metal = traitement_number($1);
	}

	if ($resMineHTML =~/<li class="crystal tooltip" title="(.*?) C/) {
		$cristal = traitement_number($1);
	}
	 
	if ($resMineHTML =~/<li class="deuterium tooltip" title="(.*?) D/) {
		$deut = traitement_number($1);
	}

	if ($resMineHTML =~/Énergie nécessaire:\n*\s*<span class="time">(.*?)<\/span>/) {
		$energie = traitement_number($1);
	}

	my %res = ("level" => $level,
				"metal" => $metal,
				"cristal" => $cristal,
				"deuterium" => $deut,
				"energie" => $energie);

	foreach my $cle (keys(%res)) {
   		print "$cle : $res{$cle}\n";
	}
     
    return %res;
}

sub get_liste_batiment {
	my %batiment = ("mine_metal" => 1,
					"mine_cristal" => 2,
					"mine_deuterium" => 3,
					"centrale_solaire" => 4,
					"centrale_fusion" => 12,
					"hangar_metal" => 22,
					"hangar_cristal" => 23,
					"hangar_deuterium" => 24,
					"usine_robot" => 14,
					"chantier_spatial" => 21,
					"laboratoire_recherche" => 31,
					"depot_ravitaillement" => 34,
					"silo_missiles" => 44,
					"usine_nanite" => 15,
					"terraformeur" => 33);

	return %batiment;
}

1;