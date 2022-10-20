#!/bin/sh
#
# quickly grab and set up my ~/bin on remote machine
#
# shellcheck disable=2016,2164
#

mkdir -p ~/.cache
cd ~/.cache
git clone https://github.com/mitchweaver/bin
cd bin

mkdir -p ~/.local/bin
make
make install

if ! grep 'PATH:${HOME}/local/bin' ~/.profile ; then
    echo 'export PATH=$PATH:${HOME}/local/bin' >> ~/.profile
fi
if ! grep 'PATH:${HOME}/local/bin' ~/.bash_profile ; then
    echo 'export PATH=$PATH:${HOME}/local/bin' >> ~/.bash_profile
fi

rm -rf -- ~/.cache/bin
