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
pgrep -f xbanish    || xbanish -t 30 &
pgrep -f picom      || picom &
pgrep -f redshift   || firejail-redshift.sh &
pgrep -f parcellite || firejail parcellite &
pgrep -f weatherd   || weatherd -d >/dev/null 2>&1 &

#### why is this broken on i3 startup... have to manually do it
# pgrep -f pipewire   || gentoo-pipewire-launcher &

pgrep -f xdimmer || xdimmer -p 20 -s 10 -b 1 -t 570 &

pgrep -f xautolock  || xautolock \
    -locker 'i3lock-fancy-rapid 10 pixel' \
    -time 10 \
    -notify 15 \
    -notifier notify-send >~/.cache/xautolock.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# APPLICATIONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# firejail-discord.sh >~/.cache/discord.log 2>&1 &
# firejail-spotify.sh >~/.cache/spotify.log 2>&1 &
mailspring >~/.cache/mailspring.log 2>&1 &
# joplin-desktop-bin >~/.cache/joplin.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# WINDOW MANAGER
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
polybar-msg cmd quit >~/.cache/polybar.log 2>&1
polybar mybar >>~/.cache/polybar.log 2>&1 &
exec i3 >~/.cache/i3.log 2>&1
