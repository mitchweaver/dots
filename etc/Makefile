all:
	@>&2 echo "Use 'make install'."

install:
	install -D -m 0644 rc.local /etc/rc.local
	install -D -m 0644 resolv.conf.tail /etc/resolv.conf.tail
	install -D -m 0644 X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
