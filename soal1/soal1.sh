#!/bin/bash

#a.
grep -o "[I|E].*" syslog.log

#b. cari error dan jumlahnya
modified=$(grep "The ticket was modified while updating" syslog.log | wc -l)
cTicket=$(grep "Permission denied while closing ticket" syslog.log | wc -l)
closed=$(grep "Tried to add information to closed ticket" syslog.log | wc -l)
timeout=$(grep "Timeout while retrieving information" syslog.log | wc -l)
noExist=$(grep "Ticket doesn't exist" syslog.log | wc -l)
connection=$(grep "Connection to DB failed" syslog.log | wc -l)

#c.d. print error dan info
echo "Error,Count" > error_info.csv
printf "The ticket was modified while updating,%d\n
Permission denied while closing ticket,%d\n
Tried to add information to closed ticket,%d\n
Timeout while retrieving information,%d\n
Ticket doesn't exist,%d\n
Connection to DB failed,%d\n" $modified $cTicket $closed $timeout $noExist $connection|
sort -t, -nr -k2 >> error_info.csv

#e.
tr ' ' '\n' < syslog.log > test.txt
grep -o "(.*)" test.txt | tr -d "(" | tr -d ")" | sort | uniq > user_statistic.txt
echo "Username,INFO,ERROR" > user_statistic.csv
while read -r userName
do
info=$(grep -E -o "INFO.*($userName)" syslog.log | wc -l)
error=$(grep -E -o "ERROR.*($userName)" syslog.log | wc -l)
echo "$userName,$info,$error" >> user_statistic.csv

done < user_statistic.txt
