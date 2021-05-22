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
	#
	sudo systemctl enable ntpd
	sudo systemctl start ntpd
