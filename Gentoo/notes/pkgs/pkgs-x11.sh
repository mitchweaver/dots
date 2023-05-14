#!/bin/sh

# ==========================================================
# X11 Stuff
# ==========================================================

add() {
    emerge --verbose --noreplace "$@"
}

add \
    x11-apps/xhost \
    x11-apps/xinput \
    x11-apps/xmodmap \
    x11-apps/xrandr \
    x11-apps/xsetroot \
    x11-misc/xclip \
    x11-misc/xdotool \
    x11-misc/xsel \
    x11-misc/redshift \
    x11-misc/sxhkd \
    x11-misc/xautolock \
    x11-misc/xwallpaper \
    x11-misc/slop \
    x11-misc/arandr \
    x11-misc/xbanish \
    x11-apps/xwininfo \
    x11-apps/mesa-progs

add \
    gui-libs/display-manager-init

echo 'DISPLAYMANAGER="lightdm"' > /etc/conf.d/display-manager
rc-update add elogind default
rc-update add display-manager default
# ==========================================================
