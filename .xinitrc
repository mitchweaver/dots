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
# PROGRAMS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
pgrep -f parcellite || parcellite &
pgrep -f nextcloud  || nextcloud &
pgrep -f sxhkd      || sxhkd &
pgrep -f xbanish    || xbanish-t 10 &
pgrep -f picom      || picom -b
pgrep -f xautolock  || xautolock \
    -locker 'i3lock-fancy-rapid 20 pixel' \
    -secure \
    -time 10 \
    -notify 15 \
    -notifier notify-send &

pgrep -f redshift || \
    redshift -v -l '36.15398:-95.99277' >~/.cache/redshift.log 2>&1 &

# note: sleep here seems to avoid "dummy output" bug
pgrep -f pipewire   || { sleep 5 ; gentoo-pipewire-launcher ; } &

background &

exec i3 -d all > "$XDG_CACHE_HOME"/i3.log 2>&1
