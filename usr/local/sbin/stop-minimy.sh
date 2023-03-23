#!/bin/bash
#
# stop-minimy.sh - call the Python script to stop Minimy 
#
echo "Stopping Minimy with: $HOME/minimy/stop.py ..."
$HOME/minimy/stop.py
sleep 2
lsenv noclear                              # show status but don't clear screen
