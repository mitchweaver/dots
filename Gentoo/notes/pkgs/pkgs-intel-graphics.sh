#!/bin/sh

add() {
    emerge --verbose --noreplace "$@"
}

add \
    media-libs/libva-intel-media-driver \
    media-libs/libva-intel-driver \
    x11-drivers/xf86-video-intel
