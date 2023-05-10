#!/bin/sh

# determine whether binary or compiled, on gentoo 
if command -v librewolf >/dev/null ; then
    LIBREWOLF=librewolf
elif command -v librewolf-bin >/dev/null ; then
    LIBREWOLF=librewolf-bin
fi

exec firejail \
    --profile="${HOME}/.firejail/joplin.profile" \
    /usr/bin/$LIBREWOLF "$@"
