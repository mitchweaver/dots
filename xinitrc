#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

rm -f ${HOME}/.cache/font-config/*.cache* &
xset +fp ${HOME}/files/fonts &
xrdb load ${HOME}/src/dots/Xresources &

xset m 0 0 &
xset b off &
xhost +local: >/dev/null &
xmodmap ${HOME}/src/dots/Xmodmap &

# enable scrolling with thinkpad trackpoint (openbsd)
xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation" 1 &
xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation Button" 2 &
xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation Axes" 6 7 4 5 &

background ${HOME}/.wall &
bright set 100 &
vol set 50 &

while type dwm >/dev/null ; do
    pgrep -f dunst      || dunst -conf ${HOME}/src/dots/dunstrc &
    pgrep -f bar        || bar           &
    pgrep -f batmon     || batmon        &
    pgrep -f clip       || clip -d       &
    pgrep -f ytdl-queue || ytdl-queue -d &
    pgrep -f compton    || compton --config ${HOME}/src/dots/compton.conf -b
    #pgrep -f torrent-queue || torrent-queue -d &
    dwm >${HOME}/.cache/dwm.log 2>&1 && exit || continue
done
