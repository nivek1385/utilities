#!/bin/bash
#Uses EP API to pull today's birthdays from the ECHL

rm bdays.txt
for year in $(seq 1950 2000); do
  wget "http://api.eliteprospects.com:80/beta/leagues/10/players?limit=5&filter=dateOfBirth%3D$year-$(date +"%m-%d")&apikey=080db487b8181a68f6dc2dd2e91a531c" -O bday.txt
  count=$(jq '.metadata.count' bday.txt)
  if [[ $count > 0 ]] ; then
    jq '.data[].id,.data[].firstName,.data[].lastName' bday.txt >> bdaytmp.txt
    mv bdaytmp.txt bday.txt
    for k in $count; do
      sed -n "${k}p" bday.txt >> bdays.txt
      sed -n "$((k+count))p" bday.txt >> bdays.txt
      sed -n "$((k+count+count))p" bday.txt >> bdays.txt
      echo '*****************************************************************'
    done
  fi
done
