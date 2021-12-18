#!/bin/sh

case ${1#--} in
    link|l)
        ln -sf ~/src/dots/themes/"${0##*/}" ~/src/dots/themes/current
        ;;
esac

background='#282936'
foreground='#e9e9f4'
cursor='#e9e9f4'

color0='#282936'
color1='#ea51b2'
color2='#00f769'
color3='#ebff87'
color4='#62d6e8'
color5='#b45bcf'
color6='#a1efe4'
color7='#e9e9f4'
color8='#4d4f68'
color9='#ea51b2'
color10='#00f769'
color11='#ebff87'
color12='#62d6e8'
color13='#b45bcf'
color14='#a1efe4'
color15='#f7f7fb'
