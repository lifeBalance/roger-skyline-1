#!/bin/sh

file=/etc/crontab
old_sum=${file}_sum.old
new_sum=${file}_sum.new

if [ ! -f $old_sum ]
then
	shasum < $file > $old_sum	# Compute old sum (if it doesn't exist)
	exit
fi

shasum < $file > $new_sum		# Compute new sum

if [ "$(diff $old_sum $new_sum)" != "" ]
then
	mail -s "crontab has been modified!" root
	shasum < $file > $old_sum
fi