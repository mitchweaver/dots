#!/bin/sh

while true ; do

    BAT=$(sh ~/bin/battery-check.sh)

    xsetroot -name "$WIFI$BAT$VPN$DATE"
    
    sleep 3

done

# while true ; do

#     export BAT="[ $(sh ~/bin/battery-check.sh) ]"

#     sleep 10

# done

# while true ; do

#     export WIFI="[ $(sh ~/bin/wifi-check.sh iwn0) ]"
#     export VPN="[ $(sh ~/bin/vpn-check.sh) ]"

#     sleep 3

# done &

# while true ; do

#     export DATE="[ $(sh ~/bin/date.sh) ]"

#     sleep 60

# done &
