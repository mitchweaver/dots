#!/bin/mksh
#
# http://github.com/mitchweaver/dots
#

# don't run if not interactive
[[ $- != *i* ]] && return

alias echo='builtin print'
alias type='builtin whence -v'

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

cd() { 
    if [ $# -eq 0 ] ; then
        builtin cd ${HOME}
    else
        builtin cd "$@"   ||
        builtin cd *"$@"  ||
        builtin cd "$@"*  ||
        builtin cd *"$@"* ||
        builtin cd "$(find . -iname *"$@"* -maxdepth 1 | head -n 1)" ||
        builtin cd "$(find . -iname *"$@"* -maxdepth 2 | head -n 1)" ||
        builtin cd "$(find . -iname *"$@"* -maxdepth 10 | head -n 1)"
    fi 2> /dev/null
    export PS1="$(_get_PS1)${RANGER_LEVEL:+[ranger] }${SSH_TTY:+(SSH) }"
}

_parse_branch() { 
    git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
} 2> /dev/null 

# todo: find a good way to wrap these
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
            mitch) _get_PS1() { echo -n "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W$(_parse_branch)\[\e[1;37m\] " ; } ;;
            root)  _get_PS1() { echo -n "\[\e[0;32m\][root]\[\e[1;36m\] \W\[\e[1;37m\] " ; } ;;
            *)     _get_PS1() { echo -n '% \W ' ; }
        esac
esac

[ -n "$RANGER_LEVEL" ] && clear

cd .

(rm -rf ${HOME}/{*.core,*.out,*.dump,Desktop,Downloads} 2> /dev/null &)
