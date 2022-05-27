#!/usr/bin/env bash

set -e

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

# ===================================================================
# gnome
# ===================================================================
dnf install -y \
	gnome-tweaks gconf-editor gnome-extensions-app \
	gnome-shell-extension-appindicator \
	gnome-shell-extension-caffeine \
	gnome-shell-extension-dash-to-dock \
	gnome-shell-extension-user-theme \
	gnome-shell-extension-no-overview \
	gnome-shell-extension-frippery-move-clock


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
	python3-docker

pip3 install --upgrade pip

# archive
dnf install -y pigz zip unzip unrar p7zip

# system
dnf install -y \
	util-linux-user fail2ban clamav htop detox \
	inotify-tools lm_sensors
systemctl enable fail2ban
systemctl start fail2ban

# misc
dnf install -y pv tree neofetch slop translate-shell exa \
	xsel xclip

# networking
dnf install -y \
	openssh-server openssh openvpn rdesktop rsync wget \
	curl aria2 wireshark net-tools nmap netcat speedtest-cli \
	tor torsocks tigervnc dnsutils bluez bluez-libs bluez-tools \
	openssl w3m

# media
dnf install -y \
	gimp ImageMagick ffmpeg ffmpegthumbnailer youtube-dl \
	jpegoptim gyazo

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
	firefox \
	torbrowser-launcher \
	mpv \
	libreoffice \
	obs-studio \
	shotcut \
	zathura-pdf-mupdf \
	xournal \
	discord \
	qbittorrent

dnf install -y lpf-spotify-client
lpf update
rpm -i /root/rpmbuild/RPMS/x86_64/spotify-client*.rpm

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
    turbojpeg-devel

# ===================================================================
# xorg stuff (not applicable on wayland)
# ===================================================================
#######    xbanish xautolock xdotool xterm xbacklight 
#######    xsetroot xinput xset sxhkd arandr picom


# ===================================================================
# non-repo packages
# ===================================================================
if ! command -v gotop >/dev/null 2>&1 ; then
	wget 'https://github.com/xxxserxxx/gotop/releases/download/v4.1.3/gotop_v4.1.3_linux_amd64.rpm' -O /tmp/gotop.rpm
	rpm -i /tmp/gotop.rpm
	rm -f /tmp/gotop.rpm
fi

if ! command -v bitwarden >/dev/null 2>&1 ; then
	wget 'https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=rpm' -O  /tmp/bitwarden.rpm
	rpm -i /tmp/bitwarden.rpm
	rm -f /tmp/bitwarden.rpm
fi

if ! command -v pfetch >/dev/null 2>&1 ; then
	git clone https://github.com/dylanaraps/pfetch /tmp/pfetch
	sudo install -D -m 0755 /tmp/pfetch/pfetch /usr/local/bin/pfetch
	rm -rf /tmp/pfetch
fi

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
