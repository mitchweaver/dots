#!/bin/sh

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ENV VARIABLES
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export DISPLAY="${DISPLAY:-:0}"
export _JAVA_AWT_WM_NONREPARENTING=1

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# XORG SETTINGS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
xrdb load ~/.Xresources
xmodmap ~/.xmodmaprc
xset +fp ~/.fonts
xset m 0 0
xset b off

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ONE SHOT COMMANDS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
background &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# DAEMONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
pgrep -f parcellite || parcellite >~/.cache/parcellite.log 2>&1 &
pgrep -f nextcloud  || nextcloud >~/.cache/nextcloud.log 2>&1 &
pgrep -f sxhkd      || sxhkd >~/.cache/sxhkd.log 2>&1 &
pgrep -f redshift   || redshift -v >~/.cache/redshift.log 2>&1 &
pgrep -f xbanish    || xbanish -t 10 &
pgrep -f picom      || picom -b
pgrep -f pipewire   || gentoo-pipewire-launcher &
pgrep -f xautolock  || xautolock \
    -locker 'i3lock-fancy-rapid 20 pixel' \
    -time 10 \
    -notify 15 \
    -notifier notify-send >~/.cache/xautolock.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# APPLICATIONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
sylpheed >~/.cache/sylpheed.log 2>&1 &

exec i3 -d all >~/.cache/i3.log 2>&1
