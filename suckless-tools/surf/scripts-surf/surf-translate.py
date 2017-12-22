import sys
from os import system

print(len(sys.argv))

arg = sys.argv[1]

arg = arg.replace("'", "")
arg = arg.replace('"', "")
arg = arg.replace("`", "")

arg = "'" + arg + "'"

print(arg)

system('st -w surf-translate -T surf-translate -n surf-translate -e /bin/sh -c "trans -b ' + arg + '| less -Q -R -s --tilde"')
