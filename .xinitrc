#!/bin/sh
# vim:ft=config

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

###/opt/piavpn/bin/pia-client -quiet &
###/opt/Signal/signal-desktop --start-in-tray &

xset m 0 0 &
xset b off &
xhost +local: >/dev/null &
xrdb load ~/.Xresources &
xmodmap ~/.xmodmaprc &
xset +fp ~/.fonts &

vol s 40 &
bright s 60 &
ytdlq -d &
torrent-queue -d &
autorotate -d &
clip -d &

# paped -l ~/Pictures/wallpapers &
background &

sxhkd &
xbanish -i shift -i control -i mod1 -i mod4 &
dunst &
picom -b
#xidle -area 6 -timeout 420 -sw -program slock &

while command -v dwm ; do dwm && break || continue ; done
