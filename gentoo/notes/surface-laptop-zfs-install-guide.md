# Gentoo installation on Surface Laptop 6 with encrypted ZFS

*Written: Feb 2026*

This will be an installation with encrypted /home partition.

Reason for this over full disk encryption is simplifies problems with buggy hardware like these surfaces and reduces the possibility of locking yourself out of your system. FDE with these require some extra initramfs work which I just didn't feel like doing. In my opinion, encrypting /home is normally sufficient.

This write up is my attempt to document EVERY single step I perform on way to a full installation.
Please see my portage configuration files as well which is probably in my dotfiles git repo.

## initial setup

**step 1**: download gentoo admincd and dd to a usb

this is for zfs modules and has most drivers, conveniently the wifi and keyboard modules needed for the surface

**step 2**: launch and connect to wifi

```
wpa_passphase your_ssid your_password > /etc/wpa_supplicant/wpa_supplicant.conf
rc-service wpa_supplicant start
dhcpcd
# ensure time is correct
rc-service busybox-ntpd start
# set root pass (default is disabled)
passwd
rc-service sshd start
```

## partitioning

layout:

| part | size | type |
| --- | --- | --- |
| /dev/nvme0n1p1 | 128mb | EFI |
| /dev/nvme0n1p2 | 512mb | boot |
| /dev/nvme0n1p3 | 34gb | swap |
| /dev/nvme0n1p4 | 50gb | root |
| /dev/nvme0n1p5 | rest | encrypted home |

```
fdisk /dev/nvme0n1
g           # wipe table
n           # new
+128MiB     # size of 128mb
t           # set type
1           # 1 for ZFS

n           # new
+512MiB     # size of 512mb

n           # new
+34GiB      # size of 34gb
t           # set type
19          # swap

n           # new
+50GiB      # size of 50gb (root partition)

n           # new
enter       # fill rest of space (will be used for encrypted home partition)
```

## create non-zfs filesystems

```
mkswap /dev/nvme0n1p3
swapon /dev/nvme0n1p3
mkfs.fat -F 32 /dev/nvme0n1p1
```

## create zfs pools and datasets

pool+dataset layout:

| dataset | mountpoint | partition |
| ------- | ---------- | -------- |
| bpool/gentoo/root | /boot | /dev/nvme0n1p2 |
| rpool/gentoo/root | / | /dev/nvme0n1p4 |
| rpool/gentoo/var | /var | /dev/nvme0n1p4 |
| hpool/gentoo/root | /home | /dev/nvme0n1p5 |

*Note: manually specifying features may not be needed but these are notes of mine from years ago so out of paranoia I'm keeping them*

```
modprobe zfs

# bpool
zpool create -f -d \
    -o feature@async_destroy=enabled \
    -o feature@embedded_data=enabled \
    -o feature@empty_bpobj=enabled \
    -o feature@enabled_txg=enabled \
    -o feature@extensible_dataset=enabled \
    -o feature@hole_birth=enabled \
    -o feature@large_blocks=enabled \
    -o feature@lz4_compress=enabled \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=lz4 \
    -O devices=off \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/boot \
    bpool \
    /dev/disk/by-id/nvme-SDDPTQD-512G-1124-WD_25084E808940-part2

# rpool
zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O compression=lz4 \
  -O canmount=off \
  -O dnodesize=auto \
  -O atime=off \
  -O normalization=formD \
  -O mountpoint=/ \
  -o feature@async_destroy=enabled \
  -m none \
  -R /mnt/gentoo \
  rpool \
  /dev/disk/by-id/nvme-SDDPTQD-512G-1124-WD_25084E808940-part4

# hpool
zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O compression=lz4 \
  -O canmount=off \
  -O dnodesize=auto \
  -O atime=off \
  -O normalization=formD \
  -O mountpoint=/home \
  -o feature@async_destroy=enabled \
  -m none \
  hpool \
  /dev/disk/by-id/nvme-SDDPTQD-512G-1124-WD_25084E808940-part5
  
# enable trim
zpool set autotrim=on rpool
zpool set autotrim=on bpool
zpool set autotrim=on hpool

## upgrade pools if any new updates
zpool upgrade rpool
zpool upgrade bpool
zpool upgrade hpool
```

verify all created OK with `zpool status`

now we have our pools created we can create the datasets:

