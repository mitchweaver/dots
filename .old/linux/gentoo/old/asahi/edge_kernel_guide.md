# ------------------------ Links: -------------------------------------------
# https://docs.kernel.org/rust/quick-start.html
# https://github.com/rust-lang/rust-bindgen
# https://github.com/AsahiLinux/PKGBUILDs/blob/main/linux-asahi/config.edge
# ---------------------------------------------------------------------------

# Getting Rust

check if working rust toolchain + needed packages

```sh
cd /usr/src/linux
export LIBCLANG_PATH=/usr/lib/llvm/15/lib
make rustavailable
```

You will say you're missing bindgen, source modules, or rust itself.  
Let's fix that.

```sh
cat >>/etc/portage/package.use/rust.use <<"EOF"
dev-lang/rust rust-src rustfmt rust-analyzer system-llvm -miri -clippy
dev-lang/rust-bin rust-src rustfmt rust-analyzer system-llvm -miri -clippy
virtual/rust rust-src rustfmt
EOF

cat >>/etc/portage/package.mask <<"EOF"
# =========================================================
# Asahi Linux
# =========================================================
# At time of writing rust must be 1.66.0 or newer for kernel 6.2.0
<dev-lang/rust-1.66.0
<dev-lang/rust-bin-1.66.0
<virtual/rust-1.66.0
# highest version allowed for kernel 6.2.0 is 0.56.0
>dev-util/bindgen-0.56.0
EOF

cat >>/etc/portage/package.accept_keywords <<"EOF"
# for rust bindings, which we need for the Asahi GPU
# note: at time of writing the only version of bindgen that works
#       with Asahi's kernel version (6.2.0) is 0.56.0
=dev-util/bindgen-0.56.0::gentoo **
EOF

# note: worth checking the musl overlay to see if they have one with any patches
#       at time of writing the latest they had was 1.62.0 which would not work
emerge -1nuN dev-lang/rust-bin::gentoo
emerge -1n =dev-util/bindgen-0.56.0::gentoo
```

### Check again, this time to see if it can find clang

```sh
# bug, need to patch to ensure we get feedback if we're still missing clang
# see: https://lkml.org/lkml/2023/5/7/230

patch -p0 <<"EOF"
--- scripts/rust_is_available.sh
+++ scripts/rust_is_available.sh
@@ -106,6 +106,15 @@
 ·  ·   | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' \
 ·  ·   | head -n 1 \
 )
+if [ -z "$bindgen_libclang_version" ]; then
+    if [ "$1" = -v ]; then
+        echo >&2 "***"
+        echo >&2 "*** libclang could not be found by bindgen.  Ensure that LIBCLANG_PATH"
+        echo >&2 "*** is set correctly."
+        echo >&2 "***"
+    fi
+    exit 1;
+fi
 bindgen_libclang_min_version=$($min_tool_version llvm)
 bindgen_libclang_cversion=$(get_canonical_version $bindgen_libclang_version)
 bindgen_libclang_min_cversion=$(get_canonical_version $bindgen_libclang_min_version)
EOF
```

### You should now get something like this.

If you get the message that libclang can't be found, you need to fix your clang installation.

```sh
macbook /usr/src/linux $ export LIBCLANG_PATH=/usr/lib/llvm/15/lib
macbook /usr/src/linux $ make rustavailable
***
*** Rust compiler 'rustc' is too new. This may or may not work.
***   Your version:     1.66.1
***   Expected version: 1.66.0
***
Rust is available!
```

## Getting the asahi-edge kernel config

This is an extension of the default asahi config that needs appended to our .config

```sh
# copy known good config
zcat /proc/config.gz > .config
wget https://github.com/AsahiLinux/PKGBUILDs/raw/main/linux-asahi/config.edge
cat config.edge >> .config
```

However, Asahi Arch Arm already has rust kernel support, we do not yet.

Can verify this with:

```sh
grep CONFIG_RUST=y .config
```

To add it:

```sh
export LIBCLANG_PATH=/usr/lib/llvm/15/lib
make menuconfig
```

Enable as built-in:

```
General Setup ->
  [*] Rust Support
```

Save and exit.  
You should now see your asahi GPU driver in your .config:

```sh
$ grep DRM_ASAHI .config
CONFIG_DRM_ASAHI=m
```

If you do not, you may need to go to `Deivce Drivers -> Graphics Support` and enable it.  
**WARNING**: DO NOT ENABLE AS BUILT-IN, ONLY MODULE!

## Build and install

```sh
make -j$(nproc)

# make sure your /boot is mounted
mount /boot

# ================================================================
# Note: if this is your first time building, your old kernel files
#       won't have the -edge tag on them so they will be different
#
#       Keep this in mind, may want to leave the old ones around
#       in case the edge kernel doesn't boot for some reason
#
##### store old kernel files just in case
#####mkdir -p /boot/old
#####mv -vf /boot/System.map-* /boot/old/
#####mv -vf /boot/config-*     /boot/old/
#####mv -vf /boot/initramfs-*  /boot/old/
#####mv -vf /boot/vmlinuz-*    /boot/old/
# ================================================================

KERNVER=$(make -s kernelrelease)

# You should now see the -edge on your kernel version.
echo "Kernel Version: $KERNVER"

make modules_install
make install

# you should now see your new kernel files in /boot
ls /boot

# Keep in mind, ZFS is a kernel module.
# Every time we touch the kernel we should rebuild it to be safe.
emerge -av =sys-fs/zfs-kmod-2.1.11::mitchw

# rebuild initramfs
dracut \
    --force \
    --quiet \
    --kver "${KERNVER}" \
    --compress gzip

# boot loader and firmware
grub-mkconfig -o /boot/grub/grub.cfg
# do NOT forget to update m1n1
update-m1n1
# reinstall these just to be safe
emerge -av linux-firmware
emerge -av asahi-firmware
# re-run extractor
asahi-fwextract
```

## Reboot

If all things go well, you should now be able to reboot.  
Make sure to select `-edge` in the grub menu if it happens not to be the default.

You should now be able to see your GPU driver in `lsmod`.

