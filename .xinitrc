#!/bin/sh
# vim:ft=config

export DISPLAY=${DISPLAY:-:0}
export CLUTTER_VBLANK=none
export __GL_SYNC_TO_VBLANK=0

# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# remove titlebar in firefox
export MOZ_GTK_TITLEBAR_DECORATION=client

# enable touch input for firefox
export MOZ_USE_XINPUT2=1

# disable firefox telemetry
export MOZ_DATA_REPORTING=0
export MOZ_TELEMETRY_REPORTING=0
export MOZ_CRASHREPORTER=0
export MOZ_SERVICES_HEALTHREPORT=0
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# monero wallet constant 100% cpu without this
export QMLSCENE_DEVICE=softwarecontext

command -v dimensions >/dev/null &&
export DIMENSIONS="$(dimensions)"

xset b off &
xhost +local: >/dev/null &
xrdb load ~/.Xresources &
xmodmap ~/.xmodmaprc &
xset +fp ~/.fonts &

# make mouse cursor smallest
dconf write /org/gnome/desktop/interface/cursor-size 25 &

# disable mouse acceleration
xset m 0 0 &

xrandr --output DisplayPort-0 --primary --auto --rotate normal \
       --output HDMI-A-0 --auto --rotate normal --right-of DisplayPort-0

pulseaudio --check
pulseaudio -D
vol s 50 &
bright s 50 &
ytdlq -d &
torrent-queue -d &
subs -d &
autorotate -d &
background &
sxhkd &
xbanish &
# clip -d &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# x11vnc -viewonly -xkb -nopw -wait 5 \
#     -noxrecord -noxdamage -tightfilexfer \
#     -noxfixes -forever -shared -rfbport 5900 \
#     -display :0 &
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if command -v dwm >/dev/null ; then
    dunst &
    bar -d &
    picom -b
    while command -v dwm ; do dwm && break || continue ; done
fi
