#!/bin/sh

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ENV VARIABLES
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export DISPLAY="${DISPLAY:-:0}"
export _JAVA_AWT_WM_NONREPARENTING=1
export STEAM_RUNTIME=1
if command -v dimensions >/dev/null ; then
    export DIMENSIONS="$(dimensions)"
fi

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# XORG SETTINGS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
xmodmap ~/.xmodmaprc
xset +fp ~/.fonts
xset m 0 0
xset b off

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# SET PROPER DPI
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
if [ "$DIMENSIONS" ] ; then
    # shellcheck disable=2086
    set -- $DIMENSIONS
    case $1 in
        # laptop
        1920)
            if [ "$(cat /etc/hostname)" != desktop ] ; then
                # pgrep -f redshift   || redshift &
                pgrep -f xbanish    || xbanish -t 30 &
                sed -i 's/.*Xft.dpi:.*/Xft.dpi: 120/' ~/.Xresources
            fi
            ;;
        # desktop
        3840)
            sed -i 's/.*Xft.dpi:.*/Xft.dpi: 196/' ~/.Xresources
            ;;
    esac
fi

xrdb load ~/.Xresources

case $(hostname) in
    *desktop*)
# --output DP-2 --mode 1920x1080 --pos 1920x0 -r 144 --rotate normal \
        xrandr \
            --output DP-0 --primary --mode 1920x1080 -r 390 --pos 0x0 --rotate normal \
            --output HDMI-0 --off \
            --output DP-1 --off \
            --output DP-3 --off --output DP-4 --off --output DP-5 --off
esac

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ONE SHOT COMMANDS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
background &
{
    dbus-update-activation-environment --all
    gnome-keyring-daemon --start --components=secrets
} &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# DAEMONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# pgrep -f nextcloud  || nextcloud >~/.cache/nextcloud.log 2>&1 &
pgrep -f dunst      || dunst >~/.cache/dunst.log 2>&1 &
pgrep -f parcellite || parcellite &
pgrep -f sxhkd      || sxhkd >~/.cache/sxhkd.log 2>&1 &

pgrep -f xdimmer || xdimmer -p 20 -s 10 -b 1 -t 570 &

pgrep -f wireplumber || nohup gentoo-pipewire-launcher > /dev/null 2>&1 &

#pgrep -f xautolock  || xautolock \
#    -locker 'i3lock-fancy-rapid 10 pixel' \
#    -time ${LOCK_TIME:-10} \
#    -notify 15 \
#    -notifier notify-send >~/.cache/xautolock.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# APPLICATIONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# discord >~/.cache/discord.log 2>&1 &
# spotify >~/.cache/spotify.log 2>&1 &
# mailspring >~/.cache/mailspring.log 2>&1 &
# joplin-desktop-bin >~/.cache/joplin.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# WINDOW MANAGER
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
polybar-msg cmd quit >~/.cache/polybar.log 2>&1
polybar mybar >>~/.cache/polybar.log 2>&1 &
pgrep -f picom || picom -b
exec i3 >~/.cache/i3.log 2>&1
