#!/bin/sh -e

sudo dnf install -y \
	inih inih-devel mesa-libgbm mesa-libgbm-devel libuuid libuuid-devel \
	systemd-devel

mkdir -p ~/tmp
cd ~/tmp

git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland

cd xdg-desktop-portal-hyprland

meson build --prefix=/usr
ninja -C build
cd hyprland-share-picker && make all && cd ..
sudo ninja -C build install
sudo cp ./hyprland-share-picker/build/hyprland-share-picker /usr/bin
