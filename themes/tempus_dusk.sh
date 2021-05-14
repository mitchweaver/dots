#!/bin/sh
#
# tempus_dusk
#

case ${1#--} in
    link|l)
        ln -sf ~/src/dots/themes/"${0##*/}" ~/src/dots/themes/current
        ;;
esac

background='#1f252d'
foreground='#a2a8ba'
cursor='#a2a8ba'

color0='#1f252d'
color1='#cb8d56'
color2='#8ba089'
color3='#a79c46'
color4='#8c9abe'
color5='#b190af'
color6='#8e9aba'
color7='#a2a8ba'
color8='#a29899'
color9='#d39d74'
color10='#80b48f'
color11='#bda75a'
color12='#9ca5de'
color13='#c69ac6'
color14='#8caeb6'
color15='#a2a8ba'
