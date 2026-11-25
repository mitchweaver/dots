#!/bin/sh

if ! flatpak list | grep steam >/dev/null ; then
    flatpak install -y com.valvesoftware.Steam
fi

if ! flatpak list | grep -i gamescope >/dev/null ; then
    # automatically grab the correct gamescope version that matches steams runtime version
    sudo flatpak install -y flathub org.freedesktop.Platform.VulkanLayer.gamescope//$(flatpak info --show-runtime com.valvesoftware.Steam | cut -d/ -f3)
fi


