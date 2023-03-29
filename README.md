# mycroft-tools
Line commands to be used with Mycroft running on Linux

*NOTE:* These tools are in the process of being adapted from mycroft-core to ovos-core, as it seems Mycroft will be no more :((
```
  * bash_profile                    Can be copied to ~ as .bash_profile to add shortcuts
  * buttons.service                 Systemd file to start buttons as a daemon 
  * mycroft.service                 Systemd file to start mycroft
  * mpd.conf                        Sample mpd configuration file
  * tmpfs.service                   Service to mount tmpfs file systems
  * usr/local/sbin/buttons          Script to call buttons.py  
  * usr/local/sbin/buttons.py       Poll GPIO pins for button presses of previous, stop and next
  * usr/local/sbin/gr               A grep wrapper that does not send output to stderr
  * usr/local/sbin/install1         Script to customize a fresh flash of Ubuntu desktop
  * usr/local/sbin/install2         Script to install ovos-core
  * usr/local/sbin/lsenv            List the Mycroft environment - what services are running?
  * usr/local/sbin/lsskills         List Mycroft skills installed or not installed
  * usr/local/sbin/lstemp           Report the temperature of the Raspberry Pi
  * usr/local/sbin/setup.sh         Install executable files into /usr/local/sbin  
  * usr/local/sbin/start-minimy.sh  Start the Minimy stack 
  * usr/local/sbin/start-mycroft.sh Start the Mycroft(OVOS) stack 
  * usr/local/sbin/stop-minimy.sh   Stop the Minimy stack 
  * usr/local/sbin/stop-mycroft.sh  Stop the Mycroft(OVOS) stack 
  * usr/local/sbin/testplay         Play back a recorded file to test your speakers
  * usr/local/sbin/testrecord       Record for a short while and save to a file to test your microphone
  * usr/local/sbin/tmpfsmnt         Scripts to mount tmpfs file systems
```
# Installation
Clone the package then run ``setup.sh`` to copy the scripts to ``/usr/local/sbin``.
```
$ cd
$ git clone https://github.com/mike99mac/mycroft-tools
$ cd mycroft-tools
$ sudo ./setup.sh

# Feedback
Feel free to email me at mike99mac at gmail.com
