#!/bin/sh
umask 022
ulimit -c 0

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ▞▀▖      ▐          ▌ ▌         
# ▚▄ ▌ ▌▞▀▘▜▀ ▞▀▖▛▚▀▖ ▚▗▘▝▀▖▙▀▖▞▀▘
# ▖ ▌▚▄▌▝▀▖▐ ▖▛▀ ▌▐ ▌ ▝▞ ▞▀▌▌  ▝▀▖
# ▝▀ ▗▄▘▀▀  ▀ ▝▀▘▘▝ ▘  ▘ ▝▀▘▘  ▀▀ 
PATH=/bin:/sbin:$PATH
PATH=/usr/bin:/usr/sbin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
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

export PYTHONOPTIMIZE=2 # disable docstrings, debug info

if command -v nproc >/dev/null ; then
    export NPROC=$(nproc)
else
    while read -r line ; do
        case $line in
            *'cpu cores'*)
                export NPROC="${line#*: }"
        esac
    done </proc/cpuinfo
fi

export LC_CTYPE='en_US.UTF-8'
export LANG="$LC_CTYPE" \
    LANGUAGE="$LC_CTYPE" \
    LC_ALL="$LC_CTYPE" \
    LOCALE="$LC_CTYPE"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ▌ ▌▛▀▖▞▀▖ ▌ ▌         
# ▝▞ ▌ ▌▌▄▖ ▚▗▘▝▀▖▙▀▖▞▀▘
# ▞▝▖▌ ▌▌ ▌ ▝▞ ▞▀▌▌  ▝▀▖
# ▘ ▘▀▀ ▝▀   ▘ ▝▀▘▘  ▀▀ 
export XDG_OPEN=opn
export XDG_CURRENT_DESKTOP=Gnome

export XDG_CONFIG_HOME="${HOME}/.config" \
       XDG_DOWNLOAD_DIR="${HOME}/Downloads" \
       XDG_DOCUMENTS_DIR="${HOME}/Documents" \
       XDG_MUSIC_DIR="${HOME}/Music" \
       XDG_PICTURES_DIR="${HOME}/Pictures" \
       XDG_VIDEOS_DIR="${HOME}/Videos"

export XDG_DATA_HOME="${HOME}/.local"
export XDG_CACHE_HOME="${HOME}/.cache"

export XDG_DESKTOP_DIR="${HOME}/Desktop" \
       XDG_PUBLICSHARE_DIR="$XDG_CACHE_HOME/Public" \
       XDG_TEMPLATES_DIR="$XDG_CACHE_HOME/Templates"
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ▙▗▌    ▛▀▖                    ▌ ▌         
# ▌▘▌▌ ▌ ▙▄▘▙▀▖▞▀▖▞▀▌▙▀▖▝▀▖▛▚▀▖ ▚▗▘▝▀▖▙▀▖▞▀▘
# ▌ ▌▚▄▌ ▌  ▌  ▌ ▌▚▄▌▌  ▞▀▌▌▐ ▌ ▝▞ ▞▀▌▌  ▝▀▖
# ▘ ▘▗▄▘ ▘  ▘  ▝▀ ▗▄▘▘  ▝▀▘▘▝ ▘  ▘ ▝▀▘▘  ▀▀ 

export ENV="${XDG_DOCUMENTS_DIR}/src/dots/shell/main.shellrc"

export MENU_PROG=menu \
       TERMINAL_PROG=gnome-terminal \
       PLUMBER=opn \
       SUBS_MENU_PROG="menu -wide -p Subs:" \

export TRASH_DIR="${XDG_DATA_HOME}/Trash" \
       TASKS_FILE="${XDG_DOCUMENTS_DIR}/tasks.txt" \
       SUBS_FILE="${XDG_DOCUMENTS_DIR}/subs.txt" \
       TWITCH_STREAM_FILE="${XDG_DOCUMENTS_DIR}/twitch.txt" \
       RADIO_STATIONS_FILE="${XDG_DOCUMENTS_DIR}/radio.txt" \
       YTDLQ_DIR="${HOME}/.ytdlq"

export YTDL_OPTS='-c -R 50 --geo-bypass --prefer-ffmpeg -o %(title)s.%(ext)s'
export MPV_OPTS="--really-quiet --force-seekable=yes"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ▛▀▖   ▗▀▖      ▜▐   ▛▀▖                      
# ▌ ▌▞▀▖▐  ▝▀▖▌ ▌▐▜▀  ▙▄▘▙▀▖▞▀▖▞▀▌▙▀▖▝▀▖▛▚▀▖▞▀▘
# ▌ ▌▛▀ ▜▀ ▞▀▌▌ ▌▐▐ ▖ ▌  ▌  ▌ ▌▚▄▌▌  ▞▀▌▌▐ ▌▝▀▖
# ▀▀ ▝▀▘▐  ▝▀▘▝▀▘ ▘▀  ▘  ▘  ▝▀ ▗▄▘▘  ▝▀▘▘▝ ▘▀▀ 
if command -v gnvim-launch >/dev/null ; then
    export EDITOR=gnvim-launch
elif command -v gnvim >/dev/null ; then
    export EDITOR='gnvim --disable-ext-tabline'
else
    export EDITOR=nvim
fi

export BROWSER=firefox
export PAGER=less MANPAGER=less
# opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
export LESS='-QRsim +Gg'
export LESSHISTFILE=/dev/null
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ▛▀▖▜       ▞▀▖ ▛▀▘          ▌ ▌          ▞▀▖            
# ▙▄▘▐ ▝▀▖▛▀▖▚▄▌ ▙▄▙▀▖▞▀▖▛▚▀▖ ▌ ▌▞▀▘▞▀▖▙▀▖ ▚▄ ▛▀▖▝▀▖▞▀▖▞▀▖
# ▌  ▐ ▞▀▌▌ ▌▖ ▌ ▌ ▌  ▌ ▌▌▐ ▌ ▌ ▌▝▀▖▛▀ ▌   ▖ ▌▙▄▘▞▀▌▌ ▖▛▀ 
# ▘   ▘▝▀▘▘ ▘▝▀  ▘ ▘  ▝▀ ▘▝ ▘ ▝▀ ▀▀ ▝▀▘▘   ▝▀ ▌  ▝▀▘▝▀ ▝▀▘
if [ -d "${XDG_DOCUMENTS_DIR}/src/plan9" ] ; then
    export PLAN9="${XDG_DOCUMENTS_DIR}/src/plan9"
elif [ -d /usr/lib/plan9 ] ; then
    export PLAN9=/usr/lib/plan9
fi
if [ "$PLAN9" ] ; then
    export PATH="$PATH:$PLAN9/bin"
    export font="$PLAN9/lib/font/terminus/ter-u14v.font"
    export lfont="$PLAN9/lib/font/mntcarlo/mntcarlo.font"
    export tabstop=4
fi
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#    ▐  ▌            ▐     ▗▀▖▗▀▖
# ▞▀▖▜▀ ▛▀▖▞▀▖▙▀▖ ▞▀▘▜▀ ▌ ▌▐  ▐  
# ▌ ▌▐ ▖▌ ▌▛▀ ▌   ▝▀▖▐ ▖▌ ▌▜▀ ▜▀ 
# ▝▀  ▀ ▘ ▘▝▀▘▘   ▀▀  ▀ ▝▀▘▐  ▐  
# empty ~/tmp
rm -rf ~/tmp 2>/dev/null ||:
mkdir -p ~/tmp
