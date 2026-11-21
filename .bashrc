#!/usr/bin/env bash

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# ========================================================================
# for oksh
export ENV=~/src/dots/shell/main.shellrc
source "$ENV"
# ========================================================================

