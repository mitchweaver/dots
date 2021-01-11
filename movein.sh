#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

: ${DOTS:=${HOME}/src/dots}

msg() { >&2 printf '%s\n' "$*" ; }

if command -v apt >/dev/null ; then
    msg 'We are using Ubuntu, installing programs...'
    [ $(id -u) -eq 0 ] || sudo=sudo
    $sudo apt update
    $sudo apt upgrade -y
    $sudo apt install -y \
        build-essential git make rsync file tree \
        gawk sed procps xsel x11-xserver-utils \
        x11-utils xdotool xinput xidle xwallpaper \
        openvpn curl wget nmap htop unzip jq pv docker.io \
        docker-compose ranger toilet
    $sudo apt autoremove -y
fi

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ▌ ▌ ▛▀▘▗▜       
# ▝▞  ▙▄ ▄▐ ▞▀▖▞▀▘
# ▞▝▖ ▌  ▐▐ ▛▀ ▝▀▖
# ▘ ▘ ▘  ▀▘▘▝▀▘▀▀ 
ln -sf "$DOTS"/.xinitrc ${HOME}/.xinitrc
ln -sf "$DOTS"/.xinitrc ${HOME}/.xsessionrc
ln -sf "$DOTS"/.profile    ${HOME}/.profile
ln -sf "$DOTS"/.xmodmaprc ${HOME}/.xmodmaprc
ln -sf "$DOTS"/.Xresources ${HOME}/.Xresources
xrdb load ${HOME}/.Xresources
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#    ▗     
# ▌ ▌▄ ▛▚▀▖
# ▐▐ ▐ ▌▐ ▌
#  ▘ ▀▘▘▝ ▘
mkdir -p ${HOME}/.config/nvim
ln -sf "$DOTS"/.config/nvim/init.vim ${HOME}/.config/nvim/init.vim
ln -sf "$DOTS"/.vimrc ${HOME}/.vimrc
curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#            ▗▀▖▗    
#   ▞▀▖▞▀▖▛▀▖▐  ▄ ▞▀▌
# ▗▖▌ ▖▌ ▌▌ ▌▜▀ ▐ ▚▄▌
# ▝▘▝▀ ▝▀ ▘ ▘▐  ▀▘▗▄▘
mkdir -p ${HOME}/.config/mpv
mkdir -p ${HOME}/.config/sxhkd
mkdir -p ${HOME}/.config/cava
mkdir -p ${HOME}/.config/ranger
mkdir -p ${HOME}/.config/dunst
ln -sf "$DOTS"/.config/mpv/mpv.conf ${HOME}/.config/mpv/mpv.conf
ln -sf "$DOTS"/.config/cava/cava.conf ${HOME}/.config/cava/cava.conf
ln -sf "$DOTS"/.config/ranger/scope.sh ${HOME}/.config/ranger/scope.sh
ln -sf "$DOTS"/.config/ranger/rifle.conf ${HOME}/.config/ranger/rifle.conf
ln -sf "$DOTS"/.config/ranger/rc.conf ${HOME}/.config/ranger/rc.conf
ln -sf "$DOTS"/.config/autostart ${HOME}/.config/autostart
ln -sf "$DOTS"/.config/sxhkd/sxhkdrc ${HOME}/.config/sxhkd/sxhkdrc
ln -sf "$DOTS"/.config/picom.conf ${HOME}/.config/picom.conf
ln -sf "$DOTS"/.config/dunst/dunstrc ${HOME}/.config/dunst/dunstrc
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#     ▗       
# ▛▚▀▖▄ ▞▀▘▞▀▖
# ▌▐ ▌▐ ▝▀▖▌ ▖
# ▘▝ ▘▀▘▀▀ ▝▀ 
ln -sf "$DOTS"/.gitconfig ${HOME}/.gitconfig
ln -sf "$DOTS"/.pylintrc ${HOME}/.pylintrc
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

msg 'done!'
