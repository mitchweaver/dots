# cant find?
#
# translate-shell
# swappy
#
# pending:
# nwg-look
# html-tidy (mailspring)
#
#
# not available:
# mailspring
#
# ? pavucontrol
#
# fail2ban
#
# dnsmasq ??
#
# cifs utils/samba?
#
# libnfs?
#
# redshift?
#
# wl-clipboard cliphist waybar
# ========================================================================

add() {
    pkg_add "$@"
}

# office
add \
    firefox tor-browser libreoffice thuanr mupdf zathura zathura-pdf-mupdf nextcloud

# sys tools
add \
    htop pv pciutils usbutils smartmontools dosfstools exfat-fuse ntfs_3g upower

# archive
add \
    p7zip unzip unrar

# development
add \
    neovim py3-neovim git got hugo pylint3 shellcheck rust

# libraries
add \
    libsecret nlohmann-json py3-numpy py3-scipy libldns libnotify \
    gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-rs gst-plugins-ugly \
    x264 x265

# scripting tools
add \
    jq entr dateutils detox figlet dos2unix pandoc libqrencode inotify-tools

# networking
add \
    rsync curl wget nmap socat ldns-utils \
    wireshark speedtest-cli rdesktop \
    tor torsocks wireguard-tools

# misc terminal userland
add \
    kitty ranger neofetch tree bat eza dictd-server dict-client w3m

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
    lxappearance dunst thunar thunar-media-tags tumbler \
    xwallpaper

# ========================================================================
############### wayland
############### add \
###############     wayland-protocols wlr-randr glfw \
###############     grim slurp
##################    sway swaybg swayidle swaylock
# ========================================================================

# fonts
add \
    liberation-fonts terminus-nerd-fonts noto-nerd-fonts noto-emoji noto-cjk spleen

# themes
add \
    arc-icon-theme paper-gtk-theme paper-icon-theme papirus-icon-theme

# printing
add \
    cups cups-libs hplip

# package/port building
add \
     ninja meson metaauto autoconf automake cmake gmake gpatch

#### dwz jsoncpp catch2 scdoc help2man python-tkinter

