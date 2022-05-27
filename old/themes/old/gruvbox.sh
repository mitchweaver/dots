#!/bin/sh

case ${1#--} in
    link|l)
        ln -sf ~/src/dots/themes/"${0##*/}" ~/src/dots/themes/current
        ;;
esac

background='#282828'
foreground='#ebdbb2'
cursor='#fbf1c7'

color0='#282828'
color1='#cc241d'
color2='#98971a'
color3='#d79921'
color4='#458588'
color5='#b16286'
color6='#689d6a'
color7='#a89984'
color8='#928374'
color9='#fb4934'
color10='#b8bb26'
color11='#fabd2f'
color12='#83a598'
color13='#d3869b'
color14='#8ec07c'
color15='#ebdbb2'
