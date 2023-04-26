genkernel \
	--no-clean --no-mrproper --oldconfig \
	--menuconfig --makeopts=-j21 \
	--no-zfs \
	--no-hyperv \
	--no-virtio \
	--no-btrfs \
	--lvm --mdadm \
	--mdadm-config=/etc/mdadm.conf all
