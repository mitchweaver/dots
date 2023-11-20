# Firejail profile alias for nextcloud
# This file is overwritten after every install/update
# Persistent local customizations
include nextcloud-desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

whitelist ${HOME}/nextcloud
noblacklist ${HOME}/nextcloud 

whitelist ${HOME}/Downloads
noblacklist ${HOME}/Downloads

whitelist ${HOME}/downloads
noblacklist ${HOME}/downloads

# Redirect
include nextcloud.profile
