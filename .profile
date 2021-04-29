#!/bin/sh
umask 022
ulimit -c 0

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
PATH=/bin:/sbin:$PATH
PATH=/usr/bin:/usr/sbin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=$(printf '%s:' ${HOME}/bin/*/):${HOME}/bin:$PATH
PATH=${HOME}/.local/bin:$PATH
export PATH

export MANPATH="${HOME}/.local/share/man:$MANPATH"
export FONTCONFIG_PATH=/etc/fonts

export CFLAGS='-O2 -pipe -fstack-protector-strong -fexceptions'
export PYTHONOPTIMIZE=2

# using en_US.UTF-8 over C causes case-insensitive sorting
# up to you whether the benefits outweigh the negatives
export LC_ALL="C"
export LC_CTYPE="$LC_ALL" \
       LANG="$LC_ALL" \
       LANGUAGE="$LC_ALL" \
       LOCALE="$LC_ALL"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export XDG_OPEN=opn

export XDG_CONFIG_HOME="${HOME}/.config" \
       XDG_DOWNLOAD_DIR="${HOME}/Downloads" \
       XDG_DOCUMENTS_DIR="${HOME}/files" \
       XDG_MUSIC_DIR="${HOME}/music" \
       XDG_PICTURES_DIR="${HOME}/images" \
       XDG_VIDEOS_DIR="${HOME}/videos"

# export XDG_DESKTOP_DIR="${HOME}/Desktop"

export XDG_DATA_HOME="${HOME}/.local"
export XDG_CACHE_HOME="${HOME}/.cache"

export XDG_PUBLICSHARE_DIR="$XDG_CACHE_HOME/Public" \
       XDG_TEMPLATES_DIR="$XDG_CACHE_HOME/Templates"
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

export ENV="${HOME}/src/dots/shell/main.shellrc"
export LOCAL="${HOME}/.local"

export MENU_PROG=menu \
       TERMINAL_PROG=st \
       PLUMBER=opn \
       SUBS_MENU_PROG="menu -wide -p Subs:" \
       SUBS_DAEMON_INTERVAL=3600 \
       CRYPTO_TICKER_INTERVAL=30

export TRASH_DIR="${XDG_DATA_HOME}/Trash" \
       TASKS_FILE="${XDG_DOCUMENTS_DIR}/tasks.txt" \
       SUBS_FILE="${XDG_DOCUMENTS_DIR}/subs.txt" \
       TWITCH_STREAM_FILE="${XDG_DOCUMENTS_DIR}/twitch.txt" \
       YTDLQ_DIR="${HOME}/.ytdlq"

export YTDL_OPTS='-c -R 50 --geo-bypass --prefer-ffmpeg -o %(title)s.%(ext)s'
export MPV_OPTS="--really-quiet --force-seekable=yes"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
for editor in nvim vim vi ; do
    if command -v $editor >/dev/null ; then
        export EDITOR=$editor
        break
    fi
done
export BROWSER=firefox
export PAGER=less MANPAGER=less
# opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
export LESS='-QRsim +Gg'
export LESSHISTFILE=/dev/null
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

mkdir -p "/tmp/$USER"
ln -sf "/tmp/$USER" ~/tmp
# not sure how to stop these from being created, fix later
rm ~/tmp/"$USER" 2>/dev/null
