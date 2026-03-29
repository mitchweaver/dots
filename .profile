#!/bin/sh

# ========================================================================
# PATHS
# ========================================================================
export PATH="$PATH:/usr/X11R6/bin:/usr/local/sbin:$HOME/.local/go/bin:$HOME/.cargo/bin:$HOME/.npm/bin"
export MANPATH="${HOME}/.local/share/man:$MANPATH"
export PATH=$PATH:${HOME}/.local/bin

# hide npm patch to ~/.local/npm instead of ~/.npm
export NPM_CONFIG_PREFIX="${HOME}/.local/npm"
# hide GOPATH to ~/.local/go instead of ~/go
export GOPATH="${HOME}/.local/go"

mkdir -p "$NPM_CONFIG_PREFIX"
mkdir -p "$GOPATH"

# for ksh
if [ -f ~/src/dots/shell/main.shellrc ] ; then
    export ENV="${HOME}/src/dots/shell/main.shellrc"
fi

# ========================================================================
# OS specific settings
# ========================================================================
case $(uname) in
    Linux|FreeBSD)
        export CC="${CC:-gcc}" cc="${cc:-gcc}"
        umask 022
        ;;
    OpenBSD)
        export CC="${CC:-clang}" cc="${cc:-clang}"
        ;;
    Darwin|MacOS)
        export CC="${CC:-clang}" cc="${cc:-clang}"
        # allow time machine to backup to samba/nfs
        defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
esac

case $(uname) in
    OpenBSD)
        export NPROC="$(sysctl -n hw.ncpuonline)"
        ;;
    *)
        if command -v nproc >/dev/null ; then
            export NPROC="$(nproc)"
        fi
esac

# ========================================================================
# DIRECTORIES
# ========================================================================
export XDG_CONFIG_HOME="${HOME}/.config" \
       XDG_DOWNLOAD_DIR="${HOME}/downloads" \
       XDG_DOCUMENTS_DIR="${HOME}/files" \
       XDG_PICTURES_DIR="${HOME}/images"

export XDG_DESKTOP_DIR="${HOME}/desktop"
export XDG_DATA_HOME="${HOME}/.local"
export XDG_CACHE_HOME="${HOME}/.cache"

# i dont use these but some programs complain
# if they can't write to them
export XDG_NULL_DIR="/tmp/$USER-tmp/.xdg-$USER-void"
mkdir -p "$XDG_NULL_DIR"
export XDG_PUBLICSHARE_DIR="$XDG_NULL_DIR" \
       XDG_TEMPLATES_DIR="$XDG_NULL_DIR" \
       XDG_VIDEOS_DIR="$XDG_NULL_DIR" \
       XDG_MUSIC_DIR="$XDG_NULL_DIR"

# ========================================================================
# MISC SETTINGS
# ========================================================================
for i in nvim vim vi nvi nano ; do
    if command -v $i >/dev/null 2>&1 ; then
        export EDITOR=$i
        break
    fi
done

for i in librewolf librewolf-bin firefox firefox-bin chromium chromium-bin ; do
    if command -v $i >/dev/null ; then
        export BROWSER=$i
        break
    fi
done

export MENU_PROG=menu
export XDG_OPEN=opn PLUMBER=opn

export PAGER=less MANPAGER=less
# opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
export LESS='-QRsim +Gg'
export LESSHISTFILE=/dev/null

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="$LC_ALL" \
       LANG="$LC_ALL" \
       LANGUAGE="$LC_ALL" \
       LOCALE="$LC_ALL"

# ===================================================
# create tmp dir
# ===================================================
if [ -d ~/tmp ] ; then
    mv ~/tmp ~/tmp.bk
fi

mkdir -p "/tmp/$USER-tmp/tmp"
ln -sf "/tmp/$USER-tmp/tmp" ~/tmp
chmod -R 0700 "/tmp/$USER-tmp"

# ===================================================
# other symlinks for junk I don't want on disk
# ===================================================
# rm -r ~/.w3m 2>/dev/null ||:
# rm -f ~/.python_history
# rm -f ~/.wget-hsts

# mkdir -p ~/tmp/.junk/w3m
# ln -sf ~/tmp/.junk/w3m ~/.w3m

# touch ~/tmp/.junk/python_history
# ln -sf ~/tmp/.junk/python_history ~/.python_history

# touch ~/tmp/.junk/wget-hsts
# ln -sf ~/tmp/.junk/wget-hsts ~/.wget-hsts

# rm -f ~/.bash_history ~/.ksh_history
# ln -sf ~/tmp/.junk/bash_history ~/.bash_history
# ln -sf ~/tmp/.junk/ksh_history ~/.ksh_history

# ========================================================================
# FIX PERMISSIONS
# ========================================================================
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

################export MOZ_ENABLE_WAYLAND=1
################export MOZ_USE_XINPUT2=1
################export GTK_THEME=Arc-Dark

# if command -v cliphist >/dev/null ; then
#     mkdir -p ~/tmp/.cliphist
#     chmod -R 0700 ~/tmp/.cliphist
#     ln -sf ~/tmp/.cliphist ~/.cache/cliphist
# fi

