#!/bin/sh

add() {
    apk update
    apk add "$@"
}

# MISSING:
# dictd dictd-gcide mullvad-app tenacity
# signal supersonic

# ========================================================================
# APK SETUP
# ========================================================================
cat >/etc/apk/repositories <<EOF
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF

apk update
apk upgrade

# ========================================================================
# META PACKAGES
# ========================================================================
apk add docs

# ========================================================================
# NON-BUSYBOX / GNU
# ========================================================================
apk add coreutils binutils findutils grep util-linux util-linux-login \
    iproute2 gawk chrony

# ========================================================================
# KERNEL / DEVICE SPECIFIC
# ========================================================================
# uncomment for intel/amd cpu
##### apk add intel-ucode amd-ucode
##### apk add intel-media-driver libva-intel-driver mesa-vulkan-intel xf86-video-intel

# ========================================================================
# SYSTEM DAEMONS
# ========================================================================
apk add zram-init

# ========================================================================
# SYSTEM UTILS
# ========================================================================
apk add doas sudo bc htop lsof lm-sensors pciutils usbutils \
    smartmontools sysstat upower git

# ========================================================================
# ARCHIVE
# ========================================================================
apk add p7zip unzip zip lz4 xz lzo

# ========================================================================
# FILESYSTEM
# ========================================================================
apk add samba-client dosfstools exfat-utils cifs-utils ntfs-3g

# ========================================================================
# MISC SYSTEM LIBS
# ========================================================================
apk add libnotify libsecret py3-numpy py3-scipy nlohmann-json

# ========================================================================
# NETWORKING
# ========================================================================
apk add rsync openresolv netcat-openbsd nmap bind-tools \
    dnsmasq curl dhcpcd socat rdesktop ldns wireless-tools iw \
    ethtool speedtest-cli \
    bluez bluez-tools bluez-alsa pipewire-spa-bluez blueman \
    tor torsocks

# ========================================================================
# SCRIPTING UTILS
# ========================================================================
apk add entr detox dos2unix inotify-tools dateutils libqrencode w3m lynx

# ========================================================================
# TERMINAL USERLAND
# ========================================================================
apk add oksh kitty kitty-kitten neovim ranger translate-shell tree pv \
    progress eza bat py3-pynvim ncdu

# ========================================================================
# LEGACY X11
# ========================================================================
setup-xorg-base
setup-wayland-base
apk add x11-apps/xrandr x11-apps/xev

# ========================================================================
# DEVELOPMENT
# ========================================================================
apk add build-base gcc patch musl-dev meson ninja shellcheck jq \
    nodejs openjdk25-jre py3-pylint py3-setuptools hugo sassc cargo go

# ========================================================================
# DEV LIBS
# ========================================================================
apk add linux-headers ncurses-dev libx11-dev libxinerama-dev libxft-dev \
    eudev-dev elfutils-dev openssl-dev

# ========================================================================
# SECURITY
# ========================================================================
apk add fail2ban clamav flatpak wireguard-tools

# ========================================================================
# WAYLAND UTILS
# ========================================================================
apk add wayland-libs-egl grim slurp agammastep brightnessctl

# ========================================================================
# GFX
# ========================================================================
apk add imagemagick jpegoptim exiftool

# ========================================================================
# VIDEO
# ========================================================================
apk add mpv ffmpeg ffmpegthumbnailer yt-dlp

# ========================================================================
# VIDEO LIBRARIES
# ========================================================================
apk add x264 x265 mesa mesa-dri-gallium \
    gst-plugins-base gst-plugins-good \
    gst-plugins-bad gst-plugins-ugly

# ========================================================================
# AUDIO
# ========================================================================
apk add pipewire pipewire-pulse pipewire-alsa wireplumber \
    cuetools alsa-utils alsa-ucm-conf alsa-plugins pavucontrol \
    shntool vorbis-tools wavpack rtkit

# ========================================================================
# PRINTING
# ========================================================================
apk add cups cups-filters cups-pdf hplip

# ========================================================================
# FONTS
# ========================================================================
apk add figlet mkfontscale fontconfig font-util font-spleen \
    font-noto font-noto-cjk font-noto-emoji font-liberation font-unifont \
    font-terminus-nerd font-ibm-plex-mono-nerd font-hack-nerd \
    font-share-tech-mono-nerd

# ========================================================================
# MISC USERLAND
# ========================================================================
apk add neofetch mupdf zathura zathura-pdf-mupdf

# ========================================================================
# FIRMWARE
# ========================================================================
apk add linux-firmware bluez-firmware sof-firmware

# ========================================================================
# THEMES
# ========================================================================
apk add nwg-look lxappearance \
    arc-icon-theme papirus-icon-theme paper-icon-theme \
    arc-theme materia-gtk-theme paper-gtk-theme

# ========================================================================
# BIG APPLICATIONS
# ========================================================================
apk add librewolf libreoffice wireshark nextcloud-client \
    gimp obs-studio shotcut flatpak

# ========================================================================
# SWAY
# ========================================================================
apk add sway swaybg swayidle swaylock swaysome \
    xwayland xdg-desktop-portal xdg-desktop-portal-wlr \
    seatd eudev elogind \
    wl-clipboard cliphist waybar dunst \
    thunar thunar-media-tags-plugin thunar-archive-plugin tumbler


