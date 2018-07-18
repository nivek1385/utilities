#!/bin/bash

echo "Enter start time: "
read start
read -p "Enter end time: " end
#echo $((end - start))


StartDate=$(date -u -d "$start" +"%s.%N") 
FinalDate=$(date -u -d "$end" +"%s.%N")
date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M"
