#!/bin/sh

xset +fp /home/mitch/.fonts
feh --bg-scale /home/mitch/workspace/dotfiles/suckless-tools/dwm/wall &
xmodmap ~/.Xmodmap
xrdb load ~/.Xresources &
xset m 0 0 &
clipmenud &
# compton &
slstatus &
# xautolock -time 10 -secure -locker /usr/local/bin/slock &
unclutter &
# xbacklight -set 95 &
