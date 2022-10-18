# vim:ft=config

include /usr/share/mailspring/mailspring.local
include globals.local

# include disable-common.inc	# dangerous directories like ~/.ssh and ~/.gnupg
# include disable-programs.inc
#include disable-devel.inc	# development tools such as gcc and gdb
#include disable-exec.inc	# non-executable directories such as /var, /tmp, and /home
#include disable-interpreters.inc	# perl, python, lua etc.
#include disable-shell.inc	# sh, bash, zsh etc.
#include disable-xdg.inc	# standard user directories: Documents, Pictures, Videos, Music

whitelist ${HOME}/.config/Mailspring
whitelist /usr/share/mailspring
noblacklist /usr/share/mailspring
noblacklist ${HOME}/.config/Mailspring

include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# include disable-shell.inc

caps.drop all
ipc-namespace
netfilter
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
# include allow-bin-sh.inc

noblacklist ${HOME}/.mozilla
whitelist ${HOME}/.mozilla/firefox/profiles.ini
read-only ${HOME}/.mozilla/firefox/profiles.ini

# disable-mnt
# private-dev
private-bin bash,
private-etc os-release,fonts,localtime,selinux,
private-etc alternatives,ca-certificates,crypto-policies,fonts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,machine-id,nsswitch.conf,pki,resolv.conf,ssl

include electron.profile
