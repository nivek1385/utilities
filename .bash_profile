# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=${HOME}/bin:$PATH
export JAVA_HOME=/opt/omega/java
export PATH=${JAVA_HOME}/bin:$PATH
export MVN_HOME=/opt/omega/maven
export PATH+=':${MVN_HOME}/bin'
export PATH
#source ~/khsvn/svn-khartley.sh
alias shy='ssh -Y'
alias sl='ls'
alias gist='history | grep'
alias gs='git status'
# do not create history entries for the following commands
export HISTIGNORE='&:[ ]*:exit:ls:bg:fg:jobs:history:clear:pwd'
alias dtstamp="date +'%G%m%d%H%M%S'"
alias dstamp="date +'%G%m%d'"
alias tstamp="date +'%H%M%S'"
cd() { builtin cd "$@"; pwd; echo; ls; } #cd changes directory, prints current (new) dir, prints newline, lists contents of (new) dir
alias cdmnt='mount /dev/cdrom /mnt/cdrom'
alias cdcd='cd /mnt/cdrom'

# extract:  Extract most know archives with one command
# ---------------------------------------------------------
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
alias mnt='mount | column -t'
# Find a file from the current directory
alias ff='find . -name '

#alias ip="whoami ; echo -e \ - Public facing IP Address:; curl ipecho.net/plain ; echo ; echo -e \ - Internal IP Address: ; ifconfig wlp2s0 | grep 'inet addr:' | cut -d ' ' -f12 | cut -d: -f2"
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

alias wcl='wc -l'        # count # of lines

#implement later: source <(curl -sS domain.tld/scripts/.bashrc)


# reloads the prompt, usefull to take new modifications into account
alias reload='source ~/.bash_profile'
# grabs the latest .bash_profile file and reloads the prompt
alias updatebashprofile='curl -L https://github.com/nivek1385/utilities/raw/master/.bash_profile > ~/.bash_profile && reload'
