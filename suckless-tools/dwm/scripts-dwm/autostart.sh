#!/bin/sh

bgs -z /home/mitch/workspace/dotfiles/suckless-tools/dwm/wall &
slstatus &
clipmenud &
xset m 0 0 &
xrdb load ~/.Xresources &
compton &
xautolock -time 10 -secure -locker /usr/local/bin/slock &
xbacklight -set 95 &
