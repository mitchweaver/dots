#!/bin/sh

for i in joplin-bin joplin-desktop-bin ; do
    if [ -x /usr/bin/$i ] ; then
        joplin=$i
    fi
done

[ "$joplin" ] || exit 1

exec firejail --appimage --profile="${HOME}/.firejail/joplin.profile" "/usr/bin/$joplin" "$@"
