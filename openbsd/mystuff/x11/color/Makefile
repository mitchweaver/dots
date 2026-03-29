COMMENT=	dead simple x11 color picker
CATEGORIES=	x11

NAME=	color
V= 1.0
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
	${INSTALL_PROGRAM} ${WRKBUILD}/${NAME} ${PREFIX}/bin

.include <bsd.port.mk>
