#!/bin/sh

add() {
    emerge --verbose --noreplace "$@"
}

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# i3 Rice Stuff
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
add \
    x11-misc/dunst \
    x11-misc/parcellite \
    x11-misc/pcmanfm \
    x11-misc/picom \
    x11-misc/lightdm \
    x11-misc/i3lock-fancy-rapid

# RICE
add \
    lxde-base/lxappearance

# THEMES
add \
    x11-themes/arc-theme

eselect repository enable 4nykey
emerge --sync 4nykey
add x11-themes/papirus-icon-theme

eselect repository enable tastytea
emerge --sync tastytea
add x11-themes/paper-icon-theme

# eselect repository enable edgets
# emerge --sync edgets
# add x11-themes/materia-theme
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

#x11-wm/i3
#x11-misc/polybar

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# wayfire
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
gui-wm/wayfire
gui-libs/wayfire-plugins-extra
