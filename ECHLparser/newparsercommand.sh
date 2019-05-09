#!/bin/bash
watch -n 600 -g "curl -s 'https://lscluster.hockeytech.com/feed/?feed=modulekit&view=schedule&key=dfd0ffe484e007d9&fmt=xml&client_code=echl&lang=en&season_id=48&team_id=undefined&league_code=&fmt=xml'" && echo "CHANGED" && ~/utilities/ECHLparser/parser.sh

