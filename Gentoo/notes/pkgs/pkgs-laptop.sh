#!/bin/sh

add() {
    emerge --verbose --noreplace "$@"
}

# ===============================================================================
# LAPTOP ONLY
# ===============================================================================
add \
    net-wireless/iw \
    net-wireless/wireless-tools \
    net-wireless/wpa_supplicant \
    sys-power/acpi \
    sys-power/acpilight \
    sys-apps/fwupd \
    sys-apps/fwupd-efi \
    media-libs/libva-intel-media-driver

# for newer thinkpads:
# add app-laptop/tpacpi-bat

# https://wiki.gentoo.org/wiki/Power_management/Guide#About_laptop-mode-tools
#
# note: remember copy tlp.conf from this repo
add \
    sys-power/thermald \
    sys-power/tlp \
    sys-power/powertop

rc-update add thermald default
rc-update add tlp default
rc-service thermald start
rc-service tlp start
