#!/bin/sh
# This script is a FLV converter to get mp4 data format. Thus "list.txt" text file which contains flv video paths.
# Required : FFMPEG

VCODEC="libx264"
ACODEC="libfaac"
AR=22050
VPRE="max"
THREADS=5
BITRATE="400k"
 
videos=`cat list.txt | while read i; do echo $i; done | sed 's/video.flv$/''/g' | sed -r 's/.{1}$//'`

for convert in $(echo "$videos");
do 
    date=`date +%Y-%m-%d`
    start=$(date +%s)
    ffmpeg -i /mnt/storage/$convert/video.flv -vcodec $VCODEC -ar $AR -acodec $ACODEC -vpre $VPRE -threads $THREADS -b $BITRATE /mnt/storage/$convert/video.mp4;
    finish=$(date +%s)
    echo -e "FINISH: $(( ($finish-$start) / 60 )) minutes, $(( ($finish-$start) % 60 )) seconds - Converted file: /mnt/storage/$convert/video.mp4" >> list.out
done