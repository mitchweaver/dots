#!/bin/sh

exec firejail --profile="${HOME}/.firejail/nextcloud-desktop.profile" /usr/bin/nextcloud "$@"
