#!/bin/sh

# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

export DIMENSIONS="$(dimensions)"

# remove titlebar in firefox
export MOZ_GTK_TITLEBAR_DECORATION=client

# enable touch input for firefox
export MOZ_USE_XINPUT2=1

###bright s 60 &
background &
vol s 40 &
ytdlq -d &
torrent-queue -d &

# --- so, so buggy... have to let gnome handle these
###/opt/piavpn/bin/pia-client -quiet &
###/opt/Signal/signal-desktop --start-in-tray &
###discord --start-minimized &

# annoying, have to wait for gnome to start it
{ sleep 3 ; pkill nm-applet ; } &

# have to wait for gnome to settle,
# otherwise these dont take effect
{
    sleep 3
    xset m 0 0 &
    xset b off &
    xhost +local: >/dev/null
    xrdb load ~/.Xresources
    xmodmap ~/.xmodmaprc
} &

# vim:ft=config
