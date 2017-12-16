#!/bin/bash
#Season Info ECHL Parser for SportsClubStats

cd ~/utilities/ECHLparser
wget "http://cluster.leaguestat.com/feed/index.php?feed=chlpremium&key=dfd0ffe484e007d9&client_code=echl&sub=seasons" -O seasons.xml

xmlstarlet pyx seasons.xml > seasons.txt #convert xml to pyx format
sed -i 's/-\\n//g' seasons.txt #Remove lines containing only -\n
sed -i '/^ *$/d' seasons.txt #Remove empty lines
sed -i '/(copyright.*/,+15d' seasons.txt
tr -d '\n' < seasons.txt | sed 's/)/)\n/g' > season.txt
mv season.txt seasons.txt
sed -i 's/^.*(/(/g' seasons.txt
sed -i '/^playoff)/d' seasons.txt
sed -i 's/(//g' seasons.txt
sed -i 's/)//g' seasons.txt
sed -i '/^start_date.*/d' seasons.txt
sed -i '/^end_date.*/d' seasons.txt
sed -i '/^league_id.*/d' seasons.txt
sed -i '/^career.*/d' seasons.txt
sed -i '/^playoff-.*/d' seasons.txt
sed -i '/^season_name.*/d' seasons.txt
sed -i '/^season$/d' seasons.txt
tac seasons.txt > season.txt
sed -i '/.*All-Star/I,+1 d' season.txt
sed -i '/.*All Star/I,+1 d' season.txt
sed -i '/.*Playoffs/I,+1 d' season.txt
sed -i '/.*Pre.*/I,+1 d' season.txt
tac season.txt > seasons.txt
sed -i 's/season_id-/id=/g' seasons.txt
sed -i 's/short_name-/year=/g' seasons.txt
sed -i 's/ Reg//g' seasons.txt
tac seasons.txt > season.txt
mv season.txt seasons.txt
sed -i ':r;$!{N;br};s/\nid/;id/g' seasons.txt
sed -i 's/year=/year="/g' seasons.txt
sed -i 's/;/";/g' seasons.txt
sed -i 's/year=//g' seasons.txt
sed -i 's/id=//g' seasons.txt

id=$(grep "\"$1\";" seasons.txt | sed 's/.*;//g')
echo $id
