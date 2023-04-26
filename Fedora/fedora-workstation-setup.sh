#!/usr/bin/env bash

# ===================================================================
# initial setup
# ===================================================================

dnf upgrade --refresh
dnf check
dnf autoremove
dnf install -y rpm-build

# ------------ firmware ---------------------
#fwupdmgr get-devices
#fwupdmgr refresh --force
#fwupdmgr get-updates
#fwupdmgr update
# -------------------------------------------

# make dnf not suck as much
if ! grep fastestmirror=1 /etc/dnf/dnf.conf >/dev/null ; then
cat >> /etc/dnf/dnf.conf <<EOF
fastestmirror=1
max_parallel_downloads=10
deltarpm=true
EOF
fi

# ===================================================================
# repos
# ===================================================================
dnf install -y  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf upgrade --refresh
dnf groupupdate core
dnf install -y rpmfusion-free-release-tainted
dnf install -y dnf-plugins-core

# # ===================================================================
# # gnome
# # ===================================================================
# dnf install -y \
# 	gnome-tweaks gconf-editor gnome-extensions-app \
# 	gnome-shell-extension-appindicator \
# 	gnome-shell-extension-caffeine \
# 	gnome-shell-extension-dash-to-dock \
# 	gnome-shell-extension-user-theme \
# 	gnome-shell-extension-no-overview \
# 	gnome-shell-extension-frippery-move-clock \
# 	gnome-shell-theme-flat-remix \
# 	gnome-shell-extension-screenshot-window-sizer \
# 	gnome-screenshot

# ===================================================================
# sway
# ===================================================================
dnf install -y \
	wlroots sway sway-systemd
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
	util-linux-user fail2ban htop detox \
	inotify-tools lm_sensors hwinfo lshw \
	clamav clamav-data clamav-update lsof \
	timeshift

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
	curl aria2 wireshark net-tools nmap netcat speedtest-cli \
	tor torsocks tigervnc dnsutils bluez bluez-libs bluez-tools \
	openssl w3m socat dnstop

# taskwarrior
dnf install -y task taskopen tasksh vit

# media
dnf install -y \
	gimp ImageMagick ffmpeg ffmpegthumbnailer youtube-dl \
	jpegoptim gyazo audacity-freeworld

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

# printing
dnf install -y cups cups-client cups-lpd cups-pdf

# sound
dnf install -y pipewire-pulseaudio pulseaudio-utils pavucontrol

# ===================================================================
# user space
# ===================================================================
dnf install -y \
	ranger \
	torbrowser-launcher \
	mpv \
	shntool \
	cuetools \
	flac \
	wavpack \
	vorbis-tools \
	libreoffice \
	obs-studio \
	shotcut \
	zathura-pdf-mupdf \
	xournal \
	discord \
	qbittorrent \
	qbittorrent-nox \
	gedit \
	gedit-plugins \
	evince \
	evince-thumbnailer \
	evince-previewer \
	evince-nautilus

dnf install -y lpf-spotify-client
lpf update
rpm -i /root/rpmbuild/RPMS/x86_64/spotify-client*.rpm

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
    glibc-devel

# ===================================================================
# xorg stuff (not applicable on wayland)
# ===================================================================
dnf install -y xhost xbanish xdotool xterm xbacklight xsetroot xinput arandr picom sxhkd xautolock
# xdimmer

# ===================================================================
# firefox
# ===================================================================
if ! command -v firefox-nightly >/dev/null 2>&1 ; then
	sudo dnf remove -y firefox
	sudo dnf copr enable proletarius101/firefox-nightly -y
	sudo dnf update -y
	sudo dnf install -y firefox-nightly
	mkdir -p /usr/local/bin
	ln -sf "$(which firefox-nightly)" /usr/local/bin/firefox
fi

# ===================================================================
# non-repo packages
# ===================================================================
if ! command -v gotop >/dev/null 2>&1 ; then
	wget 'https://github.com/xxxserxxx/gotop/releases/download/v4.1.3/gotop_v4.1.3_linux_amd64.rpm' -O /tmp/gotop.rpm
	rpm -i /tmp/gotop.rpm
	rm -f /tmp/gotop.rpm
fi

if ! command -v pfetch >/dev/null 2>&1 ; then
	git clone https://github.com/dylanaraps/pfetch /tmp/pfetch
	sudo install -D -m 0755 /tmp/pfetch/pfetch /usr/local/bin/pfetch
	rm -rf /tmp/pfetch
fi

# ===================================================================
# snaps
# ===================================================================
#if ! command -v snap >/dev/null 2>&1 || ! [ -e /snap ] ; then
#	dnf install -y snapd
#	ln -s /var/lib/snapd/snap /snap
#fi

# ===================================================================
# if using xorg
# ===================================================================
####### use xinitrc because new linux is stupid
######cat <<EOF | sudo tee /usr/share/xsessions/xinitrc.desktop
######[Desktop Entry]
######Encoding=UTF-8
######Name=xinitrc
######Comment=xinitrc
######Exec=/home/mitch/.xinitrc
######TryExec=/home/mitch/.xinitrc
######Type=Application
######EOF
######
####### in fact lets just not use display manager
######sudo systemctl disable gdm
