#
# http://github.com/mitchweaver/dots
#

# -*-*-*-*-*-*-* run on exit *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
do_exit() {
    ssh-add -D </dev/null
    eval $(ssh-agent -s -k)

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

    for pid in $_pids ; do
        kill $pid
    done
}
trap do_exit EXIT INT TERM KILL

# -*-*-*-*-*-*-* my vars *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export DOTS=~/etc \
       MENU_PROG=menu \
       MPV_OPTS="--really-quiet --include=$DOTS/mpv.conf" \
       MUPDF_OPTS='-C d9d5ba'

export ENV=$DOTS/kshrc \
       EDITOR=~/bin/wrapper/v \
       BROWSER=~/bin/wrapper/brws \
       PAGER=less \
       MANPAGER=less \
       LESS=-ieR

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

# -*-*-*-*-*-*-* system vars *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
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

export CFLAGS='-O2 -pipe -fstack-protector-strong -fexceptions'
export NPROC=$(sysctl -n hw.ncpu)

export LANG='en_US.UTF-8' \
       LANGUAGE='en_US.UTF-8' \
       LC_ALL='en_US.UTF-8' \
       LOCALE='en_US.UTF-8' \
       LC_CTYPE='en_US.UTF-8'

# -*-*-*-*-*-*-*-* one-off commands *-*-*-*-*-*-*-*-*-*-*-*-*-*
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

# -*-*-*-*-*-*-*-* user daemons *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
_pids=

# compton --config $DOTS/compton.conf       & _pids="$_pids $!"
xidle -area 6 -timeout 300 -sw -program lck & _pids="$_pids $!"
dunst -conf $DOTS/dunstrc                   & _pids="$_pids $!"
slstatus                                    & _pids="$_pids $!"
xbanish                                     & _pids="$_pids $!"
sctd                                        & _pids="$_pids $!"
batmon                                      & _pids="$_pids $!"
clip -d                                     & _pids="$_pids $!"
ytdlq -d                                    & _pids="$_pids $!"

# -*-*-*-*-*-*-*-* start *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

dwm

do_exit
