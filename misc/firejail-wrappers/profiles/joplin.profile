# vim:ft=config

include electron.local

noblacklist ${HOME}/.config/Electron
noblacklist ${HOME}/.config/electron*-flag*.conf

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/Electron
whitelist ${HOME}/.config/electron*-flag*.conf
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

whitelist ${HOME}/.config/joplin
whitelist ${HOME}/.config/Joplin
noblacklist ${HOME}/.config/joplin
noblacklist ${HOME}/.config/Joplin
whitelist ${HOME}/.config/joplin-desktop
noblacklist ${HOME}/.config/joplin-desktop

caps.drop all
apparmor
caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
noinput
notv
nou2f
novideo
shell none

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
