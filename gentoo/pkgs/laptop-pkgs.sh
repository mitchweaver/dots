#!/bin/sh

add() {
    emerge -av --noreplace --update --verbose-conflicts "$@" || return 1
}

add \
net-wireless/iw \
net-wireless/wireless-tools \
net-wireless/wpa_supplicant \
sys-power/acpilight \
x11-misc/gammastep \
sys-power/tlp

# if nouveau:
# sys-firmware/nvidia-firmware
# x11-drivers/xf86-video-nouveau

# if nvidia:
# x11-drivers/nvidia-drivers
# sys-firmware/nvidia-firmware

