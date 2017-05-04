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
export PATH+=":${MVN_HOME}/bin"
export PATH
source ~/khsvn/svn-khartley.sh
alias shy="ssh -Y"
alias sl="ls"
alias gist="history | grep"
alias gs="git status"
# do not create history entries for the following commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:jobs:history:clear:pwd"
alias dtstamp="date +'%G%m%d%H%M%S'"
alias dstamp="date +'%G%m%d'"
alias tstamp="date +'%H%M%S'"
