all: 
	ln -sf ~/src/dots/.detoxrc ~/.detoxrc
	ln -sf ~/src/dots/.gitconfig ~/.gitconfig
	ln -sf ~/src/dots/.msmtprc ~/.msmtprc
	ln -sf ~/src/dots/.mbsyncrc ~/.mbsyncrc
	ln -sf ~/src/dots/.profile ~/.profile
	ln -sf ~/src/dots/.vimrc ~/.vimrc
	ln -sf ~/src/dots/.xmodmaprc ~/.xmodmaprc
	ln -sf ~/src/dots/.Xresources ~/.Xresources
	ln -sf ~/src/dots/.xsession ~/.xsession
	ln -sf ~/src/dots/.xsession ~/.xinitrc
	# --------------------------------------
	ln -sf ~/src/dots/shell/main.shellrc ~/.bashrc
	ln -sf ~/src/dots/shell/main.shellrc ~/.kshrc 
	ln -sf ~/src/dots/.bash_profile ~/.bash_profile
	# --------------------------------------
	mkdir -p ~/.config
	ln -sf ~/src/dots/.config/mpv ~/.config/mpv
	ln -sf ~/src/dots/.config/cataclysm-dda ~/.config/cataclysm-dda
	ln -sf ~/src/dots/.config/neomutt ~/.config/neomutt
	ln -sf ~/src/dots/.config/nvim ~/.config/nvim
	ln -sf ~/src/dots/.config/ranger ~/.config/ranger
	ln -sf ~/src/dots/.config/sxhkd ~/.config/sxhkd
	ln -sf ~/src/dots/.config/zathura ~/.config/zathura
	ln -sf ~/src/dots/.config/picom.conf ~/.config/picom.conf
