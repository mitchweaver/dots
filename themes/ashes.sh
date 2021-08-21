#!/bin/sh
#
# ashes
#

case ${1#--} in
    link|l)
        ln -sf ~/src/dots/themes/"${0##*/}" ~/src/dots/themes/current
        ;;
esac

color0='#1c2023'
color1='#c7ae95'
color2='#95c7ae'
color3='#aec795'
color4='#ae95c7'
color5='#c795ae'
color6='#95aec7'
color7='#c7ccd1'
color8='#747c84'
color9='#c7ae95'
color10='#95c7ae'
color11='#aec795'
color12='#ae95c7'
color13='#c795ae'
color14='#95aec7'
color15='#f3f4f5'

background='#1c2023'
foreground='#c7ccd1'
cursor='#c7ae95'
