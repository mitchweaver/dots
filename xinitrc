#!/bin/sh

cd ${HOME}

# if desktop
# xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --mode 1360x768 --pos 1920x0 --rotate normal --output DP-1 --off

bright 100
vol -dec 100
caps
xset +fp /home/mitch/usr/fonts
xrdb load /home/mitch/etc/Xresources
xmodmap ${HOME}/etc/Xmodmap
xset m 0 0
xset b off

case "$(basename $(file -b -i -L ${HOME}/var/tmp/wall))" in
     *gif*|*webm*|*mp4*|*mkv*|*stream*) mpvbg ${HOME}/var/tmp/wall & ;;
     *png*|*jpg*|*jpeg*|*) feh --bg-fill --no-fehbg ${HOME}/var/tmp/wall &
esac > /dev/null 2>&1

_run() { ! pgrep -f $1 && $@ > /dev/null & }

for i in bar 'clip --daemon' xbanish batmon composit ; do
    _run $i
done > /dev/null 2>&1

# If dwm crashes, or was pkill, relaunch
# --- note: this magically preserves opened windows!
# if I exit dwm, close
while type dwm > /dev/null ; do
    dwm && break || continue
done 1> /tmp/dwm.log \
     2> /tmp/dwm_err.log
