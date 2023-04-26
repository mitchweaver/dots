#!/bin/sh -e
#
# from: https://github.com/hyprwm/Hyprland/discussions/284
#
# NOTE: PROBABLY BROKEN
#
# alternatively this copr may be updated:
# https://copr.fedorainfracloud.org/coprs/justinz/hyprland/builds/
# ex: dnf copr enable justinz/hyprland
# ---------------------------------------------------------

# build reqs
sudo dnf install -y ninja-build cmake meson gcc-c++ libxcb-devel libX11-devel pixman-devel wayland-protocols-devel cairo-devel pango-devel
sudo dnf install -y libxkbcommon-devel libinput-devel

mkdir ~/build
cd ~/build

git clone --recursive https://github.com/hyprwm/Hyprland

cd Hyprland
meson _build
ninja -C _build

sudo ninja -C _build install

# SESSION FILE

####sudo cp /usr/local/share/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions

# SAMPLE CONFIG

#####mkdir -p ~/.config/hypr
####cp example/hyprland.conf ~/.config/hypr
