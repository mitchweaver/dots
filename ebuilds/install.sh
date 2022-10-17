#!/bin/sh

if ! grep '[mitchw]' /etc/portage/repos.conf/eselect-repo.conf >/dev/null ; then
	eselect repository create mitchw
fi

rsync -avhu --progress --delete mitchw/ /var/db/repos/mitchw
