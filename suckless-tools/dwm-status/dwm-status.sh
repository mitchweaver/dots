#!/bin/sh

while true ; do

    DATE="[ $(sh date.sh) ]"
    VPN="[ $(sh vpn-check.sh) ]"
    BAT="[ $(sh battery-check.sh) ]"
    WIFI="[ $(sh wifi-check.sh iwn0) ]"

    xsetroot -name "$WIFI$BAT$VPN$DATE"

    sleep 1

done
