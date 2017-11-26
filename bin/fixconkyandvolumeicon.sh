#!/bin/bash
### FIXES OPENBOX STARTING THESE TWO WEIRD
### RUN IT IN YOUR OPENBOX AUTOSTART
sleep 10s
killall conky volumeicon
sleep 1s
conky -q &
volumeicon &
sleep 15s
killall megasync
sleep 5s
megasync &
