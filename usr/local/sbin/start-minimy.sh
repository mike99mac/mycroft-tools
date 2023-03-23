#!/bin/bash
#
# start-minimy.sh
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
  local fsType=`mount | grep $mountDir | awk '{print $5}'`
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
  else
    echo "$cmd was successful"
  fi
 }                                         # mountFStmpfs()

#+--------------------------------------------------------------------------+
function mountLogDirs
# make log files directories tmpfs's to prolong the life of the micro-SD card
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  mountFStmpfs home-$USER-minimy-logs.mount Minimy log directory
  mountFStmpfs var-log.mount /var/log
  if [ ! -d /var/log/mpd ]; then           # mpd needs a log file to start
    sudo mkdir /var/log/mpd
    sudo touch /var/log/mpd/mpd.log
  fi
 }

#+--------------------------------------------------------------------------+
function startSystem 
# Start Minimy base components 
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  if [ ! -d $baseDir ]; then
    echo "ERROR: base directory $baseDir not found"
    echo "To clone Minimy to your home directory: "
    echo "cd; git clone https://github.com/ken-mycroft/minimy"
    exit 1
  fi  

  echo 'System Starting ...'
  cd $baseDir
  cat install/mmconfig.yml | grep -v "AWS" | grep -v "Goog"

  echo 'Start Local STT Server'
  which deactivate >/dev/null
  if [ $? = 0 ]; then
    deactivate
  fi
  cd framework/services/stt/local/CoquiSTT
  source venv_coqui/bin/activate
  python3 server.py --model-dir ds_model  > coqui_stt.log 2>&1 &
  which deactivate >/dev/null
  if [ $? = 0 ]; then
    deactivate
  fi
  cd ../../../../..

  echo 'Starting Local TTS Server ...'
  cd framework/services/tts/local/mimic3
  deactivate
  source .venv/bin/activate
  bin/mimic3 --model-dir voices/apope  > mimic3_tts.log 2>&1 &
  which deactivate >/dev/null
  if [ $? = 0 ]; then
    deactivate
  fi

  cd ../../../../..
  source venv_ngv/bin/activate

  export PYTHONPATH=`pwd`
  export SVA_BASE_DIR=`pwd`
  export GOOGLE_APPLICATION_CREDENTIALS="/home/pi/minimy/install/my-google-key.json"
  if [ -f tmp/save_audio/* ]; then
    rm tmp/save_audio/*
  fi
  if [ -f tmp/save_text/* ]; then
    rm tmp/save_text/*
  fi
  if [ -f tmp/save_tts/* ]; then
    rm tmp/save_tts/*
  fi

  echo 'Starting Message Bus ...'
  cd bus
  python3 MsgBus.py &
  cd ..
  sleep 2

  echo 'Starting System Skill ...'
  cd skills/system_skills
  python3 skill_system.py &
  sleep 1
  cd ../../

  echo 'Starting Intent Service ...'
  python3 framework/services/intent/intent.py &
  sleep 2 

  echo 'Starting Media Service ...'
  python3 framework/services/output/media_player.py &
  python3 framework/services/tts/tts.py &
  python3 framework/services/stt/stt.py &
  sleep 1
 }                                         # startSystem() 

#+--------------------------------------------------------------------------+
function loadOneSkill 
# load one skill 
# Arg 1    : Skill directory 
# Args 2-n : description of the skill
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}
  
  local theDir=$1
  shift
  local desc="$@"

  if [ ! -d $theDir ]; then 
    echo "ERROR: Directory $theDir not found"
    exit 1
  fi
  cd $theDir
  echo "Loading $desc ..."
  python3 __init__.py $PWD &
 }                                         # loadOneSkill{}

#+--------------------------------------------------------------------------+
function loadSystemSkills
# load all system skills
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  echo ' '
  echo 'Start System Skills ...'
  cd $baseDir
  python3 skills/system_skills/skill_fallback.py &
  python3 skills/system_skills/skill_media.py &
  python3 skills/system_skills/skill_volume.py &
  python3 skills/system_skills/skill_alarm.py &
  sleep 2 
 } 

#+--------------------------------------------------------------------------+
function loadUserSkills
# load all user skills
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  echo ' '
  echo 'Start User Skills'
  cd $baseDir/skills/user_skills

  loadOneSkill help Help skill
  echo 'WARNING! NOT loading rfm radio skill!'
  # loadOneSkill ../rfm RFM skill
  echo 'WARNING! NOT loading youtube music skill!'
  # loadOneSkill ../youtube YouTube skill 
  loadOneSkill ../email Email skill
  loadOneSkill ../wiki Wiki skill
  loadOneSkill ../timedate TimeDate skill 
  loadOneSkill ../example1 Example 1 skill 
  loadOneSkill ../npr_news NPR News skill 
  loadOneSkill ../weather Weather skill 
  echo 'WARNING! NOT loading Home Assistant skill!'
  # loadOneSkill ../ha_skill Home Assistant skill
  loadOneSkill ../connectivity Connectivity skill 
  loadOneSkill ../mpc mpc/mpd music skill  # Mike's music skill
  sleep 3
 }                                         # loadUserSkills()

#+--------------------------------------------------------------------------+
function loadMic
# load the microphone 
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  echo 'Finally, start the mic'
  cd $baseDir
  source venv_ngv/bin/activate
  python3 framework/services/input/mic.py &
  echo 
 }                                         # loadMic()

# main()
baseDir="$HOME/minimy"
export PYTHONPATH="$baseDir:$baseDir/venv_ngv/lib/python3.10/site-packages"
export SVA_BASE_DIR="$baseDir"

mountLogDirs $@                            # mount tmpfs's over log mount tmpfs's over log directories
startSystem
loadSystemSkills 
loadUserSkills 
loadMic 
echo '** System Started **'
