#!/bin/bash
#
# dedit: Use dmenu to open and edit a file from a given list.

FILES="/home/mitch/workspace/dotfiles \
       /home/mitch/.config \
       /home/mitch/bin \
       /home/mitch/downloads \
       /home/mitch/tmp \
       /home/mitch \
       /home/mitch/.config/ranger/rifle.conf \
       /home/mitch/.config/ranger/rc.conf"


DMENU='dmenu -l -i -fn terminus-10 -nb #ffffff -nf #000000 -sb #000000 -sf #ffffff'


EDITOR='urxvtc -e vim'


# Show list of options
choice=$(ls -tHBap ${FILES} | grep -v / | $DMENU -p 'File to edit:')

if [ $choice ]; then
    $EDITOR ${FILES}/${choice}
fi
