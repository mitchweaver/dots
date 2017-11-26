#!/bin/sh

# Starts a urxvt client from the daemon

urxvtc "$@"
if [ $? -eq 2 ]; then
   urxvtd -q -o -f
   urxvtc "$@"
fi
