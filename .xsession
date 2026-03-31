#!/bin/sh
#
# ~/.xsession ----- ran by xenodm(1)
#
# vim:ft=config
# ========================================================================

if [ -e ~/.profile ] ; then
    . ~/.profile
fi

# ========================================================================
# VARIABLES
# ========================================================================

# export DISPLAY=${DISPLAY:-:0}
export _JAVA_AWT_WM_NONREPARENTING=1

# if command -v dimensions >/dev/null ; then
#     export DIMENSIONS="$(dimensions)"
# fi

export XDG_SESSION_TYPE=i3
export XDG_RUNTIME_DIR="/tmp/run/user/$(id -u)"
mkdir -m 700 -p "$XDG_RUNTIME_DIR"

# ========================================================================
# INPUT
# ========================================================================
case $(sysctl -n hw.version) in
    ThinkPad*)
        # enable scrolling with thinkpad trackpoint on OpenBSD
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Axes' 6 7 4 5
esac

# ========================================================================
# allow line-in to be monitored
# ========================================================================
#####pacmd load-module module-loopback latency_msec=5

# ========================================================================
# allow local connections to the xserver (from chroots etc)
# ========================================================================
#####xhost +local: >/dev/null

# ========================================================================
# one-shot commands
# ========================================================================
xrdb load ~/.Xresources
xmodmap ~/.xmodmaprc
xset +fp ~/.fonts
xset +fp ~/nextcloud/opt/fonts
xset m 0 0
xset b off

vol s 50
bright s 80
background

# reset sct to base 6500 before daemon starts
sct 6500

dbus-update-activation-environment --all

# ========================================================================
# daemons
# ========================================================================
# daemon_launch() {
#     cmd=$1
#     shift
#     if command -v $cmd >/dev/null && ! pgrep -f $cmd >/dev/null ; then
#         printf 'Starting: %s\n' $cmd
#         $cmd "$@" &
#     fi
# }

# daemon_launch dbus-launch dunst
# daemon_launch xbanish -s
# daemon_launch xdimmer -p 20 -s 10 -b 1 -t 570
# daemon_launch picom -b

##### daemon_launch sctd

######### daemon_launch xautolock -locker slock -time 30 -notify 15 -notifier notify-send

# daemon_launch sxhkd
# daemon_launch mmbar -d

# unset -f daemon_launch

# ========================================================================
# start
# ========================================================================

######exec dbus-launch --exit-with-session --sh-syntax cwm
# exec dbus-launch --exit-with-session --sh-syntax i3 >~/.cache/i3-log.log 2>&1

# export XDG_SESSION_TYPE=wayland
# export XDG_SESSION_DESKTOP=sway
# export XDG_CURRENT_DESKTOP=sway
# export WLR_DRM_NO_ATOMIC=1
# mkdir -p ~/.cache

