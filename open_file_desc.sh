#!/bin/sh
file=/proc/sys/fs/file-nr
max_nr=`awk {'print $3'} /proc/sys/fs/file-nr`
curr_nr=`awk {'print $1'} /proc/sys/fs/file-nr`
perc_nr=`cat $file |awk {'print $1'}|while read i;do awk 'BEGIN{print "%",$i*100/'$max_nr'}'| sed 's/% /%/g'; done`

echo $curr_nr of $max_nr "($perc_nr)"

