#!/bin/sh

xmodmap ~/.Xmodmap
feh --bg-scale /home/mitch/workspace/dotfiles/suckless-tools/dwm/wall &
compton &
slstatus &
clipmenud &
xset m 0 0 &
xrdb load ~/.Xresources &
# xautolock -time 10 -secure -locker /usr/local/bin/slock &
unclutter &
xbacklight -set 95 &
