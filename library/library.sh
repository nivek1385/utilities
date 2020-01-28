#!/bin/bash

#Pull in colors.sh to define colors
. colors.sh

AbortScript() {
  Warn "ABORTING SCRIPT AT LINE NUMBER $1"
  exit 2
}

logdtstamp() {
  date +'%Y-%m-%d %H:%M:%S'
}

pause() {
  read -p "$*"
}

rootCheck() {
  curUser=$(whoami)
  if [ "$curUser" != "root" ]; then
    Error "Sorry, but you must be root to execute this script."
	exit 1
  fi
  return
}

logUsage() {
  #Usage: logUsage "$*"
  logdir=$LOGDIR
  mkdir -p $logdir
  outinfo "Logging usage of script..."
  echo "$(logdtstamp) - $(whoami)@$HOSTNAME $0 $*" >> $logdir/logUsage.log
}

#Output for logging
### verbosity levels
silent_lvl=0
crit_lvl=1
err_lvl=2
warn_lvl=3
notify_lvl=4
info_lvl=5
debug_lvl=6
## outsilent prints output even in silent mode
outsilent () { verb_lvl=$silent_lvl outlog "$@" ;}
outnotify () { verb_lvl=$notify_lvl outlog "$@" ;}
outok ()    { verb_lvl=$notify_lvl outlog "SUCCESS - $@" ;}
outwarn ()  { verb_lvl=$warn_lvl outlog "${yellow}WARNING${reset} - $@" ;}
outwarning ()  { verb_lvl=$warn_lvl outlog "${yellow}WARNING${reset} - $@" ;}
outinfo ()  { verb_lvl=$info_lvl outlog "${blue}INFO${reset} ---- $@" ;}
outdebug () { verb_lvl=$debug_lvl outlog "${green}DEBUG${reset} --- $@" ;}
outerror () { verb_lvl=$err_lvl outlog "${red}ERROR${reset} --- $@" ;}
outcrit ()  { verb_lvl=$crit_lvl outlog "${magenta}FATAL${reset} --- $@" ;}
outcritical ()  { verb_lvl=$crit_lvl outlog "${magenta}FATAL${reset} --- $@" ;}
outdumpvar () { for var in $@ ; do outdebug "$var=${!var}" ; done }
outlog() {
  if [ $verbosity -ge $verb_lvl ]; then
    datestring=`date +"%Y-%m-%d %H:%M:%S"`
    echo -e "$datestring - $@"
  fi
}

#Logging setup
export LOGDIR=~/logs
export DATE=$(date +"%Y%m%d")
export DATETIME=$(date +"%Y%m%d_%H%M%S")
 
ScriptName=$(basename $0)
Job=$(basename $0 .sh)i #"$*"
JobClass=$(basename $0 .sh)
 
startlog() {
  if [ $NO_JOB_LOGGING ] ; then
    outinfo "Not logging to a logfile because -Z option specified." #(*)
  else
    [[ -d $LOGDIR/$JobClass ]] || mkdir -p $LOGDIR/$JobClass
    Pipe=/tmp/${Job}_${DATETIME}.pipe
    mkfifo -m 700 $Pipe
    LOGFILE=${LOGDIR}/$JobClass/${Job}_${DATETIME}.log
    exec 3>&1
    tee ${LOGFILE} <$Pipe >&3 &
    teepid=$!
    exec 1>$Pipe
    PIPE_OPENED=1
    outnotify Logging to $LOGFILE  # (*)
    [ $SUDO_USER ] && outnotify "Sudo user: $SUDO_USER" #(*)
  fi
}
 
stoplog() {
  if [ ${PIPE_OPENED} ] ; then
    exec 1<&3
    sleep 0.2
    ps --pid $teepid >/dev/null
    if [ $? -eq 0 ] ; then
      # a wait $teepid whould be better but some
      # commands leave file descriptors open
      sleep 1
      kill  $teepid
    fi
    rm $Pipe
    unset PIPE_OPENED
  fi
}
