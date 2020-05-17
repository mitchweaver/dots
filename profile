umask 022
ulimit -c 0

# -*-*-*-*-*-*-* system vars *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export ENV=~/.kshrc

PATH=/bin:/sbin:$PATH
PATH=/usr/bin:/usr/sbin:/usr/X11R6/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=$PATH:${HOME}/src/ascii
PATH=$(printf '%s:' ${HOME}/bin/*/):${HOME}/bin:$PATH
PATH=${HOME}/.local/bin:$PATH
export PATH

export MANPATH="${HOME}/.local/share/man:$MANPATH"

# ---- bonsai stuff --------
export BONSAI_ROOT="${HOME}/.bonsai"
export PATH="$BONSAI_ROOT/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BONSAI_ROOT/lib"
export MANPATH="$BONSAI_ROOT/share/man:$MANPATH"
# --------------------------

export CFLAGS='-O2 -pipe -fstack-protector-strong -fexceptions'

export NPROC=$(nproc)

[ "$NPROC" ] ||
while read -r line ; do
    case $line in
        *'cpu cores'*)
			export NPROC="${line#*: }"
    esac
done </proc/cpuinfo

export LC_CTYPE='en_US.UTF-8'
export LANG="$LC_CTYPE" \
       LANGUAGE="$LC_CTYPE" \
       LC_ALL="$LC_CTYPE" \
       LOCALE="$LC_CTYPE"

# -*-*-*-*-*-*-* plan 9 stuff *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
if [ -d ~/src/plan9 ] ; then
    export PLAN9=~/src/plan9
elif [ -d /usr/lib/plan9 ] ; then
    export PLAN9=/usr/lib/plan9
fi
if [ "$PLAN9" ] ; then
    export PATH=$PATH:$PLAN9/bin
    export font=$PLAN9/lib/font/terminus/ter-u14v.font
    export lfont=$PLAN9/lib/font/mntcarlo/mntcarlo.font
    export tabstop=4
fi

# -*-*-*-*-*-*-* my vars *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export XDG_OPEN=opn

export XDG_CONFIG_HOME=~/.config \
       XDG_DOWNLOAD_DIR=~/Downloads \
       XDG_DOCUMENTS_DIR=~/fil \
       XDG_MUSIC_DIR=~/mus \
       XDG_PICTURES_DIR=~/img \
       XDG_VIDEOS_DIR=~/vid \

export XDG_DATA_HOME=~/.local

export XDG_CACHE_HOME=~/.cache

export XDG_DESKTOP_DIR=$XDG_CACHE_HOME \
       XDG_PUBLICSHARE_DIR=$XDG_CACHE_HOME \
       XDG_TEMPLATES_DIR=$XDG_CACHE_HOME \
       XDG_RUNTIME_DIR=$XDG_CACHE_HOME

export TRASH_DIR=${XDG_CACHE_HOME}/trash \
       MENU_PROG=menu \
       PLUMBER=opn \
       TASKS_FILE=~/fil/tasks.txt \
       SUBS_FILE=~/fil/subs.txt \
       SUBS_MENU_PROG="menu -wide -p Subs:" \
       PLUMBER=opn \
       TWITCH_STREAM_FILE=~/fil/twitch.txt \
       RADIO_STATIONS_FILE=~/fil/radio.txt \
       YTDLQ_DIR=~/.ytdlq

export YTDL_OPTS='-c -R 50 --geo-bypass --prefer-ffmpeg -o %(title)s.%(ext)s' \
       MPV_OPTS="--really-quiet --force-seekable=yes"

# --ytdl-raw-options=force-ipv4=

export PASH_CLIP='clip -i' \
       PASH_LENGTH=32 \
       PASH_DIR=~/fil/pash

# -*-*-*-*-*-*-* default programs *-*-*-*-*-*-*-*-*-*-*-*-*-*
export EDITOR=nvim
export BROWSER=brws
export PAGER=less MANPAGER=less
# opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
export LESS='-QRsim +Gg'
export LESSHISTFILE=/dev/null

# -*-*-*-*-*-*-* other stuff *-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*
# empty ~/tmp
rm -rf ~/tmp 2>/dev/null ||:
mkdir -p ~/tmp

# autostart X on login
pgrep X >/dev/null || launchx
