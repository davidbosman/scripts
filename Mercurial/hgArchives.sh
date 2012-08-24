#!/bin/bash

# A small script to init an HG repo if it does not
# already exist, add new files in the folder and make a commit with the time stamp as message, all of that within gedit.
#
# ATTENTION: in order to know where to do version control voodoo the script need the file to already have been saved one time in the desired directory.
#
# Tool Settings that you must define wen add this new external tool: 
# Save = Current Document, 
# Input = Nothing,
# OutPut = Display in Bottom Pane,
# Language = All
#
# Free to use and improve (let me know):
# david@davidbosman.fr
# http://davidbosman.fr
# 
# ;)

# format the date for commit message as "Monday 12 June 2011 @ HH:MM":
MSG="`date '+%A %d %B %Y @ %Hh%M'`"
# get the path to the file:
DIR="~/Documents/perso/Archives"
cd ~/Documents/perso/Archives/

# If Mercurial not already intiated in this directory, initiate it:
if [[ ! -e $DIR/.hg ]]; then
    hg init
fi

#Add and commit the file(s):
hg add
hg commit -m "Commit automatique: ${MSG}"

