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

