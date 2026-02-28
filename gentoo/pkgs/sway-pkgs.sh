#!/bin/sh

add() {
    emerge -av --noreplace --update --verbose-conflicts "$@" || return 1
}

# SWAY
add \
    gui-wm/swayfx \
    gui-apps/swaybg \
    gui-apps/swayidle \
    gui-apps/swaylock \
    gui-libs/xdg-desktop-portal-wlr \
    gui-apps/wl-clipboard \
    app-misc/cliphist \
    gui-apps/waybar \
    x11-misc/dunst \
    xfce-base/thunar \
    xfce-extra/thunar-media-tags-plugin \
    xfce-extra/thunar-archive-plugin

