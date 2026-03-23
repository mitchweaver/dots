#!/bin/sh
#
# echo back correct -fuse-ld based on whether we have mold installed or not
#

if [ -x /usr/bin/mold ] ; then
    printf '%s' '-fuse-ld=mold'
else
    printf '%s' '-fuse-ld=ld'
fi

