#!/bin/sh

# homebrewed GNU stow
#
# ----------------------------------------------

dots=~/workspace/dotfiles

link() { ln -s $dots/"$1" ; }


link(bin)

link(.kshrc)
link(.aliases)
link(.Xmodmap)
link(.config)
link(.fonts)
link(.git)
link(.gitconfig)
link(.gitignore)
link(.irssi)
link(.mpd)
link(.profile)
link(.pylintrc)
link(.vim)
link(.vimrc)
link(.w3m)


mkdir ~/.surf
ln -s $dots/suckless-tools/surf/scripts-surf/script.js ~/.surf
ln -s $dots/suckless-tools/surf/bookmarks ~/.bookmarks
ln -s $dots/suckless-tools/surf/bookmarks ~/.surf/bookmarks


echo "Now starting /etc symlinks..."

cd /etc
ln -s /home/mitch/workspace/dotfiles/etc/asound.conf
ln -s /home/mitch/workspace/dotfiles/etc/hosts


# --- this can be distro depedent, do this manually.
# ln -s /home/mitch/workspace/dotfiles/etc/rc.local
