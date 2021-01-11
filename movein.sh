#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

: ${DOTS:=~/src/dots}

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
ln -sf "$DOTS"/.xinitrc ~/.xinitrc
ln -sf "$DOTS"/.xinitrc ~/.xsessionrc
ln -sf "$DOTS"/.profile    ~/.profile
ln -sf "$DOTS"/.xmodmaprc ~/.xmodmaprc
ln -sf "$DOTS"/.Xresources ~/.Xresources
xrdb load ~/.Xresources
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#    ▗     
# ▌ ▌▄ ▛▚▀▖
# ▐▐ ▐ ▌▐ ▌
#  ▘ ▀▘▘▝ ▘
mkdir -p ~/.config/nvim
ln -sf "$DOTS"/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -sf "$DOTS"/.vimrc ~/.vimrc
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#            ▗▀▖▗    
#   ▞▀▖▞▀▖▛▀▖▐  ▄ ▞▀▌
# ▗▖▌ ▖▌ ▌▌ ▌▜▀ ▐ ▚▄▌
# ▝▘▝▀ ▝▀ ▘ ▘▐  ▀▘▗▄▘
mkdir -p ~/.config/mpv
mkdir -p ~/.config/sxhkd
mkdir -p ~/.config/cava
mkdir -p ~/.config/ranger
mkdir -p ~/.config/dunst
ln -sf "$DOTS"/.config/mpv/mpv.conf ~/.config/mpv/mpv.conf
ln -sf "$DOTS"/.config/cava/cava.conf ~/.config/cava/cava.conf
ln -sf "$DOTS"/.config/ranger/scope.sh ~/.config/ranger/scope.sh
ln -sf "$DOTS"/.config/ranger/rifle.conf ~/.config/ranger/rifle.conf
ln -sf "$DOTS"/.config/ranger/rc.conf ~/.config/ranger/rc.conf
ln -sf "$DOTS"/.config/autostart ~/.config/autostart
ln -sf "$DOTS"/.config/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
ln -sf "$DOTS"/.config/picom.conf ~/.config/picom.conf
ln -sf "$DOTS"/.config/dunst/dunstrc ~/.config/dunst/dunstrc
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#     ▗       
# ▛▚▀▖▄ ▞▀▘▞▀▖
# ▌▐ ▌▐ ▝▀▖▌ ▖
# ▘▝ ▘▀▘▀▀ ▝▀ 
ln -sf "$DOTS"/.gitconfig ~/.gitconfig
ln -sf "$DOTS"/.pylintrc ~/.pylintrc
ln -sf "$DOTS"/shell/main.shellrc ~/.bashrc
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

msg 'done!'
