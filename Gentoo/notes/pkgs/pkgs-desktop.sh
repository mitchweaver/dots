#!/bin/sh

add() {
    emerge --verbose --noreplace "$@"
}

# ===============================================================================
# DESKTOP ONLY
# ===============================================================================

eselect repository enable steam-overlay
emerge --sync steam-overlay

add \
    games-util/steam-launcher \
    games-server/steamcmd \
    games-util/xpadneo

if ! grep disable_ertm /etc/rc.local >/dev/null ; then
cat >> /etc/rc.local <<EOF
echo 'Y' > /sys/module/bluetooth/parameters/disable_ertm
EOF
fi

echo 'options bluetooth disable\_ertm=Y' > /etc/modprobe.d/xpadneo.conf

