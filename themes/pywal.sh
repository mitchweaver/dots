#!/bin/sh
case ${1#--} in
    link|l)
        ln -sf ~/.cache/wal/colors.sh ~/src/dots/themes/current
        ;;
esac
