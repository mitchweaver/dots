#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

xrdb load $DOTS/Xresources

rm -f ~/.cache/font-config/*.cache*
find ~/files/fonts -type f -name fonts.dir | while read -r dir ; do
    xset +fp "${dir%/*}"
done
xset fp rehash
fc-cache

xmodmap $DOTS/Xmodmap &
xset m 0 0 &
xset b off &
xhost +local: >/dev/null &

# enable scrolling with thinkpad trackpoint (openbsd)
xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1 &
xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2 &
xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Axes' 6 7 4 5 &

background &
bright -s 100 &
vol -s 50 &

while type dwm >/dev/null ; do
    dwm && exit || continue
done
