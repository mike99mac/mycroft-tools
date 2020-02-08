# mycroft-tools
This toolkit is a set of line command tools to use with mycroft - https://mycroft.ai/

List skills, intents and vocabularies:

# mlsskills -h
Name: mlsskills - List Mycroft skillss
Usage: mlsskills [OPTIONS] [PATTERN]
Where: PATTERN is an optional string pattern to search for

OPTIONS:
  -h|--help         Give help (this screen)
  -a|--all          List both installed and uninstalled skills
  -l|--long         Long listing of skills
  -u|--uninstalled  Only list skills not installed
  -x|--debug        Print commands and arguments as they are executed

# mlsintent -h
Name: mlsintent - List Mycroft intents
Usage: mlsintent [OPTIONS] [PATTERN]
Where: PATTERN is an optional string pattern to search for

OPTIONS:
  -h|--help         Give help (this screen)
  -l|--long         Long listing of intent
  -x|--debug        Print commands and arguments as they are executed

# mlsvocab -h
Name: mlsvocab - List Mycroft vocabs
Usage: mlsvocab [OPTIONS] [PATTERN]
Where: PATTERN is an optional string pattern to search for

OPTIONS:
  -h|--help         Give help (this screen)
  -l|--long         Long listing of vocab
  -x|--debug        Print commands and arguments as they are executed
