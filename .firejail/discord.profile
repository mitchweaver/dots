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
