#!/bin/sh

exec firejail --profile="${HOME}/.firejail/spotify.profile" /usr/bin/spotify "$@"
