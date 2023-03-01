#!/bin/bash
#
# start-mycroft.sh - make the log file directory a tmpfs, then start mycroft from ~/ovos-core
#
# check environment
ovosStartScript=~/ovos-core/start-mycroft.sh
if [ ! -x $ovosStartScript ]; then
  echo "ERROR: did not find executable $ovosStartScript - is ovos-core installed?"
  exit 1
fi

# make log files directories tmpfs's 
echo "making /var/log/ directory a tmpfs ..." 
cmd="sudo systemctl start var-log.mount"
eval $cmd
rc=$?
if [ "$rc" != 0 ]; then
  echo "WARNING $cmd returned $rc - proceeding without tmpfs log directory"
fi
echo "making Mycroft log directory a tmpfs ..." 
cmd="sudo systemctl start home-pi-.local-state-mycroft.mount"
eval $cmd
rc=$?
if [ "$rc" != 0 ]; then
  echo "WARNING $cmd returned $rc - proceeding without tmpfs log directory"
fi

if [ ${#VIRTUAL_ENV} = 0 ]; then           # not in a venv
  if [ -f /home/pi/ovos-core/venv/bin/activate ]; then # activate it
    echo "Starting venv ..."
    source /home/pi/ovos-core/venv/bin/activate 
  else
    echo "ERROR: you must run Mycroft in a venv"
    exit 1
  fi
fi

# if no args passed, start Mycroft with "all"
if [ $# = 0 ]; then
  arg1=all
else
  arg1=$1
fi
$ovosStartScript $arg1

