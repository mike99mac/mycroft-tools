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
  else 
    echo "$cmd was successful"
  fi
 }                                         # mountFStmpfs()

#+--------------------------------------------------------------------------+
function mountLogDirs 
#+--------------------------------------------------------------------------+
 {
  : SOURCE: ${BASH_SOURCE}
  : STACK:  ${FUNCNAME[@]}

  # make log files directories tmpfs's to lengthen the life of the micro-SD card
  mountFStmpfs home-$USER-.local-state-mycroft.mount Mycroft log directory
  mountFStmpfs var-log.mount /var/log
  if [ ! -d /var/log/mpd ]; then           # mpd needs a log file to start
    sudo mkdir /var/log/mpd
    sudo touch /var/log/mpd/mpd.log
  fi
 } 

SOURCE="${BASH_SOURCE[0]}"
script=${0}
script=${script##*/}
cd -P "$( dirname "$SOURCE" )"
DIR="$( pwd )"
VIRTUALENV_ROOT=${VIRTUALENV_ROOT:-"${DIR}/.venv"}

function help() {
    echo "${script}:  Mycroft command/service launcher"
    echo "usage: ${script} [COMMAND] [restart] [params]"
    echo
    echo "Services COMMANDs:"
    echo "  all                      Runs core services: bus, audio, skills, voice"
    echo "  debug                    Runs core services, then starts the CLI"
    echo "  audio                    Audio playback service"
    echo "  bus                      Messagebus service"
    echo "  skills                   Skill service"
    echo "  voice                    Voice capture service"
    echo "  gui                      GUI protocol service"
    echo "  enclosure                Enclosure service"
    echo
    echo "Options:"
    echo "  cli                      Command Line Interface"
    echo "  restart                  Restart service if running"
    echo
    echo "Examples:"
    echo "  ${script} all"
    echo "  ${script} all restart"
    echo "  ${script} cli"
    exit 1
}

_module=""
function name-to-script-path() {
    case ${1} in
        "bus")               _module="mycroft.messagebus.service" ;;
        "skills")            _module="mycroft.skills" ;;
        "audio")             _module="mycroft.audio" ;;
        "voice")             _module="mycroft.client.speech" ;;
        "cli")               _module="mycroft.client.text" ;;
        "gui")               _module="mycroft.gui" ;;
        "enclosure")         _module="mycroft.client.enclosure" ;;
        *)
            echo "Error: Unknown name '${1}'"
            exit 1
    esac
}

function launch-process() {
    name-to-script-path ${1}
    echo "Starting $1"                     # Launch process in foreground
    python3 -m ${_module} $_params
}

function launch-background() {
    # Check if given module is running and start (or restart if running)
    name-to-script-path ${1}
    if pgrep -f "python3 (.*)-m ${_module}" > /dev/null ; then
        if ($_force_restart) ; then
            echo "Restarting: ${1}"
            "${DIR}/stop-mycroft.sh" ${1}
        else                               # Already running, no need to restart
            return
        fi
    else
        echo "Starting background service $1"
    fi
    python3 -m ${_module} $_params &       # Launch process in background
}

function launch-all() {
    echo "Starting all mycroft services from ovos-core"
    launch-background bus
    launch-background skills
    launch-background audio
    launch-background voice
    launch-background enclosure
}

# main()
# if we are not in a venv, try to run in one
if [ ${#VIRTUAL_ENV} = 0 ]; then           # not in a venv
  VIRTUAL_ENV="/home/$USER/ovos-core/venv"
  if [ ! -f $VIRTUAL_ENV/bin/activate ]; then
    echo "ERROR: $VIRTUAL_ENV/bin/activate not found"
    exit 1
  fi
  source $VIRTUAL_ENV/bin/activate
  echo "started a venv ..."
fi
  
mountLogDirs $@                             # mount tmpfs's over log mount tmpfs's over log directories
  
_opt=$1
_force_restart=false
shift
if [[ "${1}" == "restart" ]] || [[ "${_opt}" == "restart" ]] ; then
    _force_restart=true
    if [[ "${_opt}" == "restart" ]] ; then
        # Support "start-mycroft.sh restart all" as well as "start-mycroft.sh all restart"
        _opt=$1
    fi
    shift
fi
_params=$@
 
case ${_opt} in
    bus|gui|audio|skills|voice|enclosure)
        launch-background ${_opt}
        ;;
    cli)
        launch-process cli
        ;;
    debug)
      # launch-all; launch-process cli
        launch-all; ovos-cli-client
        ;;
    *)
        launch-all
        ;;
esac

