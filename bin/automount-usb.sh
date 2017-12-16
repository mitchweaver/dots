#!/bin/sh

DEVCLASS=$1
DEVNAME=$2
MOUNTROOT="/mnt"
DEBUG=0

case $DEVCLASS in
2)
	# disk devices
	disklabel=`/sbin/disklabel $DEVNAME 2>&1 | \
	sed -n '/^disk: /s/^disk: //p'`
[ $DEBUG == 1 ] && logger -i "hotplugd descovered DISKLABEL $disklabel"
	case $disklabel in
	"SCSI disk")
		slices=`/sbin/disklabel $DEVNAME 2>&1 | \
		sed -n '/^ *[abd-z]: /s/^ *\([abd-z]\):.*/\1/p'`
		for slice in ${slices}; do
[ $DEBUG == 1 ] && logger -i "hotplugd attaching SLICE $slice of DEVICE $DEVNAME"
			[ ! -d $MOUNTROOT/$DEVNAME$slice ] && mkdir -p -m 1777 $MOUNTROOT/$DEVNAME$slice
			mount /dev/$DEVNAME$slice $MOUNTROOT/$DEVNAME$slice
		done
		;;
	esac
	;;
3)
	# network devices; requires hostname.$DEVNAME
	sh /etc/netstart $DEVNAME
	;;
esac

# chmod 0755 /etc/hotplug/attach
