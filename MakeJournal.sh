#!/bin/bash

JournalFile="`date '+%Y-%m%d-J-%A'`"
Entry="`date '+### %H:%M'`"
JOURNAL=/home/david/Dropbox/perso/archives/$JournalFile.markdown

if [ -s $Journal ]; then
	echo "
" >> $JOURNAL
	echo $Entry >> $JOURNAL
	echo "
" >> $JOURNAL
	gnome-open $JOURNAL
else
	touch $JOURNAL
	echo "
" >> $JOURNAL
	echo $Entry >> $JOURNAL
	echo "
" >> $JOURNAL
	gnome-open $JOURNAL	
fi
