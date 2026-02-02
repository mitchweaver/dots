#!/bin/sh -x

if [ ! -e ~/.vim/autoload/plug.vim ] ; then
    printf '\n%s\n\n' "Installing vim plug"

    curl -#fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -e ~/.config/nvim ] ; then
    mkdir -p ~/.config
    cp -r ../.config/nvim ~/.config/
fi

if [ ! -f ~/.vimrc ] ; then
    cp -v ../.vimrc ~/.vimrc
    if [ -f ~/.bashrc ] ; then
        echo 'alias v=vim' >> ~/.bashrc
    fi
fi
