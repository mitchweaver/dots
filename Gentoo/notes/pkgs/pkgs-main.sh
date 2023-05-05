#!/bin/sh

add() {
    emerge --verbose --noreplace "$@"
}

# initial install / GentooLTO setup
add \
    sys-apps/busybox \
    dev-vcs/git \
    eselect-repository \
    app-admin/sudo \
    sys-kernel/genkernel \
    sys-kernel/linux-firmware

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
    dev-python/pillow

# system utils
add \
    sys-process/htop  \
    app-misc/ranger \
    sys-apps/exa \
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
    app-text/dos2unix

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
    media-gfx/gimp \
    media-gfx/imagemagick \
    media-gfx/jpegoptim \
    media-libs/exiftool \
    media-plugins/gimp-lqr

# VIDEO
add \
    media-video/mpv \
    media-video/shotcut \
    media-video/ffmpegthumbnailer \
    net-misc/yt-dlp \
    media-video/v4l2loopback \
    media-plugins/gst-plugins-v4l2 \
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
    app-eselect/eselect-repository

# PRINTING
add \
    net-print/cups \
    net-print/cups-filters \
    net-print/cups-pdf \
    net-print/hplip

# NETWORKING
add \
    net-analyzer/netcat \
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
    net-wireless/bluez-alsa \
    sys-apps/ethtool

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

# FONTS
add \
    x11-apps/mkfontscale \
    media-libs/fontconfig \
    media-fonts/font-util \
    media-fonts/fontawesome \
    media-fonts/liberation-fonts \
    media-fonts/noto \
    media-fonts/noto-cjk \
    media-fonts/noto-emoji \
    media-fonts/roboto \
    media-fonts/terminus-font

# RICE
add \
    lxde-base/lxappearance

# INTERNET / OFFICE
add \
    net-misc/nextcloud-client \
    app-office/libreoffice-bin

# THEMES
add \
    x11-themes/arc-theme

eselect repository enable 4nykey
emerge --sync 4nykey
add x11-themes/papirus-icon-theme

eselect repository enable tastytea
emerge --sync tastytea
add x11-themes/paper-icon-theme

eselect repository enable edgets
emerge --sync edgets
add x11-themes/materia-theme

# MAILSPRING
eselect repository enable kzd
eselect repository enable edgets
emerge --sync kzd
emerge --sync edgets
add mailspring

# PROPRIETARY
add \
    net-im/discord \
    media-sound/spotify

# node
eselect repository enable broverlay
emerge --sync broverlay
add nodejs-bin

# ===============================================================================
# OLD WORLD
# ===============================================================================


