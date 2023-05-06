#!/bin/sh

mailspring=/usr/bin/mailspring

if [ -L "$mailspring" ] ; then
    mailspring=/usr/share/mailspring/mailspring
fi

# --appimage \
exec firejail \
    --profile="${HOME}/.firejail/mailspring.profile" \
    $mailspring --no-sandbox
