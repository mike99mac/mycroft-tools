# Installing OVOS
This document describes how to install and run OVOS - the Open Voice Operating System

It assumes you have prepared a Linux operating system installed with the proper prerequisites.  If you haven't, there is well documented description here: https://github.com/mike99mac/minimy-mike99mac

To install and configure OVOS, perform the following steps:
- Install OVOS in a virtual environment:

`` 
$ sh -c "curl -s https://raw.githubusercontent.com/OpenVoiceOS/ovos-installer/main/installer.sh -o installer.sh && chmod +x installer.sh && sudo ./installer.sh"
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

Press **Enter** and the install should take a few minutes.  When it is done, OVOS should be running.

Run the following command to see OVOS processes:

```
$ ps -ef | grep -v grep | grep ovos
root     2418483       1  0 12:52 ?        00:00:08 /home/pi/.venvs/ovos/bin/python3 /home/pi/.venvs/ovos/bin/ovos_PHAL_admin
pi       2418485     838  0 12:52 ?        00:00:08 /home/pi/.venvs/ovos/bin/python3 /home/pi/.venvs/ovos/bin/ovos-messagebus
pi       2418486     838  0 12:52 ?        00:00:09 /home/pi/.venvs/ovos/bin/python3 /home/pi/.venvs/ovos/bin/ovos_PHAL
pi       2418487     838  3 12:52 ?        00:01:00 /home/pi/.venvs/ovos/bin/python3 /home/pi/.venvs/ovos/bin/ovos-core
pi       2418489     838  9 12:52 ?        00:02:33 /home/pi/.venvs/ovos/bin/python3 /home/pi/.venvs/ovos/bin/ovos-dinkum-listener
```

## Installing OVOS media service
To install the new OVOS media service, perform the following tasks:

- Go into a virtual environment:

```
$ source /home/pi/.venvs/ovos/bin/activate
```

- Install the ovos-media plugin:

```
(ovos) $ pip install --ignore-installed  ovos-media
```

- Set the preference ``enable_old_audioservice`` to False:

```
(ovos) $ ovos-config set -k enable_old_audioservice
Please enter the value to be stored (type: bool) : False
```

- Change to the directory where user system user service files exist:

```
(ovos) $ cd /home/pi/.config/systemd/user
```

- Create a systemd file to start the OVOS media service: 

```
(ovos) $ sudo vi ovos-media.service
[Unit]
Documentation=https://openvoiceos.github.io/ovos-docker/about/glossary/components/#ovos-media
Description=Open Voice OS - Media
After=network.target ovos-messagebus.service ovos-phal.service
Requires=ovos-messagebus.service ovos-phal.service

[Service]
WorkingDirectory=/home/pi/.venvs/ovos
ExecStart=/home/pi/.venvs/ovos/bin/ovos-media
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s KILL $MAINPID
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
```

- Enable it to run at boot time:

```
(ovos) $ systemctl --user enable ovos-media
Created symlink /home/pi/.config/systemd/user/default.target.wants/ovos-media.service → /home/pi/.config/systemd/user/ovos-media.service.
```

- Reboot your Linux system: 

```
(ovos) sudo reboot
```

- When it comes back up, get a new SSH session and check the OVOS processes:

```
$ ps -ef | grep -v grep | grep ovos
```
