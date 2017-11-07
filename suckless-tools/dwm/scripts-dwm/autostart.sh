#!/bin/sh

bgs -z /home/mitch/workspace/dotfiles/suckless-tools/dwm/wall.*
clipmenud &
xbacklight -set 95 &
xset m 0 0 &
xrdb load ~/.Xresources &
redshift &
compton &
xautolock -time 10 -secure -locker /usr/local/bin/slock &
