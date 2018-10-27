#!/bin/bash
#ECHL Parser for SportsClubStats

pause () {
    if [ "$*" = "" ]; then
        read -p "PAUSING, PRESS ENTER TO CONTINUE."
    else
        read -p "$*"
    fi
}

league="ECHL"
cd ~/utilities/ECHLparser || exit
#wget "http://cluster.leaguestat.com/feed/index.php?feed=chlpremium&key=dfd0ffe484e007d9&client_code=echl&sub=teams" -O teams.xml
#wget "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=teamsbyseason&key=dfd0ffe484e007d9&fmt=json&client_code=echl&lang=en&season_id=48&league_code=&fmt=json" -O teams.json
wget "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=teamsbyseason&key=dfd0ffe484e007d9&fmt=xml&client_code=echl&lang=en&season_id=48&league_code=&fmt=xml" -O teams.xml
#wget "http://cluster.leaguestat.com/feed/index.php?feed=chlpremium&key=dfd0ffe484e007d9&client_code=echl&sub=schedule" -O schedule.xml
#wget "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=schedule&key=dfd0ffe484e007d9&fmt=json&client_code=echl&lang=en&season_id=48&team_id=undefined&league_code=&fmt=json" -O schedule.json
wget "https://lscluster.hockeytech.com/feed/?feed=modulekit&view=schedule&key=dfd0ffe484e007d9&fmt=xml&client_code=echl&lang=en&season_id=48&team_id=undefined&league_code=&fmt=xml" -O schedule.xml
echo "Files downloaded"

echo "Starting base level sed conversions"
sed -i '/id>/d' teams.xml #Remove all ID lines (removing league and team ID codes)
sed -i '/nickname/d' teams.xml #Remove nickname lines (e.g. Cyclones)
sed -i '/caption/d' teams.xml #Remove unused team caption lines
sed -i '/team_logo_url/d' teams.xml #Remove team logo URLs
sed -i 's/division_long_name>North/division_long_name>Eastern/g' teams.xml #Convert extra division name to conference name
sed -i 's/division_long_name>South/division_long_name>Eastern/g' teams.xml #Convert extra division name to conference name
sed -i 's/division_long_name>Central/division_long_name>Western/g' teams.xml #Convert extra division name to conference name
sed -i 's/division_long_name>Mountain/division_long_name>Western/g' teams.xml #Convert extra division name to conference name
sed -i '/city>/d' teams.xml #Remove city name (e.g. Cincinnati)
sed -i 's/Idaho/Boise/' teams.xml #Convert Idaho to Boise because of SCS limitations
sed -i 's/IDH/BOI/' teams.xml #Convert IDH to BOI because of SCS limitations
sed -i '3,11d' teams.xml #Remove headers
sed -i '165,170d' teams.xml #Remove footers
echo "Finished base level sed conversions"
echo "Starting xmlstarlet conversions"
xmlstarlet pyx teams.xml > team.txt #convert xml to pyx format
echo "Finished xmlstarlet conversions"

