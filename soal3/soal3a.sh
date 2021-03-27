#!/bin/bash
for ((num=1; num<=23; num=num+1))
do
if [ $num -le 9 ]
then
wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_0$num"
else
wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$num"
fi
done

md5sum * | \
sort | \
awk 'BEGIN{lasthash = ""} $1 == lasthash {print $2} {lasthash = $1}' | \
xargs rm

i=1
for fi in Koleksi_*; do
	mv "$fi" Koleksi_$i
	i=$((i+1))
done
