#!/bin/sh

add() {
    emerge -av --noreplace --update --verbose-conflicts "$@" || return 1
}

# ======= overlays ========================
eselect repository enable guru
emerge --sync guru

eselect repository enable edgets
emerge --sync edgets
# =========================================

# most important must be installed first
add \
    sys-devel/mold


# GENTOO-SPECIFIC
add \
    app-eselect/eselect-python \
    app-eselect/eselect-repository \
    app-portage/gentoolkit \
    app-portage/portage-utils \
    sys-block/zram-init

# SYSTEM DAEMONS
add \
    app-admin/sysklogd \
    sys-process/cronie \
    net-misc/openntpd

# system utils
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
    sys-devel/bc

# ARCHIVE
add \
    app-arch/p7zip \
    app-arch/unrar \
    app-arch/unzip \
    app-arch/zip \
    app-arch/lz4 \
    app-arch/xz-utils

# FILESYSTEM
add \
    sys-fs/dosfstools \
    sys-fs/ntfs3g \
    net-fs/nfs-utils \
    net-fs/libnfs

# ========================================
# if using samba instead of nfs
######################net-fs/cifs-utils \
######################net-fs/samba \
# ========================================

# MISC SYSTEM LIBS
add \
    x11-libs/libnotify \
    app-crypt/libsecret \
    dev-python/numpy \
    dev-python/scipy \
    dev-cpp/nlohmann_json

# NETWORKING
add \
    net-analyzer/openbsd-netcat \
    net-analyzer/nmap \
    net-analyzer/speedtest-cli \
    net-dns/bind-tools \
    net-dns/dnsmasq \
    net-misc/curl \
    net-misc/dhcpcd \
    net-misc/socat \
    net-misc/rdesktop \
    net-vpn/wireguard-tools \
    net-wireless/bluez \
    net-wireless/bluez-tools \
    media-sound/bluez-alsa \
    sys-apps/ethtool \
    net-libs/ldns

# scripting utilities
add \
    app-admin/entr \
    app-misc/detox \
    app-text/dos2unix \
    sys-fs/inotify-tools \
    app-misc/dateutils \
    media-gfx/qrencode

############## wireless (if laptop)
# add \
#     net-wireless/iw \
#     net-wireless/wireless-tools \
#     net-wireless/wpa_supplicant

# terminal userland
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
    www-client/w3m

# misc legacy x11 stuff
add \
    x11-apps/xrdb \
    x11-apps/xrandr

# terminal userland needed libraries
add \
    dev-python/pynvim

# development
add \
    dev-util/shellcheck-bin \
    app-containers/docker \
    app-containers/docker-compose \
    app-misc/jq \
    dev-python/pylint \
    www-apps/hugo

# security
add \
    net-analyzer/fail2ban

###################    sys-apps/flatpak

# wayland  utils
add \
    gui-libs/egl-wayland \
    gui-apps/grim \
    gui-apps/slurp \
    x11-misc/gammastep \
    sys-power/acpilight

# GFX
add \
    media-gfx/gimp \
    media-gfx/imagemagick \
    media-gfx/jpegoptim \
    media-libs/exiftool

# VIDEO
add \
    media-video/mpv \
    media-video/ffmpeg \
    media-video/ffmpegthumbnailer \
    net-misc/yt-dlp \
    media-video/obs-studio \
    media-video/shotcut

# video libraries
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

# AUDIO
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

# large binaries
add \
    dev-java/openjdk-jre-bin \
    app-office/libreoffice-bin

# office
add \
    www-client/firefox \
    net-misc/nextcloud-client \
    mail-client/mailspring \
    app-text/htmltidy \
    app-office/joplin-desktop

# PRINTING
add \
    net-print/cups \
    net-print/cups-filters \
    net-print/cups-pdf \
    net-print/hplip

# FONTS
add \
    app-misc/figlet \
    x11-apps/mkfontscale \
    media-libs/fontconfig \
    media-fonts/font-util \
    media-fonts/fontawesome \
    media-fonts/liberation-fonts \
    media-fonts/noto \
    media-fonts/noto-cjk \
    media-fonts/noto-emoji \
    media-fonts/roboto \
    media-fonts/terminus-font \
    media-fonts/dejavu \
    media-fonts/hack \
    media-fonts/ibm-plex \
    media-fonts/nerdfonts \
    media-fonts/unifont \
    media-fonts/spleen

# SWAY
add \
    gui-wm/swayfx \
    gui-apps/swaybg \
    gui-apps/swayidle \
    gui-apps/swaylock \
    gui-libs/xdg-desktop-portal-wlr \
    gui-apps/wl-clipboard \
    gui-apps/waybar \
    gui-apps/mako

# misc userland
add \
    x11-misc/pcmanfm \
    app-misc/neofetch \
    app-text/mupdf

# firmware
add \
    sys-kernel/linux-firmware \
    sys-firmware/alsa-firmware \
    sys-firmware/sof-firmware

# themes
add \
     lxde-base/lxappearance \
     x11-themes/arc-theme \
     x11-themes/arc-icon-theme \
     x11-themes/vanilla-dmz-xcursors

# lightdm
add \
     gui-libs/display-manager-init \
     x11-misc/lightdm

# # my ebuilds
# add \
#     app-shells/oksh

#################### proprietary
###################add \
###################    net-im/discord

#     app-text/zathura \
#     app-text/zathura-meta

