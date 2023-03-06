#!/bin/bash
#
# start-mycroft.sh - make the log file directory a tmpfs, then start mycroft from ~/ovos-core
#
#+--------------------------------------------------------------------------+
function mountFStmpfs
# Mount a file system in a tmpfs using systemd .mount files 
# Arg 1    : systemd .mount file to use
# Args 2-n : description of the file system 
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  local mountFile=$1
  shift
  local desc="$@"                          # remaining args are desription

  local mountDir=`echo $mountFile | sed 's:-:/:g'`
  local fsType=`mount | grep /var/log | awk '{print $5}'`
  if [ "$fsType" = tmpfs ]; then           # already a tmpfs
    echo "$mountDir is already a tmpfs"
    return
  fi
  echo "making directory $fileSystem a tmpfs ..."
  cmd="sudo systemctl start $mountFile"
  eval $cmd
  rc=$?
  if [ "$rc" != 0 ]; then
    echo "WARNING $cmd returned $rc - proceeding without tmpfs $desc" 
  fi
 }                                         # mountFStmpfs()

#+--------------------------------------------------------------------------+
function startMycroft 
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  ovosStartScript=~/ovos-core/start-mycroft.sh
  if [ ! -x $ovosStartScript ]; then
    echo "ERROR: did not find executable $ovosStartScript - is ovos-core installed?"
    exit 1
  fi
  
  # verify that we are in a venv
  if [ ${#VIRTUAL_ENV} = 0 ]; then           # not in a venv
    if [ ! -f /home/$USER/ovos-core/venv/bin/activate ]; then
      echo "ERROR: Mycroft must be run in a venv"
      exit 1
    else
      source /home/$USER/ovos-core/venv/bin/activate # start the venv
    fi
  fi  
  
  # make log files directories tmpfs's to lengthen the life of the micro-SD card
  mountFStmpfs home-$USER-.local-state-mycroft.mount Mycroft log directory
  mountFStmpfs var-log.mount /var/log
  if [ ! -d /var/log/mpd ]; then 
    sudo mkdir /var/log/mpd
    sudo touch /var/log/mpd/mpd.log
  fi
  
  # if no args passed, start Mycroft with "all"
  if [ $# = 0 ]; then
    arg1=all
  else
    arg1=$1
  fi
  $ovosStartScript $arg1
 }                                         # startMycroft()
  
# main()
startMycroft $@                            # start Mycroft passing all args
  
