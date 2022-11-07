#!/bin/bash
# (C) Martin V\"ath <martin at mvath.de>
# SPDX-License-Identifier: GPL-2.0-only

BashrcdTrue() {
	case ${1:-n} in
	[nNfF]*|[oO][fF]*|0|-)
		return 1;;
	esac
	:
}

BashrcdLog() {
	local i m=elog
	BashrcdTrue $BASHRCDNOLOG && m=einfo
	for i
	do	$m "$i"
	done
}

BashrcdEcho() {
	local i m=einfo
	BashrcdTrue $BASHRCDLOG && m=elog
	for i
	do	$m "$i"
	done
}

BashrcdPhase() {
	local c
	eval c=\${bashrcd_phases_c_$1}
	if [ -n "${c:++}" ]
	then	c=$(( $c + 1 ))
	else	c=0
	fi
	eval "bashrcd_phases_c_$1=\$c
	bashrcd_phases_${c}_$1=\$2"
}

BashrcdMain() {
	local bashrcd
	for bashrcd in "${PORTAGE_CONFIGROOT%/}/etc/portage/bashrc.d/"*.sh
	do	case $bashrcd in
		*'/bashrcd.sh')
			continue;;
		esac
		test -r "$bashrcd" || continue
		. "$bashrcd"
		BashrcdTrue $BASHRCD_DEBUG && BashrcdEcho "$bashrcd sourced"
	done
	unset -f BashrcdPhase
BashrcdMain() {
	local bashrcd_ebuild_phase bashrcd_phase bashrcd_num bashrcd_max
	bashrcd_ebuild_phase=$EBUILD_PHASE
	[ -n "${bashrcd_ebuild_phase:++}" ] || [ $# -eq 0 ] || bashrcd_ebuild_phase=$1
	: ${ED:=${D%/}${EPREFIX%/}/}
	BashrcdTrue $BASHRCD_DEBUG && BashrcdEcho \
		"$0: $* ($# args)" \
		"EBUILD_PHASE=$EBUILD_PHASE" \
		"PORTDIR=$PORTDIR" \
		"CATEGORY=$CATEGORY" \
		"P=$P" \
		"USER=$USER" \
		"UID=$UID" \
		"HOME=$HOME" \
		"PATH=$PATH" \
		"ROOT=$ROOT" \
		"PORTAGE_CONFIGROOT=$PORTAGE_CONFIGROOT" \
		"LD_PRELOAD=$LD_PRELOAD" \
		"EPREFIX=$EPREFIX" \
		"D=$D" \
		"ED=$ED"
	for bashrcd_phase in all "$bashrcd_ebuild_phase"
	do	eval bashrcd_max=\${bashrcd_phases_c_$bashrcd_phase}
		[ -z "${bashrcd_max:++}" ] && continue
		bashrcd_num=0
		while {
			eval eval \"\\\${bashrcd_phases_${bashrcd_num}_$bashrcd_phase}\"
			[ $bashrcd_num -ne $bashrcd_max ]
		}
		do	bashrcd_num=$(( $bashrcd_num + 1 ))
		done
	done
}
	BashrcdMain "$@"
}
