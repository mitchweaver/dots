#!/bin/sh

add() {
    emerge -av --noreplace --update --verbose-conflicts "$@" || return 1
}

# ========================================================================
# overlays
# ========================================================================
# if ! grep eselect-repository /var/lib/portage/world >/dev/null ; then
# 	add eselect-repository
# fi

for repo in guru edgets pf4public tastytea librewolf ; do
    # if ! grep $repo /etc/portage/repos.conf/eselect-repo.conf >/dev/null ; then
    eselect repository enable $repo
    emerge --sync $repo
    # fi
done

# ========================================================================
# must be installed first
# ========================================================================
if ! command -v mold >/dev/null ; then
    add sys-devel/mold
fi

add \
    app-admin/bitwarden-desktop-bin \
    app-admin/doas \
    app-admin/entr \
    app-admin/sudo \
    app-admin/sysklogd \
    app-admin/sysstat \
    app-alternatives/bzip2 \
    app-alternatives/cpio \
    app-alternatives/gzip \
    app-alternatives/lzip \
    app-alternatives/ninja \
    app-alternatives/sh \
    app-alternatives/tar \
    app-antivirus/clamav \
    app-arch/lz4 \
    app-arch/p7zip \
    app-arch/unrar \
    app-arch/unzip \
    app-arch/xz-utils \
    app-arch/zip \
    app-cdr/cuetools \
    app-containers/docker \
    app-containers/docker-compose \
    app-crypt/libsecret \
    app-dicts/dictd-gcide \
    app-editors/neovim \
    app-eselect/eselect-python \
    app-eselect/eselect-repository \
    app-i18n/translate-shell \
    app-misc/nwg-look \
    app-misc/dateutils \
    app-misc/detox \
    app-misc/figlet \
    app-misc/jq \
    app-misc/neofetch \
    app-misc/ranger \
    app-office/joplin-desktop \
    app-office/libreoffice \
    app-portage/gentoolkit \
    app-portage/portage-utils \
    app-shells/oksh \
    app-text/dictd \
    app-text/dos2unix \
    app-text/htmltidy \
    app-text/mupdf \
    app-text/tree \
    app-text/zathura \
    app-text/zathura-meta \
    app-text/pandoc-cli \
    dev-cpp/nlohmann_json \
    dev-lang/rust \
    dev-lang/go \
    dev-libs/lzo \
    dev-python/numpy \
    dev-python/pylint \
    dev-python/pynvim \
    dev-python/scipy \
    dev-util/shellcheck \
    dev-vcs/git \
    gui-apps/grim \
    gui-apps/slurp \
    gui-apps/swappy \
    gui-libs/egl-wayland \
    lxde-base/lxappearance \
    mail-client/mailspring \
    media-fonts/font-util \
    media-fonts/liberation-fonts \
    media-fonts/nerdfonts \
    media-fonts/noto \
    media-fonts/noto-cjk \
    media-fonts/noto-emoji \
    media-fonts/spleen \
    media-fonts/unifont \
    media-fonts/fontawesome \
    media-gfx/gimp \
    media-gfx/imagemagick \
    media-gfx/jpegoptim \
    media-gfx/qrencode \
    media-libs/alsa-ucm-conf \
    media-libs/exiftool \
    media-libs/fontconfig \
    media-libs/gst-plugins-bad \
    media-libs/gst-plugins-good \
    media-libs/gst-plugins-ugly \
    media-libs/x264 \
    media-libs/x265 \
    media-plugins/gst-plugins-meta \
    media-plugins/gimp-lqr \
    media-plugins/alsa-plugins \
    media-plugins/gst-plugins-v4l2 \
    media-plugins/gst-plugins-x264 \
    media-plugins/gst-plugins-x265 \
    media-plugins/gst-plugins-vpx \
    media-plugins/gst-plugins-opus \
    media-plugins/gst-plugins-mpg123 \
    media-plugins/gst-plugins-flac \
    media-sound/alsa-utils \
    media-sound/bluez-alsa \
    media-sound/pavucontrol \
    media-sound/shntool \
    media-sound/supersonic \
    media-sound/tenacity \
    media-sound/vorbis-tools \
    media-sound/wavpack \
    media-video/ffmpeg \
    media-video/ffmpegthumbnailer \
    media-video/mpv \
    media-video/obs-studio \
    media-video/shotcut \
    media-video/v4l2loopback \
    media-video/x264-encoder \
    net-analyzer/fail2ban \
    net-analyzer/nmap \
    net-analyzer/openbsd-netcat \
    net-analyzer/speedtest-cli \
    net-analyzer/wireshark \
    net-dns/bind-tools \
    net-dns/dnsmasq \
    net-dns/openresolv \
    net-firewall/nftables \
    net-fs/cifs-utils \
    net-fs/libnfs \
    net-fs/nfs-utils \
    net-fs/samba \
    net-libs/ldns \
    net-libs/nodejs \
    net-misc/chrony \
    net-misc/curl \
    net-misc/dhcpcd \
    net-misc/nextcloud-client \
    net-misc/rdesktop \
    net-misc/socat \
    net-misc/yt-dlp \
    net-misc/yt-dlp \
    net-print/cups \
    net-print/cups-filters \
    net-print/cups-pdf \
    net-print/hplip \
    net-proxy/torsocks \
    net-vpn/mullvadvpn-app \
    net-vpn/tor \
    net-vpn/wireguard-tools \
    net-wireless/bluez \
    net-wireless/bluez-tools \
    net-wireless/blueman \
    sys-apps/bat \
    sys-apps/ethtool \
    sys-apps/eza \
    sys-apps/flatpak \
    sys-apps/lm-sensors \
    sys-apps/pciutils \
    sys-apps/progress \
    sys-apps/pv \
    sys-apps/smartmontools \
    sys-apps/usbutils \
    sys-auth/rtkit \
    sys-block/zram-init \
    sys-devel/bc \
    sys-devel/dwz \
    sys-firmware/alsa-firmware \
    sys-firmware/sof-firmware \
    sys-fs/dosfstools \
    sys-fs/exfat-utils \
    sys-fs/inotify-tools \
    sys-fs/ncdu \
    sys-fs/ntfs3g \
    sys-kernel/linux-firmware \
    sys-power/upower \
    sys-process/cronie \
    sys-process/htop  \
    sys-process/lsof \
    www-apps/hugo \
    www-client/librewolf \
    www-client/torbrowser-launcher \
    www-client/w3m \
    x11-apps/mkfontscale \
    x11-apps/xev \
    x11-apps/xrandr \
    x11-apps/xrdb \
    x11-libs/libnotify \
    x11-terms/kitty \
    x11-themes/arc-icon-theme \
    x11-themes/arc-theme \
    x11-themes/paper-icon-theme \
    x11-themes/papirus-icon-theme \
    x11-themes/vanilla-dmz-xcursors

#### net-im/signal-desktop-bin

# broken?
#####sci-ml/ollama

