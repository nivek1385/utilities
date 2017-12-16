#!/bin/bash
#ECHL Parser for SportsClubStats

cd ~/utilities/ECHLparser
note=""
case $1 in
	"06-07")
		seasonid=1
		;;
	"07-08")
		seasonid=5
		;;
	"08-09")
		seasonid=9
		note="Playoff tiebreakers are not configured properly due to mid-season folding of teams."
		;;
	"09-10")
		seasonid=13
		;;
	"10-11")
		seasonid=17
		;;
	"11-12")
		seasonid=22
		;;
	"12-13")
		seasonid=25
		;;
	"13-14")
		seasonid=29
		;;
	"14-15")
		seasonid=33
		;;
	"15-16")
		seasonid=37
		;;
	"16-17")
		seasonid=40
		;;
esac
wget "http://cluster.leaguestat.com/feed/index.php?feed=chlpremium&key=dfd0ffe484e007d9&client_code=echl&sub=teams&season_id=$seasonid" -O teams.xml
wget "http://cluster.leaguestat.com/feed/index.php?feed=chlpremium&key=dfd0ffe484e007d9&client_code=echl&sub=schedule&season_id=$seasonid" -O schedule.xml

xmlstarlet pyx teams.xml > team.txt #convert xml to pyx format
xmlstarlet pyx schedule.xml > schedule.txt #convert xml to pyx format
sed -i 's/-\\n//g' team.txt
sed -i '/^ *$/d' team.txt #Remove empty lines
tr -d '\n' < team.txt | sed 's/)/)\n/g' > echl.txt
sed -i 's/^.*(/(/g' echl.txt
sed -i '/^(rank.*/d' echl.txt
sed -i '/^(overall_rank.*/d' echl.txt
sed -i '/^(clinched.*/d' echl.txt
sed -i '/^(city.*/d' echl.txt
sed -i '/^(games_played.*/,+23d' echl.txt
sed -i '/^conference_rank.*/d' echl.txt
sed -i '/^team.*/d' echl.txt
sed -i 's/^(team_id.*/\t\t\t\tteam:/g' echl.txt
sed -i 's/^(team_name-//g' echl.txt
sed -i 's/(//g' echl.txt
sed -i 's/)//g' echl.txt
sed -i ':a;N;$!ba;s/team:\n/team: /g' echl.txt
sed -i '/^team_code.*/ s/$/)/' echl.txt
sed -i 's/^team_code-/(/g' echl.txt
sed -i ':r;$!{N;br};s/\n(/ (/g' echl.txt
sed -i '/^season_id.*/,+2d' echl.txt
sed -i '/^required_copyright.*/,+6d' echl.txt
sed -i '1s;^;LeagueBegin\n\tLeague:\tECHL\t(Sort: Lottery)\n;' echl.txt
sed -i 's/^conference-/\t\tConference: /g' echl.txt
sed -i '/Conference:/ s/$/ (sort: Conf) (Playoffs: 8)/' echl.txt
sed -i 's/^division-/\t\t\tDivision: /g' echl.txt
sed -i '/Division:/ s/$/ (sort: Div) (Playoffs: 4)/' echl.txt
cat -n echl.txt | sort -uk2 | sort -nk1 | cut -f2- > echl2.txt
mv echl2.txt echl.txt
echo -e "\tKind: pro
\tSport: hockey
\tGender: male
\tCountry: USA
\tState:
\tLevel: AA
\tSeason: $1 (current: false)
\tAuthor: Kevin Hartley
\tNote:$note
\tLotteryNote:
LeagueEnd

SortBegin
\tDiv: Average Points, Points, WinsInRegulationorOvertime, GoalsDelta,
Points HeadToHeadNHL, If [(All=SameParent) Average Wins SameParent],
GoalsFor, DrawLots
\tConf: MoveClinchedToFront, Average Points, Points,
WinsInRegulationorOvertime, GoalsDelta, Points HeadToHeadNHL, If
[(All=SameParent) Average Wins SameParent], GoalsFor, DrawLots
\tLottery: MoveClinchedToFrontBySeed, Average Points, Points,
WinsInRegulationOrOvertime, GoalsDelta, Points HeadToHeadNHL, If
[(All=SameParent) Average Wins SameParent], GoalsFor, DrawLots
SortEnd
" >> echl.txt

