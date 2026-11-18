#!/bin/sh

CLOUD="$HOME/cloud"
DOTS="$HOME/src/dots"

# cloud links
ln -svfn "$CLOUD"/files        ~/files
ln -svfn "$CLOUD"/images       ~/images
ln -svfn "$CLOUD"/src          ~/src

# homedir
ln -svfn "$DOTS/.cvsrc"                  ~/.cvsrc
ln -svfn "$DOTS/.detoxrc"                ~/.detoxrc
ln -svfn "$DOTS/.gitconfig"              ~/.gitconfig
ln -svfn "$DOTS/.gitignore_global"       ~/.gitignore_global
ln -svfn "$DOTS/.profile"                ~/.profile
ln -svfn "$DOTS/.pylintrc"               ~/.pylintrc
ln -svfn "$DOTS/.shellcheckrc"           ~/.shellcheckrc
ln -svfn "$DOTS/.vimrc"                  ~/.vimrc
ln -svfn "$DOTS/.wgetrc"                 ~/.wgetrc

# ~/.config
for prog in mpv nvim kitty ranger swayimg ; do
    if [ ! -L "$HOME/.config/$prog" ] ; then
        rm -rv "$HOME/.config/$prog"
	ln -svn "$DOTS/.config/$prog" "$HOME/.config/$prog"
    fi
done

# easy way to tell if whatever script is on my laptop/desktop
# or if I'm ssh somewhere and something that shouldn't run won't be run
if [ ! -f /etc/THIS_IS_MY_MACHINE ] ; then
    echo 'Installing /etc/THIS_IS_MY_MACHINE ...'
    sudo touch /etc/THIS_IS_MY_MACHINE
    sudo chmod 0644 /etc/THIS_IS_MY_MACHINE
fi

