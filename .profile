#!/bin/sh

# ========================================================================
# PATHS
# ========================================================================
export PATH="$HOME/.local/bin:$PATH:/usr/local/bin:/usr/local/sbin"
export MANPATH="$HOME/.local/share/man:$MANPATH"

if [ -d /usr/X11R6/bin ] ; then
    export PATH="$PATH:/usr/X11R6/bin"
fi

# hide GOPATH to ~/.local/go instead of ~/go
export GOPATH="${HOME}/.local/go"

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

if [ -f "$HOME/src/dots/shell/main.shellrc" ] ; then
    export ENV="$HOME/src/dots/shell/main.shellrc"
fi

# ========================================================================
# OS specific settings
# ========================================================================
case $(uname) in
    Linux|FreeBSD)
        export CC="${CC:-gcc}" cc="${cc:-gcc}"

        if [ -e /etc/THIS_IS_MY_MACHINE ] ; then
            # cause all newly created files to be unreadable by other users
            umask 0077
        fi
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
if [ -e /etc/THIS_IS_MY_MACHINE ] ; then
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DOWNLOAD_DIR="$HOME/downloads"
    export XDG_DOCUMENTS_DIR="$HOME/files"
    export XDG_PICTURES_DIR="$HOME/images"
    export XDG_DESKTOP_DIR="$HOME/desktop"
    export XDG_MUSIC_DIR="$HOME/music"
    export XDG_VIDEOS_DIR="$HOME/videos"

    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CACHE_HOME="$HOME/.cache"

    for xdg_dir in \
        "$XDG_CACHE_HOME" \
        "$XDG_CONFIG_HOME" \
        "$XDG_DATA_HOME" \
        "$XDG_DOCUMENTS_DIR" \
        "$XDG_PICTURES_DIR"
    do
        if [ -e "$xdg_dir" ] ; then
            chmod 0700 "$xdg_dir"
        fi
    done

    # i dont use these but some programs complain
    # if they can't write to them
    export XDG_NULL_DIR="/tmp/$USER-tmp/.xdg-$USER-void"
    mkdir -p "$XDG_NULL_DIR"
    export XDG_PUBLICSHARE_DIR="$XDG_NULL_DIR"
    export XDG_TEMPLATES_DIR="$XDG_NULL_DIR"

    chmod 0700 "$XDG_NULL_DIR"
fi

# ========================================================================
# MISC SETTINGS
# ========================================================================
if [ ! -e ~/.hushlogin ] ; then
    touch ~/.hushlogin
fi

if [ -e /etc/THIS_IS_MY_MACHINE ] ; then
    export EDITOR=/usr/bin/nvim
else
    for i in nvim vim vi nvi nano ; do
        if command -v $i >/dev/null 2>&1 ; then
            export EDITOR=$i
            break
        fi
    done
fi

for i in librewolf librewolf-bin firefox firefox-bin chromium chromium-bin ; do
    if command -v $i >/dev/null ; then
        export BROWSER=$i
        break
    fi
done

if command -v opn >/dev/null ; then
    export XDG_OPEN=opn
    export PLUMBER=opn
fi

export PAGER=less
export MANPAGER=less
# opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
export LESS='-QRsim +Gg'
export LESSHISTFILE=/dev/null

# ===================================================
# LOCALIZATION
# ===================================================
if [ -e /etc/THIS_IS_MY_MACHINE ] ; then
    # NOTE: en_US.UTF-8 over C causes case-insensitive sorting
    # NOTE: "C" is supposed to be fastest text parsing up to you whether the benefits outweigh the negatives
    # NOTE: using "C" can cause bugs in terminal programs that expect certain font features to work
    export LC_ALL="en_US.UTF-8"
    export LC_CTYPE="$LC_ALL"
    export LANG="$LC_ALL"
    export LANGUAGE="$LC_ALL"
    export LOCALE="$LC_ALL"
fi

# ===================================================
# create tmp dir
# ===================================================
# only proceed if we're not on macos or within wsl
if [ ! -e /etc/wsl.conf ] && [ ! -e /System/Library/CoreServices/SystemVersion.plist ] ; then
    # and only proceed if we're on my machine
    if [ -e /etc/THIS_IS_MY_MACHINE ] ; then
        mkdir -p "/tmp/$USER-tmp"

        if [ ! -e ~/tmp ] ; then
            ln -s "/tmp/$USER-tmp" ~/tmp
        fi

        rm -r ~/.w3m 2>/dev/null ||:
        rm ~/.python_history ||:
        rm ~/.wget-hsts ||:

        mkdir -p ~/tmp/.junk/w3m
        ln -s ~/tmp/.junk/w3m ~/.w3m

        touch ~/tmp/.junk/python_history
        ln -s ~/tmp/.junk/python_history ~/.python_history

        touch ~/tmp/.junk/wget-hsts
        ln -s ~/tmp/.junk/wget-hsts ~/.wget-hsts

        rm ~/.bash_history ~/.ksh_history ||:
        ln -s ~/tmp/.junk/bash_history ~/.bash_history
        ln -s ~/tmp/.junk/ksh_history ~/.ksh_history

        chmod -R 0700 "/tmp/$USER-tmp"
    fi
else
    mkdir -p ~/tmp
fi

# ========================================================================
# FIX PERMISSIONS
# ========================================================================
if [ -e /etc/THIS_IS_MY_MACHINE ] ; then
    find ~/tmp -type d ! -perm 0700 -exec chmod 0700 {} +
    find ~/tmp -type f ! -perm 0600 -exec chmod 0600 {} +

    if [ -d ~/.gnupg ] ; then
        chmod 0700 ~/.gnupg
        find ~/.gnupg -type f ! -perm 0600 -exec chmod 0600 {} +
    fi

    if [ -d ~/.ssh ] ; then
        chmod 0700 ~/.ssh

        [ -f ~/.ssh/config ]     && chmod 0600 ~/.ssh/config
        [ -f ~/.ssh/id_rsa ]     && chmod 0600 ~/.ssh/id_rsa
        [ -f ~/.ssh/id_rsa.pub ] && chmod 0644 ~/.ssh/id_rsa.pub

        [ -f ~/.ssh/authorized_keys ] && chmod 0600 ~/.ssh/authorized_keys

        # start ssh-agent
        if ! pgrep -u "$USER" -x ssh-agent >/dev/null ; then
            eval "$(ssh-agent -s)" >/dev/null
        fi

        # add key only if not already loaded
        if [ -f ~/.ssh/id_rsa ] && ! ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf ~/.ssh/id_rsa | awk '{print $2}')" ; then
            ssh-add ~/.ssh/id_rsa
        fi
    fi
fi

# ========================================================================
# wayland crap
# ========================================================================
if command -v wayland-info >/dev/null ; then
    export XDG_SESSION_TYPE=wayland
    export QT_QPA_PLATFORM=wayland
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
    export MOZ_ENABLE_WAYLAND=1
    export _JAVA_AWT_WM_NONREPARENTING=1
fi

# ========================================================================
# basic check if we've been run or not
# see kshrc
# ========================================================================
export DOT_PROFILE_IMPORTED=1

