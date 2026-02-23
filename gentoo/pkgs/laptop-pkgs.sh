#!/bin/sh

add() {
    emerge -av --noreplace --update --verbose-conflicts "$@" || return 1
}

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
    sys-power/acpilight

### x11-misc/gammastep

