#!/bin/bash

TheDateName=`date +%Y-%m%d-%Hh%M`;
NewName=backup-$TheDateName.log ;
rsync -a --del --ignore-errors --force /Users/david /Volumes/tux/backup/;
TheDate=`date +%Y-%m%d-%H:%M`; 
echo "backup OK @ $TheDate" >> /media/tux/$NewName; 

