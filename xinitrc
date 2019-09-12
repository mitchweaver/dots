#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

# allow local network to access xserver
# (ex: run X apps from chroots)
xhost +local:

#while sleep 10 ; do : ; done

autostart

# sudo chroot ${HOME}/env/bs1 /bin/dwm

# If dwm crashes, or was pkill, relaunch
# --- note: this magically preserves opened windows!
# if I exit dwm, close
while type dwm >/dev/null ; do
    dwm  > /tmp/dwm.log \
        2> /tmp/dwm_err.log \
    && break || continue
done