```
# create root pool dataset
zfs create -o mountpoint=none -o canmount=off rpool/gentoo
zfs create -o canmount=noauto -o mountpoint=legacy rpool/gentoo/root

# create encrypted home
# will ask for passphase when called with "zfs load-key" which we will add as a service later
zfs create -o mountpoint=legacy -o encryption=on -o keyformat=passphrase -o keylocation=prompt  rpool/gentoo/home

# create separate /var (optional)
zfs create -o mountpoint=legacy  rpool/gentoo/var

# create boot pool dataset
zfs create -o mountpoint=none bpool/gentoo
zfs create -o mountpoint=legacy bpool/gentoo/root
```

mount the datasets:

```
# mount root
mkdir -p /mnt/gentoo
mount -t zfs rpool/gentoo/root /mnt/gentoo

# mount root folders
mkdir -p /mnt/gentoo/home /mnt/gentoo/boot /mnt/gentoo/var
mount -t zfs rpool/gentoo/home /mnt/gentoo/home
mount -t zfs rpool/gentoo/var  /mnt/gentoo/var
mount -t zfs bpool/gentoo/root /mnt/gentoo/boot
```

mount efi:
```
mkdir -p /mnt/gentoo/boot/efi
mount /dev/nvme0n1p1 /mnt/gentoo/boot/efi
```

## check if everything is correct
`zfs list -t all`

## stage and chroot

```
cd /mnt/gentoo

# download hardened amd64 openrc
wget https://distfiles.gentoo.org/releases/amd64/autobuilds/XXXXXXXXXXXX/stage3-amd64-hardened-openrc-XXXXXXXXXXXX.tar.xz

tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
cp -f /etc/resolv.conf /mnt/gentoo/etc/
chroot /mnt/gentoo
```

## Once inside...

* copy over your `/etc/portage` configs
* if you use `mold`, comment it out in `LDFLAGS` as we don't have it installed yet
* set up tmpfs --(note if you use zram-init later you will need to delete this before rebooting):
* set up locale
* set timezone
* fix make.profile if needed

tmpfs:
```
mkdir -p /var/notmpfs
chown -R portage:portage $_
chmod 755 $_

# will remove this from fstab for zram-init later but for now
# add this to /etc/fstab
#
# tmpfs /var/tmp tmpfs rw,nosuid,nodev,size=12G,mode=1777 0 0

mount /var/tmp
mkdir -p /var/tmp/portage
```

locale:
```
cat >/etc/locale.gen <<"EOF"
# note: remember to run 'locale-gen'
en_US ISO-8859-1
en_US.UTF-8 UTF-8
EOF
```

timezone:
```
echo "US/Central" > /etc/timezone
emerge --config sys-libs/timezone-data
ln -sf ../usr/share/zoneinfo/US/Central /etc/localtime
```

make.profile:
```
ln -sf /var/db/repos/gentoo/profiles/default/linux/amd64/23.0/hardened /etc/portage/make.profile
```

## Update world

always good to make sure have a clean base before starting mess with the system

```
emerge --sync
emerge --update --newuse --deep --with-bdeps=y @world
```

## Convenience

```
emerge busybox
cat >/usr/bin/vi <<"EOF"
#!/bin/sh
exec busybox vi "$@"
EOF
chmod +x /usr/bin/vi
```


## Switch to git from rsync for faster syncs

```
emerge dev-vcs/git eselect-repository

eselect repository remove -f gentoo
eselect repository add gentoo git https://github.com/gentoo-mirror/gentoo
# delete old rsync repo
rm -rf /var/db/repos/gentoo
# sync now with git, should be faster
emerge --sync gentoo
```

## fstab

```
bpool/gentoo/root            /boot           zfs rw,relatime,xattr,posixacl    0 0
/dev/nvme0n1p1               /boot/efi       vfat            noauto            1 2

rpool/gentoo/root            /               zfs             rw,xattr,posixacl 0 0
rpool/gentoo/var             /var            zfs             rw,xattr,posixacl 0 0

hpool/gentoo/root            /home           zfs             rw,xattr,posixacl 0 0

/dev/nvme0n1p3               none            swap            defaults          0 0
```

## Important note before continuing

A lot going forward will assume you have my gentoo configurations as I've mostly written this as notes to myself.  
I will quickly summarize the most important here to get ZFS working:

```
echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf
echo 'ACCEPT_LICENSE="linux-fw-redistributable"' >> /etc/portage/make.conf
sys-apps/util-linux static-libs
sys-boot/grub libzfs
```

## Kernel configuration - part 1

install kernel, genkernel, and firmware
```
eselect repository enable linux-surface
emerge --sync linux-surface
# first grab sources:
emerge surface-sources
# then after:
emerge genkernel linux-firmware
```

create kernel symlink
```
cd /usr/src/linux
ln -s $PWD/whatever-linux linux
cd linux
```

