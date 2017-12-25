#!/bin/sh

xmodmap ~/.Xmodmap &
xset +fp ~/.fonts &
feh --bg-scale ~/workspace/dotfiles/suckless-tools/dwm/wall &
bash ~/workspace/dotfiles/lemonbar/bar &
xset m 0 0 &
xrdb load ~/.Xresources &
unclutter -jitter 1 -noevents -idle 5 &

# slstatus &

# For some bizarre reason, '-root' stops `tabbed`
# from starting. Why is this?
# unclutter -jitter 1 -root -noevents -idle 5 &

# clipmenud &

# xautolock -time 10 -secure -locker /usr/local/bin/slock &
# xbacklight -set 95 &
# compton &
