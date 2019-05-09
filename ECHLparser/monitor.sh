#!/bin/bash

# monitor.sh - Monitors a web page for changes
# sends an email notification if the file change

URL="https://lscluster.hockeytech.com/feed/?feed=modulekit&view=schedule&key=dfd0ffe484e007d9&fmt=xml&client_code=echl&lang=en&season_id=48&team_id=undefined&league_code=&fmt=xml"
cd ~/utilities/ECHLparser
while true; do
    mv new.html old.html 2> /dev/null
    curl $URL -L --compressed -s > new.html
grep -ic final old.html new.html
    DIFF_OUTPUT="$(diff new.html old.html)"
    if [ "0" != "${#DIFF_OUTPUT}" ]; then
       ./parser.sh 
	sleep 300
    else
        sleep 300
    fi
done
