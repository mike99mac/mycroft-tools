#!/bin/bash
#
# setup.sh - Install mike99mac's mycroft-tools in ./usr/local/sbin to the real /usr/local/sbin
# 
#+--------------------------------------------------------------------------+
# copy all files from the git clone to /usr/local/sbin
echo "Copying all scripts to /usr/local/sbin ..."
cmd="sudo cp usr/local/sbin/* /usr/local/sbin/"
$cmd
rc=$?
if [ "$rc" != 0 ]; then                  # error
  echo "ERROR: command $cmd returned $rc" 
  exit 2
fi
echo "Success!  There are new scripts in your /usr/local/sbin/ directory"

