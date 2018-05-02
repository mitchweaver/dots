#!/bin/sh

cd ~
ln -sf ~/etc/aliases ~/.aliases
ln -sf ~/etc/vim ~/.vim
ln -sf ~/etc/vimrc ~/.vimrc
ln -sf ~/etc/w3m ~/.w3m
ln -sf ~/etc/Xmodmap ~/.Xmodmap
#ln -sf ~/etc/xinitrc ~/.xinitrc
ln -sf ~/etc/Xresources ~/.Xresources
xrdb load ~/.Xresources
#ln -sf ~/etc/profile ~/.profile
ln -sf ~/etc/config ~/.config

cd ~/etc

[ ! -d ./suckless ] && 
    git clone http://github.com/mitchweaver/suckless

cd ~
[ ! -d ./bin ] &
    git clone http://github.com/mitchweaver/bin
