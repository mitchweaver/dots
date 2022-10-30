#!/bin/sh

umask 022

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
PATH=/bin:/sbin:$PATH
PATH=/usr/bin:/usr/sbin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=${HOME}/.local/bin:$PATH
LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH
export PATH
export LD_LIBRARY_PATH

export MANPATH="${HOME}/.local/share/man:$MANPATH"
export FONTCONFIG_PATH="/etc/fonts:${HOME}/.fonts"

if [ -d ~/.bonsai ] ; then
    export MANPATH="${HOME}/.bonsai/share/man:$MANPATH"
    export PATH="${HOME}/.bonsai/bin:$PATH"
fi

if [ -e ~/.bonsai/bin/oksh ] ; then
    export SHELL="${HOME}/.bonsai/bin/oksh"
fi

export NPROC="${NPROC:-$(nproc 2>/dev/null)}"
export NPROC="${NPROC:-1}"
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

case $(uname) in
    OpenBSD|Darwin)
        export CC="${CC:-clang}" cc="${cc:-clang}"
        ;;
    Linux|FreeBSD)
        export CC="${CC:-gcc}" cc="${cc:-gcc}"
esac

# using en_US.UTF-8 over C causes case-insensitive sorting
# up to you whether the benefits outweigh the negatives
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="$LC_ALL" \
       LANG="$LC_ALL" \
       LANGUAGE="$LC_ALL" \
       LOCALE="$LC_ALL"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export XDG_OPEN=opn PLUMBER=opn

export XDG_CONFIG_HOME="${HOME}/.config" \
       XDG_DOWNLOAD_DIR="${HOME}/downloads" \
       XDG_DOCUMENTS_DIR="${HOME}/files" \
       XDG_PICTURES_DIR="${HOME}/images"

export XDG_DESKTOP_DIR="${HOME}/Desktop"
export XDG_DATA_HOME="${HOME}/.local"
export XDG_CACHE_HOME="${HOME}/.cache"

# i dont use these but some programs complain
# if they can't write to them
export XDG_PUBLICSHARE_DIR="$XDG_CACHE_HOME/null" \
       XDG_TEMPLATES_DIR="$XDG_CACHE_HOME/null" \
       XDG_VIDEOS_DIR="$XDG_CACHE_HOME/null" \
       XDG_MUSIC_DIR="$XDG_CACHE_HOME/null"
mkdir -p "$XDG_CACHE_HOME/null"
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

export ENV="${HOME}/src/dots/shell/main.shellrc"
export MENU_PROG=menu
export YTDL_OPTS='-c -R 50 --geo-bypass --prefer-ffmpeg -o %(title)s.%(ext)s'

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# hide GOPATH to ~/.local/go instead of ~/go
export GOPATH=${HOME}/.local/go

# try to catch either 11 or 8 openjdk version
for i in 11 8 ; do
    if [ -d /usr/local/jdk-$i ] ; then
        export JAVA_HOME=/usr/local/jdk-$i
        export PATH=$PATH:$JAVA_HOME/bin
        break
    fi
done

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
if command -v nvim >/dev/null 2>&1 ; then
	export EDITOR=nvim
elif command -v vim >/dev/null 2>&1 ; then
	export EDITOR=vim
fi

if command -v brws >/dev/null 2>&1 ; then
    export BROWSER=brws
elif command -v firefox >/dev/null 2>&1 ; then
	export BROWSER=firefox
elif command -v firefox-bin >/dev/null 2>&1 ; then
	export BROWSER=firefox-bin
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
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

rm -f ~/tmp
mkdir -p "/tmp/tmp-$USER"
chmod -R 777 "/tmp/tmp-$USER"
ln -s "/tmp/tmp-$USER" ~/tmp
