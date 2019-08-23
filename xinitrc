#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

autostart

# if desktop
# xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --mode 1360x768 --pos 1920x0 --rotate normal --output DP-1 --off

# If dwm crashes, or was pkill, relaunch
# --- note: this magically preserves opened windows!
# if I exit dwm, close
while type dwm > /dev/null ; do
    dwm  > /tmp/dwm.log \
        2> /tmp/dwm_err.log \
    && break || continue
done
