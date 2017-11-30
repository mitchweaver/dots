#!/bin/bash

# PAUSE MUSIC (if playing)
mpc pause &

# Screenshot
scrot -z -q 60 /tmp/screen.jpg && jpegoptim /tmp/screen.jpg

# Distort to hide text on screen
convert /tmp/screen.jpg -paint 2 /tmp/screen.jpg && jpegoptim /tmp/screen.jpg

# Merge Screenshot and Lock Symbol
[[ -f ~/.config/i3/lock.png ]] && convert /tmp/screen.jpg  ~/.config/i3/lock.png -gravity center -composite -matte /tmp/screen.png

# Lock
i3lock -f -e -i /tmp/screen.png &

# Blank Screen
xset dpms force off

# Delete
rm /tmp/screen.png
