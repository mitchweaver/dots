#!/bin/sh

for i in desktops/*.desktop ; do
    for dir in \
        ~/Desktop \
        ~/.local/applications \
        ~/.local/share/applications
    do
        if [ ! -e $dir/"$i" ] ; then
            sed < "$i" "s/<USER>/$USER/g" > $dir/"${i##*/}"
        fi
    done
done

for i in icons/*.png icons/*.svg ; do
    [ -e ~/.local/share/icons/"$i" ] ||
    cp "$i" ~/.local/share/icons/
done
