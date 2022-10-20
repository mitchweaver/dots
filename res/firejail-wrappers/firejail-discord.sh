#!/bin/sh

exec firejail --profile="${HOME}/.firejail/discord.profile" /usr/bin/discord "$@"