sed -i 's/-\\n//g' team.txt
sed -i '/^ *$/d' team.txt #Remove empty lines
tr -d '\n' < team.txt | sed 's/)/)\n/g' > echl.txt
sed -i 's/^.*(/(/g' echl.txt
sed -i 's/^division_short_name/TEAMDELIM/g' echl.txt #Change extraneous division_short_name line to TEAMDELIM for easier processing
sed -i 's/.*-//g' echl.txt
sed -i '135,137d' echl.txt #Remove Footers
sed -i 's/)/FIELDDELIM/g' echl.txt #Change ) to FIELDDELIM for easier processing later
tr -d '\n' < echl.txt > team.txt #Remove all line breaks
sed -i 's/TEAMDELIM/\n/g' team.txt #Change TEAMDELIM to newline
sed -i 's/^FIELDDELIM//g' team.txt #Remove FIELDDELIM at beginning of line
sed -i 's/FIELDDELIM$//g' team.txt #Remove FIELDDELIM at end of line
sed -i 's/FIELDDELIM/|/g' team.txt #Change FIELDDELIM to |
#team.txt should now be TEAM,TEAMCODE,CONF,DIV
awk -F "|" 'BEGIN{OFS="|";} {print $3,$4,$1,$2}' team.txt > echl.txt #reorder to CONF|DIV|TEAM|TEAMCODE
sort echl.txt > team.txt #Sort alphabetically by CONF, DIV, TEAM
echo -e "LeagueBegin\n\tLeague: $league (Sort: Conf)" > echl.txt #Start producing the SCS data
awk -F '|' '{line[$1][$2][$3" ("$4")"]=1}
END{
  for (x in line){
    print "\t\tConference: "x " (sort: Conf) (Playoffs: 8)"
    for (y in line[x]){
      print "\t\t\tDivision: "y " (sort: Div) (Playoffs: 4)"
      for (z in line[x][y]){
        print "\t\t\t\tteam: " z
      }
    }
  }
}' team.txt >> echl.txt #Process team.txt into SCS format
{
echo -e "\\tKind: pro
\\tSport: hockey
\\tGender: male
\\tCountry: USA
\\tState:
\\tLevel: AA
\\tSeason: 18-19 (current: True)
\\tAuthor: Kevin Hartley, Victor Hayslip
\\tNote: Automation via bash scripting and the ECHL's Leaguestat XML. Updated script as of 2018-10-25 takes into account the current home win, OT, and SO percentages for the league once a minimum number of games has been reached (currently set to 100).
\\tLotteryNote:
LeagueEnd

SortBegin
\\tDiv: Average Points, Points, WinsInRegulationorOvertime, GoalsDelta,
Points HeadToHeadNHL, If [(All=SameParent) Average Wins SameParent],
GoalsFor, DrawLots
\\tConf: MoveClinchedToFront, Average Points, Points,
WinsInRegulationorOvertime, GoalsDelta, Points HeadToHeadNHL, If
[(All=SameParent) Average Wins SameParent], GoalsFor, DrawLots
\\tLottery: MoveClinchedToFrontBySeed, Average Points, Points,
WinsInRegulationOrOvertime, GoalsDelta, Points HeadToHeadNHL, If
[(All=SameParent) Average Wins SameParent], GoalsFor, DrawLots
SortEnd
"
echo -e "RulesBegin
	PointsForWinInRegulation:	2
	PointsForWinInOvertime:	2
	PointsForWinInShootout:	2
	PointsForLossInRegulation:	0
	PointsForLossInOvertime:	1
	PointsForLossInShootout:	1
	PointsForTie:	0
	PercentOfGamesThatEndInTie:	0
	PercentOfGamesThatEndInOvertimeWin:	OTPERCENT
	PercentOfGamesThatEndInShootoutWin:	SOPERCENT
	HomeFieldAdvantage: HMPERCENT
	WeightType:	PythagenpatIgnoreShootOutWinningGoals
	WeightExponent:	0.458
	WhatDoYouCallATie:	tie
	WhatDoYouCallLottery:	lottery
	WhatDoYouCallPromoted:	Brabham
	Promote:	1
	PromotePlus:	0
	PromotePlusPercent:	0
	WhatDoYouCallDemoted:	relegated
	Demote:	0
	DemotePlus:	0
	DemotePlusPercent:	0
RulesEnd
"
echo -e "GamesBegin
TeamListedFirst: away"
} >> echl.txt
sed -i '3,15d' schedule.xml #Remove headers
sed -i '/mobile_calendar/d' schedule.xml #Remove mobile_calendar line
sed -i '/client_code/d' schedule.xml #Remove client_code line
sed -i '/venue_/d' schedule.xml #Remove venue lines
sed -i '/url/d' schedule.xml #Remove URLs from the schedule
sed -i '/id>/d' schedule.xml #Remove LS/HT IDs
sed -i '/quick_score/d' schedule.xml #Remove quick_score line
sed -i '/date>/d' schedule.xml #Remove extra date line
sed -i '/date_with/d' schedule.xml #Remove extra date line
sed -i '/date_time/d' schedule.xml #Remove extra date line
sed -i '/Game/d' schedule.xml #Remove extra date line
sed -i '/<status/d' schedule.xml #Remove status line
sed -i 's/game_status/status/g' schedule.xml #Change game_status to status
sed -i '/game/d' schedule.xml #Remove multiple unnecessary lines
sed -i '/team>/d' schedule.xml #Remove teamID lines
sed -i '/period/d' schedule.xml #Remove period line
sed -i '/schedule_/d' schedule.xml #Remove extra schedule lines
sed -i '/timezone/d' schedule.xml #Remove extra TZ info line
sed -i '/attendance/d' schedule.xml #Remove attendance info
sed -i '/location/d' schedule.xml #Remove location line
sed -i '/team_n/d' schedule.xml #Remove {visiting|home}_team_n{ame|nickname} lines
sed -i '/division/d' schedule.xml #Remove division lines
sed -i '/notes/d' schedule.xml #Remove notes line
sed -i '/use_shoot/d' schedule.xml #Remove use_shootouts lines
sed -i '/last_modified/d' schedule.xml #Remove last_modified lines
sed -i '/if_nec/d' schedule.xml #Remove if_necessary lines
sed -i '/overtime/d' schedule.xml #Remove OT boolean
sed -i '/shootout/d' schedule.xml #Remove SO boolean
sed -i '/started/d' schedule.xml #Remove started boolean lines
sed -i '/<final>/d' schedule.xml #Remove final boolean lines
sed -i '/city/d' schedule.xml #Remove city lines
sed -i 's/Final OT/Final (OT)/g' schedule.xml #Put OT in parentheses
sed -i 's/Final SO/Final (SO)/g' schedule.xml #Put SO in parentheses
xmlstarlet pyx schedule.xml > schedule.txt #convert xml to pyx format

