#!/bin/ksh
#
# http://github.com/mitchweaver/dots
#

# don't run if not interactive
[[ $- != *i* ]] && return

# unaliases
alias {fc,w,r,bg,fg,jobs,autoload,login,stop}=true 

. ${HOME}/etc/aliases

alias echo='builtin print'
alias type='builtin whence -v'

set bgnice
set nohup
set -o vi-tabcomplete
set -o csh-history
bind Space:magic-space > /dev/null

export HISTFILE=${HOME}/tmp/.ksh_history
export {SAVEHIST,HISTSIZE}=100000
export HISTCONTROL=ignoreboth
ulimit -c 0

parse_branch() { git branch 2> /dev/null | \
    sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' ; }

cd() { [ $# -eq 0 ] &&
           builtin cd ${HOME} ||
                 builtin cd "$1"
        [ -n "$RANGER_LEVEL" ]  &&
            export PS1="$PS1(RANGER): " ||
            export PS1="$(get_PS1)" ; }

# todo: find a good way to wrap these
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

[ -n "$RANGER_LEVEL" ]  && 
    { clear ; ls ; cd . ; } ||
        export PS1="$(get_PS1)"

case "${TERM}" in
    linux|dumb|vt220)
        echo -en "\e]P0232323" #black
        echo -en "\e]P82B2B2B" #darkgrey
        echo -en "\e]P1D75F5F" #darkred
        echo -en "\e]P9E33636" #red
        echo -en "\e]P287AF5F" #darkgreen
        echo -en "\e]PA98E34D" #green
        echo -en "\e]P3D7AF87" #brown
        echo -en "\e]PBFFD75F" #yellow
        echo -en "\e]P48787AF" #darkblue
        echo -en "\e]PC7373C9" #blue
        echo -en "\e]P5BD53A5" #darkmagenta
        echo -en "\e]PDD633B2" #magenta
        echo -en "\e]P65FAFAF" #darkcyan
        echo -en "\e]PE44C9C9" #cyan
        echo -en "\e]P7E5E5E5" #lightgrey
        echo -en "\e]PFFFFFFF" #white
        clear #for background artifacting
esac

(rm -rf \
    ${HOME}/*.core \
    ${HOME}/*.dump \
    ${HOME}/Desktop \
    ${HOME}/Downloads \
    ${HOME}/nohup.out \
    ${HOME}/*.hup \
    ${HOME}/.xsel.log \
> /dev/null 2>&1 &)
