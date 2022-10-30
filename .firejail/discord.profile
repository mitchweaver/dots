# Firejail profile for discord
# This file is overwritten after every install/update
# Persistent local customizations
include discord.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
whitelist ${HOME}/.config/discord

# need these three for xdg-open to open links
# in main browser from within discord
private-bin firefox,awk,readlink,env,discord
private-opt discord

# Redirect
include discord-common.profile

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

include firefox-common.profile

noblacklist /home/mitch/downloads
whitelist /home/mitch/downloads

noblacklist /home/mitch/tmp
whitelist /home/mitch/tmp

noblacklist /home/mitch/.cache/discord_cache
whitelist /home/mitch/.cache/discord_cache

