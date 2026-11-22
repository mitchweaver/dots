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
    com.github.flxzt.rnote \
    com.interversehq.qView \
    com.obsproject.Studio \
    com.rustdesk.RustDesk \
    com.super_productivity.SuperProductivity \
    com.tradingview.tradingview \
    com.valvesoftware.Steam \
    io.github.dweymouth.supersonic \
    io.github.pwr_solaar.solaar \
    io.github.ungoogled_software.ungoogled_chromium \
    io.mpv.Mpv \
    net.cozic.joplin_desktop \
    org.darktable.Darktable \
    org.gimp.GIMP \
    org.gnome.Boxes \
    org.kde.kolourpaint \
    org.libreoffice.LibreOffice \
    org.shotcut.Shotcut \
    org.signal.Signal \
    org.torproject.torbrowser-launcher \
    org.wireshark.Wireshark \
    org.fedoraproject.MediaWriter
do
    if flatpak list | grep -i "$app" >/dev/null ; then
        >&2 printf '[*] %s already installed... skipping...\n' "$app"
    else
        sudo flatpak install -y "$app"
    fi
done

# ========================================================================
# NVIDIA
# ========================================================================
if lspci | grep -i nvidia >/dev/null ; then
    if ! flatpak list | grep -i org.freedesktop.Platform.GL.nvidia >/dev/null ; then
        sudo flatpak install -y flathub org.freedesktop.Platform.GL.nvidia-"$(tr . - < /sys/module/nvidia/version)"
        sudo flatpak install -y flathub org.freedesktop.Platform.GL32.nvidia-"$(tr . - < /sys/module/nvidia/version)"
    fi
fi

# ========================================================================
######flatpak install -y flathub md.obsidian.Obsidian
######flatpak install flathub net.ankiweb.Anki
######flatpak install flathub com.github.wwmm.easyeffects
# ========================================================================

