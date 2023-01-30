#!/bin/bash
#
# setup.sh - Install mike99mac's mycroft-tools in ./usr/local/sbin to the real /usr/local/sbin
#            This must be run as "sudo ./setup.sh" from the git clone as it expects
#            the script lsintent to be in the relative directory usr/local/sbin
# 
#+--------------------------------------------------------------------------+
# copy all files from the git clone to /usr/local/sbin
echo "Copying all scripts to /usr/local/sbin ..."

cmd="chgrp pi /usr/local/sbin"
$cmd
rc=$?
if [ "$rc" != 0 ]; then                  # error
  echo "ERROR: command $cmd returned $rc" 
  exit 2
fi

cmd="chmod g+w /usr/local/sbin"
$cmd
rc=$?
if [ "$rc" != 0 ]; then                  # error
  echo "ERROR: command $cmd returned $rc" 
  exit 2
fi

cmd="cp usr/local/sbin/* /usr/local/sbin/"
$cmd
rc=$?
if [ "$rc" != 0 ]; then                  # error
  echo "ERROR: command $cmd returned $rc" 
  exit 2
fi

cmd="chown pi /usr/local/sbin/*"
$cmd
rc=$?
if [ "$rc" != 0 ]; then                  # error
  echo "ERROR: command $cmd returned $rc"
  exit 2
fi

echo "Success!  There are new scripts in your /usr/local/sbin/ directory"