sed -i 's/-\\n//g' schedule.txt
sed -i '/^ *$/d' schedule.txt #Remove empty lines
tr -d '\n' < schedule.txt | sed 's/)/)\n/g' > games.txt
sed -i 's/^Schedule(Schedule(/GAMEDELIM/g' games.txt
tr -d '\n' < games.txt > schedule.txt
sed -i 's/GAMEDELIM/\n/g' schedule.txt
sed -i 's/)date_played(/|/g' schedule.txt
sed -i 's/)home_goal_count(/|/g' schedule.txt
sed -i 's/)visiting_goal_count(/|/g' schedule.txt
sed -i 's/)status(/|/g' schedule.txt
sed -i 's/)home_team_code(/|/g' schedule.txt
sed -i 's/)visiting_team_code(/|/g' schedule.txt
sed -i 's/)scheduled_time)//g' schedule.txt
sed -i 's/(SiteKit(Schedule(//g' schedule.txt

sed -i 's/date_played-//g' schedule.txt
sed -i '/status-Final.*|home_team_code/b; s/status-.*|home_team_code/status-|home_team_code/g' schedule.txt #IF status != Final*, delete status
sed -i 's/Final//g' schedule.txt
sed -i 's/scheduled_time-//g' schedule.txt
sed -i 's/visiting_team_code-//g' schedule.txt
sed -i 's/visiting_goal_count-//g' schedule.txt
sed -i 's/home_goal_count-//g' schedule.txt
sed -i 's/status-//g' schedule.txt
sed -i 's/home_team_code-//g' schedule.txt
sed -i 's/Schedule(Copyright.*//g' schedule.txt #Remove footers
while read -r line; do
  gamedate=$(echo $line | cut -d '|' -f 1)
  year=$(echo $gamedate | cut -d '-' -f 1)
  month=$(echo $gamedate | cut -d '-' -f 2)
  day=$(echo $gamedate | cut -d '-' -f 3)
  newdate=$month/$day/$year
  sed -i "s@$gamedate@$newdate@g" schedule.txt
done < schedule.txt
#schedule.txt is in the order DATE1|HOME_GOAL2|VISIT_GOAL3|STATUS4|HOME5|VISIT6|TIME7
#Wanted order is DATE1|TIME7|VISIT6|VISIT_GOAL3|HOME_GOAL2|STATUS4|HOME5
awk -F "|" 'BEGIN{OFS=" ";} {print $1,$7,$6,$3,"-",$2,$4,$5}' schedule.txt > games.txt
sed -i 's/0 - 0//g' games.txt
sed -i 's/ - /-/g' games.txt
sed -i 's/  / /g' games.txt
sed -i 's/pm .ST/pm/g' games.txt
sed -i 's/am .ST/am/g' games.txt
sed -i 's/IDH/BOI/g' games.txt

cat games.txt >> echl.txt
echo "GamesEnd" >> echl.txt
gp=$(egrep -c ":.*-" games.txt)
otgp=$(grep -c "(OT)" games.txt)
sogp=$(grep -c "(SO)" games.txt)
hmgw=$(awk '/-/ && !/\(..\)/ { split($5, a, "-"); if (a[1] < a[2]) { count++ } } END{ print count }' games.txt)
reggp=$(egrep ":.*-" games.txt | grep -vc "(..)")
hmpercent=$(bc -l <<< "$hmgw/$reggp")
otpercent=$(bc -l <<< "$otgp/$gp")
sopercent=$(bc -l <<< "$sogp/$gp")
if [ $gp -lt 100 ]; then
  hmpercent=".54851228978007761966"
  otpercent=".13463514902363823227"
  sopercent=".07091469681397738951"
fi
sed -i "s/HMPERCENT/$hmpercent/g" echl.txt
sed -i "s/OTPERCENT/$otpercent/g" echl.txt
sed -i "s/SOPERCENT/$sopercent/g" echl.txt
python ~/bin/send.py "import@sportsclubstats.com" "ECHL" "$(cat echl.txt)" "echl.txt"
rm schedule.txt games.txt echl.txt team.txt teams.xml schedule.xml
