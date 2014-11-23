 #!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use HTML::Form;
use HTTP::Cookies;
use Getopt::Std;

sub agent_connect {
    # initialisation de l'agent
    my $ua =
      LWP::UserAgent->new(
        agent => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36',
        cookie_jar => HTTP::Cookies->new(
            file           => 'cookie.txt',
            autosave       => 1,
            ignore_discard => 1        # le cookie devrait être effacé à la fin
        )
    );
    return $ua ;
}


sub connect_ogame {
    print "Tentative de connexion\n";
    my $base = 'http://fr.ogame.gameforge.com/';

    # Fichier des options
    open(FICHIN, 'config.txt') or die "Cannot open fichier config.txt files";

    my $user=0;
    my $pass=0;
    while($_=<FICHIN>) {
        my $var = $_; 
        if(/User =/) {
             $var =~/User =(.*?)\n/;
             $user=$1;
             $user=~s/[ \n]+//g;
        }
        if(/Pass =/) {
             $var =~/Pass =(.*?)\n/;
             $pass=$1;
             $pass=~s/[ \n]+//g;
        }
    }

    print "User :$user\n";
    print "Pass :$pass\n";

    my ( $user, $pass ) = qw( **** ***** );

    my $ua = agent_connect();

    # création de la requête
    my $req = HTTP::Request->new( GET => "${base}" );

    # exécute la requête et reçoit la réponse
    my $res = $ua->request($req);
    die $res->status_line if not $res->is_success;

    # le formulaire de login est le premier formulaire de la page
    my $form = ( HTML::Form->parse( $res->content, $base ) )[0];

    # remplit les champs du formulaire
    $form->find_input('login')->value($user);
    $form->find_input('pass')->value($pass);

    # valide et renvoie le formulaire
    my $mainPage = $ua->request( $form->click );

    # retour de la page
    # if ($mainPage->is_success) {
    #     print $mainPage->content;
    # } else {
    #     print $res->status_line . "\n";
    # }
    
    # Récupération du lien de redirect   
    $mainPage->content() =~ /<a href="(.*?)">/ ;
    my $urlMainPage = $1 ;       

    # Récupération de la page main
    my $reqMain = HTTP::Request->new( GET => "$urlMainPage" );
    my $resMain = $ua->request($reqMain);
    
    #Affichage page Main
    #print $resMain->content() ;

    # Rajouter Test de connexion OK 

    print "\nConnexion réussi" ;

    return $resMain->content();

}

1;
