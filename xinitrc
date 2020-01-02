#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

wmname LG3D

# allow local network to access xserver
# (ex: run X apps from chroots)
xhost +local:

xset m 0 0

autostart

# exec openbox-session

# If dwm crashes, or was pkill, relaunch
# --- note: this magically preserves opened windows!
#if I exit dwm, close
while type dwm >/dev/null ; do
    dwm  > /tmp/dwm.log \
        2> /tmp/dwm_err.log \
    && break || continue
done
