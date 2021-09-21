#!/bin/bash
#
# setup.sh - Install mike99mac's mycroft-tools in ./usr/local/sbin to the real /usr/local/sbin
#            This must be run as "sudo ./setub.sh" from the git clone as it expects
#            the script lsintent to be in the relative directory usr/local/sbin
# 
#+--------------------------------------------------------------------------+
# check for the lsintent file
echo "Checking for lsintent file ..."
if [ ! -f ./usr/local/sbin/lsintent ]; then # error
  echo "ERROR: cannot file the script ./usr/local/sbin/lsintent"
  exit 1
fi

# copy all files from the git clone to /usr/local/sbin
echo "Copying all scripts to /usr/local/sbin ..."
cmd="sudo cp usr/local/sbin/* /usr/local/sbin/"
$cmd
rc=$?
if [ "$rc" != 0 ]; then                  # error
  echo "ERROR: command $cmd returned $rc" 
  exit 2
fi

# make lsskills and lsvocab symbolic links to lsintent
echo "Making symbolic links in /usr/local/sbin ..."
cd /usr/local/sbin
for nextName in lsskills lsvocab; do
  cmd="/usr/bin/ln -s lsintent $nextName"  # make a symlink
  $cmd                                     # run the command  
  rc=$?
  if [ "$rc" != 0 ]; then                # error
    echo "ERROR: command $cmd returned $rc" 
    exit 3
  fi
done  
echo "Success!  There are new scripts in your /usr/local/sbin/ directory"
