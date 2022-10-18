#!/bin/sh

exec firejail --profile="${HOME}/.firejail/discord.profile" discord
