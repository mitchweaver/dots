#!/bin/sh

# fix for bug with floating windows and java programs (ex: ghidra)
export _JAVA_AWT_WM_NONREPARENTING=1

# remove titlebar in firefox
export MOZ_GTK_TITLEBAR_DECORATION=client

# enable touch input for firefox
export MOZ_USE_XINPUT2=1

export DIMENSIONS="$(dimensions)"

# --- so, so buggy... have to let gnome handle these
###/opt/piavpn/bin/pia-client -quiet &
###/opt/Signal/signal-desktop --start-in-tray &
###discord --start-minimized &

{
    # have to wait for gnome to settle,
    # otherwise these many not take effect
    sleep 2

    # annoying, have to wait for gnome to start it
    pkill nm-applet

    xset m 0 0 &
    xset b off &
    xhost +local: >/dev/null
    xrdb load ~/.Xresources
    xmodmap ~/.xmodmaprc
    # because xmodmap sometimes gets overwritten in gnome...
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

    case $(hostname) in
        xps) ;;
          *) steam -silent &
    esac

    vol s 40 &
    ytdlq -d &
    torrent-queue -d &
    autorotate -d &

    # paped -l ~/Pictures/wallpapers &
    background &

    # force nemo to be default file manager over nautilus
    # if command -v nemo >/dev/null ; then
        # xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
    # else
        xdg-mime default org.gnome.Nautilus.desktop inode/directory application/x-gnome-saved-search
    # fi


    # use st as nemo/nautilus terminal
    if command -v stwrapper >/dev/null ; then
        for i in gnome cinnamon ; do
            gsettings set org.$i.desktop.default-applications.terminal exec stwrapper
            gsettings set org.$i.desktop.default-applications.terminal exec-arg -e
        done
    else
        for i in gnome cinnamon ; do
            gsettings set org.$i.desktop.default-applications.terminal exec gnome-terminal
            gsettings set org.$i.desktop.default-applications.terminal exec-arg --
        done
    fi

    # remove consant indexing of tracker
    gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
    gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false
} &

# vim:ft=config
