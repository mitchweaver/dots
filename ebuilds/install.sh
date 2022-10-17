#!/bin/sh

if ! grep '[mitchw]' /etc/portage/repos.conf/eselect-repo.conf >/dev/null ; then
	if grep 'app-eselect/eselect-repository' /var/lib/portage/world >/dev/null ; then
		eselect repository create mitchw
	else
		>&2 echo 'You need to emerge eselect-repository.'
		exit 1
	fi
fi

rsync -avhu --progress --delete mitchw/ /var/db/repos/mitchw
