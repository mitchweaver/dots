#!/bin/bash


a=`sed 's/.\{3\}$//' <<< cat /sys/class/thermal/thermal_zone0/temp`
b=`sed 's/.\{3\}$//' <<< cat /sys/class/thermal/thermal_zone1/temp`

avg=$(( (a + b) / 2))

echo 🌡️ "$avg"°C
