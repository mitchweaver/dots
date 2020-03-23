all:
	@>&2 echo "Use 'make install' to install."

install:
	@install    -m 0400 gitconfig ~/.gitconfig
	@install    -m 0400 profile   ~/.profile
	@install    -m 0400 Xdefaults ~/.Xdefaults
	@install    -m 0400 xmodmaprc ~/.xmodmaprc
	@install    -m 0400 xsession  ~/.xsession
	@install    -m 0400 vimrc     ~/.vimrc
	@install -D -m 0400 picom.conf        ~/.config/picom.conf
	@install -D -m 0400 mpv.conf          ~/.config/mpv/mpv.conf
	@install -D -m 0400 dunstrc           ~/.config/dunst/dunstrc
	@install -D -m 0700 ranger/scope.sh   ~/.config/ranger/scope.sh
	@install -D -m 0400 ranger/rifle.conf ~/.config/ranger/rifle.conf
	@install -D -m 0400 ranger/rc.conf    ~/.config/ranger/rc.conf
	@install    -m 0400 kshrc ~/.kshrc
	@install    -m 0400 rtorrent.rc ~/.rtorrent.rc
	@mkdir -p ~/.config/nvim ~/.vim/autoload
	@printf '%s\n%s\n%s\n' \
		'set runtimepath^=~/.vim runtimepath+=~/.vim/after' \
		'let &packpath=&runtimepath' \
		'source ~/.vimrc' \
		>~/.config/nvim/init.vim
	[ -f ~/.vim/autoload/plug.vim ] || \
		curl -sfL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
		>~/.vim/autoload/plug.vim
	@mkdir -p ~/.config/ranger/plugins
	[ -f ~/.config/ranger/plugins/devicons_linemode.py ] || \
		curl -sfL https://github.com/alexanderjeurissen/ranger_devicons/raw/master/__init__.py \
		>~/.config/ranger/plugins/devicons_linemode.py
	[ -f ~/.config/ranger/plugins/devicons.py ] || \
		curl -sfL https://github.com/alexanderjeurissen/ranger_devicons/raw/master/devicons.py \
		>~/.config/ranger/plugins/devicons.py
	ln -sf ~/.Xdefaults ~/.Xresources
	ln -sf ~/.kshrc     ~/.bashrc
	[ -f ~/.cache/wall ] || cp -f etc/openbsd_wall.jpg ~/.cache/wall

uninstall:
	rm -f ~/.gitconfig
	rm -f ~/.profile
	rm -f ~/.Xdefaults
	rm -f ~/.Xresources
	rm -f ~/.xmodmaprc
	rm -f ~/.xsession
	rm -f ~/.kshrc
	rm -f ~/.bashrc
	rm -f ~/.rtorrent.rc
	rm -f ~/.vimrc
	rm -f ~/.vim/autoload/plug.vim
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.config/picom.conf
	rm -f ~/.config/mpv/mpv.conf
	rm -f ~/.config/dunst/dunstrc
	rm -f ~/.config/ranger/scope.sh
	rm -f ~/.config/ranger/rifle.conf
	rm -f ~/.config/ranger/rc.conf
	rm -f ~/.config/ranger/plugins/__init__.py
	rm -f ~/.config/ranger/plugins/devicons.py
	rm -f ~/.config/ranger/plugins/devicons_linemode.py
	rm -r ~/.config/ranger/plugins/__pycache__ 2>/dev/null ||:
	rmdir ~/.config/ranger/plugins 2>/dev/null ||:
	rmdir ~/.config/ranger 2>/dev/null ||:
	rmdir ~/.config/mpv    2>/dev/null ||:
	rmdir ~/.config/dunst  2>/dev/null ||:
	rmdir ~/.config/nvim   2>/dev/null ||:
	rmdir ~/.vim/autoload  2>/dev/null ||:
	rmdir ~/.vim           2>/dev/null ||:
