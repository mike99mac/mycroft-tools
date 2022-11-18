# mycroft-tools
Line commands to be used with Mycroft running on Linux
```
  * gr             - A grep wrapper that does not send output to stderr
  * lsenv          - List the Mycroft environment - what services are running?
  * lsintent       - List Mycroft intents - What can I say?
  * lsmycrofttools - List all tools in the mycroft-tools repo (this file)
  * lspairing      - List the Mycroft pairing code to pair a new device with mycroft.ai
  * lsskill        - List intent, etc files of one Mycroft skills
  * lsskills       - List Mycroft skills installed or not installed
  * lstemp         - Report the temperature of the Raspberry Pi
  * lsvocab        - List Mycroft vocabularies - what are the pieces of requests recognized?
  * lsvocab        - List Mycroft vocabularies - what are the pieces of requests recognized?
  * testplay       - Play back a recorded file to test your speakers
  * testrecord     - Record for a short while and save to a file to test your microphone
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
```
