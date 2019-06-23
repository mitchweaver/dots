#!/bin/mksh
#
# http://github.com/mitchweaver/dots
#

# don't run if not interactive
[[ $- != *i* ]] && return

# ksh-specific alternatives
alias echo='builtin print'
alias type='builtin whence -v'

# source my aliases
. ${HOME}/etc/aliases

set -o bgnice nohup trackall

case ${SHELL} in
    /*/mksh) set -o vi ;;
    /*/ksh) set -o csh-history vi-tabcomplete
esac

export HISTFILE=${HOME}/tmp/.ksh_history \
       {SAVEHIST,HISTSIZE}=1000 \
       HISTCONTROL=ignoreboth

ulimit -c 0

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
    export PS1="$(_get_PS1)${RANGER_LEVEL:+[ranger] }${SSH_TTY:+(SSH) }"
}

# get which git branch we're on, used in our PS1
_parse_branch() { 
    local branch=`git rev-parse --symbolic-full-name --abbrev-ref HEAD`
    [ -n "$branch" ] &&
        echo -n " $branch"
} 2> /dev/null 

# todo: clean this mess
case ${SHELL} in
    /*/mksh)
        _x="$(echo -n \\001)"
        _get_PS1() { 
            case ${PWD} in
                ${HOME}) local tmp_pwd='~' ;;
                '/') local tmp_pwd='/' ;;
                *) local tmp_pwd="${PWD##*/}"
            esac
            case ${USER} in
                mitch) echo -n "$_x$(echo -n \\r)$_x\e[1;35mm$_x\e[0;32mi$_x\e[0;33mt$_x\e[0;34mc$_x\e[1;31mh$_x\e[1;36m $tmp_pwd$_x$(_parse_branch)$_x\e[1;37m " ;;
                root)  echo -n "$_x$(echo -n \\r)$_x\e[1;35m[root]$_x\e[1;36m $tmp_pwd$_x$(_parse_branch)$_x\e[1;37m " ;;
                *)     echo -n '% $tmp_pwd '
            esac
        } ;;
    /*/ksh) # openbsd
        case ${USER} in
            mitch) _get_PS1() { echo -n "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W $(_parse_branch)\[\e[1;37m\] " ; } ;;
            root)  _get_PS1() { echo -n "\[\e[0;32m\][root]\[\e[1;36m\] \W\[\e[1;37m\] " ; } ;;
            *)     _get_PS1() { echo -n '% \W ' ; }
        esac
esac

# check if we're in ranger or not
[ -n "$RANGER_LEVEL" ] && clear

# this activates our PS1
cd .

# clear junk i hate seeing
(rm -rf ${HOME}/{*.core,*.out,*.dump,Desktop,Downloads} 2> /dev/null &)
