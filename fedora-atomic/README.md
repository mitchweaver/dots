# Fedora Silverblue / Kinoite Install

Note that due to the nature of immutable OS, this involves many reboots which is annoying

## upgrade
```
rpm-ostree refresh-md
rpm-ostree upgrade

# important: if there were any kernel updates, you need to reboot or else it will mess up steps below
#            this is because you will be installing old kernel versions of drivers etc
reboot
```

## enable repositories
```
rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# now reboot
reboot

# now update firmware if available
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
```

## NVIDIA (skip if intel / amd  or if you're sticking with nouveau)
```
# ====== NVIDIA ==================================
rpm-ostree install kmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda

# reboot -- if you don't see this, then you don't have nvidia set up
rpm -qa | grep kmod-nvidia

rpm-ostree kargs \
    --append=rd.driver.blacklist=nouveau \
    --append=modprobe.blacklist=nouveau \
    --append=nvidia-drm.modeset=1

# for encrypted drives, remove from kargs "rhgb" else you will not boot
# this is because of running into chicken-and-egg problem of the driver being on the encrypted drive
# but plymouth wants to start to show the decryption gui
EDITOR=vi rpm-ostree kargs --editor

# reboot and check with
nvidia-smi

# this should say MIT/GPL if you have open drivers
modinfo nvidia | grep -i license
# ====== END NVIDIA ==================================
```

## anything we're deleting
```
# fedora specific crap
rpm-ostree override remove fedora-bookmarks fedora-chromium-config

# virtual machine host support which don't need since this is bare metal
rpm-ostree override remove \
    open-vm-tools-desktop \
    open-vm-tools \
    qemu-guest-agent \
    spice-vdagent \
    spice-webdavd \
    virtualbox-guest-additions

# ======================== BUDGIE ===============================
rpm-ostree override remove \
    ark ark-libs
# ======================== BUDGIE ===============================

# ======================== GNOME ===============================
rpm-ostree override remove \
    gnome-tour yelp malcontent-control \
	gnome-classic-session \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-places-menu \
    gnome-shell-extension-window-list \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-background-logo

flatpak uninstall -y flathub org.fedoraproject.MediaWriter
flatpak uninstall -y flathub org.gnome.Contacts
flatpak uninstall -y flathub org.gnome.Maps
flatpak uninstall -y flathub org.gnome.Calendar
flatpak uninstall -y flathub org.gnome.Decibels
flatpak uninstall -y flathub org.gnome.baobab
flatpak uninstall -y flathub org.gnome.Snapshot
# ====================== END GNOME ===============================

# ========================= KDE ===============================
# KDE specific junk
rpm-ostree override remove \
    fedora-chromium-config-kde \
    khelpcenter plasma-welcome plasma-drkonqi kde-partitionmanager kcharselect \
    plasma-browser-integration plasma-discover-notifier plasma-discover \
    plasma-discover-rpm-ostree plasma-welcome-fedora plasma-discover-libs \
    plasma-discover-kns plasma-discover-flatpak filelight

# flatpak uninstalls
flatpak uninstall -y org.kde.elisa org.kde.kmahjongg org.kde.kmines org.kde.qrca org.kde.skanpage
# ====================== END KDE ===============================
```

## installing anything that has to be on host system
```
# NOTE: file managers sandbox thumbnailers already, so it will not work inside another container
# NOTE: for some reason nmtui isnt included in networkmanager anymore by default
rpm-ostree install \
    distrobox kitty kitty-terminfo kitty-kitten ranger fastfetch fail2ban \
    NetworkManager-tui ffmpegthumbnailer

# ======================== BUDGIE ===============================
rpm-ostree install \
    wlr-randr
# ======================== BUDGIE ===============================

# ================ SWAY =============================================
curl -Lo /etc/yum.repos.d/swayfx.repo https://copr.fedorainfracloud.org/coprs/swayfx/swayfx/repo/fedora-45/swayfx-swayfx-fedora-45.repo
rpm-ostree override remove sway --install swayfx

rpm-ostree install gammastep swappy swayimg
# ================ END SWAY =========================================

# ============== GNOME ===================
rpm-ostree install gnome-tweaks
# ========================================
```

## kernel arguments
```
# disable nvme power saving (micro stutters on some laptops -- minor extra power draw)
# only enable if you have problems
####### rpm-ostree kargs --append=nvme_core.default_ps_max_latency_us=0

# misc other kern args
#      * net.ifnames = keep wlan0 eth0 etc instead of wlpen0erike0re0r0ere stupid names
#      * watchdog = useless
#      * split_lock_detect = dmesg spam benign errors
rpm-ostree kargs \
    --append=net.ifnames=0 \
    --append=nowatchdog \
    --append=split_lock_detect=off

# remove kernel modules for internel webcam microphone
rpm-ostree kargs \
    --append=snd_hda_intel.dmic_detect=0 \
	--append=snd_sof_intel_hda_generic=0 \
    --append=snd_sof_intel_hda_common.dmic_num=0

# disable ipv6
rpm-ostree kargs \
    --append=ipv6.disable=1

# iommu (specifying both is harmless)
rpm-ostree kargs \
    --append=intel_iommu=on \
    --append=amd_iommu=on

# misc other security
# shouldnt cause problems and very minimal if any performance impact
# any questions on what they do just ask your favorite LLM
rpm-ostree kargs \
    --append=page_alloc.shuffle=1 \
    --append=slab_nomerge \
	--append=init_on_alloc=1 \
    --append=init_on_free=1 \
	--append=randomize_kstack_offset=on \
	--append=vsyscall=none \
    --append=debugfs=off
```

