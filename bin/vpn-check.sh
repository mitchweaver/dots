#!/bin/bash


if [ $(pidof openvpn) ] ; then
    
    echo "VPN: ✔️"
else
    echo "VPN: ✖️"

fi
