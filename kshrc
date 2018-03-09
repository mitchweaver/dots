#!/bin/ksh
#
# http://github.com/mitchweaver/dots
#

# don't run if not interactive
[[ $- != *i* ]] && return

set bgnice 
set nohup
set -o vi-tabcomplete
bind Space:magic-space > /dev/null

alias echo='builtin print'
alias type='builtin whence -v'

# unaliases
alias {fc,w,r,bg,fg,jobs,autoload,local,login,stop}=true 

export HISTFILE=${HOME}/tmp/.ksh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoreboth
ulimit -c 0

parse_branch() { git branch 2> /dev/null | \
    sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' ; }

cd() { [ $# -eq 0 ] &&
           builtin cd ${HOME} ||
           builtin cd "$1"
        export PS1="$(get_PS1)" ; }

case ${SHELL} in
    /bin/ksh)
        [ $(id -u) -eq 0 ] &&
            get_PS1() { echo "\[\e[0;32m\][root]\[\e[1;36m\] \W\[\e[1;37m\] " ; } ||
            get_PS1() { echo "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W$(parse_branch)\[\e[1;37m\] " ; } ;;
    /bin/mksh)
        _x="$(print \\001)"
        get_PS1() { 
            case ${PWD} in
                ${HOME}) tmp_pwd='~' ;;
                *) tmp_pwd=`basename "${PWD}"`
            esac
            echo -n "$_x$(print \\r)$_x\e[1;35mm$_x\e[0;32mi$_x\e[0;33mt$_x\e[0;34mc$_x\e[1;31mh$_x\e[1;36m $tmp_pwd$_x$(parse_branch)$_x\e[1;37m "
        } ;;
esac

export PS1="$(get_PS1)"

(rm -rfP \
    ${HOME}/*.core \
    ${HOME}/*.dump \
    ${HOME}/Desktop \
    ${HOME}/Downloads \
    ${HOME}/nohup.out \
    ${HOME}/*.hup \
    ${HOME}/.xsel.log \
> /dev/null 2>&1 &)

. ${HOME}/etc/aliases