## install flatpak apps
```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

flatpak install -y flathub io.github.ungoogled_software.ungoogled_chromium
flatpak install -y flathub org.torproject.torbrowser-launcher

flatpak install -y flathub com.valvesoftware.Steam
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.obsproject.Studio
flatpak install -y flathub org.shotcut.Shotcut
flatpak install -y flathub io.mpv.Mpv

flatpak install -y flathub org.gimp.GIMP
flatpak install -y flathub org.libreoffice.LibreOffice

flatpak install -y flathub md.obsidian.Obsidian
flatpak install -y flathub net.cozic.joplin_desktop
flatpak install -y flathub com.super_productivity.SuperProductivity
flatpak install -y flathub com.bitwarden.desktop

flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub io.github.dweymouth.supersonic

flatpak install -y flathub org.signal.Signal
flatpak install -y flathub com.getmailspring.Mailspring

flatpak install -y flathub org.wireshark.Wireshark

flatpak install -y flathub com.tradingview.tradingview

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.gtk.Gtk3theme.Materia-light
flatpak install -y flathub org.gtk.Gtk3theme.Materia-dark

######### IF NVIDIA ##########
flatpak install -y flathub org.freedesktop.Platform.GL.nvidia-"$(tr . - < /sys/module/nvidia/version)"
flatpak install -y flathub org.freedesktop.Platform.GL32.nvidia-"$(tr . - < /sys/module/nvidia/version)"
```

## other programs
```
# mullvad
curl -fsSL -o /etc/yum.repos.d/mullvad.repo https://repository.mullvad.net/rpm/stable/mullvad.repo
rpm-ostree install mullvad-vpn

# tailscale
ostree remote add tailscale https://pkgs.tailscale.com/stable/fedora/tailscale.repo
rpm-ostree install tailscale

# mega.nz
cat > /etc/yum.repos.d/megasync.repo <<EOF
[MEGAsync]
name=MEGAsync
baseurl=https://mega.nz/linux/repo/Fedora_$(rpm -E %fedora)/
gpgkey=https://mega.nz/linux/repo/Fedora_$(rpm -E %fedora)/repodata/repomd.xml.key
gpgcheck=1
enabled=1
EOF
rpm-ostree install megasync
```

# systemd services
```
# annoying on boot
systemctl disable NetworkManager-wait-online.service

# enables
systemctl enable fail2ban
systemctl enable mullvad-daemon
```

## distrobox
```
# creating containers
mkdir -p ~/.distrobox

# our init hook removes scripts to run commands on the host from within the container
# I consider these to be security risks and I don't use them anyway
#
# NOTE: if requiring nvidia drivers in the container, need to pass the --nvidia flag
#       however this wont work for alpine due to glibc/musl
distrobox create \
    --name alpine \
    --image alpine:latest \
    --unshare-ipc \
    --init-hooks "umount /usr/bin/distrobox-host-exec 2>/dev/null ; rm /usr/bin/host-spawn /usr/bin/distrobox-host-exec 2>/dev/null ; echo \#\!/bin/sh > /usr/bin/host-spawn ; echo exit\ 1 >> /usr/bin/host-spawn ; chmod 755 /usr/bin/host-spawn"

distrobox enter alpine
sudo su

# update all containers
cat > /etc/apk/repositories <<"EOF"
https://dl-cdn.alpinelinux.org/alpine/edge/main
https://dl-cdn.alpinelinux.org/alpine/edge/community
https://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF
apk update
apk upgrade

# META
apk add docs

# NON-BUSYBOX / GNU
apk add coreutils binutils findutils grep util-linux gawk iproute2

# SYSTEM UTILS
apk add bc htop lsof lm-sensors pciutils usbutils smartmontools sysstat upower git

# ARCHIVE
apk add p7zip unzip zip lz4 xz lzo

# MISC SYSTEM LIBS
apk add libnotify libsecret py3-numpy py3-scipy nlohmann-json

# NETWORKING
apk add rsync openresolv netcat-openbsd nmap bind-tools socat ldns wireless-tools speedtest-cli

# SCRIPTING UTILS
apk add entr detox dos2unix inotify-tools dateutils libqrencode w3m w3m-image py3-pillow py3-pillow_heif lynx

# TERMINAL USERLAND
apk add oksh neovim ranger htop translate-shell tree pv progress eza bat py3-pynvim ncdu neofetch kitty-terminfo

# DEVELOPMENT
apk add build-base gcc patch musl-dev meson ninja shellcheck jq py3-pylint hugo sassc

# COMMON DEV LIBS
apk add linux-headers ncurses-dev openssl-dev elfutils-dev

# MEDIA
apk add ffmpeg imagemagick jpegoptim exiftool cuetools shntool vorbis-tools wavpack mpv yt-dlp

######################## SWAY ####################################
apk add swaybg swayimg gammastep
##################################################################
```

