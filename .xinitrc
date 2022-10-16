#!/bin/sh

# source environment variables
# shellcheck disable=1090,1039
[ -f ~/.profile ] && . ~/.profile

export DISPLAY="${DISPLAY:-:0}"

xrdb load ~/.Xresources
xmodmap ~/.xmodmaprc
xset +fp ~/.fonts
xset m 0 0
xset b off

#    run xdimmer -p 20 -s 10 -b 1 -t 570
#    run xautolock -locker slock -time 30 -notify 15 -notifier notify-send

# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

picom -b

exec i3 > "$XDG_CACHE_HOME"/i3.log 2>&1
