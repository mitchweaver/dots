#!/bin/sh

# ========================================================================
# WIREGUARD
# ========================================================================
INT="wvr.sh"

if ip link show "$INT" >/dev/null 2>&1 && ifconfig | grep "$INT" >/dev/null ; then
    echo " $INT"
else
    echo ' disconnected'
fi

