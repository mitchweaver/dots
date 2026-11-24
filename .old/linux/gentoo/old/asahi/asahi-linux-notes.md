# Asahi Linux Gentoo Installation

## Booting Asahi Linux Minimal

1. install asahi-linux-minimal, give it 15GB of space
2. login: root/root
3. change password for both root and alarm accounts

## Connect to wifi

```
ifconfig wlan0 up
systemctl enable iwd.service
systemctl start iwd.service
iwctl --passphrase XXXXX station wlan0 connect YOUR_SSID
# may give some garble error message, ignore
dhcpcd
dhcpcd
ping 1.1.1.1
```

## Update system, install tools

1. pacman -Syu
2. reboot
3. pacman -S git

# Getting ZFS access

Unfortunately `archzfs` is [unmaintained for arm64](https://github.com/archzfs/archzfs/issues/472).  
Being how popular Arch is, I was genuinely surprised...

So instead, we are going to have to compile it ourselves.

```
pacman -S linux-asahi-headers wget gcc make autoconf automake libtool
wget https://github.com/openzfs/zfs/releases/download/zfs-2.1.11/zfs-2.1.11.tar.gz
tar xf zfs-*.tar.gz
cd zfs-*
# Due to GPL/CDDL license isses between the kernel and OpenZFS, we need to make ZFS think its GPL
# see: https://github.com/openzfs/zfs/issues/14555
# see: https://github.com/openzfs/zfs/issues/11357
sed -i 's/CDDL/GPL/g' META
./autogen.sh
./configure
make -j$(nproc)
make install
```

If all the above went okay, we should now be able to load the zfs module and run zpool without errors.

```
depmod
modprobe zfs
zpool status
```

### Filesystem creation

### Forward

Asahi uses "efi as boot" meaning both your /boot and /boot/efi, (as you normally would), are instead just /boot  
Just keep this in mind through this guide.

## Layout

As of right now, your layout should look like this:

```
Device             Start       End  Sectors  Size Type
/dev/nvme0n1p1 Apple Silicon boot       (MACOS DO NOT TOUCH)
/dev/nvme0n1p2 Apple APFS               (MACOS DO NOT TOUCH)
/dev/nvme0n1p3 Apple APFS               (MACOS DO NOT TOUCH)
/dev/nvme0n1p4 EFI System               (ASAHI EFI/BOOT DO NOT TOUCH)
/dev/nvme0n1p5 Linux filesystem         (Arch Arm Asahi)
/dev/nvme0n1p6 Apple Silicon recovery   (MACOS DO NOT TOUCH)
```

Technically you can delete the Arch Arm partition later but highly recommend you do not.  
Rather have an officially supported distro installed to install updates and so on.  
Also just good to have in emergencies.

Next we will create a partition to be used as swap.

**Warning: Swap on ZFS is extremely unstable and NOT recommended.**

1. see: https://github.com/openzfs/zfs/issues/7734
2. see: https://github.com/openzfs/zfs/issues/260#issuecomment-758782144

Instead we will be creating regular partition for swap.

In my case, I have 16GB ram and while it may be wasteful I still go by the old
addage of "2x your ram" for swap partition size. Maybe some day Asahi will support hibernation,
so let's be optimistic.

```
fdisk /dev/nvme0n1
n
+32GiB
t
(select your new partition)
19
```

Next, we will create the partition to be used for ZFS.  
This can be any size, I'll be using the remainder of the disk.

```
n
enter
enter
```

You should now have something like that looks like this:

```
Device             Start       End   Sectors  Size Type
/dev/nvme0n1p1         6    128005    128000  500M Apple Silicon boot
/dev/nvme0n1p2    128006  19555077  19427072 74.1G Apple APFS
/dev/nvme0n1p3  19555078  20165381    610304  2.3G Apple APFS
/dev/nvme0n1p4  20165382  20287493    122112  477M EFI System
/dev/nvme0n1p5  20287494  23217157   2929664 11.2G Linux filesystem
/dev/nvme0n1p6 242965551 244276259   1310709    5G Apple Silicon recovery
/dev/nvme0n1p7  23217408  31606015   8388608   32G Linux swap
/dev/nvme0n1p8  31606016 241321215 209715200  800G Linux filesystem
```

*Remember do NOT alter any of the p1-p5 or you may end up with an unbootable/bricked system...*

Make your swap

```
mkswap (YOUR SWAP PARTITION) (for me: /dev/nvme0n1p7)
```

## Creating the ZFS pool

Again, make sure you're using the correct partition.  
In my case here it is `/dev/nvme0n1p8`

If you're following something as niche as this guide I'm assuming
you're familiar with ZFS and the common options/features enabled.
If not, take some time to research (Google) each one below to ensure
its what you want.

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
  /dev/nvme0n1p8
```

You should now be able to see that pool with `zpool list`:

```
[root@alarm dev]# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
rpool   796G   576K   796G        -         -     0%     0%  1.00x    ONLINE  /mnt/gentoo
[root@alarm dev]#
```

## Creating datasets

```
mkdir -p /mnt/gentoo

# create encrypted parent dataset, prompting for password
zfs create -o mountpoint=none -o canmount=off -o encryption=on -o keyformat=passphrase -o keylocation=prompt rpool/gentoo

# create root dataset
zfs create -o canmount=noauto -o mountpoint=legacy rpool/gentoo/root

# mount it
mount -t zfs rpool/gentoo/root /mnt/gentoo

# make folders on the new root
for folder in boot home var sys dev proc ; do
    mkdir -p "/mnt/gentoo/$folder"
done

# optional but suggested, create separate /home and /var sets
zfs create -o mountpoint=legacy rpool/gentoo/home
zfs create -o mountpoint=legacy rpool/gentoo/var
mount -t zfs rpool/gentoo/home /mnt/gentoo/home
mount -t zfs rpool/gentoo/var /mnt/gentoo/var
```

You should now be able to see all of your datasets:

```
[root@alarm dev]# zfs list -t all
NAME                USED  AVAIL     REFER  MOUNTPOINT
rpool              1.69M   771G       96K  none
rpool/gentoo        816K   771G      192K  none
rpool/gentoo/home   192K   771G      192K  legacy
rpool/gentoo/root   240K   771G      240K  legacy
rpool/gentoo/var    192K   771G      192K  legacy
[root@alarm dev]#
```

And you should see that they are mounted:

```
[root@alarm dev]# mount | grep rpool
rpool/gentoo/root on /mnt/gentoo type zfs (rw,relatime,xattr,noacl)
rpool/gentoo/home on /mnt/gentoo/home type zfs (rw,relatime,xattr,noacl)
rpool/gentoo/var on /mnt/gentoo/var type zfs (rw,relatime,xattr,noacl)
[root@alarm dev]#
```

# And now for Gentoo

```
# copy your stage3 from your other machine
scp stage3-arm64-musl-hardened-*.tar.xz root@macbook:/mnt/gentoo/
cd /mnt/gentoo
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
rm stage3-*.tar.xz
# mount pseudo-filesystems
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
# copy resolv.conf
cp /etc/resolv.conf /mnt/gentoo/etc/
# chroot in!
chroot /mnt/gentoo
```

## Once inside

Now things should be familiar. Continue installing Gentoo roughly as normal.

```
# Fix paths, idk why arch is weird
export PATH="$PATH:/bin:/sbin"

# do this now so you dont forget later
passwd root

# Set up make.conf with some nice defaults:
cat >> /etc/portage/make.conf <<EOF
MAKEOPTS=-j$(nproc)
EMERGE_DEFAULT_OPTS="--alphabetical --ask --ask-enter-invalid --verbose"
FEATURES="fail-clean parallel-fetch parallel-install network-sandbox ipc-sandbox userpriv userfetch compress-build-logs compressdebug nodoc noinfo -news"
GRUB_PLATFORMS="efi-64"
EOF

emerge --sync
emerge --update --oneshot portage
```

#### If you're like me and nano drives you insane:

```
emerge busybox
ln -s $(which busybox) /bin/vi
emerge --rage-clean nano
sed -i 's/nano/vi/g' /etc/profile
source /etc/profile
env-update
```

### Setup required overlays

```
emerge -n eselect-repository dev-vcs/git

eselect repository enable musl
emerge --sync musl

cat > /etc/portage/repos.conf/asahi.conf <<EOF
[DEFAULT]
main-repo = asahi

[asahi]
location = /var/db/repos/asahi
sync-type = git
sync-uri = https://github.com/chadmed/asahi-overlay
auto-sync = yes
EOF
emerge --sync asahi
```

### Make necessary /etc/portage changes

```
rm -r \
  /etc/portage/package.mask \
  /etc/portage/package.accept_keywords \
  /etc/portage/package.use

mkdir -p /etc/portage/package.use

# musl workarounds
echo '*/*::musl' >> /etc/portage/package.unmask
echo '*/*::musl ~arm64' >> /etc/portage/package.accept_keywords
cat >>/etc/portage/package.mask<<EOF
# force usage of older elogind that is patched from the musl overlay
sys-auth/elogind::gentoo
EOF

# zfs packages will complain about not having "~arm64"
echo 'sys-fs/zfs ~arm64' >> /etc/portage/package.accept_keywords
echo 'sys-fs/zfs-kmod ~arm64' >> /etc/portage/package.accept_keywords

# allow grub to detect zfs
cat > /etc/portage/package.use/zfs.use <<EOF
sys-apps/util-linux static-libs
sys-boot/grub libzfs -themes
EOF

# asahi kernel stuff
echo "sys-kernel/asahi-sources symlink" >> /etc/portage/package.use/kernel.use
echo "sys-apps/kmod zstd" >> /etc/portage/package.use/kernel.use
echo "sys-kernel/linux-firmware linux-fw-redistributable no-source-code" >> /etc/portage/package.license
```

### install needed packages

```
emerge -avnuN asahi-sources
emerge -avnuN dracut
emerge -avnuN u-boot
emerge -avnuN kmod
emerge -avnuN dosfstools
emerge -avnuN efibootmgr

# NOTE: Current bug in m1n1, has a hardcoded glibc gcc for some reason.
#       I don't know why they aren't just calling gcc. This breaks our musl-libc.
#
# /bin/sh: line 1: aarch64-unknown-linux-gnu-gcc: command not found
#
# Workaround: temporarily create a symlink
ln -s $(which gcc) /usr/local/bin/aarch64-unknown-linux-gnu-gcc
emerge -avnuN m1n1
unlink /usr/local/bin/aarch64-unknown-linux-gnu-gcc

# Note this WILL FAIL as we don't have a kernel built yet to make the zfs module.
# Just attempt it anyway and let it fail at the end so we get the dependencies.
#
# Also note, it will grab gentoo-sources annoyingly as a dependency, just let it do it...
# We will be using asahi-sources obviously so just ignore the gentoo ones
emerge -avnuN grub
```

### mount EFI partition

```
# mount our Asahi ESP partition to /boot
# IMPORTANT: yes /boot, not /boot/efi!
#
# Make sure to mount the correct one, should look like this:
# /dev/nvme0n1p4  20165382  20287493    122112  477M EFI System
mount /dev/nvme0n1p4 /boot
```

### build the kernel

```
# verify /usr/src/linux points to the asahi sources
# (should be automatic due to our symlink use flag)
readlink /usr/src/linux

cd /usr/src/linux

# grab current known good config from the running Asahi Arch
zcat /proc/config.gz > .config

make -j"$(nproc)"

if [ -e /boot/vmlinuz-linux ] ; then
    mv -vf /boot/vmlinuz-linux /boot/vmlinuz-old
fi
if [ -e /boot/initramfs-linux.img ] ; then
    mv -vf /boot/initramfs-linux.img /boot/initramfs-old.img
fi

KERNVER=$(make -s kernelrelease)
echo "Kernel Version: $KERNVER"
make modules_install
make install

# you should now see your new kernel files in /boot
ls /boot
```

### Finish emerging grub/zfs

Now that we have a working compiled kernel tree, we can successfully
build the zfs kernel module and link it with grub

```
emerge -av =sys-fs/zfs-kmod-2.1.11::mitchw
emerge -av grub
```

### dracut for initramfs

```
mkdir -p /etc/dracut.conf.d

# grab chadmed's dracut.conf
wget https://github.com/chadmed/asahi-gentoosupport/raw/main/resources/dracut.conf \
  -O /etc/dracut.conf.d/10-apple.conf

# add zfs support
cat >>/etc/dracut.conf.d/10-apple.conf <<EOF

# Add ZFS support
nofsck="yes"
add_dracutmodules+=" zfs "
omit_dracutmodules+=" btrfs resume "
EOF

dracut \
    --force \
    --quiet \
    --kver "${KERNVER}" \
    --compress gzip
```

### Grub!

Note: I like net.ifnames=0 and zswap, but feel free to disable if you wish.

```
cat >/etc/default/grub <<EOF
GRUB_DISTRIBUTOR="Gentoo"
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_TERMINAL=console
GRUB_DISABLE_LINUX_PARTUUID=false
GRUB_DISABLE_RECOVERY=true
GRUB_DISABLE_SUBMENU=y
GRUB_CMDLINE_LINUX="dozfs root=ZFS=rpool/gentoo/root net.ifnames=0 nowatchdog zswap.enabled=1 zswap.compressor=lz4"
EOF

grub-install --removable --efi-directory=/boot --boot-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

### asahi-scripts and firmware

```
update-m1n1
emerge -avnuN asahi-firmware
emerge -avnuN linux-firmware
asahi-fwextract
```

## ZFS services

```
rc-update add zfs-import boot
rc-update add zfs-mount boot
rc-update add zfs-share default
rc-update add zfs-zed default
```

## Finishing touches

Create your `/etc/fstab`

*Note, again here `/dev/nvme0n1p4` is my EFI partition*

```
# <fs>                <mountpoint>        <type>      <opts>            <dump/pass>
# ============================================================================================
/dev/nvme0n1p4        /boot               vfat        noauto            1 2
rpool/gentoo/root     /                   zfs         rw,xattr,posixacl 0 0
rpool/gentoo/home     /home               zfs         rw,xattr,posixacl 0 0
rpool/gentoo/var      /var                zfs         rw,xattr,posixacl 0 0
tmpfs                 /var/tmp/portage    tmpfs size=2G,uid=portage,gid=portage,mode=775,nosuid,noatime,nodev 0 0
```

# You're done!

Last checks

1. make sure you set a root password
2. install any networking packages you may need after reboot

# Links

1. https://github.com/AsahiLinux/docs/wiki/Installing-Gentoo-with-LiveCD
2. https://github.com/chadmed/asahi-gentoosupport
