#!/bin/bash
if [ $# != 2 ]
then
    printf "Syntaxe: $0 [url|play|record] http://www.pluzz.fr/...\n" >&2
    exit 1
fi
command="$1"
url="$2"
 
if [ "$command" != 'url' -a "$command" != 'play' -a "$command" != 'record' ]
then
    printf "Command must be 'url', 'play' or 'record', not '$command'\n" >&2
    exit 2
fi
 
stream_url_part1='mms://a988.v101995.c10199.e.vm.akamaistream.net/7/988/10199/3f97c7e6/ftvigrp.download.akamai.com/10199/cappuccino/production/publication'
video_page_url=$(wget -qO- "$url" | grep -o 'http://info.francetelevisions.fr/?id-video=[^"]\+')
stream_url_part2=$(wget -qO- "$video_page_url" | grep urls-url-video | grep -o '[^"]\+\.wmv')
stream_url="$stream_url_part1/$stream_url_part2"
 
if [ "$command" = "url" ]
then
    printf "$stream_url\n"
elif [ "$command" = "play" ]
then
    vlc "$stream_url"
elif [ "$command" = "record" ]
then
    output_file=${stream_url##*/}
    printf "Recording to $output_file...\n"
    vlc "$stream_url" ":sout=#std{access=file,mux=asf,dst=$output_file}"
fi
