## zfs

boot disk

notice part2 is our boot part (not part1 which is efi)

```
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
```

made root disk

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
  /dev/disk/by-id/nvme-SDDPTQD-512G-1124-WD_25084E808940-part4
```

turn on autotrim

```
zpool set autotrim=on rpool
zpool set autotrim=on bpool
```

upgrade if needed

```
zpool upgrade rpool
zpool upgrade bpool
```

## Create ZFS Datasets

```
# create root pool dataset encrypted
zfs create -o mountpoint=none -o canmount=off -o encryption=on -o keyformat=passphrase -o keylocation=prompt rpool/gentoo
zfs create -o canmount=noauto -o mountpoint=legacy rpool/gentoo/root

# create /home and /var
zfs create -o mountpoint=legacy rpool/gentoo/home
zfs create -o mountpoint=legacy  rpool/gentoo/var

# create boot pool dataset
zfs create -o mountpoint=none bpool/gentoo
zfs create -o mountpoint=legacy bpool/gentoo/root

# mount root
mkdir /mnt/gentoo
mount -t zfs rpool/gentoo/root /mnt/gentoo

# mount root folders
mkdir -p /mnt/gentoo/home /mnt/gentoo/boot /mnt/gentoo/var
mount -t zfs rpool/gentoo/home /mnt/gentoo/home
mount -t zfs rpool/gentoo/var  /mnt/gentoo/var
mount -t zfs bpool/gentoo/root /mnt/gentoo/boot
```

## efi

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

# Once inside...

## directory and portage config setup

Note, this section is mainly for myself and my configs
if you're following from elsewhere, skip over to the next section

```
# for zram tmp later
mkdir -p /var/tmp/notmpfs
chown -R portage $_
chmod 755 $_

# will remove this from fstab for zram-init later but for now
# add this to /etc/fstab
#
# tmpfs /var/tmp/portage tmpfs rw,nosuid,nodev,size=2G,mode=1777 0 0
#

# then
mkdir -p /var/tmp/portage
mount /var/tmp/portage

# now copy over your /etc/portage files
# * important remove use mold from LDFLAGS as we dont have it installed yet
# * comment/uncomment anything as needed for this machine

# copy and gen locale before continuing
cp -f locale.gen /etc/locale.gen
locale-gen

# update world
source ~/dots/shell/gentoo.shellrc
pkg sync
pkg a mold
# now edit LDFLAGS in /etc/make.conf for mold

# update world
pkg u
```

## intel microcode

```
pkg a sys-firmware/intel-microcode
```


