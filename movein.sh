#!/bin/sh
#
# http://github.com/mitchweaver/dots
#

: ${DOTS:=~/src/dots}

msg() { >&2 printf '%s\n' "$*" ; }
query() {
    >&2 printf '%s (y\\n): ' "$*"
    read -r ans
    [ "$ans" = y ] || return 1
}

if command -v apt >/dev/null ; then
    msg 'We are using Ubuntu, installing programs...'
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y \
        build-essential git make rsync file tree \
        gawk sed procps xsel x11-xserver-utils \
        x11-utils xdotool xinput xidle xwallpaper \
        openvpn curl wget nmap htop unzip jq pv docker.io \
        docker-compose ranger toilet sxhkd dunst ranger \
        neovim gdb gnupg2 fail2ban

    # needed to build suckless programs
    sudo apt install -y \
        libxt-dev libxi-dev libx11-dev libxcb-xinput-dev \
        libfreetype-dev

    # needed to build picom
    sudo apt install -y \
        libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
        libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev \
        libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev \
        libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev \
        libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev \
        libpcre2-dev libpcre3-dev libevdev-dev uthash-dev \
        libev-dev libx11-xcb-dev ninja-build meson

    query 'Install non-essentials?' &&
    sudo apt install -y \
        firefox mpv mupdf translate-shell \
        imagemagick youtube-dl sct aria2 proxychains \
        dnstop iotop wireshark nethogs clamav unrar zip \
        jpegoptim ffmpegthumbnailer gimp thunderbird \
        pylint
    sudo apt autoremove -y

    rm -rf /tmp/skroll /tmp/xbanish /tmp/pywal 2>/dev/null
    git clone http://github.com/jcs/xbanish /tmp/xbanish
    cd /tmp/xbanish || exit 1
    make
    make PREFIX=${HOME}/.local install

    git clone http://github.com/dylanaraps/pywal /tmp/pywal
    cd /tmp/pywal || exit 1
    python3 setup.py install --user

    git clone git://z3bra.org/skroll.git /tmp/skroll
    cd /tmp/skroll || exit 1
    make
    make PREFIX=${HOME}/.local install

    git clone http://github.com/yshui/picom
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    install -D -m build/src/picom ~/.local/bin/picom

    curl https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip -O /tmp/exa.zip
    unzip /tmp/exa.zip -d /tmp
    install -D -m 0755 /tmp/exa-linux-x86_64 ~/.local/bin/exa
else
    msg 'We are not using Ubuntu... Cannot install apps!'
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

rice

#          ▐           ▌
# ▞▀▘▌ ▌▞▀▘▜▀ ▞▀▖▛▚▀▖▞▀▌
# ▝▀▖▚▄▌▝▀▖▐ ▖▛▀ ▌▐ ▌▌ ▌
# ▀▀ ▗▄▘▀▀  ▀ ▝▀▘▘▝ ▘▝▀▘
sudo systemctl disable gdm
sudo systemctl disable gdm3
sudo systemctl enable fail2ban

msg 'done!'
