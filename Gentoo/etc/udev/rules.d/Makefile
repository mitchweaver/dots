PREFIX = /etc/udev/rules.d

all:
	:

install:
	install -Dm0644 90-backlight.rules ${DESTDIR}${PREFIX}/
	install -Dm0644 99-keyboard-backlight.rules ${DESTDIR}${PREFIX}/

uninstall:
	rm ${DESTDIR}${PREFIX}/90-backlight.rules
	rm ${DESTDIR}${PREFIX}/99-backlight.rules

test:
	:

