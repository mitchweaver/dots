#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

(rm -rf ${HOME}/.cache/font-config &)

background ${HOME}/.wall &

xrdb load ${HOME}/src/dots/Xresources
xmodmap ${HOME}/src/dots/Xmodmap
xset +fp ${HOME}/files/fonts
xset m 0 0
xset b off

# enable scrolling with thinkpad trackpoint (openbsd)
xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation" 1
xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation Button" 2
xinput set-prop /dev/wsmouse "WS Pointer Wheel Emulation Axes" 6 7 4 5

# allow local network to access xserver
# (ex: run X apps from chroots)
xhost +local:

bright 100 &
vol -dec 100 &

! pgrep -f sxhkd      && sxhkd -c ${HOME}/src/dots/sxhkdrc &
! pgrep -f dunst      && dunst -conf ${HOME}/src/dots/dunstrc &
! pgrep -f bar        && bar     &
! pgrep -f batmon     && batmon  &
! pgrep -f clip       && clip -d &
! pgrep -f xbanish    && xbanish &
! pgrep -f ytdl-queue && ytdl-queue -d &

# If dwm crashes, or was pkill, relaunch
# --- note: this magically preserves opened windows!
while type dwm >/dev/null ; do
    dwm && break || continue
done
