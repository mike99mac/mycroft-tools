#!/bin/bash
#
# stop-minimy.sh - kill processes with minimy strings in them 
#
echo "Stopping Minimy ..." 
procs=`ps -ef | egrep 'minimy/skills|skills/system_skills|framework/services|MsgBus|mimic3|skill_system.py' | grep -v grep`
if [ ${#procs} = 0 ]; then 
  echo "Minimy does not appear to be running"
else
  echo "$procs" | while read nextProc; do
    pid=`echo $nextProc | awk '{print $2}'`
    echo "killing process: $nextProc ..."
    sudo kill $pid
  done 
fi
sleep 2
lsenv noclear                              # show status but don't clear screen

