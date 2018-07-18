#!/bin/bash

#----------------------------------------------------------------------------------
# Project Name      - pwck.sh
#----------------------------------------------------------------------------------

_VERSION_="2018-07-17"
URL="https://api.pwnedpasswords.com/range/"

XERR(){ printf "[L%0.4d] ERROR: %s\n" "$1" "$2" 1>&2; exit 1; }
ERR(){ printf "[L%0.4d] ERROR: %s\n" "$1" "$2" 1>&2; }

#USAGE(){
#    while read; do
#        printf "%s\n" "$REPLY"
#    done <<-EOF
#                    GETIP ($_VERSION_)
#                    Written by terminalforlife (terminalforlife@yahoo.com)
#                    View your internal and/or external IP address.
#        SYNTAX:     getip [OPTS]
#        OPTS:       --help|-h|-?            - Displays this help information.
#                    --version|-v            - Output only the version datestamp.
#                    --update|-U             - Check for updates to getip.
#                    --debug|-D              - Enables the built-in bash debugging.
#                    --internal|-l           - Show only the internal IP address.
#                    --external|-e           - Show only the external IP address.
#                    --ip-only|-i            - Show only the IP address.
#    EOF
#}

#while [ "$1" ]; do
#    case "$1" in
#        --help|-h|-\?)
#            USAGE; exit 0 ;;
#        --version|-v)
#            printf "%s\n" "$_VERSION_"
#            exit 0 ;;
#        --update|-U)
#            UPDATE="true" ;;
#        --debug|-D)
#            DEBUGME="true" ;;
#        --internal|-l)
#            ISHOW="true" ;;
#        --external|-e)
#            ESHOW="true" ;;
#        --ip-only|-i)
#            IPONLY="true" ;;
#        *)
#            XERR "$LINENO" "Invalid argument(s) detected." ;;
#    esac
#    shift
#done

read -sp "Enter password: " pw
hash=$(echo -n $pw | sha1sum)
hash5=$(echo $hash | cut -c1-5)
hashend=$(echo $hash | cut -c6- | awk -F ' ' '{print $1}')
pwned=$(curl "${URL}${hash5}" | grep -i $hashend | awk -F ':' '{print $2'} | tr -d "\r")
echo "That password has been pwned $pwned times."
unset hash
unset hashend
unset hash5
