#!/usr/bin/env bash

WHERE=~/Pictures/dayonegallery.html

echo "<!DOCTYPE html><html lang=\"fr\"><head><meta charset=\"utf-8\" \/><title>Galerie de photos Day One</title><style type=\"text/css\" media=\"screen\">body {background-color:#434343;}img {width:140px; float:right; border:2px solid #434343;}" > $WHERE
echo ".square {" >> $WHERE
    echo "float: left;" >> $WHERE
echo "    width:100px;" >> $WHERE
echo "    height:100px;" >> $WHERE
echo "    display:block;" >> $WHERE
echo "    overflow:hidden;" >> $WHERE
echo "}" >> $WHERE
echo ".page{" >> $WHERE
echo "width:100%;}</style></head><body>" >> $WHERE
echo "<div class=\"page\">" >> $WHERE

for i in ~/Library/Mobile\ Documents/5U8NS4GX82~com~dayoneapp~dayone/Documents/Journal_dayone/photos/*	
	do	
		#ENTRY=`basename "$i" .jpg`
		ENTRY=`dirname "$i"`	
		echo "<div class=\"square\"><a href=\"file:///" >> $WHERE
		echo "$ENTRY" >> $WHERE
		echo "\/.DS_Store\\"><img src=\"" >> $WHERE
		echo "$i" >> $WHERE
		echo "\"/></a></div>" >> $WHERE
	done
	
for i in ~/Dropbox/perso/archives/*.png	
	do	
		echo "<div class=\"square\"><a href=\"" >> $WHERE
		echo "$i" >> $WHERE
		echo "\"><img src=\"" >> $WHERE
		echo "$i" >> $WHERE
		echo "\"/></a></div>" >> $WHERE
	done
	
echo "</div></body></html>" >> $WHERE
