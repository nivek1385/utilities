# .bash_functions

cd() { builtin cd "$@"; pwd; echo; ls; }

pause() {
  read -p "$*"
}

lowercase() {
  echo "$@" | tr '[A-Z]' '[a-z]'
}

uppercase() {
  echo "$@" | tr '[a-z]' '[A-Z]'
}

plowercase() {
  tr '[A-Z]' '[a-z]' "$@"
}

puppercase() {
  tr '[a-z]' '[A-Z]' "$@"
}

logger() {
  tee -a ~/$1-$(dtstamp).log
}

#Extracts archive files without needing to know the specific command and options required for each archive type.
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)    tar xjf $1    ;;
      *.tar.gz)     tar xzf $1    ;;
      *.bz2)        bunzip2 $1    ;;
      *.rar)        unrar x $1    ;;
      *.gz)         gunzip $1     ;;
      *.tar)        tar xf $1     ;;
      *.tbz2)       tar xjf $1    ;;
      *.tgz)        tar xzf $1    ;;
      *.zip)        unzip $1      ;;
      *.Z)          uncompress $1 ;;
      *.7z)         7z x $1       ;;
      *)      echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file."
  fi
}

#ip: Provides public and private IP addresses.  Without interface supplied, defaults to iface of default route
ip() {
whoami
echo -e \ - Public facing IP address:
curl ipecho.net/plain
echo
echo -e \ - Internal IP Address:
if [ $# -eq 0 ]; then
  int=$(route | grep '^default' | grep -o '[^ ]*$')
  echo "No interface supplied, using default route's interface: $int"
else
  int=$1
fi
if [ "$(ifconfig $int | grep 'inet')" != "" ]; then
  ifconfig $int | grep 'inet' | sed "s/   \+/:/" | sed "s/  .*//" | sed "s/[a-z: ]\+//"
else
  echo "No IP address found for interface $int"
fi
}

#Displays phase of the moon and related data
phase () {
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
    echo "The moon phase is currently $phase with $illum% illuminated. The next moon$riseorset is $nxtriseorset. The current direction is $dir with an altitude of $alt at a distance of $dist. The next full moon is $nxtfull; the next new moon is $nxtnew. N.B. All dates and times are for Rockville, MD." | sed 's/  / /g' | sed 's/°/ degrees/g' | sed 's/%%/%/g'
    if [ $# -eq 0 ] ; then
        weather Moon
    elif [ $1 = "png" ] ; then
        weather Moon.png >> moon.png
    elif [ $1 = "nowttr" ] ; then
        echo ""
    fi
}

#Provides weather forecast. With a ZIP code or city location, will provide weather forecast for said ZIP/city
weather () {
    url="wttr.in/"
    if [ $# -eq 0 ] ; then
        curl $url
    else
        curl $url${1}
    fi
}

#Update bash dot files
dotupdate () {
    #check for params rc vs prof
    #no params = do both
    if [ $# -eq 0 ] ; then
        echo "No dot files selected, updating all."
        for i in ".bashrc" ".bash_profile" ".bash_aliases" ".bash_functions"
        do
            if [ -L ~/$i ]; then
                #update git repo and reload
                echo "File $i is a symlink, will have to update git repo."
                cd ~/utilities || exit
                git pull
            else
                #update file directly
                echo "File $i is NOT a symlink, updating directly."
                curl -L https://github.com/nivek1385/utilities/raw/master/$i > ~/$i
            fi
        done
        pause "Press enter to reload."
        reload
    else
        #Test what param is
        case "$1" in
            .bashrc | bashrc )
                file=.bashrc
            ;;
            .bash_profile | bash_profile | .bashprof | bashprof )
                file=.bash_profile
            ;;
        esac
        if [ -L ~/$file ]; then
            #update git repo and reload
            echo "File $file is a symlink, will have to update git repo."
            cd ~/utilities || exit
            git pull
        else
            #update file directly
            echo "File $file is NOT a symlink, updating directly."
            curl -L https://github.com/nivek1385/utilities/raw/master/$file > ~/$file
        fi
    fi
}

