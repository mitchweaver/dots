# After install

## install all packages

## setup environment

```
rc-update add sshd default
rc-update add sysklogd default
rc-update add cronie default
rc-update add chronyd default
rc-update add fail2ban default
rc-update add cupsd default
rc-update add bluetooth default
rc-update add docker default
rc-update add elogind default
rc-update add display-manager default
rc-update add dnsmasq default
useradd -m -G users,wheel,audio,video,lpadmin,input -s /bin/bash mitch
passwd mitch
echo "US/Central" > /etc/timezone
emerge --config sys-libs/timezone-data
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
eselect locale set en_US.utf8
locale-gen
env-update

emerge --rage-clean nano
sed -i 's/nano/vi/g' /etc/profile
emerge sudo
EDITOR=vi visudo
```


```
mkdir -p /etc/modprobe.d ; rmmod pcspkr ; echo "blacklist pcspkr" >>/etc/modprobe.d/blacklist.conf
```
