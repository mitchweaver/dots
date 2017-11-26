#!/bin/bash

vol=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master))

vol_val=$(echo $vol | sed 's/.$//')

if [ $vol_val -gt 65 ] ; then
    echo "🔊 $vol"
    
elif [ $vol_val -gt 40 ] ; then
    echo "🔉 $vol"

elif [ $vol_val -gt 10 ] ; then
    echo "🔈 $vol"

elif [ $vol_val -eq 0 ] ; then
    echo "🔇 $vol"
fi
