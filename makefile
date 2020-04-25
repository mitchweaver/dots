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

install: mkdirs mklinks
