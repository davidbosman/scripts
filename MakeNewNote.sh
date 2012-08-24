#!/bin/bash
#
# Open a dialog box, asking user a title for the new note
# Create a file name based on day's date + title + .markdown:
# "2011-0323-N-title.markdown"
# Add a template in the file, and a unique ID in the keywords field.
# Finaly open it in Gnome's default text editor.
# By default it will also paste the clipboard (generaly an URL, in my case) in the "Source" field of the template.
#
# require :
# xclip
# zenity
#
# Author:
# David Bosman -- david@davidbosman.fr
#
# version:
# 0.1
# 2011, Feb 22.
# Happy note-taking ;)

        # Where should the notes be stored?
        # MYPATH=/home/david/Documents/perso/Archives/
	MYPATH=/home/david/
        Filedate=`date '+%Y-%m%d'`
        MYDATE=`date '+%A %d %B %Y'`
        ID=`date '+id_%Y%m%d%H%M%S'`
        xclip -o >/tmp/tmp.txt
        MYCLIP=`cat /tmp/tmp.txt`

		# if uname = Darwin -> Mac
		# if uname = Linux -> Linux

        #dialogbox to ad a title to the name of the note:
        if ret=`zenity --entry --title='Titre de votre note' --text='Les espaces seront convertis en "--" :'`
		then
			titre1=$ret
			#if [ "$titre1" = "" ]
			#	then
			#		echo "Il faut un titre"
			#		exit
			#fi
		else
			exit
	fi
        titre=`echo $titre1 | tr ' ' '-'`
        FILENAME=$Filedate-$titre.markdown
        echo "Title: $titre1  " > $MYPATH$FILENAME
        echo "Date: $MYDATE  " >> $MYPATH$FILENAME
        echo "Source:  " >> $MYPATH$FILENAME
        echo "Keywords: $ID,  " >> $MYPATH$FILENAME
        echo "  " >> $MYPATH$FILENAME
        echo ">$MYCLIP" >> $MYPATH$FILENAME
        echo " " >> $MYPATH$FILENAME
        echo " " >> $MYPATH$FILENAME
        gnome-open $MYPATH$FILENAME

