#!/bin/sh

# busybox disables
rc-update del ntpd default

rc-update add wpa_supplicant default
rc-update add chronyd default
rc-update add sshd default
rc-update add dnsmasq default
rc-update add zram-init default
rc-update add fail2ban default
rc-update add cupsd default
rc-update add dbus default
rc-update add dhcpcd default
rc-update add blueooth default
rc-update add tlp default

# zfs
rc-update add zfs-share default
rc-update add zfs-zed default

# ===================================
# sway
rc-update add seatd default
rc-update add elogind default

