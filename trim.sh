#!/bin/bash

#change format if you need
#ffmpeg -i 0.ts -vcodec copy -acodec copy 0.mp4

echo "enter the split time stamps ex: 00.05.45-00.10.08 00.12.15-00.15.25"
read timestamps

i=0

for time in $timestamps; do
	name="_trim${i}.mp4"
	timestamp=${time//-/" -to "}
	timestamp=${timestamp//./":"}
	ffmpeg -ss ${timestamp} -i 0.mp4 -c copy ${name}
	((i = i + 1))
done

for f in _trim*; do echo "file '$f'" >>_list.txt; done
ffmpeg -safe 0 -f concat -segment_time_metadata 1 -i _list.txt -vf select=concatdec_select -af aselect=concatdec_select,aresample=async=1 output.mp4
rm ./_list.txt ./_trim*.mp4

#if you edit multiple files and need to automaticaly name the output files
# create a _count.md file and write the starting number

#count=$(<_count.md)

#for f in _trim*; do echo "file '$f'" >>_list.txt; done
#ffmpeg -safe 0 -f concat -segment_time_metadata 1 -i _list.txt -vf select=concatdec_select -af aselect=concatdec_select,aresample=async=1 "rl_${count}.mp4"
#rm ./_list.txt  ./_trim*.mp4
#mv ./rl_* ./final

#count_plus=$(($count + 1))
#echo "$count_plus" >_count.md
