#!/bin/sh

if [ "${PWD##*/}" != scripts ] ; then
    >&2 "please run me from inside the scripts dir"
    exit 1
fi

# copy nvim config
if [ ! -e ~/.config/nvim ] ; then
    mkdir -p ~/.config
    cp -r ../.config/nvim ~/.config/
fi

# install plug
if [ ! -e ~/.vim/autoload/plug.vim ] ; then
    printf '\n%s\n\n' "Installing vim plug"

    mkdir -p ~/.vim/autoload
    curl -#fLo ~/.vim/autoload/plug.vim \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# copy vimrc
if [ ! -e ~/.vimrc ] ; then
    cp -v ../.vimrc ~/.vimrc
    echo 'alias v=vim' >> ~/.bashrc
    echo 'alias v=vim' >> ~/.shrc
fi

