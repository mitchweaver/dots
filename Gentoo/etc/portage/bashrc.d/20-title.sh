#!/bin/bash
# (C) Martin V\"ath <martin at mvath.de>
# SPDX-License-Identifier: GPL-2.0-only

QlopSetup() {
	local num sec hour min date
	! BashrcdTrue "${NOQLOP-}" && command -v qlop >/dev/null 2>&1 || return 0
	qlop -amH -- "$CATEGORY/$PN"
	qlop -tmH -- "$CATEGORY/$PN"
	command -v title >/dev/null 2>&1 || return 0
	num=$(tail -n1 /var/log/emerge.log | \
		sed -e 's/^.*(\([0-9]*\) of \([0-9]*\)).*$/\1|\2/') \
	&& [ -n "$num" ] || {
		date=$(date +%T)
		title "emerge $date $PN"
		return
	}
	case ${QLOPCOUNT:-1}  in
	*[!0123456789]*)
		sec=$(qlop -ACMm -- "$CATEGORY/$PN" | awk \
'/[[:space:]][0123456789]+$/{a=$NF}
END{if(a!=""){print a}}');;
	[123456789]*)
		sec=$(qlop -tCMm -- "$CATEGORY/$PN" | \
		awk -v 'i=0' -v 'm=0' -v "n=${QLOPCOUNT:-3}" \
'/[[:space:]][0123456789]+$/{a[i++]=$NF;if(i>m){m=i};if(i>=n){i=0}}
END{s=0;for(i=m;i>0;){s+=a[--i]};if(m>0){print int(s/m+1/2)}}');;
	*)
		false;;
	esac && [ -n "$sec" ] || {
		date=$(date +%T)
		title "emerge $date $num $PN"
		return
	}
	hour=$(( $sec / 3600 ))
	[ "$hour" -gt 0 ] || hour=
	hour=$hour${hour:+:}
	sec=$(( $sec % 3600 ))
	min=$(( $sec / 60 ))
	sec=$(( $sec % 60 ))
	[ "$min" -gt 9 ] || min=0$min
	[ "$sec" -gt 9 ] || sec=0$sec
	date=$(date +%T)
	title "emerge $date $num $PN $hour$min:$sec"
}

BashrcdPhase setup QlopSetup
