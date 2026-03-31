# cant find?
#
# translate-shell
# swappy
#
# cifs utils/samba?
#
# libnfs?
#
# gnome-keyring?
# ========================================================================

add() {
    pkg_add -D snap "$@"
}

# office
add \
    firefox tor-browser libreoffice mupdf zathura zathura-pdf-mupdf nextcloudclient

# sys tools
add \
    htop pv pciutils usbutils smartmontools dosfstools exfat-fuse ntfs_3g

# archive
add \
    p7zip unzip unrar

# development
add \
    neovim py3-neovim git got hugo pylint3 shellcheck

# languages
##### add \
########## go rust zig

# libraries
add \
    libsecret nlohmann-json py3-numpy py3-scipy libldns libnotify \
    gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-rs gst-plugins-ugly \
    x264 x265

# scripting tools
add \
    jq entr dateutils detox gawk dos2unix pandoc libqrencode inotify-tools \
    figlet fmt

# networking
add \
    rsync curl wget nmap socat \
    speedtest-cli rdesktop \
    tor torsocks wireguard-tools

# misc terminal userland
add \
    kitty ranger neofetch tree bat eza w3m

# image
add \
    gimp gimp-lqr-plugin ImageMagick jpegoptim p5-Image-ExifTool

# video
add \
    mpv ffmpeg ffmpegthumbnailer shotcut yt-dlp

# audio
add \
    cuetools shntool vorbis-tools wavpack

# thunar
add \
    thunar thunar-media-tags tumbler

# fonts
add \
    liberation-fonts terminus-nerd-fonts noto-nerd-fonts noto-emoji noto-cjk spleen

# themes
add \
    arc-icon-theme arc-theme-solid paper-gtk-theme paper-icon-theme papirus-icon-theme

# printing
add \
    cups cups-libs hplip

# common package/port building deps
add \
    ninja meson metaauto autoconf automake libtool intltool cmake gmake gpatch \

# less common but still common:
#     dwz jsoncpp catch2 scdoc help2man python-tkinter spdlog gettext-tools vala libdbusmenu

# wireshark
# ldns-utils

# X11+Wayland
add \
    xdotool xbanish dunst lxappearance pavucontrol

###### X11 ONLY ------- sct xdimmer xwallpaper picom slop 

# ========================================================================
# Note: wayland is very WIP/buggy on OpenBSD
add \
    wayland-protocols wlr-randr wl-clipboard \
    glfw grim slurp \
    sway swaybg swayidle swaylock
# ========================================================================

######## dictd-server dict-client

