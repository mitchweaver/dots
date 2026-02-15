# After install

## install all packages

## setup environment

```
rc-update add sshd default
rc-update add sysklogd default
rc-update add cronie default
rc-update add ntpd default
rc-update add fail2ban default
rc-update add cupsd default
rc-update add bluetooth default
rc-update add dnsmasq default
rc-update add resolvconf default
rc-update add elogind boot

############rc-update add docker default
#############rc-update add display-manager default

# remember to also edit /etc/passwd for uid/gid for NFS exports to match
useradd -m -G users,wheel,audio,video,lpadmin,input -s /bin/bash mitch
passwd mitch

echo "US/Central" > /etc/timezone
emerge --config sys-libs/timezone-data
ln -sf ../usr/share/zoneinfo/US/Central /etc/localtime

# if glibc:
printf 'en_US.UTF-8 UTF-8\nC.UTF8 UTF-8\n' > /etc/locale.gen
eselect locale set en_US.utf8
locale-gen

env-update

EDITOR=vi visudo

hostname XXXXXXX
```


```
mkdir -p /etc/modprobe.d ; rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf
```
