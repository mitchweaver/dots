# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

xrdb load ~/src/dots/Xresources &
xmodmap ~/src/dots/xmodmaprc &
xset m 0 0 &
xset b off &
xhost +local: >/dev/null &
xbacklight -set 100 &

# find ~/fil/fonts -type d |
# find ~/.bonsai/share/fonts -type d |
# while read -r dir ; do
#     xset +fp "$dir" 2>/dev/null
# done

background &
vol s 40 &
bright s 60 &
xsct 6000 &
echo 6000 > ~/.cache/sct

export DIMENSIONS="$(dimensions)"

run() { type $1 >/dev/null && ! pgrep -f $1 >/dev/null && $* & }

run dunst
# run xbanish -i shift -i control -i mod1 -i mod4
run picom --config ~/src/dots/picom.conf
run xidle -area 6 -timeout 420 -sw -program slock
run sxhkd -c ~/src/dots/sxhkdrc
# run plank

run bar -d
run clip -d
run ytdlq -d
run torrent-queue -d
run autorotate

unset -f run

# if dwm exits 0, restart -- this allows hot reloading of config.h
# while type dwm >/dev/null ; do dwm && continue || break ; done
exec dwm

# vim:ft=config
