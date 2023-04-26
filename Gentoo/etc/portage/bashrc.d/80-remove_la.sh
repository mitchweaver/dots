#!/bin/bash
# (C) Martin V\"ath <martin at mvath.de>
# SPDX-License-Identifier: GPL-2.0-only

Remove_la() {
	BashrcdTrue $NOLAFILEREMOVE && return
# Some packages are known to rely on .la files (e.g. for building of plugins):
	case "$CATEGORY/$PN" in
	'media-libs/gst-plugins-base'|'media-libs/libsidplay')
		return 0;;
	esac
	einfo 'removing unneeded *.la files'
	local shell
	shell=`command -v sh` || shell=
	: ${shell:=/bin/sh}
	Dexport=$ED find "$ED" -name '*.la' '!' -name 'libltdl.la' \
		-exec "$shell" -c "for i
	do	if grep -q -- '^shouldnotlink=no\$' \"\$i\"
		then	printf '\\t%s\\n' \"\${i#\$Dexport}\"
			rm -- \"\$i\" || echo 'removing failed!'
		fi
	done" sh '{}' '+'
}

BashrcdPhase preinst Remove_la
