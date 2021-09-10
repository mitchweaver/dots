#!/bin/sh -ex

sudo apt update
sudo apt upgrade -y

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
    ffmpegthumbnailer \
    x11-utils

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

# -------- gaming ----------------
# force evdev because libinput is AWFUL for
# consistent mouse movement
sudo apt install -y \
    libevdev-dev \
    libevdev2 \
    python3-evdev \
    xserver-xorg-input-evdev \
    xserver-xorg-input-evdev-dev \
    xserver-xorg-input-mouse

sudo mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/20-evdev.conf <<"EOF"
Section "InputClass"
    Identifier "evdev pointer catchall"
    MatchIsPointer "on"
    Driver "evdev"
    MatchDevicePath "/dev/input/event*"
    # 1 1 0 = no mouse acceleration
    Option "AccelerationNumerator" "1"
    Option "AccelerationDenominator" "1"
    Option "AccelerationThreshold" "0"
EndSection
EOF
# ---------------------------------

if ! command -v exa >/dev/null ; then
    wget https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip -O /tmp/exa.zip
    cd /tmp
    sudo apt install -y unzip
    unzip exa.zip
    install -Dm0755 bin/exa ~/.local/bin/exa
fi


# use xinitrc because new linux is stupid
if [ ! -f /usr/share/xsessions/xinitrc.desktop ] ; then
cat <<EOF | sudo tee /usr/share/xsessions/xinitrc.desktop
[Desktop Entry]
Encoding=UTF-8
Name=xinitrc
Comment=xinitrc
Exec=/home/mitch/.xinitrc
TryExec=/home/mitch/.xinitrc
Type=Application
EOF
fi

# in fact lets just not use display manager
sudo systemctl disable gdm

if ! command -v xwallpaper >/dev/null ; then
sudo apt install -y libxcb-image0-dev
git clone https://github.com/stoeckmann/xwallpaper.git /tmp/xwallpaper
cd /tmp/xwallpaper ||:
./autogen.sh
./configure
make
sudo make PREFIX=/usr/local install
fi

if ! command -v herbe >/dev/null ; then
    git clone https://github.com/dudik/herbe /tmp/herbe
    cd /tmp/herbe
    make
    sudo make PREFIX=/usr/local install
fi

# stop messing with my dns
sudo rm /etc/resolv.conf ||:
cat <<EOF | sudo tee /etc/resolv.conf
nameserver 9.9.9.9
nameserver 8.8.8.8
lookup file bind
EOF
sudo chattr +i /etc/resolv.conf

echo 'DONE!'
