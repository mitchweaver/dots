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
dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# DAEMONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
pgrep -f parcellite || parcellite >~/.cache/parcellite.log 2>&1 &
pgrep -f nextcloud  || nextcloud >~/.cache/nextcloud.log 2>&1 &
pgrep -f sxhkd      || sxhkd >~/.cache/sxhkd.log 2>&1 &
pgrep -f redshift   || redshift -v >~/.cache/redshift.log 2>&1 &
pgrep -f pipewire   || gentoo-pipewire-launcher &
pgrep -f xbanish    || xbanish -t 10 &
pgrep -f picom      || picom -b
pgrep -f dunst      || dunst >~/.cache/dunst.log 2>&1 &
pgrep -f xautolock  || xautolock \
    -detectsleep \
    -locker 'i3lock-fancy-rapid 20 pixel' \
    -time 10 \
    -notify 15 \
    -notifier notify-send >~/.cache/xautolock.log 2>&1 &

polybar-msg cmd quit
polybar mybar >~/.cache/polybar.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# APPLICATIONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
mailspring >~/.cache/mailspring.log 2>&1 &
firejail-discord.sh >~/.cache/discord.log 2>&1 &
# joplin-desktop-bin >~/.cache/joplin.log 2>&1 &
# spotify >~/.cache/spotify.log 2>&1 &

exec i3 -d all >~/.cache/i3.log 2>&1
