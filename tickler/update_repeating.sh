#!/bin/sh
for i in `seq 1 9`; do
	f="0$i"
	mv $f $f.bak
	#sed -e 's/^XXX.*XXX$//' $f.bak > $f
	sed -e '/^XXX.*XXX$/d' $f.bak > $f
done
for i in `seq 10 31`; do
	f="$i"
	mv $f $f.bak
	#sed -e 's/^XXX.*XXX$//' $f.bak > $f
	sed -e '/^XXX.*XXX$/d' $f.bak > $f
done

month=`date +%m`
list=`cal | tail -2`
numdays=`for i in $list; do echo $i; done | tail -1`

# get the list of repeating/ files
filelist=`/bin/ls repeating/`
for f in $filelist; do
	echo reading file repeating/$f
	grep "^A " repeating/$f > nextlist
	cat nextlist | while read line; do
		./insert_entry.py $line
	done
	grep "^W " repeating/$f > nextlist
	cat nextlist | while read line; do
		./insert_entry.py $line
	done
	grep "^D " repeating/$f > nextlist
	cat nextlist | while read line; do
		./insert_entry.py $line
	done
	grep "^M " repeating/$f > nextlist
	cat nextlist | while read line; do
		./insert_entry.py $line
	done
done
rm nextlist
rm *.bak
