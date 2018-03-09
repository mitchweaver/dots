#!/bin/ksh
#
# http://github.com/mitchweaver/dotfiles
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# run background processes with lower priority
set bgnice 
set nohup

# print is a better 'echo' for ksh
alias echo="builtin print" 

# source my global aliases
. ${HOME}/etc/aliases

#case ${SHELL} in
#    /bin/mksh)
#        set -o vi
#        alias ksh='mksh'
#        ;;
#    /bin/ksh)

set -o vi-tabcomplete
bind Space:magic-space > /dev/null

#esac > /dev/null 2>&1

export HISTFILE=${HOME}/tmp/.ksh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoreboth

(rm -rf \
    ${HOME}/*.core \
    ${HOME}/*.dump \
    ${HOME}/Desktop \
    ${HOME}/Downloads \
    ${HOME}/nohup.out \
    ${HOME}/*.hup \
    ${HOME}/.xsel.log \
> /dev/null 2>&1 &)
