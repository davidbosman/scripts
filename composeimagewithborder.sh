#!/usr/bin/env plain
#
# Resize 2 iPhone screenshots. Put one next to the other, add a niiiiice border & a separator. Save as a jpeg.
# Put this shell script in an Automator Application (OS X) to drag & drop pictures on it.
#
# http://davidbosman all rights unreserved, even on Mars.

filename=`date +"%y%m%d-%H%M%S"`

# Resize the 1st image to 400px width + extend it 5px to the right, to add a separator.
/opt/ImageMagick/bin/convert "$1" -resize '400' -background '#990000' -gravity west -extent '405' "/tmp/un.png"
# Resize the  2nd image to 400px
/opt/ImageMagick/bin/convert "$2" -resize '400' "/tmp/deux.png"
# Stitch the 2 images
/opt/ImageMagick/bin/convert "/tmp/un.png" "/tmp/deux.png" +append /tmp/$filename.png
#Add the border and save as a timestamped JPEG
/opt/ImageMagick/bin/convert /tmp/$filename.png -bordercolor '#990000' -border 5x5 ~/Desktop/$filename.jpg
