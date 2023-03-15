#!/bin/bash
#
# start-minimy.sh
# 
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
  deactivate
  cd framework/services/stt/local/CoquiSTT
  source venv_coqui/bin/activate
  python server.py --model-dir ds_model  > coqui_stt.log 2>&1 &
  deactivate
  cd ../../../../..

  echo 'Starting Local TTS Server ...'
  cd framework/services/tts/local/mimic3
  deactivate
  source .venv/bin/activate
  bin/mimic3 --model-dir voices/apope  > mimic3_tts.log 2>&1 &
  deactivate

  cd ../../../../..
  source venv_ngv/bin/activate

  export PYTHONPATH=`pwd`
  export SVA_BASE_DIR=`pwd`
  export GOOGLE_APPLICATION_CREDENTIALS="/home/pi/minimy/install/my-google-key.json"
  rm tmp/save_audio/*
  rm tmp/save_text/*
  rm tmp/save_tts/*

  echo 'Starting Message Bus ...'
  cd bus
  python MsgBus.py &
  cd ..
  sleep 2

  echo 'Starting System Skill ...'
  cd skills/system_skills
  python skill_system.py &
  sleep 1
  cd ../../

  echo 'Starting Intent Service ...'
  python framework/services/intent/intent.py &
  sleep 2 

  echo 'Starting Media Service ...'
  python framework/services/output/media_player.py &
  python framework/services/tts/tts.py &
  python framework/services/stt/stt.py &
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
  echo "Loading $desc"
  python __init__.py $PWD &
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
  python skills/system_skills/skill_fallback.py &
  python skills/system_skills/skill_media.py &
  python skills/system_skills/skill_volume.py &
  python skills/system_skills/skill_alarm.py &
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
  loadOneSkill ../rfm RFM skill
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
  loadOneSkill ../mpc mpc/mpd music skill  # try Mike's music skill
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
  python framework/services/input/mic.py &
 }                                         # loadMic()

# main()
baseDir="$HOME/minimy"

startSystem
loadSystemSkills 
loadUserSkills 
loadMic 
echo ' '
echo '** System Started **'
