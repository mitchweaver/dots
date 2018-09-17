cd ${HOME}

{
    xset +fp /home/mitch/usr/fonts
    xrdb load /home/mitch/etc/Xresources
    xmodmap ${HOME}/etc/Xmodmap
    xset m 0 0
    xset b off
    xbacklight -set 90
} &

for i in bar sleep ; do
    pkill -9 $i
done > /dev/null 2>&1

case "$(basename $(file -b -i -L ${HOME}/var/tmp/wall))" in
    *png*|*jpg*|*jpeg*) feh --bg-fill --no-fehbg ${HOME}/var/tmp/wall ;;
    *gif*|*webm*|*mp4*|*mkv*) mpvbg ${HOME}/var/tmp/wall
esac > /dev/null 2>&1 &

! pgrep -f clip > /dev/null &&
    clip --daemon &

#! pgrep -f xbanish > /dev/null &&
#    xbanish &

sxhkd &

compton &

bar > /dev/null 2>&1 &

#! pgrep -f torrent-queue > /dev/null &&
#    torrent-queue > /dev/null &

#! pgrep -f ytdl-queue > /dev/null &&
#    ytdl-queue > /dev/null &

# if dwm crashes, relaunch
# if I exit dwm, close
while true ; do
    dwm && break || continue
done > /dev/null 2> /tmp/dwm_err.log
