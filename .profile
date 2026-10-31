#!/bin/sh

if [ ! -e ~/.hushlogin ] ; then
    touch ~/.hushlogin
fi

# ========================================================================
# PATHS
# ========================================================================
export PATH="$HOME/.local/bin:$PATH:/usr/local/bin:/usr/X11R6/bin:/usr/local/sbin"
export MANPATH="$HOME/.local/share/man:$MANPATH"
export PATH="$PATH:$HOME/.local/flatpak-wrappers"

if [ -d ~/.local/go/bin ] ; then
    export PATH="$PATH:$HOME/.local/go/bin"
fi

if [ -d ~/.cargo/bin ] ; then
    export PATH="$PATH:$HOME/.cargo/bin"
fi

if [ -d ~/.npm/bin ] ; then
    export PATH="$PATH:$HOME/.npm/bin"
fi

if command -v nproc >/dev/null ; then
    export NPROC="$(nproc)"
fi

# for ksh
# if [ -f ~/src/dots/shell/main.shellrc ] ; then
#     export ENV="${HOME}/src/dots/shell/main.shellrc"
# fi

# ========================================================================
# OS specific settings
# ========================================================================
case $(uname) in
    Linux|FreeBSD)
        export CC="${CC:-gcc}" cc="${cc:-gcc}"

        # cause all newly created files to be unreadable by other users
        umask 0077
        ;;
    OpenBSD)
        export CC="${CC:-clang}" cc="${cc:-clang}"
        ;;
    Darwin|MacOS)
        export BASH_SILENCE_DEPRECATION_WARNING=1
        export CC="${CC:-clang}" cc="${cc:-clang}"
esac

# ========================================================================
# DIRECTORIES
# ========================================================================
# export XDG_CONFIG_HOME="${HOME}/.config" \
#        XDG_DOWNLOAD_DIR="${HOME}/Downloads" \
#        XDG_DOCUMENTS_DIR="${HOME}/files" \
#        XDG_PICTURES_DIR="${HOME}/images"
#
# export DOWNLOADS="${XDG_DOWNLOAD_DIR}"
#
# export XDG_DESKTOP_DIR="${HOME}/desktop"
# export XDG_DATA_HOME="${HOME}/.local"
# export XDG_CACHE_HOME="${HOME}/.cache"

# i dont use these but some programs complain
# if they can't write to them
# export XDG_NULL_DIR="/tmp/$USER-tmp/.xdg-$USER-void"
# mkdir -p "$XDG_NULL_DIR"
# export XDG_PUBLICSHARE_DIR="$XDG_NULL_DIR" \
#        XDG_TEMPLATES_DIR="$XDG_NULL_DIR" \
#        XDG_VIDEOS_DIR="$XDG_NULL_DIR" \
#        XDG_MUSIC_DIR="$XDG_NULL_DIR"
#
# hide GOPATH to ~/.local/go instead of ~/go
export GOPATH="${HOME}/.local/go"

# ========================================================================
# MISC SETTINGS
# ========================================================================
# for i in nvim vim vi nvi nano ; do
#     if command -v $i >/dev/null 2>&1 ; then
#         export EDITOR=$i
#         break
#     fi
# done
#
export EDITOR=nvim
export BROWSER=firefox

# for i in librewolf librewolf-bin firefox firefox-bin chromium chromium-bin ; do
#     if command -v $i >/dev/null ; then
#         export BROWSER=$i
#         break
#     fi
# done

#####export MENU_PROG=menu
####export XDG_OPEN=opn PLUMBER=opn

export PAGER=less MANPAGER=less
# opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
export LESS='-QRsim +Gg'
export LESSHISTFILE=/dev/null

# using en_US.UTF-8 over C causes case-insensitive sorting
# "C" is supposed to be fastest text parsing
# up to you whether the benefits outweigh the negatives
#
# NOTE: using "C" can cause bugs in terminal programs
#       that expect certain font features to work
########## export LC_ALL="C"
# export LC_ALL="en_US.UTF-8"
# export LC_CTYPE="$LC_ALL" \
#        LANG="$LC_ALL" \
#        LANGUAGE="$LC_ALL" \
#        LOCALE="$LC_ALL"

# ===================================================
# create tmp dir
# ===================================================
# only proceed if we're not on macos or within wsl
if [ ! -e /etc/wsl.conf ] && [ ! -e /System/Library/CoreServices/SystemVersion.plist ] ; then
    if [ ! -L ~/tmp ] ; then
        mv ~/tmp ~/tmp.bk
        ln -s "/tmp/$USER-tmp/tmp" ~/tmp
    fi

    mkdir -p "/tmp/$USER-tmp/tmp"

    rm -r ~/.w3m 2>/dev/null ||:
    rm ~/.python_history
    rm ~/.wget-hsts

    mkdir -p ~/tmp/.junk/w3m
    ln -s ~/tmp/.junk/w3m ~/.w3m

    touch ~/tmp/.junk/python_history
    ln -s ~/tmp/.junk/python_history ~/.python_history

    touch ~/tmp/.junk/wget-hsts
    ln -s ~/tmp/.junk/wget-hsts ~/.wget-hsts

    rm ~/.bash_history ~/.ksh_history
    ln -s ~/tmp/.junk/bash_history ~/.bash_history
    ln -s ~/tmp/.junk/ksh_history ~/.ksh_history
else
    mkdir -p ~/tmp
fi

# ========================================================================
# FIX PERMISSIONS
# ========================================================================
# chmod -R 0700 ~/tmp

if [ -d ~/.gnupg ] ; then
    chmod 0700 ~/.gnupg
    chmod 0600 ~/.gnupg/* 2>/dev/null ||:
fi

if [ -d ~/.ssh ] ; then
    chmod 0700 ~/.ssh
    chmod 0600 ~/.ssh/id_rsa
    chmod 0644 ~/.ssh/id_rsa.pub
    chmod 0600 ~/.ssh/config
    if [ -f ~/.ssh/authorized_keys ] ; then
        chmod 0600 ~/.ssh/authorized_keys
    fi
    # start ssh-agent
    if ! pgrep -u "$USER" -x ssh-agent >/dev/null ; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
    ssh-add ~/.ssh/id_rsa
fi 2>/dev/null

# ========================================================================
# wayland crap
# ========================================================================
# export MOZ_ENABLE_WAYLAND=1
# export MOZ_USE_XINPUT2=1
# export GTK_THEME=Arc-Dark
# export _JAVA_AWT_WM_NONREPARENTING=1
#
# export PATH=$PATH:${HOME}/.local/bin

# if command -v cliphist >/dev/null ; then
#     mkdir -p ~/tmp/.cliphist
#     chmod -R 0700 ~/tmp/.cliphist
#     ln -sf ~/tmp/.cliphist ~/.cache/cliphist
# fi

# macos fix ; fix later
if command -v brew >/dev/null ; then
    case $0 in
        *bash*)
            source ~/.bashrc
    esac
fi

# basic check if we've been run or not
# see kshrc
export DOT_PROFILE_IMPORTED=1

