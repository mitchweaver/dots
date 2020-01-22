#!/bin/loksh
#
# http://github.com/mitchweaver/dots
#

# don't run if not interactive
[[ $- != *i* ]] && return

# fix shell env variable if its broken
export SHELL=${SHELL:-$0}

ulimit -c 0

# ksh-specific alternatives
alias echo='builtin print'
alias type='builtin whence -v'

# source my aliases
[ -f ${HOME}/etc/aliases ] && . ${HOME}/etc/aliases

set -o bgnice nohup trackall csh-history vi-tabcomplete

export HISTFILE=${HOME}/tmp/.ksh_history \
       SAVEHIST=500 \
       HISTSIZE=500 \
       HISTCONTROL=ignoreboth

# cd, with recursive fuzzy-find
cd() { 
    if [ $# -eq 0 ] ; then
        builtin cd ${HOME}
    else
        builtin cd "$@" ||
        builtin cd "$@"* ||
        builtin cd *"$@" ||
        builtin cd *"$@"* ||
        for i in 0 1 2 3 4 5 6 7 8 ; do
            builtin cd "$(find . -maxdepth $(($i + 1)) -mindepth $i -type d -iname "*$@*" | head -n 1)" &&
                break
        done
    fi 2> /dev/null
    ! pgrep -x 9term >/dev/null &&
    # export PS1="$(_get_PS1)${RANGER_LEVEL:+[ranger] }${FFF_LEVEL:+[fff] }${SSH_TTY:+[SSH] }"
    PS1="$(_get_PS1)"
    if [ "$RANGER_LEVEL" ] ; then
        set -- $PS1
        PS1="[ranger: $*] "
    fi
    export PS1
}

# get which git branch we're on, used in our PS1
_parse_branch() { 
    set -- $(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>/dev/null)
    [ "$1" ] && echo -n "($*) "
}

_get_PS1() {
    case ${USER} in
        # for colored PS1
        # mitch) _get_PS1() { echo -n "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W$(_parse_branch)\[\e[1;37m\] " ; } ;;
        mitch) echo -n "\[\e[1;37m\]\W $(_parse_branch)" ;;
        root) echo -n "\[\e[1;37m\]root \W " ;;
        *)     _get_PS1() { echo -n '% \W ' ; }
    esac
}

# check if we're in ranger/fff or not
[ "$RANGER_LEVEL" ] && clear

# this activates our PS1
cd .
