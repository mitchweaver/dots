# Surface Laptop 6 Install Guide

### Overview:

This is an install with a ext4 root and an encrypted zfs /home.
The reason for this is to minimize breakage and allow for kernel updates to be pain-free via apk rather than have to deal with zfs-on-root manually. At the end of the day critical personal data is your home partition. Root filesystem data corruption (or falling into the wrong hands) doesn't matter to me personally as there's nothing of importantance kept there.

## USB

use "standard" iso, not extended
off the usb there is no wifi module so we will need a USB-C to ethernet adaptor to get going

Getting network/ssh working:
1. `ifconfig eth0 up`
2. `udhcpc eth0`
3. `apk update ; apk add openssh-server`
4. vi `/etc/ssh/sshd_config` to allow root login
5. `rc-service sshd start`
6. set a root password to log in `passwd`

## initial setup-alpine

Follow the guide until you get to `setup-disks` then ^C

```
apk add e2fsprogs util-linux grub-efi dosfstools
```

## partitioning

layout:

| part | size | type |
| --- | --- | --- |
| /dev/nvme0n1p1 | 128mb | vfat EFI |
| /dev/nvme0n1p2 | 512mb | ext4 boot |
| /dev/nvme0n1p3 | 34gb | swap |
| /dev/nvme0n1p4 | 50gb | ext4 root |
| /dev/nvme0n1p5 | rest | encrypted zfs home |

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

# important do not forget this -O flag here for syslinux to work
mkfs.ext4 -O ^64bit /dev/nvme0n1p2

mkfs.ext4 /dev/nvme0n1p4
```

## mounting and continuing

```
mount /dev/nvme0n1p4 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

# the -s 0 flag here disables swap creation which we have done manually
# -m tells it to use as type "sys" which is really just a normal install
setup-disk -m sys -s 0 /mnt
```

## chroot

```
chroot /mnt
apk update
apk add wpa_supplicant

wpa_passphrase SSID PASS >/etc/wpa_supplicant/wpa_supplicant.conf
rc-update add wpa_supplicant default

# add our zfs modules
# zfs will be unavailable until we reboot
apk add zfs zfs-stable linux-stable

# fixes grub to work with the new kernel
apk fix

# set password
passwd
```

now you can reboot
if all is well you should be able to log back in 

## After reboot

Now we will work on our encrypted `/home` partition with zfs that we have the module working

test with
`modprobe zfs`

dataset structure will be:
`hpool/home`

```
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

zpool set autotrim=on hpool
zpool upgrade hpool

# create encrypted home
# will ask for passphase when called with "zfs load-key" which we will add as a service later
zfs create -o mountpoint=legacy -o encryption=on -o keyformat=passphrase -o keylocation=prompt  hpool/home
```

Test whether you can load the dataset

```
zpool export hpool
zpool import hpool
zfs load-key hpool/home
```

If all is successful we can proceed to mounting

## /home setup

add to fstab:
```
hpool/home            /home           zfs             rw,xattr,posixacl 0 0
```

set zfs services to start at boot:
(notice difference between "boot" and "default" here)
```
# set zfs module to be loaded at boot
echo zfs >> /etc/modules

# I prefer to use my rc.local to do this manually as the alpine zfs scripts seem to be pretty jank.
# I don't know why they sometimes don't mount or sometimes don't ask for load-key pass.
# maybe TODO/fix later but this works for now
apk add git make
cd /tmp
git clone https://github.com/mitchweaver/rclocal
cd rclocal
make install
cat >>/etc/rc.local <<"EOF"
zpool import hpool &&
zfs load-key hpool/home &&
mount /home
EOF

# these are fine to add
rc-update add zfs-share default
rc-update add zfs-zed default
```

test
```
mount /home
touch /home/test
```

reboot.
See if you now have "test" after rebooting :)

## proceeding as normal...

Now we have the install and ZFS stuff out of the way. Following this write up is all that I normally do on after a typical install.

* install packages
* copy over relevant `/etc/conf.d` files
* make sure all services set to run at boot

User setup:

```
useradd mitch
passwd mitch
usermod -a -G video,audio,lp,seat,wheel,input,lpadmin mitch

# change user/group IDs
vi /etc/passwd

mkdir /home/mitch
chown -R mitch /home/mitch
```

misc other:
```
# set hostname
hostname surface
echo surface > /etc/hostname

# kill pcspkr
mkdir -p /etc/modprobe.d ; rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf
```

eudev/udev:
```
setup-devd udev
```

