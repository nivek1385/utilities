# .bash_profile

# User specific environment and startup programs
PATH=${HOME}/bin:$PATH

#Exports
export JAVA_HOME=/opt/omega/java
export PATH=${JAVA_HOME}/bin:$PATH
export PATH
# do not create history entries for the following commands
export HISTIGNORE='&:[ ]*:exit:ls:bg:fg:jobs:history:clear:pwd'

#Aliases
alias shy='ssh -Y'
alias sl='ls'
alias gist='history | grep'
alias gs='git status'
alias dtstamp="date +'%Y%m%d%H%M%S'"
alias dstamp="date +'%Y%m%d'"
alias tstamp="date +'%H%M%S'"
alias cdmnt='mount /dev/cdrom /mnt/cdrom'
alias cdcd='cd /mnt/cdrom'
alias cdmntcd='mount /dev/cdrom /mnt/cdrom;cd /mnt/cdrom'
alias mnt='mount | column -t'
# Find a file from the current directory
alias ff='find . -name '
# Find a file from root
alias fr='find / -name '
# count # of lines
alias wcl='wc -l'
# reloads the prompt, useful to take new modifications into account
alias reload='source ~/.bashrc'
# grabs the latest .bashrc\.bash_profile file and reloads the prompt
alias updatebashrc='curl -L https://github.com/nivek1385/utilities/raw/master/.bashrc > ~/.bashrc && reload'
alias updatebashprofile='curl -L https://github.com/nivek1385/utilities/raw/master/.bash_profile > ~/.bash_profile && reload'

#Functions
#cd changes directory, prints current (new) dir, prints newline, lists contents of (new) dir
cd() { builtin cd "$@"; pwd; echo; ls; }

# extract:  Extract most known archives with one command
extract () {
    if [ -f $1 ] ; then # -f means file exists and is a regular file
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#ip: Provides public and private IP addresses. Without interface specified, defaults to iface of default route
ip () {
whoami
echo -e \ - Public facing IP Address:
curl ipecho.net/plain
echo
echo -e \ - Internal IP Address: 
if [ $# -eq 0 ]
  then
        int=$(route | grep '^default' | grep -o '[^ ]*$')
        echo "No interface supplied, using default route's interface: $int"
else
        int=$1
fi
if [ "$(ifconfig $int | grep 'inet')" != "" ]; then
        ifconfig $int | grep 'inet ' | sed "s/   \+/:/" | sed "s/  .*//" | sed "s/[a-z: ]\+//"
else
        echo "No IP address found for interface $int"
fi
}

#Set distro specific settings
if [ -e /etc/redhat-release ]; then
        distro=$(cat /etc/redhat-release | cut -d " " -f1)
elif [ -e /etc/lsb-release ]; then
        source /etc/lsb-release
        distro=$DISTRIB_ID
fi
case $distro in
        "LinuxMint")
                #Do Mint specific items
                alias apu="sudo apt-get update && sudo apt-get upgrade"
                alias api="sudo apt-get install "
                ;;
        "CentOS")
                #Do CentOS specific items
                alias yumu="yum update "
                alias yumi="yum install "
                ;;
        "Redhat*")
                #Do RHEL specific items
                alias yumu="yum update "
                alias yumi="yum install "
                source ~/khsvn/svn-khartley.sh
                ;;
        *)
                #Do non-specific items
                ;;
esac

phase () {
    url="http://www.moongiant.com/phase/today"
    pattern="Illumination:"
    illum="$( curl -s "$url" | grep "$pattern" | tr ',' '\
    ' | grep "$pattern" | sed 's/[^0-9]//g')"
    if [ $illum = "" ] ; then
        echo "Error retrieving moon illumination from web."
        return 1
    elif [ $illum -eq 0 ] ; then
        phasename="new"
    elif [ $illum -eq 50 ] ; then
        phasename="quarter"
    elif [ $illum -eq 100 ] ; then
        phasename="full"
    elif [ $illum -lt 5 ] ; then
        phasename="new-ish"
    elif [ $illum -lt 45 ] ; then
        phasename="crescent"
    elif [ $illum -lt 55 ] ; then
        phasename="quarter-ish"
    elif [ $illum -lt 95 ] ; then
        phasename="gibbous"
    else
        phasename="full-ish"
    fi
    echo "The moon is currently $phasename with $illum% illuminated."
    weather Moon
}

#Provides weather forecast. With a ZIP code or city location, will provide weather forecast for said ZIP/city
weather () {
    url="wttr.in/"
    if [ $# -eq 0 ] ; then
        curl $url$(1)
    else
        curl $url
    fi   
}

#Update bash dot files
dotupdate () {
    #check for params rc vs prof
    #no params = do both
    if [ $# -eq 0 ] ; then
        echo "No dot files selected, updating both."
        for i in ".bashrc" ".bash_profile"
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
        reload
    else
        #Test what param is
        echo "TEST TEST TEST Don't have the param test done for actual params yet"
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
