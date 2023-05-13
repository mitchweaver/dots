# Gentoo on ZFS RAID with Full Disk Encryption

## WARNING

**Swap on ZFS is extremely unstable and NOT recommended.**  
I ignored warnings originally but I've experienced deadlocks/freezes as
  well. This happens more often on low spec machines.

1. https://github.com/openzfs/zfs/issues/7734
2. https://github.com/openzfs/zfs/issues/260#issuecomment-758782144

Recommendation: Just make a ext4 partition to use as swap.

## Overview

this guide is using 3 disks in this layout using two pools
one boot pool, unencrypted
one root data pool, encrypted

```
/dev/nvme0n1
	|---1gb UNENCRYPTED MIRRORED
	|--rest: ENCRYPTED STRIPED
/dev/nvme1n1
	|---1gb UNENCRYPTED MIRRORED
	|---100% ENCRYPTED STRIPED
/dev/nvme2n1
	|---1gb UNENCRYPTED MIRRORED
	|---100% ENCRYPTED STRIPED
```

## Partitioning

Step 1: Create 1g vfat partitions at the start of each disk 1 to act as EFI partition

We create this giving 4M of free space at the front

```
fdisk /dev/nvme0n1
g === create GPT scheme
n
p
2048
+1024M
t, 1 ==== set to EFI type
```

Step 2: Create 5GiB of space for boot pool

```
n
p
enter
+5120M
```

Step 3: Fill the rest of the disk with a 2nd partition to be used with ZFS

Repeat these steps on the two other disks

## Create the ZFS pools

### Boot pool

1. notice `-d` flag here disables all by default, only enabling what is confirmed to work with grub
2. remove `mirror` if you are not mirroring multiple drives

```
zpool create -f -d \
    -o feature@async_destroy=enabled \
    -o feature@bookmarks=enabled \
    -o feature@embedded_data=enabled \
    -o feature@empty_bpobj=enabled \
    -o feature@enabled_txg=enabled \
    -o feature@extensible_dataset=enabled \
    -o feature@filesystem_limits=enabled \
    -o feature@hole_birth=enabled \
    -o feature@large_blocks=enabled \
    -o feature@lz4_compress=enabled \
    -o feature@spacemap_histogram=enabled \
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
    mirror \
    /dev/disk/by-id/nvme-Nextorage_SSD_NEM-PA1TB_511210827154006728-part2 \
    /dev/disk/by-id/nvme-Nextorage_SSD_NEM-PA1TB_511210827154005281-part2 \
    /dev/disk/by-id/nvme-Nextorage_SSD_NEM-PA1TB_511210827154006737-part2
```

## Root pool

```
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
  /dev/disk/by-id/nvme-Nextorage_SSD_NEM-PA1TB_511210827154006728-part3 \
  /dev/disk/by-id/nvme-Nextorage_SSD_NEM-PA1TB_511210827154005281-part3 \
  /dev/disk/by-id/nvme-Nextorage_SSD_NEM-PA1TB_511210827154006737-part3
```

turn on autotrim on root pool
```
# NOTE: do not set autotrim on boot pool!
zpool set autotrim=on rpool
```

## Create ZFS Datasets

```
zfs create -o mountpoint=none -o canmount=off -o encryption=on -o keyformat=passphrase -o keylocation=prompt rpool/gentoo
zfs create -o canmount=noauto -o mountpoint=legacy rpool/gentoo/root
mount -t zfs  rpool/gentoo/root /mnt/gentoo
zfs create -o mountpoint=legacy rpool/gentoo/home
mkdir /mnt/gentoo/home
mount -t zfs rpool/gentoo/home /mnt/gentoo/home
zfs create -o mountpoint=legacy  rpool/gentoo/var
zfs create -o mountpoint=none bpool/gentoo
zfs create -o mountpoint=legacy bpool/gentoo/root
mkdir /mnt/gentoo/boot
mount -t zfs bpool/gentoo/root /mnt/gentoo/boot
mkdir -p /mnt/gentoo/var
mount -t zfs rpool/gentoo/var /mnt/gentoo/var
```

## Next format and mount the ESP partition

```
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.fat -F 32 /dev/nvme1n1p1
mkfs.fat -F 32 /dev/nvme2n1p1
mkdir -p /mnt/gentoo/boot/efi
mount /dev/nvme0n1p1 /mnt/gentoo/boot/efi
```

## Create zswap

see: https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.html#using-a-zvol-for-a-swap-device-on-linux

