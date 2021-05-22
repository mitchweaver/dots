all:
	# resolv.conf management with resolvconf
	sudo cp -f resolvconf.conf /etc/
	sudo resolvconf -u
	sudo mkdir -p /etc/NetworkManager/conf.d
	sudo cp -f NetworkManager/conf.d/20-rc-manager.conf /etc/NetworkManager/conf.d/
	sudo cp -f NetworkManager/conf.d/99-stay-away-from-my-dns-poettering.conf /etc/NetworkManager/conf.d/
	#
	sudo rm -rf /etc/dnscrypt-proxy
	sudo cp -rf dnscrypt-proxy /etc/
	sudo systemctl enable dnscrypt-proxy
	sudo systemctl start dnscrypt-proxy
	#
	sudo systemctl enable tor
	sudo systemctl start tor
	# openntpd from OpenBSD
	sudo cp -f ntpd.conf /etc/
	sudo systemctl enable openntpd
	sudo systemctl start openntpd
	# xorg.conf.d
	sudo mkdir -p /etc/X11/xorg.conf.d
	sudo cp -f X11/xorg.conf.d/10-libinput.conf /etc/X11/xorg.conf.d/
	# no ipv6
	sudo mkdir -p /etc/sysctl.d
	sudo cp -f sysctl.d/40-no_ipv6.conf /etc/sysctl.d/
	sudo systemctl restart systemd-sysctl
