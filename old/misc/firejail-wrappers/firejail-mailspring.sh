#!/bin/sh

if [ -e /usr/bin/mailspring ] ; then
    mailspring=/usr/bin/mailspring

    if [ -L "$mailspring" ] ; then
        mailspring=/usr/share/mailspring/mailspring
    fi
else
    mailspring=$(which mailspring)
fi

# --appimage \
exec firejail \
    --profile="${HOME}/.firejail/mailspring.profile" \
    $mailspring --no-sandbox
