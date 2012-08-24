#!/bin/bash

JournalFile="`date '+%Y-%m%d-J-%A'`"

Journal=~/Documents/perso/Archives/$JournalFile.markdown

if [ -s $Journal ]; then
       gnome-open $Journal
else
    touch $Journal
    gnome-open $Journal
fi
Entry="`date '+%H:%M'`"
echo "### $Entry" | xclip -i 
