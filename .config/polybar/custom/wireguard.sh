#!/bin/sh

ints='wg0 wg1 wg2'
ifconfig=$(ifconfig)

for int in $ints ; do
    if printf '%s\n' "$ifconfig" | grep "$int" >/dev/null ; then
        wg="$int"
        break
    fi
done

color_fmt=
# color_fmt=%{F#F0C674}
clear_fmt=%{F-}

if [ "$wg" ] ; then
    printf '%s%s %s' "${color_fmt}" "${clear_fmt}" "$wg"
else
    printf '%s%s None' "${color_fmt}" "${clear_fmt}"
# 
# 
fi
