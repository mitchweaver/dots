#!/bin/sh -e
#
# install a minimal kde-plasma environment by bypassing plasma-meta
# including only enough to get plasma-desktop working without issues
#
# Note this is also WITHOUT selecting the kde profile.
# See all my use flags in kde-plasma.use in /etc/portage
#
# note: needed use flags
#       polkit, dbus, elogind
# ========================================================================

# ========================================================================
# REMOVAL: just emerge --unmerge plasma-desktop then depclean
# ========================================================================

add() {
    doas emerge -avnuN "$@" || exit 1
}

add \
    kde-plasma/plasma-desktop \
    kde-plasma/systemsettings \
    kde-plasma/kdeplasma-addons \
    kde-plasma/kscreen \
    kde-apps/dolphin \
    display-manager-init \
    sddm \
    sddm-kcm \
    xdg-desktop-portal-kde

############# xf86-input-libinput \

# echo 'DISPLAYMANAGER="sddm"' > /etc/conf.d/display-manager
# rc-update add elogind boot
# rc-update add display-manager default

############################ no longer needed kde6? kde-plasma/xembed-sni-proxy
################################kde-plasma/powerdevil

cat <<"EOF"
=============== NOTE ======================
If using proprietary nvidia driver,
need this kernel parameter::

nvidia-drm.modeset=1
===========================================
EOF

