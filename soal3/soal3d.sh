#!/bin/bash
cd /home/amanullahd
for fi in Kucing_*; do
	zip -u -m --password "$(date +"%m%d%Y")" -r Koleksi.zip "$fi"
done

for fi in Kelinci_*; do
        zip -u -m --password "$(date +"%m%d%Y")" -r Koleksi.zip "$fi"
done