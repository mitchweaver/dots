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
    openvpn \
    p7zip \
    pandoc \
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
    imagemagick \
    shellcheck \
    slock \
    slop \
    speedtest-cli \
    sxhkd \
    sxiv \
    terminus-font \
    termshark \
    tor \
    torsocks \
    translate-shell \
    bdf-unifont \
    unrar \
    unzip \
    w3m \
    wget \
    wireshark-cli \
    wireshark-qt \
    x11vnc \
    xautolock \
    xdotool \
    xsel \
    xterm \
    xwallpaper \
    youtube-dl \
    zathura-pdf-mupdf \
    zip

pacman -Sy yay

# warning: not all below aur packages have arm64 available
yay -Syy

sudo -u mitch yay -Sy \
    abook \
    herbe \
    farbfeld \
    oksh \
    sct \
    skroll \
    toilet \
    tor-browser \
    xbanish \
    xorg-xsetroot \
    xorg-xinput \
    spleen-font \
    text2pdf

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