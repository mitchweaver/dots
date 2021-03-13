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
xmodmap ~/.xmodmaprc &
xset +fp ~/.fonts &

# determine if we're on desktop or laptop
# one shitty way to do this is see if we have a wifi card...
case $(interface) in
    wlan?|wlp*) ln -s ~/.Xresources-laptop ~/.Xresources ;;
    eth?|enp*)  ln -s ~/.Xresources-desktop ~/.Xresources
esac

xrdb load ~/.Xresources

# make mouse cursor smallest
# dconf write /org/gnome/desktop/interface/cursor-size 25 &

# disable mouse acceleration
xset m 0 0 &

xrandr --output DisplayPort-0 --primary --auto --rotate normal \
       --output HDMI-A-0 --auto --rotate normal --right-of DisplayPort-0

pulseaudio --check
pulseaudio -D

# for bluetooth headphones
command -v bluetoothctl >/dev/null &&
pactl load-module module-bluetooth-discover

run() {
    cmd=$1
    shift
    if ! pgrep $cmd >/dev/null ; then
        $cmd "$@" &
    fi
}

run vol s 50
run bright s 50
# run ytdlq -d
# run torrent-queue -d
run subs -d
run autorotate -d
# run background
# run sxhkd
# run xbanish
# run crypto-ticker -d

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# x11vnc -viewonly -xkb -nopw -wait 5 \
#     -noxrecord -noxdamage -tightfilexfer \
#     -noxfixes -forever -shared -rfbport 5900 \
#     -display :0 &
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

#if command -v dwm >/dev/null ; then
#    run dunst
#    run bar -d
#    picom -b
#    unset -f run
#    #while command -v dwm ; do dwm && break || continue ; done
#    exec dwm
#fi
