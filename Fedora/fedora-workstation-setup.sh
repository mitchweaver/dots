#!/usr/bin/env bash

# ===================================================================
# initial setup
# ===================================================================

# make dnf not suck as much
if ! grep fastestmirror=1 /etc/dnf/dnf.conf >/dev/null ; then
cat >> /etc/dnf/dnf.conf <<EOF
fastestmirror=1
max_parallel_downloads=15
deltarpm=true
EOF
fi

dnf upgrade --refresh
dnf check
dnf autoremove
dnf install -y rpm-build


# ------------ firmware ---------------------
printf '%s' "Upgrade firmware? (y/n):"
read -r ans
case $ans in
	y)
		fwupdmgr get-devices
		fwupdmgr refresh --force
		fwupdmgr get-updates
		fwupdmgr update
		;;
	*)
		>&2 echo "Skipping"
esac
# -------------------------------------------

# ===================================================================
# repos
# ===================================================================
dnf install -y  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf upgrade --refresh
dnf groupupdate core
dnf install -y rpmfusion-free-release-tainted
dnf install -y dnf-plugins-core distribution-gpg-keys

# ===================================================================
# gnome
# ===================================================================
dnf install -y \
	gnome-tweaks gconf-editor gnome-extensions-app \
	gnome-shell-extension-appindicator \
	gnome-shell-extension-caffeine \
	gnome-shell-extension-dash-to-dock \
	gnome-shell-extension-dash-to-panel \
	gnome-shell-extension-user-theme \
	gnome-shell-extension-no-overview \
	gnome-shell-extension-frippery-move-clock \
	gnome-shell-theme-flat-remix \
	gnome-shell-extension-screenshot-window-sizer \
	gnome-screenshot \
	gnome-shell-extension-blur-my-shell \
	gnome-shell-extension-background-logo \
	gnome-shell-extension-gamemode \
	gnome-shell-extension-just-perfection \
	gnome-shell-extension-openweather \
	gnome-shell-extension-workspace-indicator

# ===================================================================
# sway
# ===================================================================
#dnf install -y \
#	wlroots sway sway-systemd
	# swaybg swayidle swaylock
	# grim grimshot slurp waybar wlsunset
	# wofi

# ===================================================================
# packages
# ===================================================================
# dev stuff
yum groupinstall -y "Development Tools"
dnf install -y \
	git git-lfs make neovim python3-neovim jq \
	patch tmux docker docker-compose pylint \
	ShellCheck autoconf automake oksh \
	gawk gdb ruby perl \
	python3-setuptools \
	python3-pip \
	python3-pylint \
	python3-docker \
	golang \
	hugo

pip3 install --upgrade pip

# archive
dnf install -y pigz zip unzip unrar p7zip

# system
dnf install -y \
	util-linux-user htop detox \
	inotify-tools lm_sensors hwinfo lshw \
	lsof kitty kitty-bash-integration

# security
dnf install -y \
	firejail fail2ban clamav clamav-data clamav-update

systemctl enable fail2ban
systemctl start fail2ban
systemctl enable sshd
systemctl start sshd

# misc
dnf install -y pv progress tree neofetch slop translate-shell exa \
	xsel xclip xset ncdu diceware hdparm iozone gocr toilet

# networking
dnf install -y \
	openssh-server openssh openvpn rdesktop rsync wget \
	curl wireshark net-tools nmap netcat speedtest-cli \
	tigervnc dnsutils bluez bluez-libs bluez-tools \
	openssl w3m socat dnstop

# media
dnf install -y \
	ImageMagick ffmpeg ffmpegthumbnailer youtube-dl \
	jpegoptim mpv

# fonts
dnf install -y \
	mkfontdir \
	mkfontscale \
	terminus-fonts \
	unifont \
	fira-code-fonts \
	levien-inconsolata-fonts \
	google-noto-cjk-fonts \
	google-noto-emoji-fonts \
	google-noto-emoji-color-fonts \
	google-roboto-mono-fonts \
	google-roboto-fonts \
	roboto-fontface-fonts \
	ibm-plex-mono-fonts \
	dejavu-sans-fonts \
	dejavu-sans-mono-fonts

dnf copr enable peterwu/iosevka -y
dnf install -y \
	iosevka-term-fonts \
	iosevka-fonts

# load fonts after
fc-cache -vf

dnf install -y cabextract xorg-x11-font-utils fontconfig
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

# audio/video codecs
dnf groupupdate sound-and-video
dnf install -y libdvdcss
dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg 
dnf install -y lame\* --exclude=lame-devel
dnf group upgrade --with-optional Multimedia
dnf config-manager --set-enabled fedora-cisco-openh264
dnf install -y gstreamer1-plugin-openh264 mozilla-openh264

sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y

# for platform specific see:
# https://rpmfusion.org/Howto/Multimedia

# printing
dnf install -y cups cups-client cups-lpd cups-pdf
systemctl enable cups
systemctl start cups

# sound
dnf install -y pipewire-pulseaudio pulseaudio-utils pavucontrol pipewire-devel

