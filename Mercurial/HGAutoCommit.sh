#!/bin/sh  
  
REPOS="/Users/david/Dropbox/Arnaud"  
DATE=`date '+%Y-%m%d %A @ %H:%M'`
PC=`hostname`
  
for r in $REPOS  
do  
 echo "Working on $r"  
  
 # clean up temporary files  
 find $r -type f -name "._*" \! -wholename "*.hg*" -exec rm {} \;  
  
 # find changes  
 hg addremove -R $r  
 hg commit -m "Auto commit @ $DATE, on $PC" -R $r  
done