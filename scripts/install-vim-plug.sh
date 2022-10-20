#!/bin/sh

if [ ! -e ~/.vim/autoload/plug.vim ] ; then
    printf '\n%s\n\n' "Installing vim plug"

    curl -#fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
