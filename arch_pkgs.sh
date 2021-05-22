#!/bin/sh

echo "run me as root, ok?"
read -r blank
if [ $(id -u) -ne 0 ] ; then
	exit 1
fi

pacman -Syyuu

pacman -Sy \
arandr \
aria2 \
base-devel \
cataclysm-dda \
clamav \
curl \
detox \
dnscrypt-proxy \
dosbox \
exa \
ffmpegthumbnailer \
firefox \
freetype2 \
gimp \
git \
go \
gocr \
htop \
hugo \
inotify-tools \
ipmitool \
isync \
jpegoptim \
jq \
libreoffice \
linux-api-headers \
lolcat \
lxappearance \
mpv \
msmtp \
mupdf \
neofetch \
neomutt \
neovim \
notmuch \
nmap \
noto-fonts-cjk \
noto-fonts-emoji \
openvpn \
p7zip \
pandoc \
pcmanfm \
picom \
pv \
python-pynvim \
python-setuptools \
python-pip \
python-pylint \
ranger \
rdesktop \
imagemagick \
shellcheck \
slock \
slop \
speedtest-cli \
sxhkd \
sxiv \
terminus-font \
termshark \
tor \
torsocks \
translate-shell \
bdf-unifont \
unrar \
unzip \
w3m \
wget \
wireshark-cli \
wireshark-qt \
x11vnc \
xautolock \
xdotool \
xsel \
xwallpaper \
youtube-dl \
zathura-pdf-mupdf \
zip

pacman -Sy yay

yay -Syy

sudo -u mitch yay -Sy \
abook \
herbe \
farbfeld \
sct \
skroll \
toilet \
tor-browser \
xbanish \
spleen-font \
text2pdf

# make login screen thing
mkdir -p /usr/share/xsessions
cat > /usr/share/xsessions/dwm.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=DWM
Comment=Dynamic Window Manager
Exec=/home/mitch/.local/bin/dwm
Icon=
Type=Application
EOF
