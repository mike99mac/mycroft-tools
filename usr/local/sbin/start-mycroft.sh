#!/bin/bash
#
# start-mycroft.sh - make the log file directory a tmpfs, then start mycroft from ~/ovos-core
#
# if no args passed, assume "all"
if [ $# = 0 ]; then
  arg1=all
else
  arg1=$1
fi

ovosStartScript=~/ovos-core/start-mycroft.sh
if [ ! -x $ovosStartScript ]; then
  echo "ERROR did not find executable $ovosStartScript - is ovos-core installed?"
  exit 1
fi

# make log files directories tmpfs's 
cmd="sudo systemd start home-pi-.local-state-mycroft.mount"
eval $cmd
rc=$?
if [ "$rc" != 0 ]; then
  echo "WARNING $cmd returned $rc - proceeding without tmpfs log directory"
fi
cmd="sudo systemd start var-log.mount"
eval $cmd
rc=$?
if [ "$rc" != 0 ]; then
  echo "WARNING $cmd returned $rc - proceeding without tmpfs log directory"
fi

# start Mycroft
$ovosStartScript $arg1

