#!/bin/sh

file=/etc/crontab
old_sum=/var/log/crontab_sum.old
new_sum=/var/log/crontab_sum.new

if [ ! -f $old_sum ]
then
	shasum < $file > $old_sum	# Compute old sum (if it doesn't exist)
	exit
fi

shasum < $file > $new_sum		# Compute new sum

if [ "$(diff $old_sum $new_sum)" != "" ]
then
	echo "crontab has been modified." | mail -s "Warning!" root
	shasum < $file > $old_sum
fi