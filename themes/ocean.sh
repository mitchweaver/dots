#!/bin/sh

case ${1#--} in
    link|l)
        ln -sf ~/src/dots/themes/"${0##*/}" ~/src/dots/themes/current
        ;;
esac

background='#2b303b'
foreground='#c0c5ce'
cursor='#c0c5ce'

color0='#2b303b'
color1='#bf616a'
color2='#a3be8c'
color3='#ebcb8b'
color4='#8fa1b3'
color5='#b48ead'
color6='#96b5b4'
color7='#c0c5ce'
color8='#65737e'
color9='#bf616a'
color10='#a3be8c'
color11='#ebcb8b'
color12='#8fa1b3'
color13='#b48ead'
color14='#96b5b4'
color15='#eff1f5'
