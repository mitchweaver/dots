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
    x11-misc/polybar \
    x11-wm/i3 \
    x11-misc/i3lock-fancy-rapid
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
