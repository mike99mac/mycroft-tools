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

