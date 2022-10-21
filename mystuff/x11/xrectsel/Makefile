COMMENT=	simple rectangular selection tool for x11
CATEGORIES=	x11

NAME=	xrectsel
V= 1.2
DISTNAME=	v${V}
PKGNAME=	${NAME}-${V}
GH_TAGNAME=     ${V}
GH_ACCOUNT=     mitchweaver
GH_PROJECT=     ${NAME}

MAKE_FILE=	makefile
ALL_TARGET=	${NAME}

WANTLIB=	c X11
PERMIT_PACKAGE=	Yes

do-install:
	${INSTALL_PROGRAM} ${WRKBUILD}/${NAME}   ${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKBUILD}/${NAME}.1 ${PREFIX}/man/man1/${NAME}.1

.include <bsd.port.mk>
