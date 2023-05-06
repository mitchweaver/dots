#!/bin/sh

if [ -x /usr/bin/discord ] ; then
    discord=discord
elif [ -x /usr/bin/Discord ] ; then
    discord=Discord
fi

exec firejail --profile=/etc/firejail/"$discord".profile "/usr/bin/$discord"
