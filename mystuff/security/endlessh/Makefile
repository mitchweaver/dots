COMMENT=	SSH tarpit that slowly sends an endless banner
CATEGORIES=	security

HOMEPAGE= https://github.com/skeeto/endlessh

NAME= endlessh
V= 1.0
DISTNAME= ${NAME}-${V}
PKGNAME= ${NAME}-${V}
EXTRACT_SUFX= .tar.xz

MASTER_SITES= https://github.com/skeeto/endlessh/releases/download/${V}/

MAKE_FILE=	makefile
ALL_TARGET=	${NAME}

WANTLIB=	c
PERMIT_PACKAGE=	Yes

do-install:
	${INSTALL_PROGRAM} ${WRKBUILD}/${NAME} ${PREFIX}/bin

.include <bsd.port.mk>
