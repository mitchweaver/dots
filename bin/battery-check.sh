#!/bin/bash


perc=$(cat /sys/class/power_supply/BAT0/capacity)

if [ $(cat /sys/class/power_supply/AC/online) -eq 1 ] ; then
    
    echo "🔌 $perc%"
elif [ $perc -gt 15 ] ; then
    echo "⚡ $perc%"
elif [ $perc -gt 5 ] ; then
    echo "⚡ $perc% ❗"
else 
    echo "⚡ $perc% ☠️ ❗"

fi 

