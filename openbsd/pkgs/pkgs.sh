# cant find?
#
# translate-shell
# swappy
#
# cifs utils/samba?
#
# libnfs?
#
# redshift?
#
# wl-clipboard cliphist waybar
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

# libraries
add \
    libsecret nlohmann-json py3-numpy py3-scipy libldns libnotify \
    gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-rs gst-plugins-ugly \
    x264 x265

# scripting tools
add \
    jq entr dateutils detox gawk dos2unix pandoc libqrencode inotify-tools \
    figlet 

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

# X11
add \
    xdotool xwallpaper xbanish xdimmer \
    dunst picom sct slop \
    lxappearance pavucontrol

#  pcmanfm-qt
############ thunar thunar-media-tags tumbler

# maybe replace with redshift: sct

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
# add \
#     ninja meson metaauto autoconf automake cmake gmake gpatch \
#     rust dwz jsoncpp catch2 scdoc help2man python-tkinter

# wireshark
# ldns-utils

# ========================================================================
# wayland is very WIP/buggy on OpenBSD not recommended
#
#
############### wayland
############### add \
###############     wayland-protocols wlr-randr glfw \
###############     grim slurp
##################    sway swaybg swayidle swaylock
# ========================================================================


######## dictd-server dict-client

