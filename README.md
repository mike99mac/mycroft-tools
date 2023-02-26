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
  * usr/local/sbin/lsintent         List Mycroft intents - What can I say?
  * usr/local/sbin/lsmycrofttools   List all tools in the mycroft-tools repo (this file)
  * usr/local/sbin/lspairing        List the Mycroft pairing code to pair a new device with mycroft.ai
  * usr/local/sbin/lsskill          List intent, etc files of one Mycroft skills
  * usr/local/sbin/lsskills         List Mycroft skills installed or not installed
  * usr/local/sbin/lstemp           Report the temperature of the Raspberry Pi
  * usr/local/sbin/lsvocab          List Mycroft vocabularies - what are the pieces of requests recognized?
  * usr/local/sbin/setup.sh         Install executable files into /usr/local/sbin  
  * usr/local/sbin/testplay         Play back a recorded file to test your speakers
  * usr/local/sbin/testrecord       Record for a short while and save to a file to test your microphone
  * usr/local/sbin/tmpfsmnt         Scripts to mount tmpfs file systems
  * usr/local/sbin/uninstallmycroft Completely uninstall Mycroft 
```
Change log
```
Date          Description
?? ??? 2020   First release 
?? Nov 2021   Added scripts:
                lsenv          - list the Mycroft environment
		lspairing      - list the Mycroft pairing code
	      Fixed bugs
23 May 2022   Added scripts: 
                lsskill        - List all vocabulary, intent, dialog, etc. files for one Mycroft skill
                lsmycrofttools - list the Mycroft pairing code
	      Added help (-h|--help) for all scripts 
              Fixed bugs
15 Aug 2022   Updated lsenv for better and more concise output	      
              Added 'gr' - a grep wrapper that does not send output to stderr
27 Jan 2023   Added uninstallmycroft to completely uninstall Mycroft
```
