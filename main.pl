 #!/usr/bin/perl -w
    use strict;
    use LWP::UserAgent;
    use HTML::Form;
    use HTTP::Cookies;
    use Getopt::Std;

    require "connexion.pl";
    require "ressources_bat.pl";

    my $main_page = connect_ogame() ;
    
    my $test = get_metal_info(33850735);
    