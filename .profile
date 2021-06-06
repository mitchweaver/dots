#!/bin/sh

umask 022

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
PATH=/bin:/sbin:$PATH
PATH=/usr/bin:/usr/sbin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
for dir in \
    application daemon devel ffmpeg \
    media misc net non-shell rice \
    security utility wrapper
do
    if [ -d ~/bin/$dir ] ; then
        export PATH=${HOME}/bin/$dir:$PATH
    fi
done

if [ "$(uname)" = OpenBSD ] ; then
    export PATH=${HOME}/bin/openbsd:$PATH
fi
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

PATH=${HOME}/.local/bin:$PATH
export PATH

export MANPATH="${HOME}/.local/share/man:$MANPATH"
export FONTCONFIG_PATH=/etc/fonts

export PYTHONOPTIMIZE=2

export CFLAGS='-pipe -fstack-protector-strong -fexceptions'
case $(uname) in
    OpenBSD)
        export CC=clang cc=clang
        ;;
    Linux)
        export CC=gcc cc=gcc
esac

# using en_US.UTF-8 over C causes case-insensitive sorting
# up to you whether the benefits outweigh the negatives
export LC_ALL="en_US.UTF-8"
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

export XDG_DESKTOP_DIR="${HOME}/Desktop"
export XDG_DATA_HOME="${HOME}/.local"
export XDG_CACHE_HOME="${HOME}/.cache"

export XDG_PUBLICSHARE_DIR="$XDG_CACHE_HOME/Public" \
       XDG_TEMPLATES_DIR="$XDG_CACHE_HOME/Templates"
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

export ENV="${HOME}/src/dots/shell/main.shellrc"

export MENU_PROG=menu \
       TERMINAL_PROG=stwrapper \
       PLUMBER=opn \
       SUBS_MENU_PROG="menu -wide -p Subs:" \
       SUBS_DAEMON_INTERVAL=1800 \
       MAILD_ACCOUNT=wvr \
       CRYPTO_TICKER_INTERVAL=60 \
       STOCK_TICKER_INTERVAL=60

export TRASH_DIR="${XDG_DATA_HOME}/Trash" \
       TASKS_FILE="${XDG_DOCUMENTS_DIR}/tasks.txt" \
       SUBS_FILE="${XDG_DOCUMENTS_DIR}/subs.txt" \
       TWITCH_STREAM_FILE="${XDG_DOCUMENTS_DIR}/twitch.txt" \
       YTDLQ_DIR="${HOME}/.ytdlq"

export YTDL_OPTS='-c -R 50 --geo-bypass --prefer-ffmpeg -o %(title)s.%(ext)s'

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# hide GOPATH to ~/.go instead of ~/go
export GOPATH=${HOME}/.go

# try to catch either 11 or 8 openjdk version
# note: this path is for OpenBSD
case $(uname) in
    OpenBSD)
    for i in 11 8 ; do
        if [ -d /usr/local/jdk-$i ] ; then
            export JAVA_HOME=/usr/local/jdk-$i
            export PATH=$PATH:$JAVA_HOME/bin
            break
        fi
    done
esac

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
for editor in nvim vim vi ; do
    if command -v $editor >/dev/null ; then
        export EDITOR=$editor
        break
    fi
done
if command -v brws >/dev/null ; then
    export BROWSER=brws
else
    export BROWSER=firefox
fi
export PAGER=less MANPAGER=less
# opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
export LESS='-QRsim +Gg'
export LESSHISTFILE=/dev/null
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# Permissions
chmod 0755 ~
if [ -d ~/.gnupg ] ; then
    chmod 0700 ~/.gnupg
    chmod 0600 ~/.gnupg/*
fi
if [ -d ~/.ssh ] ; then
    chmod 0700 ~/.ssh
    chmod 0600 ~/.ssh/id_rsa
    chmod 0644 ~/.ssh/id_rsa.pub
    chmod 0600 ~/.ssh/config
    if [ -f ~/.ssh/authorized_keys ] ; then
        chmod 0600 ~/.ssh/authorized_keys
    fi
fi
if [ -f ~/.config/neomutt/password ] ; then
    chmod 0400 ~/.config/neomutt/password
fi

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
mkdir -p "/tmp/$USER"
if [ -d ~/tmp ] ; then
    rm -rf ~/tmp
fi
if [ "$(readlink ~/tmp)" != "/tmp/$USER" ] ; then
    ln -sf "/tmp/$USER" ~/tmp
fi
# mkdir -p ~/tmp/.cache
# if [ "$(readlink ~/.cache)" != ~/tmp/.cache ] ; then
#     if [ -d ~/.cache ] ; then
#         rm -r ~/.cache
#     fi
#     ln -sf ~/tmp/.cache ~/.cache
# fi
