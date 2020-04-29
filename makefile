conf_dirs = ranger mpv nvim dunst

all:
	@>&2 echo "Use 'make install'."

mkdirs:
	for dir in ${conf_dirs} ; do mkdir -p ~/.config/$$dir ; done

mklinks:
	ln -sf ~/src/dots/dunstrc ~/.config/dunst/dunstrc
	ln -sf ~/src/dots/gitconfig ~/.gitconfig
	ln -sf ~/src/dots/kshrc ~/.kshrc
	ln -sf ~/src/dots/mpv.conf ~/.config/mpv/mpv.conf
	ln -sf ~/src/dots/picom.conf ~/.config/picom.conf
	ln -sf ~/src/dots/profile ~/.profile
	ln -sf ~/src/dots/vimrc ~/.vimrc
	ln -sf ~/src/dots/cava.conf ~/.config/cava/config
	ln -sf ~/src/dots/ranger/rc.conf ~/.config/ranger/rc.conf
	ln -sf ~/src/dots/ranger/rifle.conf ~/.config/ranger/rifle.conf
	ln -sf ~/src/dots/ranger/scope.sh ~/.config/ranger/scope.sh
	ln -sf ~/src/dots/idesk ~/.idesktop
	ln -sf ~/src/dots/idesk/ideskrc ~/.ideskrc

install: mkdirs mklinks
