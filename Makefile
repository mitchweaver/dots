DOTS_DIR = ${HOME}/src/dots

all:
	@>&2 echo "Use 'make install'."

install:
	ln -sf ${DOTS_DIR}/.Xresources ${HOME}/.Xresources
	ln -sf ${DOTS_DIR}/.xinitrc ${HOME}/.xinitrc
	ln -sf ${DOTS_DIR}/.xinitrc ${HOME}/.xsessionrc
	ln -sf ${DOTS_DIR}/.profile    ${HOME}/.profile
	mkdir -p ${HOME}/.config/nvim
	ln -sf ${DOTS_DIR}/.config/nvim/init.vim ${HOME}/.config/nvim/init.vim
	ln -sf ${DOTS_DIR}/.vimrc ${HOME}/.vimrc
	curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim \
		--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	ln -sf ${DOTS_DIR}/.xmodmaprc ${HOME}/.xmodmaprc
	mkdir -p ${HOME}/.config/mpv
	ln -sf ${DOTS_DIR}/.config/mpv/mpv.conf ${HOME}/.config/mpv/mpv.conf
	mkdir -p ${HOME}/.config/cava
	ln -sf ${DOTS_DIR}/.config/cava/cava.conf ${HOME}/.config/cava/cava.conf
	mkdir -p ${HOME}/.config/ranger
	ln -sf ${DOTS_DIR}/.config/ranger/scope.sh ${HOME}/.config/ranger/scope.sh
	ln -sf ${DOTS_DIR}/.config/ranger/rifle.conf ${HOME}/.config/ranger/rifle.conf
	ln -sf ${DOTS_DIR}/.config/ranger/rc.conf ${HOME}/.config/ranger/rc.conf
	ln -sf ${DOTS_DIR}/.gitconfig ${HOME}/.gitconfig
	ln -sf ${DOTS_DIR}/.config/autostart ${HOME}/.config/autostart
	ln -sf ${DOTS_DIR}/.pylintrc ${HOME}/.pylintrc
	mkdir -p ${HOME}/.config/sxhkd
	ln -sf ${DOTS_DIR}/.config/sxhkd/sxhkdrc ${HOME}/.config/sxhkd/sxhkdrc
	ln -sf ${DOTS_DIR}/.config/picom.conf ${HOME}/.config/picom.conf
	mkdir -p ${HOME}/.config/dunst
	ln -sf ${DOTS_DIR}/.config/dunst/dunstrc ${HOME}/.config/dunst/dunstrc
	xrdb load ${HOME}/.Xresources
