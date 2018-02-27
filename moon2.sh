#!/bin/bash
url="https://www.timeanddate.com/moon/@z-us-20851"
curl -s "$url" > moon.html

grep "bk-focus" moon.html > moon.txt && rm moon.html
sed -i 's/>/>\n/g' moon.txt
sed -i 's/</\n</g' moon.txt
illum=$(grep -A 1 "id=cur-moon-percent" moon.txt | tail -n 1)
phase=$(grep -A 7 "id=cur-moon-percent" moon.txt | tail -n 1)
dir=$(grep -A 8 "Moon Direction:" moon.txt | tail -n 1)
alt=$(grep -A 1 "id=moonalt" moon.txt | tail -n 1)
dist=$(grep -A 1 "id=moondist" moon.txt | tail -n 1)
nxtfull=$(grep -A 6 "Next Full Moon:" moon.txt | tail -n 3)
nxtfull=$(echo $nxtfull | sed 's/<\/span>//g')
nxtfull=$(echo $nxtfull | sed 's/  / /g')
nxtnew=$(grep -A 6 "Next New Moon:" moon.txt | tail -n 3)
nxtnew=$(echo $nxtnew | sed 's/<\/span>//g')
if [[ $(grep "Next Moonrise:" moon.txt) ]]; then
  riseorset="rise"
else
  riseorset="set"
fi
nxtriseorset=$(grep -A 6 "Next Moon$riseorset:" moon.txt | tail -n 3)
nxtriseorset=$(echo $nxtriseorset | sed 's/<\/span>//g')
echo "The moon phase is currently $phase with $illum% illuminated. The next moon$riseorset is $nxtriseorset. The current direction is $dir with an altitude of $alt at a distance of $dist. The next full moon is $nxtfull; the next new moon is $nxtnew. N.B. All dates and times are for Rockville, MD." | sed 's/  / /g' | sed 's/°/ degrees/g'
rm moon.txt
