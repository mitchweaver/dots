#!/bin/sh

CLOUD="$HOME/cloud"
DOTS="$HOME/src/dots"

# ========================================================================
# cloud links
# ========================================================================
if [ -d ~/cloud ] ; then
    ln -svfn "$CLOUD"/files                  ~/files
    ln -svfn "$CLOUD"/images                 ~/images
    ln -svfn "$CLOUD"/src                    ~/src

    if [ -d ~/Downloads ] ; then
        rm -r ~/Downloads
    fi
    ln -svfn "$CLOUD"/Downloads              ~/Downloads

    if [ -d ~/Desktop ] ; then
        rm -r ~/Desktop
    fi
    ln -svfn "$CLOUD"/Desktop                ~/Desktop
fi

# ========================================================================
# homedir
# ========================================================================
ln -svfn "$DOTS/.bashrc"                 ~/.bashrc
ln -svfn "$DOTS/.bash_profile"           ~/.bash_profile
ln -svfn "$DOTS/.cvsrc"                  ~/.cvsrc
ln -svfn "$DOTS/.detoxrc"                ~/.detoxrc
ln -svfn "$DOTS/.gitconfig"              ~/.gitconfig
ln -svfn "$DOTS/.gitignore_global"       ~/.gitignore_global
ln -svfn "$DOTS/.gtkrc-2.0"              ~/.gtkrc-2.0
ln -svfn "$DOTS/.profile"                ~/.profile
ln -svfn "$DOTS/.pylintrc"               ~/.pylintrc
ln -svfn "$DOTS/.shellcheckrc"           ~/.shellcheckrc
ln -svfn "$DOTS/.vimrc"                  ~/.vimrc
ln -svfn "$DOTS/.wgetrc"                 ~/.wgetrc

# ========================================================================
# ~/.config
# ========================================================================
for prog in mpv nvim kitty ranger swayimg kxkbrc autostart ; do
    if [ ! -L "$HOME/.config/$prog" ] ; then
        if [ -e "$HOME/.config/$prog" ] ; then
            rm -riv "$HOME/.config/$prog"
        fi
	ln -svn "$DOTS/.config/$prog" "$HOME/.config/$prog"
    fi
done

# ========================================================================
# ~/.config KDE STUFF
# ========================================================================
for file in \
    kded5rc dolphinrc discoverrc plasma-workspace xsettingsd filetypesrc \
    kded_device_automounterrc kdeglobals kglobalshortcutsrc kiorc \
    klipperrc kmenueditrc ksplashrc kservicemenurc ktimezonedrc \
    ktrashrc kuserfeedbackrc plasma-localerc powerdevilrc \
    powermanagementprofilesrc baloofilerc user-dirs.dirs user-dirs.locale
do
    if [ ! -L "$HOME/.config/$file" ] ; then
        if [ -e "$HOME/.config/$file" ] ; then
            rm -riv "$HOME/.config/$file"
        fi
	ln -svn "$DOTS/.config/$file" "$HOME/.config/$file"
    fi
done

# ========================================================================
# ~/.local/share kde stuff
# ========================================================================
if [ -d ~/.local/share/kio ] ; then
    rm -r ~/.local/share/kio
fi
ln -svn "$DOTS/.local/share/kio" ~/.local/share/kio
# re-add execute bit if somehow got missing
chmod +x ~/.local/share/kio/servicemenus/symlink-to-desktop.desktop

# ========================================================================
# junk
# ========================================================================
mkdir -p ~/.cache
for crap in htop neofetch ; do
    if [ ! -L "$HOME/.config/$crap" ] ; then
        if [ -e "$HOME/.config/$crap" ] ; then
            rm -riv "$HOME/.config/$crap"
        fi
        mkdir -p "$HOME/.cache/$crap"
	ln -svn "$HOME/.cache/$crap" "$HOME/.config/$crap"
    fi
done

# ========================================================================
# /etc stuff
# ========================================================================
# easy way to tell if whatever script is on my laptop/desktop
# or if I'm ssh somewhere and something that shouldn't run won't be run
if [ ! -f /etc/THIS_IS_MY_MACHINE ] ; then
    echo 'Installing /etc/THIS_IS_MY_MACHINE ...'
    sudo touch /etc/THIS_IS_MY_MACHINE
    sudo chmod 0644 /etc/THIS_IS_MY_MACHINE
fi

# ========================================================================
# grab vim-plug plugin manager
# ========================================================================
if [ ! -e ~/.vim/autoload/plug.vim ] ; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

