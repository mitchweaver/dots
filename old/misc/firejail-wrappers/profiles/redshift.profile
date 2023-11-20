# vim:ft=config

quiet
include redshift.local
include globals.local

noblacklist ${HOME}/.config/redshift
noblacklist ${HOME}/.config/redshift.conf

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/redshift
whitelist ${HOME}/.config/redshift
whitelist ${HOME}/.config/redshift.conf
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
