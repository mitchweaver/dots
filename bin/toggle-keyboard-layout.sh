#!/bin/bash


if [ $(setxkbmap -query | grep -c us_intl) -eq 1 ] ; then

    setxkbmap us
else
    setxkbmap us_intl

fi

xmodmap ~/.Xmodmap
