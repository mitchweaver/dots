#!/bin/sh -ex

echo "run me as root, ok?"
read -r blank
if [ $(id -u) -ne 0 ] ; then
	exit 1
fi

pacman -Syyuu

pacman -Sy \
    arandr \
    aria2 \
    base-devel \
    bluez-utils \
    bluez-tools \
    cataclysm-dda \
    clamav \
    curl \
    detox \
    dnscrypt-proxy \
    dosbox \
    exa \
    ffmpegthumbnailer \
    firefox \
    freetype2 \
    gimp \
    git \
    go \
    gocr \
    htop \
    hugo \
    inotify-tools \
    ipmitool \
    isync \
    jpegoptim \
    jq \
    libreoffice \
    linux-api-headers \
    lolcat \
    lxappearance \
    mpv \
    msmtp \
    mupdf \
    neofetch \
    neomutt \
    neovim \
    net-tools \
    notmuch \
    nmap \
    noto-fonts-cjk \
    noto-fonts-emoji \
    openntpd \
    openvpn \
    openresolv \
    openbsd-netcat \
    p7zip \
    pcmanfm \
    picom \
    pv \
    python-pynvim \
    python-setuptools \
    python-pip \
    python-pylint \
    python-pywal \
    ranger \
    rdesktop \
    rsync \
    imagemagick \
    slock \
    slop \
    speedtest-cli \
    sxhkd \
    sxiv \
    syncthing \
    terminus-font \
    termshark \
    tor \
    torsocks \
    translate-shell \
    bdf-unifont \
    unrar \
    unzip \
    vi \
    w3m \
    wget \
    wireshark-cli \
    wireshark-qt \
    x11vnc \
    xautolock \
    xdotool \
    xsel \
    xterm \
    xorg-xbacklight \
    xorg-xsetroot \
    xorg-xinput \
    xorg-mkfontdir \
    xorg-mkfontscale \
    xwallpaper \
    youtube-dl \
    zathura-pdf-mupdf \
    zip

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# not available in arm64 repos
# pandoc \
# shellcheck \
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

pacman -Sy yay

# warning: not all below aur packages have arm64 available
yay -Syy

sudo -u mitch yay -Sy \
    abook \
    herbe \
    farbfeld \
    gotop \
    oksh \
    sct \
    skroll \
    toilet \
    xbanish \
    spleen-font \
    text2pdf

# tor-browser / tor-browser-arm

if command -v oksh >/dev/null ; then
    chsh -s $(which oksh) mitch
fi

# make login screen thing because new linux is stupid
mkdir -p /usr/share/xsessions
cat > /usr/share/xsessions/dwm.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=xinitrc
Comment=xinitrc
Exec=/home/mitch/.xinitrc
Icon=
Type=Application
EOF
