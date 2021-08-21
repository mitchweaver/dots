#!/bin/sh -ex

# sudo apt update
# sudo apt upgrade -y

wget https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip -O /tmp/exa.zip

cd /tmp
sudo apt install -y unzip
unzip exa.zip

install -Dm0755 bin/exa ~/.local/bin/exa

# programs
sudo apt install -y \
    build-essential \
    abook \
    arandr \
    aria2 \
    autoconf \
    automake \
    bluez \
    bluez-tools \
    clamav \
    curl \
    detox \
    dnscrypt-proxy \
    dnsutils \
    dosbox \
    docker \
    docker-compose \
    dstat \
    figlet \
    firefox \
    gimp \
    git \
    gconf-editor \
    golang \
    gocr \
    htop \
    hugo \
    inotify-tools \
    ipmitool \
    isync \
    jpegoptim \
    jq \
    libreoffice \
    lolcat \
    lxappearance \
    msmtp \
    mupdf \
    neofetch \
    neovim \
    net-tools \
    notmuch \
    nmap \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    openvpn \
    openresolv \
    netcat \
    patch \
    p7zip \
    pcmanfm \
    pv \
    pavucontrol \
    pulseaudio \
    pulseaudio-utils \
    pipewire \
    python3-neovim \
    python3-setuptools \
    python3-pip \
    pylint \
    python3-docker \
    pylint \
    ranger \
    rdesktop \
    rsync \
    imagemagick \
    slop \
    speedtest-cli \
    sxhkd \
    sxiv \
    syncthing \
    xfonts-terminus \
    toilet \
    tor \
    torsocks \
    translate-shell \
    tmux \
    unifont \
    unzip \
    nvi \
    w3m \
    wget \
    wireshark \
    wireless-tools \
    x11vnc \
    xautolock \
    xdotool \
    xsel \
    xclip \
    xterm \
    xbacklight \
    xinput \
    xournal \
    x11-xserver-utils \
    youtube-dl \
    zathura \
    zip \
    mpv \
    ffmpegthumbnailer

# printing
sudo apt install -y \
    cups cups-client cups-pdf

# libs
sudo apt install -y \
    libcxxtools-dev \
    libatomic1 \
    libfreetype-dev \
    libpixman-1-dev \
    libxcb-util-dev \
    libxft-dev \
    libxinerama-dev \
    libxrandr-dev \
    libjpeg-dev \
    libturbojpeg \
    ubuntu-restricted-extras \
    libavcodec-extra


# sudo dnf copr enable -y flatcap/neomutt
# sudo dnf install -y neomutt

# sudo dnf copr enable -y luminoso/Signal-Desktop
# sudo dnf install -y signal-desktop


# use xinitrc because new linux is stupid
cat <<EOF | sudo tee /usr/share/xsessions/xinitrc.desktop
[Desktop Entry]
Encoding=UTF-8
Name=xinitrc
Comment=xinitrc
Exec=/home/mitch/.xinitrc
TryExec=/home/mitch/.xinitrc
Type=Application
EOF

# in fact lets just not use display manager
###sudo systemctl disable gdm

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# wget \
#     https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.rpm \
#     -O /tmp/gotop.rpm
# sudo rpm -i /tmp/gotop.rpm
# rm /tmp/gotop.rpm
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
sudo apt install -y libxcb-image0-dev
git clone https://github.com/stoeckmann/xwallpaper.git /tmp/xwallpaper
cd /tmp/xwallpaper ||:
./autogen.sh
./configure
make
sudo make PREFIX=/usr/local install
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# git clone https://github.com/dudik/herbe /tmp/herbe
# cd /tmp/herbe
# make
# sudo make PREFIX=/usr/local install
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# stop messing with my dns
sudo rm /etc/resolv.conf
cat <<EOF | sudo tee /etc/resolv.conf
nameserver 9.9.9.9
lookup file bind
EOF
sudo chattr +i /etc/resolv.conf
# oksh \
# xbanish \
