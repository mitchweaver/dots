# vim:ft=config

# include globals.local

#include disable-common.inc	# dangerous directories like ~/.ssh and ~/.gnupg
#include disable-programs.inc
#include disable-exec.inc	# non-executable directories such as /var, /tmp, and /home
#include disable-shell.inc	# sh, bash, zsh etc.
#include disable-xdg.inc	# standard user directories: Documents, Pictures, Videos, Music

include disable-devel.inc	# development tools such as gcc and gdb
include disable-interpreters.inc	# perl, python, lua etc.

include email-common.profile

whitelist ${HOME}/.config/Mailspring
whitelist /usr/share/mailspring
noblacklist /usr/share/mailspring
noblacklist ${HOME}/.config/Mailspring

whitelist /usr/bin/mailspring
noblacklist /usr/bin/mailspring

whitelist /usr/share/mailspring
noblacklist /usr/share/mailspring

# caps.drop all
# ipc-namespace
# netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none

private-dev

private-etc os-release,fonts,localtime,selinux,
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl
