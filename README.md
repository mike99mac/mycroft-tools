# mycroft-tools
Line commands to be used with Mycroft running on Linux

*NOTE:* These tools are in the process of being adapted from mycroft-core to ovos-core, as it seems Mycroft will be no more :((
```
  * bash_profile                    Sample profile to be copied as $HOME/.bash_profile 
  * home-pi-minimy-logs.mount       Systemd file to mount tmpfs over Minimy logs
  * mycroft.service                 Systemd file to start mycroft
  * pulseaudio.service.new          Configure pulseaudio
  * pulseaudio.service.old          Configure pulseaudio in a different directory
  * pulseaudio.socket               Configure pulseaudio sockets
  * mpd.conf                        Sample mpd configuration file
  * var-log.mount                   Systemd file to mount tmpfs over /var/log
  * usr/local/sbin/buttons          Script to call buttons.py  
  * usr/local/sbin/buttons.py       Poll GPIO pins for button presses of previous, stop and next
  * usr/local/sbin/cmpcode          Compare running and github Minimy Python files 
  * usr/local/sbin/gr               A grep wrapper that does not send output to stderr
  * usr/local/sbin/gro              A grep wrapper to search OVOS code for a pattern
  * usr/local/sbin/install1         Script to customize Ubuntu desktop for Minimy or OVOS
  * usr/local/sbin/installovos      Script to install ovos-core
  * usr/local/sbin/lsenv            List many aspects of the Minimy/Mycroft environment 
  * usr/local/sbin/lsskills         List skills running 
  * usr/local/sbin/lstemp           Report the temperature of the Raspberry Pi
  * usr/local/sbin/restartminimy    Stop then start the Minimy stack   
  * usr/local/sbin/setup.sh         Install executable files into /usr/local/sbin  
  * usr/local/sbin/sortlogs         Merge and sort all log files and copy to /tmp
  * usr/local/sbin/startminimy      Start the Minimy stack 
  * usr/local/sbin/start-mycroft.sh Start the Mycroft(OVOS) stack 
  * usr/local/sbin/startovos        Start the OVOS stack 
  * usr/local/sbin/stopminimy       Stop the Minimy stack 
  * usr/local/sbin/stop-mycroft.sh  Stop the Mycroft(OVOS) stack 
  * usr/local/sbin/stopovos         Stop the OVOS stack 
  * usr/local/sbin/testplay         Play back a recorded file to test your speakers
  * usr/local/sbin/testrecord       Record a sample to a file and play back to test mic/speakers
  * usr/local/sbin/viewlogs         View merged log files                                       
```
# Installation
Clone the package then run ``setup.sh`` to copy the scripts to ``/usr/local/sbin``.
```
$ cd
$ git clone https://github.com/mike99mac/mycroft-tools
$ cd mycroft-tools
$ sudo ./setup.sh
```
# Feedback
Any questions or suggestions? Feel free to email me at mike99mac at gmail.com
