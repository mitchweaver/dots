#!/bin/sh
#
# ~/.xsession ----- ran by xenodm(1)
#
# vim:ft=config
# ========================================================================

if [ -f ~/src/dots/shell/main.shellrc ] ; then
    export ENV="${HOME}/src/dots/shell/main.shellrc"
    . ~/src/dots/shell/main.shellrc
fi

export DISPLAY=${DISPLAY:-:0}
export _JAVA_AWT_WM_NONREPARENTING=1

export XDG_RUNTIME_DIR="/tmp/run/$(id -u)"
mkdir -m 700 -p "$XDG_RUNTIME_DIR"

if command -v dimensions >/dev/null ; then
    export DIMENSIONS="$(dimensions)"
fi

case $(sysctl -n hw.version) in
    ThinkPad*)
        # enable scrolling with thinkpad trackpoint on OpenBSD
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Axes' 6 7 4 5
esac

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
##### allow line-in to be monitored
# pacmd load-module module-loopback latency_msec=5
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# ========================================================================
# allow local connections to the xserver (from chroots etc)
############xhost +local: >/dev/null
# ========================================================================

# ========================================================================
# one-shot commands
# ========================================================================
xrdb load ~/.Xresources
xmodmap ~/.xmodmaprc
xset +fp ~/.fonts
xset m 0 0
xset b off

vol s 50
bright s 80
background
########### sctc s 6000

# ========================================================================
# daemons
# ========================================================================
# daemon_launch() {
    # cmd=$1
    # shift
    # if command -v $cmd >/dev/null && ! pgrep -f $cmd >/dev/null ; then
    #     printf 'Starting: %s\n' $cmd
    #     $cmd "$@" &
    # fi
# }

# daemon_launch sxhkd
# daemon_launch mmbar -d
# daemon_launch picom -b
# daemon_launch xdimmer -p 20 -s 10 -b 1 -t 570
# daemon_launch xautolock -locker slock -time 30 -notify 15 -notifier notify-send

# unset -f daemon_launch

# ========================================================================
# start
# ========================================================================
if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-x11)
fi

export XDG_SESSION_TYPE=plasma
/usr/local/bin/ck-launch-session /usr/local/bin/startplasma-x11 >~/kde.log 2>&1

