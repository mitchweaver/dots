#!/bin/sh
# vim:ft=config

export DISPLAY=:0
export CLUTTER_VBLANK=none

# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

# remove titlebar in firefox
export MOZ_GTK_TITLEBAR_DECORATION=client

# enable touch input for firefox
export MOZ_USE_XINPUT2=1

# disable firefox telemetry
export MOZ_DATA_REPORTING=0
export MOZ_TELEMETRY_REPORTING=0
export MOZ_CRASHREPORTER=0
export MOZ_SERVICES_HEALTHREPORT=0

# monero wallet constant 100% cpu without this
export QMLSCENE_DEVICE=softwarecontext

export DIMENSIONS="$(dimensions)"

xset b off &
xhost +local: >/dev/null &
xrdb load ~/.Xresources &
xmodmap ~/.xmodmaprc &
xset +fp ~/.fonts &

# make mouse cursor smallest
dconf write /org/gnome/desktop/interface/cursor-size 25

# disable mouse acceleration
xset m 0 0

# --output DisplayPort-0 --off --output DisplayPort-1 --off \
#--mode 1920x1080
# --mode 1920x1080 

xrandr --output DisplayPort-2 --primary --auto --rotate normal \
       --output HDMI-A-0 --auto --rotate normal --left-of DisplayPort-2

pulseaudio --check
pulseaudio -D
gnome-keyring-daemon &
vol s 50 &
bright s 50 &
ytdlq -d &
torrent-queue -d &
autorotate -d &
background &
sxhkd &
dunst &
# clip -d &
picom -b

if command -v dwm >/dev/null ; then
    bar -d &
    while command -v dwm ; do dwm && break || continue ; done
fi
