#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

rm -f ${HOME}/.cache/font-config/*.cache*

xrdb load ${HOME}/src/dots/Xresources &
xset +fp ${HOME}/files/fonts &
xset m 0 0 &
xset b off &
xhost +local: >/dev/null &
xmodmap ${HOME}/src/dots/Xmodmap &

read -r machine </etc/myname
case "$machine" in
    *200) # enable scrolling with thinkpad trackpoint (openbsd)
        xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation" 1 &
        xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation Button" 2 &
        xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation Axes" 6 7 4 5 &
esac

bright set 70 >/dev/null &
vol set 50    >/dev/null &
background ${HOME}/.wall &

while type dwm >/dev/null ; do
    pgrep -f sxhkd      || sxhkd   -c       ${HOME}/src/dots/sxhkdrc &
    pgrep -f dunst      || dunst   -conf    ${HOME}/src/dots/dunstrc &
    pgrep -f compton    || compton --config ${HOME}/src/dots/compton.conf -b
    pgrep -f bar        || bar           &
    pgrep -f batmon     || batmon        &
    pgrep -f clip       || clip -d       &
    pgrep -f ytdl-queue || ytdl-queue -d &
    dwm && break || continue
done >${HOME}/.cache/dwm.log 2>&1
