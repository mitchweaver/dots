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
    net-wireless/wpa_supplicant

# sys-power/acpi
# sys-power/acpilight
# sys-power/cpupower
# sys-power/powertop
# sys-power/tlp
# sys-power/upower
# app-laptop/tpacpi-bat


