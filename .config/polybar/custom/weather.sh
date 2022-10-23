#!/bin/sh


temp=$(weatherd)
temp=${temp##* }

# fixlater
printf '%s %s\n' "" "$temp"

# case ${temp%°*} in
# esac
