#!/bin/sh

sudo install -Dvm 0644 ./etc/NetworkManager/conf.d/20-rc-manager.conf /etc/NetworkManager/conf.d/20-rc-manager.conf
sudo install -Dvm 0644 ./etc/NetworkManager/conf.d/99-stay-away-from-my-dns-poettering.conf /etc/NetworkManager/conf.d/99-stay-away-from-my-dns-poettering.conf

sudo install -Dvm 0644 ./etc/sysctl.d/40-no_ipv6.conf /etc/sysctl.d/40-no_ipv6.conf

sudo install -Dvm 0644 ./etc/resolvconf.conf /etc/resolvconf.conf

