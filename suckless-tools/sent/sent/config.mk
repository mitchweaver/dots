# sent version
VERSION = 0.2

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# includes and libs
INCS = -I. -I/usr/include -I/usr/include/freetype2 -I${X11INC}
LIBS = -L/usr/lib -lc -lm -L${X11LIB} -lXft -lfontconfig -lX11 -lpng

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\" -D_XOPEN_SOURCE=600
CFLAGS += -g -std=c99 -pedantic -Wall ${INCS} ${CPPFLAGS}
LDFLAGS += -g ${LIBS}
#CFLAGS += -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
#LDFLAGS += ${LIBS}

# compiler and linker
CC ?= cc
