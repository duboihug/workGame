 #!/usr/bin/perl -w
    use strict;
    use LWP::UserAgent;
    use HTML::Form;
    use HTTP::Cookies;
    use Getopt::Std;

    require "connexion.pl";
    require "batiments.pl";
    require "ressources.pl";

    my $main_page = connect_ogame() ;

    my @planet = get_planetes();
    my %liste_bat = get_liste_batiment();

    foreach my $pla (@planet) {
    	print"\n$pla\n";

    	foreach my $bat (keys(%liste_bat)) {
		print "\nBatiment : $bat";
   		my $test = get_bat_info_niveau_sup($pla,$liste_bat{$bat});
		}

		my %ressource = get_ressouces($pla);

		foreach my $res (keys(%ressource)) {
   		print "$res : $ressource{$res}\n";
		}

    }
    
	
	
	

	

	
    
    
    