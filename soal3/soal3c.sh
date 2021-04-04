#!/bin/bash

gambar_kucing() {
mkdir "/home/amanullahd/Kucing_$(date +"%d-%m-%Y")"
cd "/home/amanullahd/Kucing_$(date +"%d-%m-%Y")"
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
	if [ $i -le 9 ]
	then
	mv "$fi" Koleksi_0$i
	i=$((i+1))
	else
        mv "$fi" Koleksi_$i
        i=$((i+1))
	fi
done

}

gambar_kelinci() {
mkdir "/home/amanullahd/Kelinci_$(date +"%d-%m-%Y")"
cd "/home/amanullahd/Kelinci_$(date +"%d-%m-%Y")"
for ((num=1; num<=23; num=num+1))
do
if [ $num -le 9 ]
then
wget -a Foto.log https://loremflickr.com/320/240/bunny -O "Koleksi_0$num"

else
wget -a Foto.log https://loremflickr.com/320/240/bunny -O "Koleksi_$num"
fi
done

md5sum * | \
sort | \
awk 'BEGIN{lasthash = ""} $1 == lasthash {print $2} {lasthash = $1}' | \
xargs rm

i=1
for fi in Koleksi_*; do
	if [ $i -le 9 ]
	then
	mv "$fi" Koleksi_0$i
	i=$((i+1))
	else
        mv "$fi" Koleksi_$i
        i=$((i+1))
	fi
done

}


currentdate=$(date +%d)
currentmonth=$(date +%m)
currentyear=$(date +%Y)
if [ $(expr $currentyear % 4) == "0" ];
then
	if [ $currentmonth -eq 1 ] || [ $currentmonth -eq 3 ] || [ $currentmonth -eq 6 ] || [ $currentmonth -eq 7 ] || [ $currentmonth -eq 9 ] || [ $currentmonth -eq 10 ]
        then
                if [ $(expr $currentdate % 2) != "0" ];
                then
                gambar_kucing
                else
                gambar_kelinci
                fi
        else
        if [ $(expr $currentdate % 2) != "0" ];
                then
                gambar_kelinci
                else
                gambar_kucing
                fi
        fi
else
	if [ $currentmonth -eq 1 ] || [ $currentmonth -eq 4 ] || [ $currentmonth -eq 5 ] || [ $currentmonth -eq 8 ] || [ $currentmonth -eq 11 ] || [ $currentmonth -eq 12 ]
	then
		if [ $(expr $currentdate % 2) != "0" ];
		then
		gambar_kucing
		else
		gambar_kelinci
		fi
	else
	if [ $(expr $currentdate % 2) != "0" ];
                then
                gambar_kelinci
                else
                gambar_kucing
                fi
	fi
fi
