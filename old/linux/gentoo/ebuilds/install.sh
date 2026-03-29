#!/bin/sh

if ! grep 'mitchw' /etc/portage/repos.conf/eselect-repo.conf >/dev/null ; then
	sudo eselect repository create mitchw
fi

sudo rsync -avhu --progress --delete mitchw/ /var/db/repos/mitchw
