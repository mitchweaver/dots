#!/bin/sh

# udev rules for managing logitech devices with solaar
#
# https://github.com/pwr-Solaar/Solaar
#

if [ ! -e /etc/udev/rules.d/42-logitech-unify-permissions.rules ] ; then
    sudo curl -o /etc/udev/rules.d/42-logitech-unify-permissions.rules https://raw.githubusercontent.com/pwr-Solaar/Solaar/master/rules.d/42-logitech-unify-permissions.rules &&
    sudo udevadm control --reload-rules &&
    sudo udevadm trigger
fi

