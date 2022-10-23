#!/bin/sh

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ENV VARIABLES
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export DISPLAY="${DISPLAY:-:0}"
export _JAVA_AWT_WM_NONREPARENTING=1

if command -v dimensions >/dev/null ; then
    export DIMENSIONS="$(dimensions)"
fi

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
pgrep -f nextcloud  || nextcloud >~/.cache/nextcloud.log 2>&1 &
pgrep -f dunst      || dunst >~/.cache/dunst.log 2>&1 &
pgrep -f sxhkd      || sxhkd >~/.cache/sxhkd.log 2>&1 &
pgrep -f redshift   || firejail-redshift.sh -v >~/.cache/redshift.log 2>&1 &
pgrep -f xbanish    || firejail xbanish -t 10 &
pgrep -f picom      || firejail picom >~/.cache/picom.log &
pgrep -f parcellite || firejail parcellite >~/.cache/parcellite.log 2>&1 &
pgrep -f weatherd   || weatherd -d >/dev/null 2>&1 &

#### why is this broken on i3 startup... have to manually do it
# pgrep -f pipewire   || gentoo-pipewire-launcher &

####### -detectsleep \
pgrep -f xautolock  || xautolock \
    -locker 'i3lock-fancy-rapid 10 pixel' \
    -time 10 \
    -notify 15 \
    -notifier notify-send >~/.cache/xautolock.log 2>&1 &

polybar-msg cmd quit
polybar mybar >~/.cache/polybar.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# APPLICATIONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
firejail-discord.sh >~/.cache/discord.log 2>&1 &
# firejail-spotify.sh >~/.cache/spotify.log 2>&1 &
mailspring >~/.cache/mailspring.log 2>&1 &
# joplin-desktop-bin >~/.cache/joplin.log 2>&1 &

exec i3 -d all >~/.cache/i3.log 2>&1
