#!/bin/sh

add() {
    pkg install "$@"
}

# system utils
add \
    sysutils/smartmontools \
    sysutils/htop \
    sysutils/sensors \
    sysutils/pciutils \
    sysutils/usbutils

# security
add \
    security/opendoas \
    security/sudo \
    security/libsecret

# archive
add \
    archivers/7-zip \
    archivers/unrar \
    archivers/unzip

# filesystem
add \
    filesystems/linux-c7-dosfstools

# networking
add \
    ftp/wget \
    ftp/curl \
    security/nmap \
    dns/bind-tools \
    dns/dnsmasq \
    dns/ldns \
    net/socat \
    net/rdesktop \
    security/openvpn \
    net/wireguard-tools

# scripting utilities
add \
    sysutils/entr \
    sysutils/detox \
    converters/dos2unix \
    sysutils/inotify-tools \
    sysutils/dateutils

# misc development libs
add \
    java/openjdk25 \
    devel/libnotify \
    devel/nlohmann-json \
    www/tidy-html5 \
    www/tidy

# python libraries
add \
    math/py-numpy \
    science/py-scipy \
    editors/py-pynvim

# firmware
add \
    graphics/drm-kmod \
    comms/bluez-firmware

# terminal userland
add \
    shells/oksh \
    x11/kitty \
    editors/neovim \
    sysutils/py-ranger \
    textproc/translate-shell \
    sysutils/tree \
    sysutils/pv \
    sysutils/progress \
    sysutils/eza \
    textproc/bat

# development
add \
    devel/hs-ShellCheck \
    textproc/jq \
    devel/pylint

# misc x11 stuff
add \
    x11/xrandr \
    x11/xrdb

# wayland utils
add \
    graphics/egl-wayland \
    x11/grim \
    x11/slurp

# images / photography
add \
    graphics/gimp \
    graphics/ImageMagick7 \
    graphics/jpegoptim \
    graphics/exif

# video
add \
    multimedia/mpv \
    multimedia/ffmpeg \
    multimedia/ffmpegthumbnailer \
    www/yt-dlp \
    multimedia/obs-studio \
    multimedia/shotcut

# video codecs
add \
    multimedia/x264 \
    multimedia/x265 \
    multimedia/gstreamer1-plugins-x264 \
    multimedia/gstreamer1-plugins-x265 \
    multimedia/gstreamer1-plugins-good \
    multimedia/gstreamer1-plugins-bad \
    multimedia/gstreamer1-plugins-ugly \
    multimedia/gstreamer1-plugins-v4l2

# audio
add \
    audio/cuetools \
    audio/alsa-utils \
    audio/alsa-plugins \
    audio/gstreamer1-plugins-alsa \
    audio/pavucontrol \
    audio/shntool \
    audio/vorbis-tools \
    audio/wavpack

# office
add \
    www/firefox \
    editors/libreoffice \
    deskutils/nextcloudclient

# printing
add \
    print/cups \
    print/cups-filters \
    print/cups-pdf \
    print/hplip

# fonts
add \
    misc/figlet \
    misc/figlet-fonts \
    x11-fonts/mkfontscale \
    x11-fonts/fontconfig \
    x11-fonts/font-util \
    x11-fonts/liberation-fonts-ttf \
    x11-fonts/noto \
    x11-fonts/noto-emoji \
    x11-fonts/noto-extra \
    x11-fonts/nerd-fonts \
    x11-fonts/spleen \
    x11-fonts/gnu-unifont \
    x11-fonts/gnu-unifont-otf \
    x11-fonts/plex-ttf \
    x11-fonts/roboto-fonts-ttf \
    x11-fonts/dejavu \
    x11-fonts/terminus-font \
    x11-fonts/terminus-ttf

# sway
add \
    x11-wm/swayfx \
    x11/swaybg \
    x11/swayidle \
    x11/swaylock-effects \
    x11/xdg-desktop-portal-wlr \
    x11/wl-clipboard \
    x11/waybar \
    x11/mako

# misc userland
add \
    x11-fm/pcmanfm \
    sysutils/neofetch \
    sysutils/pfetch \
    graphics/pywal

# ============================
# PORTS
# ============================
# fail2ban

# ============================
# sometimes installed
# ============================
# gammastep
# todo: acpilight alternative?
# mailspring??
