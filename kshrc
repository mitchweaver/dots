#!/bin/ksh
#
# http://github.com/mitchweaver/dots
#

ulimit -c 0

# ksh-specific alternatives
alias echo='builtin print'
alias type='builtin whence -v'

# source my aliases
[ -f ${HOME}/src/dots/aliases ] && . ${HOME}/src/dots/aliases

set -o bgnice nohup trackall csh-history vi-tabcomplete

export HISTFILE=${HOME}/tmp/.ksh_history \
       HISTCONTROL=ignoreboth \
       HISTSIZE=500 \
       SAVEHIST=500

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
    [ "$1" ] && echo -n " ($*)"
}

_get_PS1() {
    case ${USER} in
        alan)  echo -n "\[\e[1;35m\]a\[\e[0;32m\]l\[\e[0;33m\]a\[\e[0;34m\]n\[\e[1;36m\] \W$(_parse_branch)\[\e[1;37m\] " ;;
        mitch) echo -n "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W$(_parse_branch)\[\e[1;37m\] " ;;
        root)  echo -n "\[\e[1;37m\]root \W " ;;
        *)     echo -n '% \W '
    esac
}

# check if we're in ranger/fff or not
[ "$RANGER_LEVEL" ] && clear

# this activates our PS1
cd .
