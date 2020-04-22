xrdb load ~/src/dots/Xresources &
xmodmap ~/src/dots/xmodmaprc &
xset m 0 0 &
xset b off &
xhost +local: >/dev/null &
xbacklight -set 100 &

find ~/fil/fonts -type d |
while read -r dir ; do
    xset +fp "$dir" 2>/dev/null
done

background &
vol -s 60 &
xsct 6000 &
echo 6000 >~/.cache/sct

export DIMENSIONS="$(dimensions)"

run() { type $1 >/dev/null && ! pgrep -f $1 >/dev/null && $* & }

run dunst
# run xbanish
run bar -d
run clip -d
run ytdlq -d
picom --config ~/src/dots/picom.conf -b

bright -s 50

#pgrep -f xidle    >/dev/null || xidle -area 6 -timeout 420 -sw \
#    -program "${HOME}/bin/wrapper/lck" & _pids="$_pids $!"

# if dwm exits 0, restart -- this allows hot reloading of config.h
while type dwm >/dev/null ; do dwm && continue || break ; done

# vim:ft=config
