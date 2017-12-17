# $OpenBSD: dot.profile,v 1.4 2005/02/16 06:56:57 matthieu Exp $
#
#sh/ksh initialization

PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
export PATH HOME TERM

# source /etc/profile

if test -n "$ZSH_VERSION"; then
    source .zshrc
elif test -n "$BASH_VERSION"; then
    source .bashrc
elif test -n "$KSH_VERSION"; then
    ENV=~/.kshrc ; . $ENV
    export ENV
elif test -n "$FCEDIT"; then
    ENV=~/.kshrc ; . $ENV
    export ENV
fi


if [ ${#X} -gt 0 ]
	then
		true
		#X has already been started as it has a pid
	else
		exec startx &
fi
