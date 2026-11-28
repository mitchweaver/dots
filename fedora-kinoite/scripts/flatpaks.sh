#!/bin/sh

if ! command -v flatpak >/dev/null ; then
    >&2 echo 'install flatpak idiot'
    exit 1
elif [ "$CONTAINER_ID" ] ; then
    >&2 echo "you're in distrobox idiot"
    exit 1
fi

# flatpak uninstalls
for crap in \
    org.kde.elisa \
    org.kde.kmahjongg \
    org.kde.kmines \
    org.kde.qrca \
    org.kde.skanpage \
    org.kde.gwenview
do
    if flatpak list | grep -i "$crap" >/dev/null ; then
        sudo flatpak uninstall -y "$crap"
    fi
done

# ========================================================================
# installs
# ========================================================================
if ! flatpak remotes | grep flathub >/dev/null ; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak remote-modify --enable flathub
fi

for app in \
    com.bitwarden.desktop \
    com.discordapp.Discord \
    com.getmailspring.Mailspring \
    com.github.tchx84.Flatseal \
    com.interversehq.qView \
    com.obsproject.Studio \
    com.rustdesk.RustDesk \
    com.super_productivity.SuperProductivity \
    com.tradingview.tradingview \
    io.github.dweymouth.supersonic \
    io.github.pwr_solaar.solaar \
    io.github.ungoogled_software.ungoogled_chromium \
    io.mpv.Mpv \
    io.github.celluloid_player.Celluloid \
    net.cozic.joplin_desktop \
    org.darktable.Darktable \
    org.gimp.GIMP \
    org.gnome.Boxes \
    org.libreoffice.LibreOffice \
    org.shotcut.Shotcut \
    org.signal.Signal \
    org.torproject.torbrowser-launcher \
    org.wireshark.Wireshark \
    org.fedoraproject.MediaWriter \
    io.github.focustimerhq.FocusTimer \
    org.kde.kolourpaint \
    org.kde.drawy
do
    if flatpak list | grep -i "$app" >/dev/null ; then
        >&2 printf '[*] %s already installed... skipping...\n' "$app"
    else
        sudo flatpak install -y flathub "$app"
    fi
done

# ========================================================================
# VULKAN
# ========================================================================
# if nvidia
if lspci | grep -i nvidia >/dev/null ; then
    # install nvidia vulkan and automatically detect correct nvidia version
    if ! flatpak list | grep -i org.freedesktop.Platform.GL.nvidia >/dev/null ; then
        sudo flatpak install -y flathub org.freedesktop.Platform.GL.nvidia-"$(tr . - < /sys/module/nvidia/version)"
        sudo flatpak install -y flathub org.freedesktop.Platform.GL32.nvidia-"$(tr . - < /sys/module/nvidia/version)"
    fi
else
    # note: check correct version to install with:
    # ----- flatpak info com.valvesoftware.Steam | grep -iE 'runtime|sdk'

    # install generic (intel/amd)
    if ! flatpak list | grep org.freedesktop.Platform.GL32.default >/dev/null ; then
        sudo flatpak install -y flathub org.freedesktop.Platform.GL32.default
    fi
    if ! flatpak list | grep org.freedesktop.Platform.Compat.i386 >/dev/null ; then
        sudo flatpak install -y flathub org.freedesktop.Platform.Compat.i386
    fi
fi

# ========================================================================
######flatpak install -y flathub md.obsidian.Obsidian
######flatpak install flathub net.ankiweb.Anki
######flatpak install flathub com.github.wwmm.easyeffects
# ========================================================================


# ========================================================================
# stuff not on flathub
# ========================================================================
if curl -s https://api.github.com/repos/alichtman/deadbolt/releases/latest | \
    grep -iE "https?://.*.deadbolt.*.x86_64.flatpak" | \
    sed -e 's/.*. "//' -e 's/".*//' | \
    xargs wget -O /tmp/deadbolt.flatpak
then
    if flatpak list | grep org.alichtman.deadbolt >/dev/null ; then
        sudo flatpak uninstall -y org.alichtman.deadbolt
    fi
    sudo flatpak install -y /tmp/deadbolt.flatpak
fi

# ========================================================================
# DEFAULT DENY SECURITY
# ========================================================================
# blocks "flatpak-spawn --host" (arbitrary command execution)
sudo flatpak override --no-talk-name=org.freedesktop.Flatpak

# deny all x11/xwayland -- KDE plasma is fully wayland now
# any apps still using xwayland grant specifically
sudo flatpak override --nosocket=x11 --socket=fallback-x11
sudo flatpak override --nodevice=all

# deny filesystem -- use portals / file chooser instead
sudo flatpak override --nofilesystem=host --nofilesystem=host-os --nofilesystem=host-etc --nofilesystem=home

# credentials
sudo flatpak override --nosocket=ssh-auth --nosocket=gpg-agent --nosocket=pcsc
sudo flatpak override --no-talk-name=org.freedesktop.secrets

# ========================================================================
# OVERRIDES
# ========================================================================
# ~/images ~/videos ~/downloads ~/desktop ~/tmp --- READONLY
for app in \
    io.mpv.Mpv \
    io.github.celluloid_player.Celluloid \
    com.interversehq.qView
do
    sudo flatpak override \
        --filesystem=xdg-desktop:ro \
        --filesystem=xdg-videos:ro \
        --filesystem=xdg-pictures:ro \
        --filesystem=xdg-download:ro \
        --filesystem=~/tmp "$app"
done

# ~/images ~/videos ~/downloads ~/desktop ~/tmp --- READ-WRITE
for app in \
    org.darktable.Darktable
do
    sudo flatpak override \
        --filesystem=xdg-desktop:rw \
        --filesystem=xdg-videos:rw \
        --filesystem=xdg-pictures:rw \
        --filesystem=xdg-download:rw \
        --filesystem=~/tmp:rw "$app"
done

# ~/obs_output ~/videos ~/images ~/downloads ~/tmp --- READ-WRITE
for app in \
    com.obsproject.Studio \
    org.shotcut.Shotcut
do
    sudo flatpak override \
        --filesystem=~/obs_output:rw \
        --filesystem=xdg-videos:rw \
        --filesystem=xdg-music:rw \
        --filesystem=xdg-pictures:rw \
        --filesystem=xdg-download:rw \
        --filesystem=~/tmp:rw "$app"
done

# ~/files ~/src ~/downloads ~/tmp --- READ-WRITE
for app in \
    org.libreoffice.LibreOffice \
    org.alichtman.deadbolt
do
    sudo flatpak override \
        --filesystem=~/src:rw \
        --filesystem=xdg-documents:rw \
        --filesystem=xdg-download:rw \
        --filesystem=~/tmp:rw "$app"
done

# x11 overrides (note: --device=all needed for gamepad support)
sudo flatpak override --socket=x11 --device=all com.valvesoftware.Steam
sudo flatpak override --socket=x11 io.github.dweymouth.supersonic

# ~/downloads
sudo flatpak override --filesystem=xdg-download:ro org.gnome.Boxes

