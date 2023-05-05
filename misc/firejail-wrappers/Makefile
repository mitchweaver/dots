all: install

install:
	mkdir -p ${HOME}/.local/bin
	install -m 0755 firejail-* ${HOME}/.local/bin/
	ln -sf ${HOME}/src/dots/misc/firejail-wrappers/.firejail ${HOME}/.firejail
