all:
	@>&2 echo "Use 'make install' to copy the files."

install:
	doas mkdir -pv /usr/ports/mystuff
	doas cp -rfv * /usr/ports/mystuff/

uninstall:
	rm -rfiv /usr/ports/mystuff