# ===================================================================
# user space
# ===================================================================
dnf install -y \
	ranger \
	mpv \
	shntool \
	cuetools \
	flac \
	wavpack \
	vorbis-tools \
	libreoffice \
	obs-studio \
	v4l2loopback \
	shotcut \
	xournal \
	redshift \
	nextcloud-client \
	pcmanfm \
        ranger

# evince \
# evince-thumbnailer \
# evince-previewer

# ===================================================================
# i3 rice
# ===================================================================
# dnf install -y \
# 	dunst \
# 	picom \
# 	i3 \
# 	i3lock \
# 	polybar

# dnf copr enable linuxredneck/xwallpaper -y
# dnf update
# dnf install -y xwallpaper

# dnf install -y lpf-spotify-client
# lpf update
# rpm -i /root/rpmbuild/RPMS/x86_64/spotify-client*.rpm

# ===================================================================
# devices
# ===================================================================
# for logitech mice dpi control
dnf install -y libratbag-ratbagd

# ===================================================================
# build crap
# ===================================================================
dnf install -y ninja-build samurai cmake libtool yasm automake autoconf

# ===================================================================
# libraries
# ===================================================================
dnf install -y \
    libcxx \
    libcxx-devel \
    libcxxabi \
    libcxxabi-devel \
    libatomic \
    freetype \
    freetype-devel \
    pixman \
    pixman-devel \
    xcb-util-devel \
    xcb-util-image-devel \
    libXft-devel \
    libXinerama-devel \
    libXrandr \
    libXrandr-devel \
    libjpeg-devel \
    turbojpeg-devel \
    harfbuzz-devel \
    fontconfig \
    libX11-devel \
    libXrandr-devel \
    libvdpau-devel \
    libva-devel \
    mesa-libGL-devel \
    mesa-libEGL-devel \
    alsa-lib-devel \
    pulseaudio-libs-devel \
    libchardet-devel \
    uchardet \
    zlib-devel \
    zlib-ng-devel \
    zlibrary-devel \
    fribidi-devel \
    gnutls-devel \
    SDL2-devel \
    qt5-qtwebengine-devel \
    qt5-qtquickcontrols2-devel \
    qt5-qtx11extras-devel \
    libcec-devel \
    gstreamer1-plugins-good-qt \
    qt5-qtbase-private-devel \
    glibc-devel \
    libXcursor-devel \
    libbsd \
    libbsd-devel

# ===================================================================
# xorg stuff (not applicable on wayland)
# ===================================================================
dnf install -y xhost xbanish xdotool xterm xbacklight xsetroot xinput arandr sxhkd xautolock
# xdimmer

# cd /tmp
# git clone https://github.com/yvbbrjdr/i3lock-fancy-rapid
# cd i3lock-fancy-rapid
# make
# install -D -m 0755 i3lock-fancy-rapid /usr/local/bin/i3lock-fancy-rapid

# ===================================================================
# firefox
# ===================================================================
#if ! command -v firefox-nightly >/dev/null 2>&1 ; then
#	sudo dnf remove -y firefox
#	sudo dnf copr enable proletarius101/firefox-nightly -y
#	sudo dnf update -y
#	sudo dnf install -y firefox-nightly
#	mkdir -p /usr/local/bin
#	ln -sf "$(which firefox-nightly)" /usr/local/bin/firefox
#fi

# ===================================================================
# non-repo packages
# ===================================================================
if ! command -v pfetch >/dev/null 2>&1 ; then
	git clone https://github.com/dylanaraps/pfetch /tmp/pfetch
	sudo install -D -m 0755 /tmp/pfetch/pfetch /usr/local/bin/pfetch
	rm -rf /tmp/pfetch
fi

if ! command -v gotop >/dev/null 2>&1 ; then
	wget https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_linux_amd64.rpm -O /tmp/gotop_v4.2.0_linux_amd64.rpm
	rpm -i /tmp/gotop_v4.2.0_linux_amd64.rpm
	rm /tmp/gotop_v4.2.0_linux_amd64.rpm
fi

# ===================================================================
# snaps
# ===================================================================
#if ! command -v snap >/dev/null 2>&1 || ! [ -e /snap ] ; then
#	dnf install -y snapd
#	ln -s /var/lib/snapd/snap /snap
#fi

# wayland stuff
######swaybg wofi waybar xorg-x11-server-Xwayland grim slurp qt6-qtwayland

# themes
dnf install -y \
	paper-icon-theme \
	papirus-icon-theme \
	lxappearance \
	arc-theme

# budgie
# dnf install -y \
# 	budgie-control-center \
# 	budgie-desktop-defaults \
# 	budgie-desktop-view \
# 	budgie-screensaver \
# 	budgie-desktop


# dnf copr enable taw/joplin
# dnf update
# dnf install -y joplin


dnf install -y nextcloud-client

# kdiskmark

# enable flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# logitech mice
dnf install -y \
	libratbag-ratbagd


# gimp stuff
dnf install -y \
	gimp gimp-lensfun gimp-lqr-plugin

# wayland import alternative
dnf install -y \
	grim

# vscodium
sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF

dnf upgrade --refresh
dnf install -y codium

