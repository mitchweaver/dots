#!/bin/sh
# vim:ft=config

# source environment variables
[ -f ~/.profile ] && . ~/.profile

# source shellrc
[ -f ${ENV:-~/.kshrc} ] && . ${ENV:-~/.kshrc}

export DISPLAY=${DISPLAY:-:0}

# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# remove titlebar in firefox
export MOZ_GTK_TITLEBAR_DECORATION=client
# disable firefox telemetry
export MOZ_DATA_REPORTING=0
export MOZ_TELEMETRY_REPORTING=0
export MOZ_CRASHREPORTER=0
export MOZ_SERVICES_HEALTHREPORT=0
# greatly increases page rendering speed on openbsd
export MOZ_ACCELERATED=1
export MOZ_WEBRENDER=1
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if command -v dimensions >/dev/null ; then
    export DIMENSIONS="$(dimensions)"
fi

xhost +local: >/dev/null
xrdb load ~/.Xresources

xmodmap ~/.xmodmaprc
xset +fp ~/.fonts
xset m 0 0
xset b off

#xrandr --output DisplayPort-0 --primary --auto --rotate normal \
#       --output HDMI-A-0 --auto --rotate normal --right-of DisplayPort-0

run() {
    cmd=$1
    shift
    if command -v $cmd >/dev/null && ! pgrep -f $cmd >/dev/null ; then
        $cmd "$@" &
    fi
}

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# run x11vnc -viewonly -xkb -nopw -wait 5 \
#     -noxrecord -noxdamage -tightfilexfer \
#     -noxfixes -forever -shared -rfbport 5900 \
#     -display :0 &
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

case $(uname) in
    OpenBSD)
        case $(sysctl -n hw.version) in
            *ThinkPad*)
                # enable scrolling with thinkpad trackpoint on OpenBSD
                xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1 &
                xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2 &
                xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Axes' 6 7 4 5 &
        esac
esac

run vol s 50
run bright s 100
run ytdlq -d
run background
run sxhkd
run xbanish
run crypto-ticker -d
run torrent-queue -d
run sctc 6500
run batmon
# run subs -d

if command -v dwm >/dev/null ; then
    run bar -d
    run picom -b
    run dunst
    run xdimmer -p 20 -s 10 -b 1 -t 570
    run xautolock -locker slock -time 10 -notify 15 -notifier $(command -v dunst)
    unset -f run
    exec dwm
fi
