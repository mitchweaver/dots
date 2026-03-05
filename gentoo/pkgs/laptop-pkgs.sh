#!/bin/sh

add() {
    emerge -av --noreplace --update --verbose-conflicts "$@" || return 1
}

eselect repository enable linux-surface
emerge --sync linux-surface

# ========================================================================
# SURFACE
# ========================================================================
add \
    sys-kernel/surface-sources \
    app-misc/surface-control \
    dev-libs/libwacom-surface \
    sys-firmware/iptsd

# ========================================================================
# WIRELESS
# ========================================================================
add \
    net-wireless/iw \
    net-wireless/wireless-tools \
    net-wireless/wpa_supplicant

# ========================================================================
# SCREEN
# ========================================================================
add \
    sys-power/acpilight \
    x11-misc/gammastep

# ========================================================================
# POWER --- NOTE: surface is super buggy, not worth
# ========================================================================
# add \
#     sys-power/tlp

