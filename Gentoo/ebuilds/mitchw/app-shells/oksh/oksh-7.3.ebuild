# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Portable OpenBSD ksh, based on the Public Domain Korn Shell (pdksh)"
HOMEPAGE="https://github.com/ibara/oksh"
SRC_URI="https://github.com/ibara/oksh/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/oksh-${P}"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

LICENSE="public-domain"
SLOT="0"

DEPEND="sys-libs/ncurses"
RDEPEND="
	${DEPEND}
	!app-shells/ksh
"

IUSE="lto minimal static"

src_configure() {
	if use lto ; then
		CONFIGURE_PARAMS="$CONFIGURE_PARAMS --enable-lto"
	fi

	if use minimal ; then
		CONFIGURE_PARAMS="$CONFIGURE_PARAMS --enable-small"
	fi

	if use static ; then
		CONFIGURE_PARAMS="$CONFIGURE_PARAMS --enable-static"
	fi

	./configure \
		--host=${CHOST} \
		$CONFIGURE_PARAMS \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die
}

post_inst() {
	# add /bin/ksh and /usr/bin/ksh symlinks
	ln -sf "${EROOT}"/bin/oksh "${EROOT}"/bin/ksh
	ln -sf "${EROOT}"/bin/oksh /bin/ksh
	# add /bin/oksh
	ln -sf "${EROOT}"/bin/oksh /bin/oksh
}
