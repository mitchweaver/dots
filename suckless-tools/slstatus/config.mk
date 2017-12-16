VERSION = 0

#paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

# LINUX
# X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# flags
CPPFLAGS = -I/usr/X11R6/include -D_DEFAULT_SOURCE
CFLAGS   = -std=c99 -pedantic -Wall -Wextra -Os
LDFLAGS  = -L$(X11LIB) -s
LDLIBS   = -lX11

# compiler and linker
# CC = cc
