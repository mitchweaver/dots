all:
	sudo cp -f resolvconf.conf /etc/
	sudo resolvconf -u
	#
	sudo rm -rf /etc/dnscrypt-proxy
	sudo cp -rf dnscrypt-proxy /etc/
	sudo systemctl enable dnscrypt-proxy
	sudo systemctl start dnscrypt-proxy
	#
	sudo systemctl enable tor
	sudo systemctl start tor
