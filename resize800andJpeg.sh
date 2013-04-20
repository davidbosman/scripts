#!/usr/bin/env plain
# resize bunch of files to 800px max and covert to jpeg.
#
# http://davidbosman all rights unreserved, even on Mars.


for f in $@
	do
		/opt/ImageMagick/bin/convert -resize 800x800\> "$f" "/tmp/un.png"
		/opt/ImageMagick/bin/convert  "/tmp/un.png" -quality 90% "$f".jpg
	done

