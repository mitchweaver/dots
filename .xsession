#!/bin/sh
# vim:ft=config

# source environment variables
[ -f ~/.profile ] && . ~/.profile

# source shellrc
[ -f ${ENV:-~/.kshrc} ] && . ${ENV:-~/.kshrc}

export DISPLAY=${DISPLAY:-:0}

# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

if command -v dimensions >/dev/null ; then
    export DIMENSIONS="$(dimensions)"
fi

case $(uname) in
    OpenBSD)
        case $(sysctl -n hw.version) in
            ThinkPad*)
                # enable scrolling with thinkpad trackpoint on OpenBSD
                xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1 &
                xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2 &
                xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Axes' 6 7 4 5 &
        esac
esac

# one-shot commands
{
    xhost +local: >/dev/null
    xrdb load ~/.Xresources
    xmodmap ~/.xmodmaprc
    xset +fp ~/.fonts
    xset m 0 0
    xset b off
    sctc s 6000
    vol s 50
    bright s 80
} &

# daemon commands
run() {
    cmd=$1
    shift
    if command -v $cmd >/dev/null && ! pgrep -f $cmd >/dev/null ; then
        printf 'Starting: %s\n' $cmd
        $cmd "$@" &
    fi
}

# run syncthing -no-browser
run sxhkd
# run xbanish
run ytdlq -d
run torrent-queue -d
run maild -d

case $(uname) in
    OpenBSD)
        case $(apm -m 2>/dev/null) in
            0|1|2|3)
                run batmon
        esac
esac

# run weatherd -d
# run crypto-ticker -d
# run stock-ticker -d
# run subs -d

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if pgrep xfce >/dev/null ; then
    volumeicon &
fi

if command -v dwm >/dev/null ; then
    background &
    run mmbar -d
    # run picom -b
    run xdimmer -p 20 -s 10 -b 1 -t 570
    run xautolock -locker slock -time 30 -notify 15 -notifier notify-send
    unset -f run
    exec dwm
fi
