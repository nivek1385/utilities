# .bash_profile

# User specific environment and startup programs
PATH=${HOME}/utilities:${HOME}/bin:$PATH
if [ -n "$PATH" ]; then
  old_PATH=$PATH:; PATH=
  while [ -n "$old_PATH" ]; do
    x=${old_PATH%%:*}       # the first remaining entry
    case $PATH: in
      *:"$x":*) ;;         # already there
      *) PATH=$PATH:$x;;    # not there yet
    esac
    old_PATH=${old_PATH#*:}
  done
  PATH=${PATH#:}
  unset old_PATH x
fi

#Exports
export PATH
# do not create history entries for the following commands
export HISTIGNORE='&:[ ]*:exit:ls:bg:fg:jobs:history:clear:pwd'

#Aliases
alias shy='ssh -Y'
alias gs='git status'
alias ga='git add'
alias cdmnt='mount /dev/cdrom /mnt/cdrom'
alias cdcd='cd /mnt/cdrom'
alias cdmntcd='mount /dev/cdrom /mnt/cdrom;cd /mnt/cdrom'

#Functions
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

fortune
~/utilities/latindate.sh
