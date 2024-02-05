# Installing OVOS
This document describes how to install and run OVOS - the Open Voice Operating System

It assumes you have prepared a Linux operating system installed with the proper prerequisites.

If you haven't, there is well documented description here: https://github.com/mike99mac/minimy-mike99mac

To install and configure OVOS, perform the following steps:
- Install OVOS in a virtual environment:
`` 
sh -c "curl -s https://raw.githubusercontent.com/OpenVoiceOS/ovos-installer/main/installer.sh -o installer.sh && chmod +x installer.sh && sudo ./installer.sh"
``

- Choose these options:
```
 - Method:   virtualenv                      
 - Version:  development        
 - Profile:  ovos               
 - GUI:      false                       
 - Skills    true            
 - Tuning:   no         
```
Press Enter and the install should take a few minutes.  When it is done, OVOS should be running.

You can run ``ps -ef | grep -v grep | grep ovos`` to see some OVOS processes:

## Installing OVOS media service
To install the new OVOS media service, perform the following tasks:

- Go into a virtual environment:
```
$ source /home/pi/.venvs/ovos/bin/activate
```
- Set the preference ``enable_old_audioservice`` to False:
(ovos) $ ovos-config set -k enable_old_audioservice
Please enter the value to be stored (type: bool) : False
```

- Next
