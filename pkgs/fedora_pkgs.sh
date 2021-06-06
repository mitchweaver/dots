#!/bin/sh

sudo dnf update
sudo dnf install -y dnf-plugins-core
sudo yum groupinstall -y "Development Tools"

# programs
sudo dnf install -y \
    abook \
    arandr \
    aria2 \
    autoconf \
    automake \
    bluez \
    bluez-libs \
    bluez-tools \
    clamav \
    curl \
    detox \
    dnscrypt-proxy \
    dnsutils \
    dosbox \
    docker \
    docker-compose \
    exa \
    figlet \
    firefox \
    gimp \
    git \
    gconf-editor \
    gnome-extensions-app \
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
    lolcat \
    lxappearance \
    msmtp \
    mupdf \
    neofetch \
    neovim \
    net-tools \
    notmuch \
    nmap \
    google-noto-cjk-fonts \
    google-noto-emoji-fonts \
    google-noto-emoji-color-fonts \
    oksh \
    openvpn \
    openresolv \
    netcat \
    patch \
    p7zip \
    pcmanfm \
    picom \
    pv \
    pavucontrol \
    pulseaudio \
    pulseaudio-utils \
    pipewire-pulseaudio \
    python3-neovim \
    python3-setuptools \
    python3-pip \
    python3-pylint \
    python3-docker \
    pylint \
    ranger \
    rdesktop \
    rsync \
    rpm-build \
    ImageMagick \
    slop \
    speedtest-cli \
    sxhkd \
    sxiv \
    syncthing \
    terminus-fonts \
    toilet \
    tor \
    torsocks \
    translate-shell \
    tmux \
    unifont \
    unzip \
    vi \
    w3m \
    wget \
    wireshark \
    wireshark-cli \
    wireless-tools \
    x11vnc \
    xbanish \
    xautolock \
    xdotool \
    xsel \
    xterm \
    xbacklight \
    xsetroot \
    xinput \
    xournal \
    xset \
    mkfontdir \
    mkfontscale \
    youtube-dl \
    zathura-pdf-mupdf \
    zip \
    mpv \
    ffmpegthumbnailer

# printing
sudo dnf install -y \
    cups cups-client cups-lpd cups-pdf

# libs
sudo dnf install -y \
    libcxx \
    libcxx-devel \
    libcxxabi \
    libcxxabi-devel \
    libatomic \
    freetype \
    freetype-devel \
    pixman \
    pixman-devel \
    xcb-util-devel \
    xcb-util-image-devel \
    libXft-devel \
    libXinerama-devel \
    libXrandr \
    libXrandr-devel

sudo dnf copr enable -y flatcap/neomutt
sudo dnf install -y neomutt

sudo dnf copr enable -y luminoso/Signal-Desktop
sudo dnf install -y signal-desktop


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
sudo systemctl disable gdm

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
wget \
    https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.rpm \
    -O /tmp/gotop.rpm
sudo rpm -i /tmp/gotop.rpm
rm /tmp/gotop.rpm
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
git clone https://github.com/stoeckmann/xwallpaper.git /tmp/xwallpaper
cd /tmp/xwallpaper ||:
./autogen.sh
./configure
make
sudo make PREFIX=/usr/local install
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
git clone https://github.com/dudik/herbe /tmp/herbe
cd /tmp/herbe
make
sudo make PREFIX=/usr/local install
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
