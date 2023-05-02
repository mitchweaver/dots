#!/bin/sh

exec firejail --profile="${HOME}/.firejail/mailspring.profile" /usr/bin/mailspring "$@"
