#!/bin/sh

CLOUD="$HOME/cloud"
DOTS="$HOME/src/dots"

# ========================================================================
# cloud links
# ========================================================================
if [ -d ~/cloud ] ; then
    ln -svfn "$CLOUD"/files        ~/files
    ln -svfn "$CLOUD"/images       ~/images
    ln -svfn "$CLOUD"/src          ~/src
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
for prog in mpv nvim kitty ranger swayimg kxkbrc ; do
    if [ ! -L "$HOME/.config/$prog" ] ; then
        if [ -f "$HOME/.config/$prog" ] ; then
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
    powermanagementprofilesrc
do
    if [ ! -L "$HOME/.config/$file" ] ; then
        if [ -f "$HOME/.config/$file" ] ; then
            rm -iv "$HOME/.config/$file"
        fi
	ln -svn "$DOTS/.config/$file" "$HOME/.config/$file"
    fi
done


# easy way to tell if whatever script is on my laptop/desktop
# or if I'm ssh somewhere and something that shouldn't run won't be run
if [ ! -f /etc/THIS_IS_MY_MACHINE ] ; then
    echo 'Installing /etc/THIS_IS_MY_MACHINE ...'
    sudo touch /etc/THIS_IS_MY_MACHINE
    sudo chmod 0644 /etc/THIS_IS_MY_MACHINE
fi

