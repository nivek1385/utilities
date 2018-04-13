\#!/bin/bash
#Using the baby monitor's get temp value to check room temp.
wget "http://192.168.1.246/?action=command&command=value_temperature" -O tmp.txt
sed -i 's/value_temperature: //' tmp.txt
tc=$(cat tmp.txt)
tf=$(echo "scale=2;((9/5) * $tc) + 32" | bc)
echo $tf
rm tmp.txt 
if [[ $tf < 60 ]]; then
  echo "LOWER THAN 60F, executing web script to raise temp..."
  wget "https://maker.ifttt.com/trigger/RaiseTemp/with/key/deEcaUi7u8AXM30ejeNEz2" -O /dev/null
elif [[ $tf -ge 60 && $tf < 75 ]]; then
  echo "Between 60 and 75, doing nothing."
elif [[ $tf -ge 75 ]]; then
  echo "75 or HIGHER, executing web script to lower temp..."
  wget "https://maker.ifttt.com/trigger/LowerTemp/with/key/deEcaUi7u8AXM30ejeNEz2" -O /dev/null
else
  echo "ERROR: temp not in any range. $tf"
fi
