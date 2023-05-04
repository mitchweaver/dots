all: install

install:
	mkdir -p ${HOME}/.local/bin
	install -m 0755 firejail-* ${HOME}/.local/bin/
	mkdir -p ${HOME}/.firejail
	cp -f .firejail/*.profile ${HOME}/.firejail/
