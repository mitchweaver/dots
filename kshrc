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

export HISTFILE=${HOME}/tmp/.ksh_history
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoreboth
ulimit -c 0

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
