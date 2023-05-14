#!/bin/sh

add() {
    emerge --verbose --noreplace "$@"
}

# development
add \
    app-editors/neovim \
    dev-python/pynvim \
    x11-terms/xterm \
    dev-util/shellcheck-bin \
    app-containers/docker \
    app-containers/docker-compose \
    app-misc/jq \
    www-apps/hugo \
    x11-terms/kitty \
    x11-terms/kitty-shell-integration \
    x11-terms/kitty-terminfo \
    dev-python/pillow \
    dev-lang/rust-bin

# system utils
add \
    sys-process/htop  \
    app-misc/ranger \
    app-text/tree \
    sys-apps/pv \
    sys-apps/progress \
    sys-process/lsof \
    sys-apps/ipmitool \
    sys-apps/lm-sensors \
    sys-apps/mlocate \
    sys-apps/pciutils \
    sys-apps/usbutils \
    sys-apps/smartmontools \
    app-admin/sysstat \
    app-misc/detox \
    app-misc/neofetch \
    app-text/dos2unix \
    app-admin/entr \
    sys-process/iotop-c \
    app-admin/doas

# alternative system-utils
add \
    sys-apps/exa \
    sys-apps/bat

# SYSTEM DAEMONS
add \
    app-admin/sysklogd \
    sys-process/cronie \
    net-misc/chrony

# FILESYSTEM
add \
    net-fs/cifs-utils \
    net-fs/samba \
    sys-fs/dosfstools \
    sys-fs/fuse \
    sys-fs/fuse:0 \
    sys-fs/inotify-tools \
    sys-fs/ntfs3g

# SECURITY
add \
    app-antivirus/clamav \
    net-analyzer/fail2ban \
    sys-apps/firejail

# GFX
add \
    media-libs/x264 \
    media-libs/x265 \
    media-video/x264-encoder \
    media-gfx/gimp \
    media-plugins/gimp-lqr \
    media-gfx/imagemagick \
    media-gfx/jpegoptim \
    media-libs/exiftool
# media-plugins/gst-plugins-x264 \
# media-plugins/gst-plugins-x265 \
#    media-libs/gst-plugins-ugly \
#    media-libs/gst-plugins-bad \

# VIDEO
add \
    media-video/mpv \
    media-video/shotcut \
    media-video/ffmpegthumbnailer \
    net-misc/yt-dlp \
    media-video/v4l2loopback \
    media-video/obs-studio

# AUDIO
add \
    app-cdr/cuetools \
    media-sound/alsa-utils \
    media-libs/alsa-ucm-conf \
    media-plugins/alsa-plugins \
    media-sound/pavucontrol \
    media-sound/shntool \
    media-sound/vorbis-tools \
    media-sound/wavpack

# ARCHIVE
add \
    app-arch/p7zip \
    app-arch/unrar \
    app-arch/unzip \
    app-arch/zip

# PYTHON
add \
    dev-python/pip \
    dev-python/setuptools \
    dev-python/pylint

# GENTOO-SPECIFIC
add \
    app-eselect/eselect-python \
    app-eselect/eselect-repository \
    app-portage/gentoolkit \
    app-portage/portage-utils

# PRINTING
add \
    net-print/cups \
    net-print/cups-filters \
    net-print/cups-pdf \
    net-print/hplip

# NETWORKING
add \
    net-analyzer/openbsd-netcat \
    net-analyzer/nmap \
    net-analyzer/wireshark \
    net-analyzer/speedtest-cli \
    net-dns/bind-tools \
    net-misc/curl \
    net-misc/dhcpcd \
    net-misc/rdesktop \
    net-misc/socat \
    net-vpn/openvpn \
    net-vpn/wireguard-tools \
    net-wireless/bluez \
    net-wireless/bluez-tools \
    media-sound/bluez-alsa \
    sys-apps/ethtool \
    net-dns/dnsmasq \
    net-libs/ldns

# misc
add \
    app-misc/dateutils

# DRIVERS / FIRMWARE
add \
    x11-base/xorg-drivers \
    x11-drivers/xf86-input-libinput \
    sys-firmware/sof-firmware

# MISC
add \
    app-misc/toilet \
    app-i18n/translate-shell \
    app-text/pandoc-bin

# INTERNET / OFFICE
add \
    net-misc/nextcloud-client
####    app-office/libreoffice-bin

# MAILSPRING
eselect repository enable edgets
emerge --sync edgets
add mailspring

# PROPRIETARY
add \
    net-im/discord \
    media-sound/spotify

# LIBS
add \
    dev-cpp/nlohmann_json

LLVM / Clang / lld
add \
    sys-devel/clang \
    sys-devel/llvm \
    sys-devel/lld

# nodejs-bin
# eselect repository enable broverlay
# emerge --sync broverlay
# add nodejs-bin

# add \
# anki-bin

# ===============================================================================
# OLD WORLD
# ===============================================================================
