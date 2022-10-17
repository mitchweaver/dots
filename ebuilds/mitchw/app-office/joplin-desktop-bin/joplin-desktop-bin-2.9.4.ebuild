# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font gnome2-utils eutils unpacker

DESCRIPTION="Joplin is an open source note-taking app"
HOMEPAGE="https://joplinapp.org"
SRC_URI="amd64? ( https://github.com/laurent22/joplin/releases/download/v${PV}/Joplin-${PV}.AppImage )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# need sys-fs/fuse:0 for libfuse.so.2
# in main tree sys-fs/fuse is version 3.0
DEPEND="sys-fs/fuse sys-fs/fuse:0"
RDEPEND="${DEPEND}"
BDEPEND=""

RESTRICT="strip mirror"
IUSE=""

S="${WORKDIR}"

src_install() {
	cd "${WORKDIR}"
	mkdir -p "${D}/opt/joplin"
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/share/applications"
	mkdir -p "${D}/usr/share/pixmaps"

	cp "${DISTDIR}/Joplin-${PV}.AppImage" "${D}/opt/joplin/Joplin.AppImage"
	fperms 0755 /opt/joplin/Joplin.AppImage

	cp "${FILESDIR}/joplin-desktop-bin.sh" "${D}/usr/bin/joplin-desktop-bin"
	fperms 0755 /usr/bin/joplin-desktop-bin

	cp "${FILESDIR}/joplin-desktop-bin.desktop" "${D}/usr/share/applications/"
	cp "${FILESDIR}/joplin-desktop-bin.svg" "${D}/usr/share/pixmaps/"
}
