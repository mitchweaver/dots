# Properly set up GentooLTO

0. copy your custom configs over `/etc/portage`
1. comment `include /etc/portage/make.conf.lto` out in make.conf
2. add the gentoo-lto overlay
3. install ltoize
4. uncomment `make.conf.lto`
5. update world

if you have tons of ram, like 32gb+ add this to speed up compile to `/etc/fstab`, then `mount /var/tmp/portage`
```
tmpfs		/var/tmp/portage		tmpfs	size=12G,uid=portage,gid=portage,mode=775,nosuid,noatime,nodev	0 0
```

## Commands

```
emerge eselect-repository dev-vcs/git
emerge --sync lto-overlay
emerge --sync mv
emerge ltoize
# now uncomment make.conf.lto and rebuild gcc to add lto/pgo/graphite support
mkdir -p /var/tmp/notmpfs
CFLAGS="-O2 -march=native -pipe" USE="-lto -pgo graphite" emerge -av gcc

eselect gcc list
eseelect gcc set (whatever is new that got built)

emerge --depclean

# rebuild gcc, now with lto/pgo/graphite on itself
emerge --newuse --with-bdeps y --update --verbose gcc

# ltoize the world
emerge --deep --with-bdeps y --verbose --keep-going @world

# update with any new flags after
emerge --newuse --deep --with-bdeps y --update --verbose --keep-going @world
mkdir -p /var/tmp/notmpfs
```

