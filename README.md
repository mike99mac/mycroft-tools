# mycroft-tools
Line commands to be used with Mycroft running on Linux
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
  * usr/local/sbin/testplay         Play back a recorded file to test your speakers
  * usr/local/sbin/testrecord       Record for a short while and save to a file to test your microphone
  * usr/local/sbin/tmpfsmnt         Scripts to mount tmpfs file systems
  * usr/local/sbin/uninstallmycroft Completely uninstall Mycroft 
```
