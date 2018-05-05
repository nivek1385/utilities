#!/bin/bash
#Run to get URL for watching NeuLion streams
#$league = league code, e.g. ECHL, OHL, AHL, etc.
#$home = home team code, 2-3 letters
#$code = code from schedule in the curl
#$date = date in YYYYMMDD format
#$gameid = NeuLion gameid for the game
#$bitrate = bitrate request

league="$1"
home="$2"
gameid="$3"
dt=$(date '+%Y%m%d')
bitrate="3000"

curl "https://$league.neulion.com/$league/servlets/schedule" -H 'Pragma: no-cache' -H 'Origin: null' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: */*' -H 'Cache-Control: no-cache' -H 'X-Requested-With: ShockwaveFlash/29.0.0.113' -H 'Connection: keep-alive' -H 'DNT: 1' --data 'ps=100&pn=0&isFlex=true&pm=0' --compressed -O ;

sed -i 1,11d schedule
sed -i 's/^.*gameId.*$//g' schedule
sed -i 's/^.*type.*$//g' schedule
sed -i 's/^.*date.*$//g' schedule
sed -i 's/^.*logo.*$//g' schedule
sed -i 's/^.*leagueId.*$//g' schedule
sed -i 's/^.*sportId.*$//g' schedule
sed -i 's/^.*season.*$//g' schedule
sed -i 's/^.*isGame.*$//g' schedule
sed -i 's/^.*score.*$//g' schedule
sed -i 's/^.*userAuth.*$//g' schedule
sed -i 's/^.*noAccess.*$//g' schedule
sed -i 's/^.*programId.*$//g' schedule
sed -i 's/^.*hasProgram.*$//g' schedule
sed -i 's/^.*isLive.*$//g' schedule
sed -i 's/^.*event.*$//g' schedule
sed -i 's/^.*endDate.*$//g' schedule
sed -i 's/^.*result.*$//g' schedule
sed -i 's/^.*isOver.*$//g' schedule
sed -i 's/^.*adaptive/http/g' schedule
sed -i 's/aznlvod/nlds10/g' schedule
sed 's/\(nlds100[0-9]\) \(cdnak.neulion.com\) \(.*\)/\1.nlss.neulioncloud.com\3/g' schedule
#sed -i 's/nlss\.neulioncloud\.com/cdnak.neulion.com/g' schedule
sed -i 's/mp4.*/mp4.m3u8/g' schedule
sed -i 's/hd_pc.*/hd_3000.m3u8/g' schedule

sed -i '/^\s*$/d' schedule
sed -i 's/^\s*//g' schedule

#code=$(grep -A43 "$gameid" schedule | tail -1 | sed "s/^.*$dt//" | sed 's/\/.*//')

#echo "http://$league-$home.nlss.neulioncloud.com/nlds/$league/$home/as/live/${dt}$code/${home}_hd_$bitrate.m3u8"
#vlc "http://$league-$home.nlss.neulioncloud.com/nlds/$league/$home/as/live/${dt}$code/${home}_hd_$bitrate.m3u8"
grep "http" schedule
