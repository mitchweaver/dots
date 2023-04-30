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
    sys-devel/gdb \
    app-misc/jq \
    www-apps/hugo \
    x11-terms/kitty \
    x11-terms/kitty-shell-integration \
    x11-terms/kitty-terminfo

# system utils
add \
    htop  \
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
    sys-apps/ripgrep \
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
    media-video/obs-studio \
    net-misc/yt-dlp

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
    app-arch/pigz \
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
    net-vpn/openvpn \
    net-vpn/wireguard-tools \
    net-analyzer/netcat \
    net-analyzer/nmap \
    net-dns/bind-tools \
    net-misc/curl \
    net-misc/dhcpcd \
    net-misc/rdesktop \
    net-misc/socat \
    net-analyzer/wireshark \
    sys-apps/ethtool \
    net-wireless/bluez \
    net-wireless/bluez-tools

# DRIVERS / FIRMWARE
add \
    x11-base/xorg-drivers \
    x11-drivers/xf86-input-libinput \
    sys-firmware/sof-firmware \
    dev-libs/libratbag

# MISC
add \
    app-misc/toilet \
    app-i18n/translate-shell

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
    app-office/libreoffice-bin \
    www-client/firefox-bin \
    www-client/chromium-bin

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

# ===============================================================================
# OLD WORLD
# ===============================================================================

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# X11 Stuff
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# add \
#     x11-apps/xhost \
#     x11-apps/xinput \
#     x11-apps/xmodmap \
#     x11-apps/xrandr \
#     x11-misc/redshift \
#     x11-misc/sxhkd \
#     x11-misc/xautolock \
#     x11-misc/xbanish \
#     x11-misc/xclip \
#     x11-misc/xdotool \
#     x11-misc/xsel \
#     x11-misc/xwallpaper \
#     x11-misc/slop
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# i3 Rice Stuff
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# x11-wm/i3-gaps
# x11-misc/dunst
# x11-misc/parcellite
# x11-misc/pcmanfm
# x11-misc/picom
# x11-misc/polybar
# x11-misc/lightdm
# x11-misc/i3lock-fancy-rapid
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

