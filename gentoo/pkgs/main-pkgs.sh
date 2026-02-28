#!/bin/sh

add() {
    emerge -av --noreplace --update --verbose-conflicts "$@" || return 1
}

# ========================================================================
# overlays
# ========================================================================
add eselect-repository

eselect repository enable guru
emerge --sync guru

eselect repository enable edgets
emerge --sync edgets

eselect repository enable pf4public
emerge --sync pf4public

eselect repository enable tastytea
emerge --sync tastytea

eselect repository enable librewolf
emerge --sync librewolf

# ========================================================================
# most important must be installed first
# ========================================================================
add \
    sys-devel/mold

# ========================================================================
# GENTOO-SPECIFIC
# ========================================================================
add \
    app-eselect/eselect-python \
    app-eselect/eselect-repository \
    app-portage/gentoolkit \
    app-portage/portage-utils

# ========================================================================
# SYSTEM DAEMONS
# ========================================================================
add \
    app-admin/sysklogd \
    sys-process/cronie \
    net-misc/chrony

# ========================================================================
# SYSTEM UTILS
# ========================================================================
add \
    app-admin/doas \
    app-admin/sudo \
    sys-process/htop  \
    sys-process/lsof \
    sys-apps/lm-sensors \
    sys-apps/pciutils \
    sys-apps/usbutils \
    sys-apps/smartmontools \
    app-admin/sysstat \
    sys-devel/bc \
    sys-power/upower \
    sys-block/zram-init \
    dev-vcs/git

# ========================================================================
# APP-ALTERNATIVES
# ========================================================================
add \
    app-alternatives/gzip \
    app-alternatives/ninja \
    app-alternatives/sh \
    app-alternatives/bzip2 \
    app-alternatives/cpio \
    app-alternatives/tar \
    app-alternatives/lzip

# ========================================================================
# ARCHIVE
# ========================================================================
add \
    app-arch/p7zip \
    app-arch/unrar \
    app-arch/unzip \
    app-arch/zip \
    app-arch/lz4 \
    app-arch/xz-utils \
    dev-libs/lzo

# ========================================================================
# FILESYSTEM
# ========================================================================
add \
    sys-fs/dosfstools \
    sys-fs/ntfs3g \
    net-fs/cifs-utils \
    net-fs/samba

## net-fs/nfs-utils
## net-fs/libnfs

# ========================================================================
# MISC SYSTEM LIBS
# ========================================================================
add \
    x11-libs/libnotify \
    app-crypt/libsecret \
    dev-python/numpy \
    dev-python/scipy \
    dev-cpp/nlohmann_json

# ========================================================================
# NETWORKING
# ========================================================================
add \
    net-dns/openresolv \
    net-analyzer/openbsd-netcat \
    net-analyzer/nmap \
    net-analyzer/speedtest-cli \
    net-dns/bind-tools \
    net-dns/dnsmasq \
    net-misc/curl \
    net-misc/dhcpcd \
    net-misc/socat \
    net-misc/rdesktop \
    net-wireless/bluez \
    net-wireless/bluez-tools \
    media-sound/bluez-alsa \
    sys-apps/ethtool \
    net-libs/ldns \
    net-analyzer/wireshark

# ========================================================================
# SCRIPTING UTILS
# ========================================================================
add \
    app-admin/entr \
    app-misc/detox \
    app-text/dos2unix \
    sys-fs/inotify-tools \
    app-misc/dateutils \
    media-gfx/qrencode

# ========================================================================
# TERMINAL USERLAND
# ========================================================================
add \
    x11-terms/kitty \
    app-editors/neovim \
    app-misc/ranger \
    app-i18n/translate-shell \
    app-text/tree \
    sys-apps/pv \
    sys-apps/progress \
    sys-apps/eza \
    sys-apps/bat \
    www-client/w3m \
    dev-python/pynvim \
    sys-fs/ncdu \
    net-misc/yt-dlp

# ========================================================================
# LEGACY X11
# ========================================================================
add \
    x11-apps/xrdb \
    x11-apps/xrandr \
    x11-apps/xev

# ========================================================================
# DEVELOPMENT
# ========================================================================
add \
    dev-util/shellcheck-bin \
    app-misc/jq \
    dev-python/pylint \
    www-apps/hugo \
    net-libs/nodejs \
    dev-java/openjdk-jre-bin

