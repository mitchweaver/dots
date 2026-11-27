# Fedora Kinoite Install

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
sudo rpm-ostree refresh-md
sudo rpm-ostree upgrade

sudo rpm-ostree install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# update firmware if available
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update

# now reboot (you won't see rpmfusion packages available until you do)
sudo reboot
```

## Intel (skip if nvidia/amd)

```
# remove the free version and install the proprietary one
# this is needed for H.264 and HEVC decoding
rpm-ostree override remove libva-intel-media-driver --install intel-media-driver

# install intel_gpu_top
rpm-ostree install igt-gpu-tools
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
# * firefox as we install librewolf later
# * tuned as we replace with tlp
rpm-ostree override remove \
    fedora-bookmarks fedora-chromium-config firefox firefox-langpacks \
    open-vm-tools-desktop open-vm-tools qemu-guest-agent spice-vdagent spice-webdavd virtualbox-guest-additions \
    fedora-chromium-config-kde khelpcenter plasma-welcome plasma-drkonqi kde-partitionmanager kcharselect \
    plasma-browser-integration plasma-discover-notifier plasma-discover \
    plasma-discover-rpm-ostree plasma-welcome-fedora plasma-discover-libs \
    plasma-discover-kns plasma-discover-flatpak filelight tuned tuned-ppd
```

## installing anything that has to be on host system
```
# NOTE: file managers sandbox thumbnailers already, so it will not work inside another container
# NOTE: for some reason nmtui isnt included in networkmanager anymore by default
rpm-ostree install \
    distrobox kitty kitty-terminfo kitty-kitten fastfetch neovim python3-neovim \
    oksh ranger htop fail2ban NetworkManager-tui ffmpegthumbnailer libavcodec-freeworld \
    powertop docker-cli docker-compose lm_sensors tlp lz4 pigz \
    papirus-icon-theme reversal-icon-theme materia-kde
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
sudo systemctl disable --now NetworkManager-wait-online.service

# LDAP/kerberos which I don't use
sudo systemctl disable --now sssd.service
sudo systemctl disable --now sssd-kcm.socket

# abomination -- thankfully it's not default on fedora, we can disable it
sudo systemctl disable --now systemd-homed.service
sudo systemctl disable --now systemd-homed-activate.service

# useless / obsolete stuff I don't know why is still defaulted to running
sudo systemctl disable --now ModemManager.service
sudo systemctl disable --now mcelog.service

# smartcard / extended yubikey functions
# note: this is safe to disable if you just use yubikey for FIDO2/2fa
sudo systemctl disable --now pcscd.socket
sudo systemctl disable --now pcscd.service

# installed via btrfs array with btrfs encrpytion so none of these are used
sudo systemctl disable --now mdmonitor.service
sudo systemctl disable --now lvm2-lvmpolld.socket
sudo systemctl disable --now dm-event.socket
sudo systemctl disable --now lvm2-monitor
sudo systemctl disable --now raid-check.timer
sudo systemctl disable --now lvm-devices-import.path
sudo systemctl disable --now lvm-devices-import.service

# fedora analytics
sudo systemctl disable --now rpm-ostree-countme.timer

# enables from packages
sudo systemctl enable --now fail2ban
sudo systemctl enable --now tlp
sudo systemctl enable --now tlp-pd.service
sudo systemctl enable --now docker
sudo systemctl enable --now mullvad-daemon
```

## disable wake on lan

```
sudo ethtool -s eth0 wol d
sudo ethtool -s wlan0 wol d
```

## raid0 -> raid1 if needed

if you accidentally striped 2 nvme in the installer...
(which annoyingly is the default, fedora seems happy to have users lose data)
and want to convert to raid1 later use this below

note fedora will handle this fine, won't run into any boot issues

```
# this will start the conversion but warning:
#
# !!! DO NOT POWER OFF DEVICE UNTIL THIS FINISHES !!!
#
sudo btrfs balance start -dconvert=raid1 /var

# monitor the conversion with
sudo watch -n 1 btrfs balance status /var
```

## now set up distrobox

see [distrobox_setup.md](distrobox_setup.md)

## install flatpaks

see [scripts/flatpaks.sh](scripts/flatpaks.sh)

