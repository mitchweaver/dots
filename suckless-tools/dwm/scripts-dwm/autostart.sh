#!/bin/sh

# in case dwm was restarted, kill all programs
pkill -9 unclutter slstatus clipmenud

xmodmap ~/.Xmodmap &
feh --bg-scale ~/workspace/dotfiles/suckless-tools/dwm/wall &

xrdb load ~/.Xresources
xset +fp /home/mitch/.fonts

# bash ~/workspace/dotfiles/lemonbar/bar &

xset m 0 0 &
unclutter -jitter 1 -noevents -idle 5 &

slstatus &

# For some bizarre reason, '-root' stops `tabbed`
# from starting. Why is this?
# unclutter -jitter 1 -root -noevents -idle 5

# clipmenud

# xautolock -time 10 -secure -locker /usr/local/bin/slock
# xbacklight -set 95
# compton