install intel microcode
```
emerge sys-firmware/intel-microcode
```

attempt to install grub
this will fail as we don't have the zfs modules installed
don't worry, we will do that next. just try to install grub as we need the dependencies
```
emerge sys-boot/grub
```

## Kernel configuration - part 2

```
# ensure clean build
make clean

# generate a default config
make defconfig

# download most recent surface config and append it to the generated .config
wget https://github.com/linux-surface/linux-surface/raw/refs/heads/master/configs/surface-6.18.config

1. comment out UFS support
2. comment out all surface book related

cat surface-6.18.config >> .config

# build kernel and modules but do not yet install the kernel or build initramfs
#
# With menuconfig, enable "simpleframebuffer" device support by going to
# "Device Drivers" -> "Framebuffer Devices"
# also enable bootup logo :)
genkernel \
  --no-clean --no-mrproper --oldconfig \
  --makeopts=-j$(nproc) \
  --menuconfig \
  --no-hyperv \
  --no-virtio \
  --no-btrfs \
  --no-mdadm \
  --no-lvm \
  --no-mountboot \
  --utils-cflags="-w" \
  kernel

# now attempt to emerge grub again
# our use flags will pull in the zfs dependencies which now that we have a kernel built  
# will allow grub and the zfs mods to all build successfully
emerge --noreplace -av --newuse --update sys-boot/grub

# rebuild the zfs module
# this step is needed here after building the kernel but before installing it
# this is because it must link with the built kernel -- afterwards we then call
# dracut to generate the initramfs containing the zfs module
emerge @module-rebuild

# now we can build all
genkernel \
  --no-clean --no-mrproper --oldconfig \
  --makeopts=-j$(nproc) \
  --no-hyperv \
  --no-virtio \
  --no-btrfs \
  --no-mdadm \
  --no-lvm \
  --zfs \
  --no-mountboot \
  --utils-cflags="-w" \
  all
  
# verify you have kernel and initramfs in /boot
```


## GRUB

ensure grub detects /boot correctly as zfs
`grub-probe /boot`

set up `/etc/default/grub`

```
GRUB_DISTRIBUTOR="Gentoo"
GRUB_DEFAULT=0
GRUB_TIMEOUT=2
GRUB_DISABLE_LINUX_PARTUUID=false
GRUB_DISABLE_RECOVERY=true
GRUB_DISABLE_OS_PROBER=true
# IMPORTANT: disable framebuffer -- helps with bugs with grub not releasing it
GRUB_TERMINAL=console
GRUB_TERMINAL_OUTPUT=console

# ======================= KERNEL ARGS ====================================
GRUB_CMDLINE_LINUX="dozfs root=ZFS=rpool/gentoo/root net.ifnames=0 nowatchdog zswap.enabled=1 zswap.compressor=lz4 split_lock_detect=off pci=hpiosize=0 acpi_osi=\"Windows 2022\""
#
#
#
### FOR NVIDIA: nvidia-drm.modeset=1
#
### FOR SURFACE LAPTOP 6: acpi_osi=\"Windows 2022\" pci=hpiosize=0
# https://github.com/linux-surface/linux-surface/wiki/Surface-Laptop-6
#
##### disable iommu seems to help with stability
# intel_iommu=off iommu=off
#
# ======================= KERNEL ARGS ====================================
```

```
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
```

## ZFS services

important: notice the "boot" vs "default" on these

```
rc-update add zfs-import boot
rc-update add zfs-mount boot
rc-update add zfs-load-key default
rc-update add zfs-share default
rc-update add zfs-zed default
```

## before rebooting

```
# make sure you have network access
emerge wpa_supplicant dhcpcd
wpa_passphase your_ssid your_password > /etc/wpa_supplicant/wpa_supplicant.conf

# networking
emerge net-dns/dnsmasq net-dns/openresolv
rc-update add wpa_supplicant default
rc-update add dhcpcd default
rc-update add sshd default
rc-update add dnsmasq default

# copy over your dhcpcd / dnsmasq / resolvconf settings

# other system services
emerge sysklogd chrony cronie
rc-update add sysklogd default
rc-update add chronyd default
rc-update add cronie default

# set root password
passwd

# set hostname
hostname surface
echo surface > /etc/hostname

# zram - also copy over your /etc/conf.d/zram-init
emerge sys-block/zram-init
rc-update add zram-init default

# kill pcspkr
mkdir -p /etc/modprobe.d ; rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf

# optional: enable root ssh login
vi /etc/ssh/sshd_config
```

