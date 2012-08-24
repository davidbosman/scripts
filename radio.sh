#!/usr/bin/perl
# ------------------------------------------------------------------
#    made by sputnick in da FreAkY lApPy lAb (c) 2009
#    gilles.quenot <AT> gmail <DOT> com
#
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of version 2 of the GNU General Public
#    License published by the Free Software Foundation.
# ------------------------------------------------------------------
#                                        ,,_
#                                       o"  )@
#                                        ''''
# ------------------------------------------------------------------
#
# vim:ts=4:sw=4

# Ajouter des radios ici en respectant la syntaxe des autres lignes :
# -----8<--------------------------------------------------------------------------------
my %hash = (
        'France_Culture'            =>    'http://www.tv-radio.com/station/france_culture_mp3/france_culture_mp3-128k.m3u',
        'France_Inter'                =>    'http://www.tv-radio.com/station/france_inter_mp3/france_inter_mp3-128k.m3u',
        'Best_Of_Classic'        =>    'http://shoutcast.omroep.nl:8072/',
        'Radio_Nova'        =>    'http://broadcast.infomaniak.net:80/radionova-high.mp3',
        'Radio_Paradise'    =>    'http://stream-ny.radioparadise.com:8062',
        'FIP'            =>    'http://mp3.live.tv-radio.com/fip/all/fiphautdebit.mp3',
        'BBC_World_News'            =>    'http://www.bbc.co.uk/worldservice/meta/tx/nb/live/ennws.asx',
);
# -----8<--------------------------------------------------------------------------------

# Changelog
#     - 0.2
#         On remplace cvlv par vlc -Idummy qui est plus portable

our $version = 0.2;
my $key;

use strict;
use warnings;

if ((defined(@ARGV)) && ($ARGV[0] eq '-v')) {
    print ("$0 $version\n");
    exit(0);
}

while (1) {
    my @arr = ();

    while($key = each %hash){
        push(@arr, $key);
    }

    my $result = qx(
        printf '%s\n' @arr 'EXIT->[]' |
            zenity --width=50 --height=300 --list --title "Radio Play" --text "Faire son choix :" --column "Radios" ||
            exit 1
    );

    chomp($result);
    exit(1) unless $result;
    exit(0) if $result eq 'EXIT->[]';

    system("{
            vlc -Idummy $hash{$result} >/dev/null 2>&1 & _pid=\$!
        } || break
        zenity --info --title=\"Radio Play\" --text=\"Now playing $result...\nCliquer \"Valider\" pour arreter.\"; kill \$_pid"
    );
}