# ========================================================================
# SECURITY
# ========================================================================
add \
    net-firewall/nftables \
    net-analyzer/fail2ban \
    app-antivirus/clamav \
    sys-apps/flatpak \
    net-vpn/wireguard-tools \
    net-vpn/mullvadvpn-app

# net-vpn/tor
# net-proxy/torsocks
# www-client/torbrowser-launcher

# ========================================================================
# WAYLAND UTILS
# ========================================================================
add \
    gui-libs/egl-wayland \
    gui-apps/grim \
    gui-apps/slurp

# ========================================================================
# GFX
# ========================================================================
add \
    media-gfx/gimp \
    media-gfx/imagemagick \
    media-gfx/jpegoptim \
    media-libs/exiftool

# ========================================================================
# VIDEO
# ========================================================================
add \
    media-video/mpv \
    media-video/ffmpeg \
    media-video/ffmpegthumbnailer \
    net-misc/yt-dlp \
    media-video/obs-studio \
    media-video/shotcut

# ========================================================================
# VIDEO LIBRARIES
# ========================================================================
add \
    media-video/x264-encoder \
    media-libs/x264 \
    media-libs/x265 \
    media-plugins/gst-plugins-x264 \
    media-plugins/gst-plugins-x265 \
    media-libs/gst-plugins-good \
    media-libs/gst-plugins-bad \
    media-libs/gst-plugins-ugly \
    media-plugins/gst-plugins-v4l2 \
    media-video/v4l2loopback

# ========================================================================
# AUDIO
# ========================================================================
add \
    app-cdr/cuetools \
    media-sound/alsa-utils \
    media-libs/alsa-ucm-conf \
    media-plugins/alsa-plugins \
    media-sound/pavucontrol \
    media-sound/shntool \
    media-sound/vorbis-tools \
    media-sound/wavpack \
    media-plugins/gst-plugins-v4l2 \
    media-video/v4l2loopback \
    sys-auth/rtkit

# ========================================================================
# PRINTING
# ========================================================================
add \
    net-print/cups \
    net-print/cups-filters \
    net-print/cups-pdf \
    net-print/hplip

# ========================================================================
# FONTS
# ========================================================================
add \
    app-misc/figlet \
    x11-apps/mkfontscale \
    media-libs/fontconfig \
    media-fonts/font-util \
    media-fonts/nerdfonts \
    media-fonts/spleen \
    media-fonts/noto \
    media-fonts/noto-cjk \
    media-fonts/noto-emoji \
    media-fonts/liberation-fonts \
    media-fonts/unifont

#   media-fonts/fontawesome \
#   media-fonts/roboto \
#   media-fonts/terminus-font \
#   media-fonts/dejavu \
#   media-fonts/hack \
#   media-fonts/ibm-plex \

# ========================================================================
# MISC USERLAND
# ========================================================================
add \
    app-misc/neofetch \
    app-text/mupdf \
    app-text/zathura \
    app-text/zathura-meta

# ========================================================================
# FIRMWARE
# ========================================================================
add \
    sys-kernel/linux-firmware \
    sys-firmware/alsa-firmware \
    sys-firmware/sof-firmware

# ========================================================================
# THEMES
# ========================================================================
add \
     lxde-base/lxappearance \
     x11-themes/arc-theme \
     x11-themes/arc-icon-theme \
     x11-themes/papirus-icon-theme \
     x11-themes/paper-icon-theme \
     x11-themes/vanilla-dmz-xcursors

# ========================================================================
# BIG APPLICATIONS
# ========================================================================
add \
    www-client/librewolf \
    app-office/libreoffice \
    net-misc/nextcloud-client \
    mail-client/mailspring \
    app-text/htmltidy \
    app-office/joplin-desktop \
    app-admin/bitwarden-desktop-bin \
    media-sound/supersonic

## net-im/signal-desktop-bin

# ========================================================================
# MY EBUILDS
# ========================================================================
add \
    app-shells/oksh

# ========================================================================
# RANDOM STUFF BELOW
# ========================================================================
#################### proprietary
###################add \
###################    net-im/discord

# app-containers/docker \
# app-containers/docker-compose \