sed -i 's/-\\n//g' schedule.txt
sed -i '/^ *$/d' schedule.txt #Remove empty lines
tr -d '\n' < schedule.txt | sed 's/)/)\n/g' > games.txt
mv games.txt schedule.txt
sed -i 's/^.*(/(/g' schedule.txt
sed -i '/^(game_id.*/d' schedule.txt
sed -i '/^(game_number.*/d' schedule.txt
sed -i '/^(venue.*/d' schedule.txt
sed -i '/team-.*/d' schedule.txt
sed -i '/_city.*/d' schedule.txt
sed -i '/_nickname.*/d' schedule.txt
sed -i '/_name.*/d' schedule.txt
sed -i 's/(//g' schedule.txt
sed -i 's/)//g' schedule.txt
sed -i 's/^date_played-//g' schedule.txt
sed -i ':r;$!{N;br};s/\nscheduled_time-/ /g' schedule.txt
sed -i '/^required_copyright.*/,+6d' schedule.txt
seq="0 4 1 2 3"
numlines=$(wc -l < schedule.txt)
for ((i = 0; i <= $numlines; i += 5))
do
  for j in $seq
  do
    line=$(($j + $i))
    awk -v l="$line" 'NR==l+1' schedule.txt >> test.txt
  done
done
mv test.txt schedule.txt
sed -i ':r;$!{N;br};s/\nfinal-1/ /g' schedule.txt
sed -i ':r;$!{N;br};s/\nscore-/ /g' schedule.txt
sed -i ':r;$!{N;br};s/\nfinal-0/ /g' schedule.txt
sed -i ':r;$!{N;br};s/\nscore/ /g' schedule.txt
sed -i 's/-&-nbsp;/ (/g' schedule.txt
sed -i '/(.*/ s/$/)/' schedule.txt
sed -i ':r;$!{N;br};s/\nhome_team_code-/ /g' schedule.txt
sed -i ':r;$!{N;br};s/\nvisiting_team_code-/ /g' schedule.txt
numgames=$(wc -l <schedule.txt)
numotgames=$(grep "(OT)" schedule.txt | wc -l)
numsogames=$(grep "(SO)" schedule.txt | wc -l)
otpercent=$(bc <<< "scale = 16; $numotgames/$numgames")
sopercent=$(bc <<< "scale = 16; $numsogames/$numgames")
echo -e "RulesBegin
	PointsForWinInRegulation:	2
	PointsForWinInOvertime:	2
	PointsForWinInShootout:	2
	PointsForLossInRegulation:	0
	PointsForLossInOvertime:	1
	PointsForLossInShootout:	1
	PointsForTie:	0
	PercentOfGamesThatEndInTie:	0
	PercentOfGamesThatEndInOvertimeWin:	$otpercent
	PercentOfGamesThatEndInShootoutWin:	$sopercent
	HomeFieldAdvantage:	0.571005917159763
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
" >> echl.txt
echo -e "GamesBegin
TeamListedFirst: away" >> echl.txt
cat schedule.txt >> echl.txt
echo -e "GamesEnd" >> echl.txt
sed -i 's/IDH/Steelheads/g' echl.txt
sed -i 's/pm AKST/pm/g' echl.txt
sed -i 's/am AKST/pm/g' echl.txt
sed -i 's/pm .ST/pm/g' echl.txt
sed -i 's/am .ST/pm/g' echl.txt
sed -i 's|\([0-9][0-9][0-9][0-9]\)-\([0-1][0-9]\)-\([0-3][0-9]\)|\2/\3/\1|g' echl.txt
# sed -i -e '11d' echl.txt
# sed -i -e '28d' echl.txt
python ~/bin/send.py "import@sportsclubstats.com" "ECHL $1" "$(cat echl.txt)" "echl.txt"
