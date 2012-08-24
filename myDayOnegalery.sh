#!/usr/bin/env bash
# david@davidbosman.fr || http://davidbosman.fr

WHERE=$HOME/Pictures/dayonegallery.html
PATH2ENTRY="$HOME/Library/Mobile Documents/5U8NS4GX82~com~dayoneapp~dayone/Documents/Journal_dayone/photos/"

echo "<!DOCTYPE html><html lang=\"fr\"><head><meta charset=\"utf-8\" \/><title>Galerie de photos Day One</title><style type=\"text/css\" media=\"screen\">body {background-color:#434343;}img {width:320px; float:left; border:2px solid #434343;}.square {float: left;width:240px;height:240px;display:block;overflow:hidden;.page{
width:90%;margin-left:5%;margin-right:5%;}</style></head><body><div class=\"page\">" > $WHERE


for i in `ls -t ~/Library/Mobile\ Documents/5U8NS4GX82~com~dayoneapp~dayone/Documents/Journal_dayone/photos/`

#for i in `ls -t $PATH2ENTRY`
	do
		echo "<div class=\"square\"><a href=\"file:///$PATH2ENTRY$i\"><img src=\"$PATH2ENTRY$i\"/></a></div>" >> $WHERE
	done
echo "</div></body></html>" >> $WHERE

open $HOME/Pictures/dayonegallery.html

