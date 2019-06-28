#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

cd ${HOME}

# if desktop
# xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --mode 1360x768 --pos 1920x0 --rotate normal --output DP-1 --off

# If dwm crashes, or was pkill, relaunch
# --- note: this magically preserves opened windows!
# if I exit dwm, close
while type dwm > /dev/null ; do
    dwm && break || continue
done 1> /tmp/dwm.log \
     2> /tmp/dwm_err.log
