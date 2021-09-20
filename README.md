# mycroft-tools
This toolkit is a set of line command tools to use with Mycroft.

Three scripts list Mycroft skills, intents and vocabularies. The help output is below.
Also I added some more helpful scripts:
  * pitemp     - Report the temperature of the Raspberry Pi
  * testplay   - Play back a recorded file to test your speakers
  * testrecord - Record for a short while and save to a file to test your microphone
```
# lsskills -h
Name: lsskills - List Mycroft skillss
Usage: lsskills [OPTIONS] [PATTERN]
Where: PATTERN is an optional string pattern to search for

OPTIONS:
  -h|--help         Give help (this screen)
  -a|--all          List both installed and uninstalled skills
  -l|--long         Long listing of skills
  -u|--uninstalled  Only list skills not installed
  -x|--debug        Print commands and arguments as they are executed

# lsintent -h
Name: lsintent - List Mycroft intents
Usage: lsintent [OPTIONS] [PATTERN]
Where: PATTERN is an optional string pattern to search for

OPTIONS:
  -h|--help         Give help (this screen)
  -l|--long         Long listing of intent
  -x|--debug        Print commands and arguments as they are executed

# lsvocab -h
Name: lsvocab - List Mycroft vocabs
Usage: lsvocab [OPTIONS] [PATTERN]
Where: PATTERN is an optional string pattern to search for

OPTIONS:
  -h|--help         Give help (this screen)
  -l|--long         Long listing of vocab
  -x|--debug        Print commands and arguments as they are executed
```
