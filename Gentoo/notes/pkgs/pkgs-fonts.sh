#!/bin/sh

add() {
    emerge --verbose --noreplace "$@"
}

# FONTS
add \
    x11-apps/mkfontscale \
    media-libs/fontconfig \
    media-fonts/font-util \
    media-fonts/fontawesome \
    media-fonts/liberation-fonts \
    media-fonts/noto \
    media-fonts/noto-cjk \
    media-fonts/noto-emoji \
    media-fonts/roboto \
    media-fonts/terminus-font \
    media-fonts/dejavu

eselect repository enable src_prepare-overlay
emerge --sync src_prepare-overlay
add media-fonts/spleen

eselect repository enable robertgzr
emerge --sync robertgzr
add media-fonts/cozette
