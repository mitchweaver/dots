#
# http://github.com/mitchweaver/dots
#

cleanup() {
    rm -rf ~/tmp
    mkdir  ~/tmp

    rm -f ~/.Xauthority \
          ~/.Xauthority-n \
          ~/.xsession-errors \
          ~/.xsel.log \
          ~/.cache/clip.log

    rm -rf ~/.dbus \
           ~/.pki \
           ~/.cache/fontconfig \
           ~/.local
}
trap cleanup EXIT SIGINT SIGTERM

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# my vars
export DOTS=~/etc
export MENU_PROG=menu
export MPV_OPTS="--really-quiet --include=$DOTS/mpv.conf"
export MUPDF_OPTS='-C d9d5ba'
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

PATH=/bin:/sbin:$PATH
PATH=/usr/bin:/usr/sbin:/usr/X11R6/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=${HOME}/bin:${HOME}/usr/bin:$PATH
PATH=$PATH:$(printf '%s:' ${HOME}/bin/*/)
PATH=$PATH:${HOME}/src/ascii
export PATH

MANPATH=/usr/share/man:/usr/local/share/man:/usr/local/man:$MANPATH
MANPATH=~/usr/share/man:$MANPATH
export MANPATH

export ENV=$DOTS/kshrc
export EDITOR=v
export BROWSER=chrome
export PAGER=less MANPAGER=less
export LESS=-ieR

export CFLAGS='-O2 -pipe -fstack-protector-strong -fexceptions'
export NPROC=$(sysctl -n hw.ncpu)

export LANG='en_US.UTF-8' \
       LANGUAGE='en_US.UTF-8' \
       LC_ALL='en_US.UTF-8' \
       LOCALE='en_US.UTF-8' \
       LC_CTYPE='en_US.UTF-8'

export XDG_CONFIG_HOME=$DOTS/config \
       XDG_DOWNLOAD_DIR=~/Downloads \
       XDG_DOCUMENTS_DIR=~/usr/files \
       XDG_MUSIC_DIR=~/usr/music \
       XDG_PICTURES_DIR=~/usr/images \
       XDG_VIDEOS_DIR=~/usr/videos \
       XDG_CACHE_HOME=~/.cache \
       XDG_DATA_HOME=~/.cache \
       XDG_DESKTOP_DIR=~/.cache \
       XDG_PUBLICSHARE_DIR=~/.cache \
       XDG_TEMPLATES_DIR=~/.cache

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

umask 022
ulimit -c 0

case $(sysctl -n hw.version) in
    'ThinkPad X200s')
        # enable scrolling with thinkpad trackpoint (openbsd)
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1 &
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2 &
        xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Axes' 6 7 4 5 &
esac

xrdb load $DOTS/Xdefaults
xmodmap $DOTS/Xmodmap &
xset m 0 0 &
xset b off &
xhost +local: >/dev/null &

background &
xbacklight -set 100 &
vol -s 50 &

pgrep xidle    >/dev/null || xidle -timeout 300 -ne -program ~/bin/lck &
# pgrep compton  >/dev/null || compton --config $DOTS/compton.conf &
pgrep dunst    >/dev/null || dunst -conf $DOTS/dunstrc &
pgrep slstatus >/dev/null || slstatus &
pgrep xbanish  >/dev/null || xbanish  &
pgrep sctd     >/dev/null || sctd     &
pgrep batmon   >/dev/null || batmon   &
pgrep clip     >/dev/null || clip -d  &
pgrep ytdlq    >/dev/null || ytdlq -d &

dwm

exit
