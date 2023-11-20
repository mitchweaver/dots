#!/bin/sh

if [ -d /usr/share/libratbag ] ; then
    sudo install -m 0644 logitech-g-pro-x-superlight.device /usr/share/libratbag
fi
