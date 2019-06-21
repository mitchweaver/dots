cd ${HOME}

# if desktop
# xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DVI-I-1 --mode 1360x768 --pos 1920x0 --rotate normal --output DP-1 --off

{ 
    xbacklight -set 100
    ${HOME}/bin/vol -dec 100
    xset +fp /home/mitch/usr/fonts
    xrdb load /home/mitch/etc/Xresources
    xmodmap ${HOME}/etc/Xmodmap
    xset m 0 0
    xset b off
} &

case "$(basename $(file -b -i -L ${HOME}/var/tmp/wall))" in
    *png*|*jpg*|*jpeg*) feh --bg-fill --no-fehbg ${HOME}/var/tmp/wall ;;
    *gif*|*webm*|*mp4*|*mkv*) ${HOME}/bin/mpvbg ${HOME}/var/tmp/wall
esac > /dev/null 2>&1 &

for i in bar sleep clip xbanish batmon ; do
    pkill -9 $i
done > /dev/null 2>&1

! pgrep -f clip > /dev/null &&
    clip --daemon &

! pgrep -f xbanish > /dev/null &&
    xbanish &

! pgrep -f batmon > /dev/null &&
    batmon &

! pgrep -f pulseaudio > /dev/null &&
    pulseaudio --start --exit-idle-time=-1 &

if [ $(cat /tmp/dwm_info/gappx) -gt 0 ] ; then
    compton &
fi

${HOME}/bin/bar > /dev/null 2>&1 &

#! pgrep -f torrent-queue > /dev/null &&
#    torrent-queue > /dev/null &

#! pgrep -f ytdl-queue > /dev/null &&
#    ytdl-queue > /dev/null &

# if dwm crashes, relaunch -- handy to force-restart after re-compile via pkill
# if I exit dwm, close
while true ; do
    dwm && break || continue
done > /dev/null 2> /tmp/dwm_err.log
