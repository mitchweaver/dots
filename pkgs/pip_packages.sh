#!/bin/sh
#
# pip packages because I'm too lazy to make ports for them
#

for ver in ' ' 3.8 3.9 3 ; do
    if command -v pip$ver > /dev/null ; then
        pip=$pip$ver
        break
    fi
done

pip$ver install -U \
    pywal \
    pysdl2 \
    diceware \
    wallstreet
