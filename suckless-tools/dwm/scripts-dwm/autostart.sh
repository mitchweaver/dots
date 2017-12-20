#!/bin/sh

# NOTE: only put stuff here that you are sure won't take up much resources!
#       htop will put anything in here under 'dwm' for performance,
#       making debugging very difficult!

xset +fp /home/mitch/.fonts &
feh --bg-scale /home/mitch/workspace/dotfiles/suckless-tools/dwm/wall &
xmodmap ~/.Xmodmap &
xset m 0 0 &
xrdb load ~/.Xresources &

# clipmenud &

# xautolock -time 10 -secure -locker /usr/local/bin/slock &
# unclutter &
# xbacklight -set 95 &
# compton &
