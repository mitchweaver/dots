# we are logging in with xenodm, which 
# will not load our profile automatically
[ -f ~/.profile ] && . ~/.profile

do_exit() {
    ssh-add -D </dev/null
    eval $(ssh-agent -s -k)

    rm -f ~/.Xauthority \
        ~/.Xauthority-n \
        ~/.xsession-errors \
        ~/.xsel.log \
        ~/.cache/clip.log \
        ~/.cache/.shell_history*

    rm -rf ~/.dbus \
        ~/.pki \
        ~/.cache/fontconfig

    # kill daemons, asking nicely first
    for pid in $_pids ; do kill $pid ; done
    sleep 1
    for pid in $_pids ; do kill -0 $pid && kill -9 $pid ; done 2>/dev/null
}
trap do_exit EXIT INT TERM KILL

case $(sysctl -n hw.version) in
    'ThinkPad X200s')
        # enable scrolling with thinkpad trackpoint (openbsd)
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1 &
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2 &
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Axes' 6 7 4 5 &
esac

xrdb load ~/.Xdefaults
xmodmap ~/.xmodmaprc &
xset m 0 0 &
xset b off &
xhost +local: >/dev/null &

background &
xbacklight -set 100 &
vol -s 50 &

# -*-*-*-*-*-*-*-* user daemons *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
_pids=

# pgrep -f compton  >/dev/null || compton     & _pids="$_pids $!"
pgrep -f dunst    >/dev/null || dunst       & _pids="$_pids $!"
pgrep -f bar      >/dev/null || bar         & _pids="$_pids $!"
pgrep -f xbanish  >/dev/null || xbanish     & _pids="$_pids $!"
pgrep -f sctd     >/dev/null || sctd        & _pids="$_pids $!"
pgrep -f batmon   >/dev/null || batmon      & _pids="$_pids $!"
pgrep -f clip     >/dev/null || clip -d     & _pids="$_pids $!"
pgrep -f ytdlq    >/dev/null || ytdlq -d    & _pids="$_pids $!"
pgrep -f xidle    >/dev/null || xidle -area 6 -timeout 300 -sw \
         -program "${HOME}/bin/wrapper/lck" & _pids="$_pids $!"

# -*-*-*-*-*-*-*-* start *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# if dwm exits 0, restart -- this allows hot reloading of config.h
while type dwm >/dev/null ; do dwm && continue || break ; done

do_exit
