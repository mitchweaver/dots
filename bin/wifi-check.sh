#!/bin/bash

result=""
IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

if [ $IP ] ; then

    result="📶 ✔️"
else
    result="📶 ✖️"

fi


SSID=$(iw dev $1 link | grep SSID: | awk -F '[ -]*' '$0=$NF')

if [ $SSID ] ; then

    result="${result} - $SSID"

fi

echo $result
