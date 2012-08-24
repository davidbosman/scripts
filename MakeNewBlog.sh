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
# David Bosman -- davidATdavidbosman.fr
#
# version:
# 0.1
# 2011, Feb 22.
# Happy note-taking ;)
        # Where should the notes be stored?
        MYPATH=/home/david/Documents/perso/Archives/

        Filedate=`date '+%Y-%m%d'`
        MYDATE=`date '+%A %d %B %Y'`
        ID=`date '+id_%Y%m%d%H%M%S'`
        xclip -o >/tmp/tmpclip.txt
        MYCLIP=`cat /tmp/tmpclip.txt`

		# if uname = Darwin -> 0SX
		# if uname = Linux -> Linux ;)

        #dialogbox to name the note (file name and title):
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
        FILENAME=$Filedate-W-$titre.blog.markdown
        echo "Title: $titre1  " > $MYPATH$FILENAME
        echo "Kewyords: $MYDATE  " >> $MYPATH$FILENAME
        echo "Category:  " >> $MYPATH$FILENAME
        echo "  " >> $MYPATH$FILENAME
        echo ">$MYCLIP" >> $MYPATH$FILENAME
        echo " " >> $MYPATH$FILENAME
        gnome-open $MYPATH$FILENAME

