#!/bin/sh

xmodmap ~/.Xmodmap &

# in case dwm was restarted, kill all programs
pkill -9 unclutter slstatus clipmenud compton 2>&1 /dev/null

feh --bg-scale ~/workspace/dotfiles/suckless-tools/dwm/wall &
compton --config ~/.config/compton.conf -b &

$(mkfontdir /home/mitch/.fonts ; mkfontscale /home/mitch/.fonts ; xset +fp /home/mitch/.fonts ; fc-cache /home/mitch/.fonts) 2>&1 /dev/null &
xrdb load ~/.Xresources &

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
