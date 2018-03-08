#!/bin/dash

xset +fp /home/mitch/usr/fonts
xrdb load /home/mitch/etc/Xresources

xmodmap ${HOME}/etc/Xmodmap
xset m 0 0
xbacklight -set 90

rm ${HOME}/.xinitrc
cd ${HOME}

tasks="xbanish clip bar bash sleep lemonbar compton"
pkill -9 $tasks -- > /dev/null 2>&1

compton --config ${HOME}/etc/config/compton.conf -b -- > /dev/null 2>&1 &

# based on what is set as my wallpaper,
# this could either be a still picture
# or a cinemagraph. Find out what it is,
# and launch with the appropriate program.
feh="feh --bg-fill --no-fehbg ${HOME}/var/tmp/wall --"
mpvbg="mpvbg ${HOME}/var/tmp/wall --"
case "$(file -b -i -L ${HOME}/var/tmp/wall)" in
    "image/png")  $feh & ;;
    "image/jpg")  $feh & ;;
    "image/jpeg") $feh & ;;

    "image/gif")  $feh ; $mpvbg & ;;
    "video/webm") $feh ; $mpvbg & ;;
    "video/mp4")  $feh ; $mpvbg & ;;
    "video/flv")  $feh ; $mpvbg & ;;
    "video/mkv")  $feh ; $mpvbg & ;;
esac > /dev/null

bar > /dev/null 2>&1 &

clip --daemon &

xbanish &

# xautolock -time 10 -secure -locker /usr/local/bin/slock

while true ; do
    dwm
done > /dev/null 2>&1
