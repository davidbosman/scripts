#!/bin/bash

#!/bin/bash
TheDestPath=/media/truecrypt7/backup

TheDateName=`date +%Y-%m%d-%Hh%M`;
NewName=backup-$TheDateName.log ;
rsync -a --del --ignore-errors --force /home/david/"2010-0807-N-Sainte-Gemme"/ $TheDestPath/"2010-0807-N-Sainte-Gemme";
rsync -a --del --ignore-errors --force /home/david/Dropbox/perso/notes/ $TheDestPath/notes;
rsync -a --del --ignore-errors --force /home/david/Images/ $TheDestPath/Images;

TheDate=`date +%Y-%m%d-%H:%M`; 
echo "backup OK @ $TheDate" >> /media/truecrypt7/$NewName; 

