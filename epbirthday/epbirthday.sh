#!/bin/bash
#Uses EP API to pull today's birthdays from the ECHL

rm bdays.txt
for year in $(seq 1950 2000); do
  wget "http://api.eliteprospects.com:80/beta/leagues/10/players?filter=dateOfBirth%3D$year-$(date +"%m-%d")&apikey=080db487b8181a68f6dc2dd2e91a531c" -O bday.txt
  count=$(jq '.metadata.count' bday.txt)
  if [[ $count > 0 ]] ; then
    jq -r '.data[].id,.data[].firstName,.data[].lastName' bday.txt >> tmp.txt
    mv tmp.txt bday.txt
    for k in $count; do
      sed -n "${k}p" bday.txt >> bdays.txt
      sed -n "$((k+count))p" bday.txt >> bdays.txt
      sed -n "$((k+count+count))p" bday.txt >> bdays.txt
    done
  fi
done

cat bdays.txt | paste -d '-' - - - >> tmp.txt
mv tmp.txt bdays.txt
echo "" >> bdays.txt

awk -F '-' '{print "http://www.eliteprospects.com/player/" $1 "/" $2 "-" $3}' bdays.txt >> tmp.txt
exec 4<tmp.txt
while read -u4 line; do
  echo $line
  ./t.ny $line | tee -a urls.txt
  echo "$line passed to tny"
  sleep 15
done
#rm tmp.txt

#awk -F '-' '{print "Happy birthday to @ECHL alum, " $2 " " $3 ". Check out his EP profile here: "}' bdays.txt >> tmp.txt
#paste tmp.txt urls.txt > bdays.txt
#rm tmp.txt urls.txt

#cd bash-send-tweet
#while read line; do
#  ./sendtweet "$line"
#  sleep $((RANDOM % 300))
#done <../bdays.txt
