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
useradd -m -G users,wheel,audio,video,lpadmin -s /bin/bash mitch
passwd mitch
echo "US/Central" > /etc/timezone
emerge --config sys-libs/timezone-data
eselect locale set en_US.utf
locale-gen
env-update
```
