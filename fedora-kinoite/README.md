# Fedora Silverblue / Kinoite Install

Note that due to the nature of immutable OS, this involves many reboots which is annoying

## user permissions

set up uid/gid to match network shares etc

```
sudo passwd root
sudo pkill -u $USER

# login as root
sudo usermod -u 6969 $USER
sudo groupmod -g 6969 $USER
sudo find $HOME -xdev -gid 1000 -exec chgrp -h $USER {} +

# redisable root password/login
sudo passwd -l root
```

## upgrade and enable repositories
```
rpm-ostree refresh-md
rpm-ostree upgrade

rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# now reboot
reboot

# update firmware if available
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
```

# Intel

```
# remove the free version and install the proprietary one
# this is needed for H.264 and HEVC decoding
rpm-ostree override remove libva-intel-media-driver --install intel-media-driver
```

## NVIDIA (skip if intel / amd  or if you're sticking with nouveau)
```
# ====== NVIDIA ==================================
rpm-ostree install kmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda

# reboot -- if you don't see this, then you don't have nvidia set up
rpm -qa | grep kmod-nvidia

rpm-ostree kargs \
    --append-if-missing=rd.driver.blacklist=nouveau \
    --append-if-missing=modprobe.blacklist=nouveau \
    --append-if-missing=nvidia-drm.modeset=1

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
# * fedora specific crap
# * virtual machine host support which don't need since this is bare metal
# * KDE specific junk
rpm-ostree override remove \
    fedora-bookmarks fedora-chromium-config firefox \
    open-vm-tools-desktop open-vm-tools qemu-guest-agent spice-vdagent spice-webdavd virtualbox-guest-additions \
    fedora-chromium-config-kde khelpcenter plasma-welcome plasma-drkonqi kde-partitionmanager kcharselect \
    plasma-browser-integration plasma-discover-notifier plasma-discover \
    plasma-discover-rpm-ostree plasma-welcome-fedora plasma-discover-libs \
    plasma-discover-kns plasma-discover-flatpak filelight
```

## installing anything that has to be on host system
```
# NOTE: file managers sandbox thumbnailers already, so it will not work inside another container
# NOTE: for some reason nmtui isnt included in networkmanager anymore by default
rpm-ostree install \
    distrobox kitty kitty-terminfo kitty-kitten fastfetch fail2ban \
    NetworkManager-tui ffmpegthumbnailer libavcodec-freeworld powertop \
    docker-cli docker-compose papirus-icon-theme reversal-icon-theme materia-kde
```

## kernel arguments
```
rpm-ostree kargs \
    --append-if-missing=net.ifnames=0 \
    --append-if-missing=ipv6.disable=1 \
    --append-if-missing=preempt=full \
    --append-if-missing=nowatchdog \
    --append-if-missing=nmi_watchdog=0 \
    --append-if-missing=split_lock_detect=off \
    --append-if-missing=mitigations=auto \
    --append-if-missing=snd_hda_intel.dmic_detect=0 \
    --append-if-missing=snd_sof_intel_hda_generic=0 \
    --append-if-missing=snd_sof_intel_hda_common.dmic_num=0 \
    --append-if-missing=snd_intel_dspcfg.dsp_driver=1 \
    --append-if-missing=intel_iommu=on \
    --append-if-missing=amd_iommu=on \
    --append-if-missing=iommu.strict=1 \
    --append-if-missing=efi=disable_early_pci_dma \
    --append-if-missing=page_alloc.shuffle=1 \
    --append-if-missing=slab_nomerge \
    --append-if-missing=init_on_alloc=1 \
    --append-if-missing=init_on_free=1 \
    --append-if-missing=randomize_kstack_offset=on \
    --append-if-missing=vsyscall=none \
    --append-if-missing=sysctl.fs.suid_dumpable=0 \
    --append-if-missing=proc_mem.force_override=ptrace \
    --append-if-missing=module_blacklist="uvcvideo,intel_ipu6,intel_ipu6_isys,tipc,rds,sctp,n_hdlc,ax25,netrom,rose,x25,appletalk,psnap,p8022,p8023,atm,af_802154,cramfs,freevxfs,jffs2,hfs,hfsplus,gfs2,ksmbd,vivid,can,firewire_core"
```

## other programs
```
# librewolf
curl -fsSL -o /etc/yum.repos.d/librewolf.repo https://repo.librewolf.net/librewolf.repo

# mullvad
curl -fsSL -o /etc/yum.repos.d/mullvad.repo https://repository.mullvad.net/rpm/stable/mullvad.repo

################ tailscale
################ostree remote add tailscale https://pkgs.tailscale.com/stable/fedora/tailscale.repo
################rpm-ostree install tailscale

# mega.nz
cat > /etc/yum.repos.d/megasync.repo <<EOF
[MEGAsync]
name=MEGAsync
baseurl=https://mega.nz/linux/repo/Fedora_$(rpm -E %fedora)/
gpgkey=https://mega.nz/linux/repo/Fedora_$(rpm -E %fedora)/repodata/repomd.xml.key
gpgcheck=1
enabled=1
EOF

rpm-ostree install megasync mullvad-vpn librewolf
```

# systemd services

reboot

```
# annoying on boot
systemctl disable NetworkManager-wait-online.service

# enables
systemctl enable fail2ban
systemctl enable mullvad-daemon
```

## distrobox
```
# NOTE: if requiring nvidia drivers in the container, need to pass the --nvidia flag
#       however this wont work for alpine due to glibc/musl
distrobox create \
    --name alpine \
    --image alpine:latest \
    --unshare-ipc

distrobox enter alpine
sudo su

# bind /mnt to the host's /mnt
rmdir /mnt
ln -s /run/host/mnt /mnt

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
apk add bc htop gotop lsof lm-sensors pciutils usbutils smartmontools sysstat upower git

# ARCHIVE
apk add p7zip unzip zip lz4 xz lzo

# MISC SYSTEM LIBS
apk add openssl libnotify libsecret py3-numpy py3-scipy nlohmann-json

# NETWORKING
apk add rsync openresolv netcat-openbsd nmap bind-tools socat ldns wireless-tools speedtest-cli

# SCRIPTING UTILS
apk add entr detox dos2unix inotify-tools dateutils libqrencode w3m w3m-image py3-pillow py3-pillow_heif lynx

# TERMINAL USERLAND
apk add oksh neovim translate-shell tree pv progress eza bat py3-pynvim ncdu pfetch neofetch kitty-terminfo

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

# RANGER

note current releases of ranger are broken with ncurses and maintainer is taking forever to make a new release

```
cd /tmp
git clone https://github.com/ranger/ranger
cd ranger
sudo make install
```

