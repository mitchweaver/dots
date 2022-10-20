#!/bin/sh

exec firejail --profile="${HOME}/.firejail/redshift.profile" /usr/bin/redshift "$@"