```
zfs create -V 16G -b $(getconf PAGESIZE) \
    -o logbias=throughput -o sync=always \
    -o primarycache=metadata \
    -o com.sun:auto-snapshot=false rpool/swap

mkswap /dev/zvol/rpool/swap
```

## Checks

```
zfs list -t all
#####zpool get bootfs rpool
```

## stage3 and chroot

```
cd /mnt/gentoo
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
cp /etc/resolv.conf /mnt/gentoo/etc/
chroot /mnt/gentoo
```

## for sanity so nano doesn't drive me insane

```
emerge --sync
cat >> /etc/portage/make.conf <<EOF
MAKEOPTS=-j$(nproc)
FEATURES="fail-clean parallel-fetch parallel-install network-sandbox ipc-sandbox userpriv userfetch compress-build-logs compressdebug nodoc noinfo -news"
EOF
emerge busybox
ln -s $(which busybox) /bin/vi
```

## keywords

zfs packages will complain about not having "~amd64" in keywords
```
echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf
```

## fstab

```
bpool/gentoo/root            /boot           zfs rw,relatime,xattr,posixacl    0 0
/dev/nvme0n1p1               /boot/efi       vfat            noauto            1 2
rpool/gentoo/root            /               zfs             rw,xattr,posixacl 0 0
rpool/gentoo/home            /home           zfs             rw,xattr,posixacl 0 0
rpool/gentoo/var             /var            zfs             rw,xattr,posixacl 0 0
/dev/zvol/rpool/swap         none            swap            sw                0 0
```

## flags

```
cat > /etc/portage/package.use/zfs.use <<EOF
sys-apps/util-linux static-libs
sys-boot/grub libzfs
EOF
```

## initial genkernel to build zfs modules

```
echo 'ACCEPT_LICENSE="linux-fw-redistributable"' >> /etc/portage/make.conf
emerge --noreplace --ask --verbose --newuse --update \
  sys-kernel/genkernel \
  sys-kernel/gentoo-sources \
  linux-firmware

# NOTE: as of 5/1/23,  the latest kernel openzfs supports is 6.2.14
#       6.3.0+ not yet supported

# NOTE THIS WILL FAIL BECAUSE NO KERNEL BUILT YET FOR ZFS!
emerge --noreplace --ask --verbose --newuse --update \
  sys-boot/grub

cd /usr/src
ln -s $PWD/whatever linux
cd linux
# (copy your kernel config now if you have one)
# Notice we only make the kernel here and are not requesting --zfs
genkernel \
  --no-clean --no-mrproper --oldconfig \
  --menuconfig --makeopts=-j$(nproc) \
  --no-hyperv \
  --no-virtio \
  --no-btrfs \
  --no-mdadm \
  --no-lvm \
  --no-mountboot \
  kernel
```

now that we have *some* kernel, we can build the zfs module
```
emerge --noreplace --ask --verbose --newuse --update \
    sys-boot/grub \
    sys-fs/zfs \
    sys-fs/zfs-kmod
```

and now we build our actual kernel, using that module
```
genkernel \
  --no-clean --no-mrproper --oldconfig \
  --makeopts=-j$(nproc) \
  --no-hyperv \
  --no-virtio \
  --no-btrfs \
  --no-mdadm \
  --no-lvm \
  --zfs \
  --menuconfig \
  --no-mountboot \
  all
```

# Grub

### ensure that your efi is mounted

`mount | grep efi`

### ensure grub detects /boot correctly as zfs

`grub-probe /boot`

### edit `/etc/default/grub`

```
GRUB_CMDLINE_LINUX="dozfs root=ZFS=rpool/gentoo/root"
GRUB_TERMINAL=console
```

### install and gen config

```
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
```

## Services

```
rc-update add zfs-import boot
rc-update add zfs-mount boot
rc-update add zfs-share default
rc-update add zfs-zed default
```

## set final mountpoints

```
zfs set mountpoint=/ rpool/gentoo/root
```

# Finishing up

## root password

dont forget this :p

> -------------- HELPERS -----------------
> ```
> EFI_DISK=/dev/nvme0n1p1

> zpool import rpool
> zpool import bpool
> zfs load-key rpool/gentoo
> mount.zfs rpool/gentoo/root /mnt/gentoo
> mount.zfs rpool/gentoo/var /mnt/gentoo/var
> mount.zfs bpool/gentoo/root /mnt/gentoo/boot
> mount $EFI_DISK /mnt/gentoo/boot/efi
> mount -t proc proc /mnt/gentoo/proc
> mount --rbind /sys /mnt/gentoo/sys
> mount --rbind /dev /mnt/gentoo/dev
> ```
