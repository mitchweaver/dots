#!/bin/bash
# (C) Martin V\"ath <martin at mvath.de>
# SPDX-License-Identifier: GPL-2.0-only

ALL_LOCALES="
aa
af
af_ZA
am
am_ET
ang
ar
ar_AE
ar_BH
ar_DZ
ar_EG
ar_IN
ar_IQ
ar_JO
ar_KW
ar_LB
ar_LY
ar_MA
ar_OM
ar_QA
ar_SA
ar_SD
ar_SY
ar_TN
ar_YE
as
ast
az
az_AZ
az_IR
be
be@latin
be_BY
bg
bg_BG
bn
bn_IN
br
br_FR
bs
bs_BA
byn
ca
ca@valencia
ca_ES
ca_ES@euro
ca_ES@valencia
chs
cht
crh
cs
cs_CZ
cy
cy_GB
cz
da
da_DK
de
de_AT
de_AT@euro
de_BE
de_BE@euro
de_CH
de_DE
de_DE.UTF-8
de_DE@euro
de_LU
de_LU@euro
dk
dv
dz
el
el_GR
el_GR.UTF-8
el_GR@euro
en
en@IPA
en@boldquot
en@quot
en@shaw
en_AU
en_BW
en_CA
en_DK
en_GB
en_GB.UTF-8
en_HK
en_IE
en_IE@euro
en_IN
en_NZ
en_PH
en_RN
en_SG
en_UK
en_US
en_US.UTF-8
en_ZA
en_ZW
eo
eo_EO
es
es_AR
es_BO
es_CL
es_CO
es_CR
es_DO
es_EC
es_ES
es_ES.UTF-8
es_ES@euro
es_GT
es_HN
es_MX
es_NI
es_PA
es_PE
es_PR
es_PY
es_SV
es_US
es_UY
es_VE
et
et_EE
eu
eu_ES
eu_ES@euro
fa
fa_IR
fa_IR.UTF-8
fi
fi_FI
fi_FI@euro
fo
fo_FO
fr
fr_BE
fr_BE@euro
fr_CA
fr_CH
fr_FR
fr_FR.UTF-8
fr_FR@euro
fr_LU
fr_LU@euro
fur
fy
ga
ga_IE
ga_IE@euro
gd
gd_GB
gez
gl
gl_ES
gl_ES@euro
gr
gu
gv
gv_GB
haw
he
he_IL
hi
hi_IN
hi_IN.UTF-8
hr
hr_HR
hu
hu_HU
hy
hy_AM
ia
id
id_ID
is
is_IS
it
it_CH
it_IT
it_IT@euro
iu
iw
iw_IL
ja
ja_JP
ja_JP.EUC
ja_JP.EUC-JP
ja_JP.UTF-8
ja_JP.eucJP
ka
ka_GE
kk
kl
kl_GL
km
km_KH
kn
ko
ko_KR
ko_KR.EUC-KR
ko_KR.UTF-8
kok
ku
kw
kw_GB
ky
la
lg
li
lo
lt
lt_LT
lv
lv_LV
mai
mg
mhr
mi
mi_NZ
mk
mk_MK
ml
mn
mr
mr_IN
mr_IN.UTF-8
ms
ms_MY
mt
mt_MT
my
my_MM
nb
nb_NO
nds
ne
nl
nl_BE
nl_BE@euro
nl_NL
nl_NL@euro
nn
nn_NO
no
no_NO
nso
nyc
oc
oc_FR
om
or
pa
pl
pl_PL
ps
pt
pt_BR
pt_PT
pt_PT@euro
rm
ro
ro_RO
ru
ru_RU
ru_RU.KOI8-R
ru_RU.UTF-8
ru_UA
rw
sa
si
sid
sk
sk_SK
sl
sl_SI
so
sp
sq
sq_AL
sr
sr@Latn
sr@ije
sr@latin
sr_RS
sr_YU
sr_YU@cyrillic
sv
sv_FI
sv_FI@euro
sv_SE
sw
syr
ta
ta_IN
te
te_IN
tg
tg_TJ
th
th_TH
ti
ti_ER
ti_ET
tig
tk
tl
tl_PH
tr
tr_TR
tt
tt_RU
ug
uk
uk_UA
ur
ur_PK
uz
uz@Latn
uz_UZ
ve
vi
vi_VN
vi_VN.UTF-8
wa
wal
wo
xh
yi
yi_US
zh
zh_CN
zh_CN.GB18030
zh_CN.GB2312
zh_CN.GBK
zh_CN.UTF-8
zh_HK
zh_HK.UTF-8
zh_SG
zh_TW
zh_TW.Big5
zh_TW.EUC-TW
zh_TW.UTF-8
zu
"

LocalePurgeNokeep() {
	local locale_keep
	for locale_keep in $KEEP_LOCALES
	do	case $1 in
		$locale_keep)
			return 1;;
		esac
	done
}

LocalePurgeMain() {
	local locale_list locale_item locale_cmd
	locale_list=
	for locale_item in $ALL_LOCALES ${ALL_LOCALES_ADD-}
	do	[ -n "$locale_item" ] && LocalePurgeNokeep "$locale_item" && \
			locale_list=$locale_list' '$locale_item
	done
	locale_cmd='for d
do	for l in $locale_list
do	if test -d "$d/$l$k"
then	rm -rvf -- "$d/$l"
fi
done
done'
	export locale_list
	shell=`command -v sh` || shell=
	: ${shell:=/bin/sh}
	if BashrcdTrue $LOCALEPURGE
	then	einfo 'removing undesired locales'
		find "$ED" -name locale -type d \
			-exec "$shell" -c "k='/LC_MESSAGES'
$locale_cmd" sh '{}' '+'
	fi
	if BashrcdTrue $MANPURGE
	then	einfo 'removing undesired manpages'
		find "$ED" -name man -type d \
			-exec "$shell" -c "k=
$locale_cmd" sh '{}' '+'
	fi
	unset locale_list
}

LocalePurge() {
	if BashrcdTrue $NOLOCALEPURGE || {
		! BashrcdTrue $LOCALEPURGE && ! BashrcdTrue $MANPURGE
	} || [ -z "${KEEP_LOCALES++}" ]
	then	return 0
	fi
	case $- in
	*f*)
		LocalePurgeMain;;
	*)
		set -f
		LocalePurgeMain
		set +f;;
	esac
}

BashrcdPhase preinst LocalePurge
