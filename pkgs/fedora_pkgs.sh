#!/bin/sh

# sudo yum update

# fedora specific
# sudo yum install \
    # libcxxabi \
    # libatomic

    # xournal
# generic
#    mpv \
    # neomutt \
    # ffmpegthumbnailer \
sudo yum install \
    abook \
    arandr \
    aria2 \
    bluez \
    bluez-libs \
    bluez-tools \
    clamav \
    curl \
    detox \
    dnscrypt-proxy \
    dnsutils \
    dosbox \
    exa \
    figlet \
    firefox \
    freetype \
    freetype-devel \
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
    python3-neovim \
    python3-setuptools \
    python3-pip \
    python3-pylint \
    pylint \
    ranger \
    rdesktop \
    rsync \
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
    libXft-devel \
    libXinerama-devel \
    mkfontdir \
    mkfontscale \
    youtube-dl \
    zathura-pdf-mupdf \
    zip

# use xinitrc insetad of stupid .desktop files
cat > /dev/stdout | sudo tee /usr/share/applications/xinitrc.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=xinitrc
Comment=xinitrc
Exec=/home/mitch/.xinitrc
TryExec=/home/mitch/.xinitrc
Type=Application
EOF

# xwallpaper \
# fedora-specific naming differences
# yum install \
