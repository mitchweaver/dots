#!/bin/bash
# (C) Martin V\"ath <martin at mvath.de>
# SPDX-License-Identifier: GPL-2.0-only

FLAG_FILTER_C_CXX=(
	'-fall-intrinsics'
	'-fbackslash'
	'-fcray-pointer'
	'-fd-lines-as-*'
	'-fdec*'
	'-fdefault-*'
	'-fdollar-ok'
	'-ffixed-*'
	'-ffree-*'
	'-fimplicit-none'
	'-finteger-4-integer-8'
	'-fmax-identifier-length*'
	'-fmodule-private'
	'-fno-range-check'
	'-freal-*'
	'-ftest-forall-temp'
	'-std=f*'
	'-std=gnu'
	'-std=legacy'
)

FLAG_FILTER_CXX_FORTRAN=(
	'-std=c1*'
	'-std=c8*'
	'-std=c9*'
	'-std=gnu1*'
	'-std=gnu8*'
	'-std=gnu9*'
	'-std=iso*'
	'-Wimplicit-function-declaration'
)

FLAG_FILTER_C_FORTRAN=(
	'-fabi-*'
	'-faligned-new'
	'-fcheck-new'
	'-fconcepts'
	'-fconstexpr-*'
	'-fdeduce-init-list'
	'-fext*'
	'-ffor-scope'
	'-ffriend-injection'
	'-fms-extensions'
	'-fnew-inheriting-ctors'
	'-fnew-ttp-matching'
	'-fno-access-control'
	'-fno-elide-constructors'
	'-fno-enforce-eh-specs'
	'-fno-extern-tls-init'
	'-fno-for-scope'
	'-fno-gnu-keywords'
	'-fno-implement-inlines'
	'-fno-implicit-*'
	'-fno-nonansi-builtins'
	'-fno-operator-names'
	'-fno-optional-diags'
	'-fno-pretty-templates'
	'-fno-rtti'
	'-fno-threadsafe-statics'
	'-fno-use-cxa-get-exception-ptr'
	'-fno-weak'
	'-fnothrow-opt'
	'-fpermissive'
	'-frepo'
	'-fsized-deallocation'
	'-fstrict-enums'
	'-fstrong-eval-order'
	'-ftemplate-*'
	'-fuse-cxa-atexit'
	'-fvisibility-*'
	'-nostdinc++'
	'-std=c++*'
	'-std=gnu++*'
	'-Wabi*'
	'-Wctor-dtor-privacy'
	'-Wdelete-non-virtual-dtor'
	'-Weffc++'
	'-Wliteral-suffix'
	'-Wlto-type-mismatch'
	'-Wmultiple-inheritance'
	'-Wnamespaces'
	'-Wno-narrowing'
	'-Wno-non-template-friend'
	'-Wno-pmf-conversions'
	'-Wno-terminate'
	'-Wnoexcept'
	'-Wnon-virtual-dtor'
	'-Wold-style-cast'
	'-Woverloaded-virtual'
	'-Wregister'
	'-Wreorder'
	'-Wsign-promo'
	'-Wstrict-null-sentinel'
	'-Wtemplates'
	'-Wvirtual-inheritance'
)

FLAG_FILTER_CFLAGS=(
)

FLAG_FILTER_CXXFLAGS=(
)

FLAG_FILTER_FORTRAN=(
	'-ansi'
	'-fallow-parameterless-variadic-functions'
	'-fcilkplus'
	'-fcond-mismatch'
	'-fdirectives-only'
	'-ffreestanding'
	'-fgimple'
	'-fgnu-tm'
	'-fgnu89-inline'
	'-fhosted'
	'-flax-vector-conversions'
	'-fms-extensions'
	'-fno-asm'
	'-fno-builtin*'
	'-fno-signed-bitfields'
	'-fno-unsigned-bitfields'
	'-fpermitted-flt-eval-methods*'
	'-fplan9-extensions'
	'-fsigned-*'
	'-fsso-struct*'
	'-funsigned-*'
	'-Wchkp'
	'-Wclobbered'
	'-Wformat*'
	'-Wvolatile-register-var'
)

FLAG_FILTER_FFLAGS=(
)

FLAG_FILTER_FCFLAGS=(
)

FLAG_FILTER_F77FLAGS=(
)

FLAG_FILTER_NONGNU=(
	'-fcf-protection*'
	'-fdevirtualize-at-ltrans'
	'-fdevirtualize-speculatively'
	'-fdirectives-only'
	'-ffat-lto-objects'
	'-fgcse*'
	'-fgraphite*'
	'-finline-functions'
	'-fipa-pta'
	'-fira-loop-pressure'
	'-fisolate-erroneous-paths-attribute'
	'-fivopts'
	'-flimit-function-alignment'
	'-floop*'
	'-flto=[0-9]*'
	'-flto=auto'
	'-flto=jobserver'
	'-flto-odr-type-merging'
	'-flto-partition=*'
	'-flto-compression-level=*'
	'-fmodulo*'
	'-fno-enforce-eh-specs'
	'-fno-ident'
	'-fno-ipa-cp-clone'
	'-fno-plt' # causes various runtime segfaults for clang:6 compiled code
	'-fno-semantic-interposition'
	'-fnothrow-opt'
	'-fpredictive-commoning'
	'-frename-registers'
	'-freorder-functions'
	'-frerun-cse-after-loop'
	'-fsched*'
	'-fsection-anchors'
	'-ftree*'
	'-funsafe-loop*'
	'-fuse-linker-plugin'
	'-fvect-cost-model'
	'-fweb'
	'-fwhole-program'
	'-malign-data*'
	'-mfunction-return*'
	'-mindirect-branch*'
	'-mvectorize*'
	'-Waggressive-loop-optimizations'
	'-Wclobbered'
	'-Wl,-z,retpolineplt' # does not work, currently
	'-Wreturn-local-addr'
)

FLAG_FILTER_GNU=(
	'-emit-llvm'
	'-flto=full'
	'-flto=thin'
	'-flto-jobs=*'
	'-fopenmp=*'
	'-frewrite-includes'
	'-fsanitize=cfi*'
	'-fsanitize=safe-stack'
	'-mllvm'
	'-mretpoline*'
	'-polly*'
	'-Wl,-z,retpolineplt'
)

FLAG_FILTER_CLANG_LTO_DEP=(
	'-fsanitize=cfi*'
	'-fwhole-program-vtables'
)

FlagEval() {
	case $- in
	*f*)	eval "$*";;
	*)	set -f
		eval "$*"
		set +f;;
	esac
}

FlagNodupAdd() {
	local addres addf addvar dups
	dups=$1
	shift
	addvar=$1
	shift
	eval addres=\$$addvar
	for addf
	do	case " $addres $dups " in
		*[[:space:]]"$addf"[[:space:]]*)
			continue;;
		esac
		addres=$addres${addres:+\ }$addf
	done
	eval $addvar=\$addres
}

FlagAdd() {
	FlagNodupAdd '' "$@"
}

FlagSub() {
	local subres subpat subf subvar sublist
	subvar=$1
	shift
	subres=
	eval sublist=\$$subvar
	for subf in $sublist
	do	for subpat
		do	[ -n "${subpat:++}" ] || continue
			case $subf in
			$subpat)
				subf=
				break;;
			esac
		done
		[ -z "${subf:++}" ] || subres=$subres${subres:+\ }$subf
	done
	eval $subvar=\$subres
}

FlagReplace() {
	local repres repf repcurr repvar reppat
	repvar=$1
	shift
	eval repf=\$$repvar
	reppat=$1
	shift
	repres=
	for repcurr in $repf
	do	case $repcurr in
		$reppat)
			$repfound && FlagAdd repres "$@"
			continue;;
		esac
		repres=$repres${repres:+\ }$repcurr
	done
	eval $repvar=\$repres
}

FlagSet() {
	local setvar
	setvar=$1
	shift
	eval $setvar=\$*
}

FlagAddCFlags() {
	FlagAdd CFLAGS "$@"
	FlagAdd CXXFLAGS "$@"
}

FlagSubCFlags() {
	FlagSub CFLAGS "$@"
	FlagSub CXXFLAGS "$@"
	FlagSub CPPFLAGS "$@"
	FlagSub OPTCFLAGS "$@"
	FlagSub OPTCXXFLAGS "$@"
	FlagSub OPTCPPFLAGS "$@"
}

FlagReplaceCFlags() {
	FlagReplace CFLAGS "$@"
	FlagReplace CXXFLAGS "$@"
	FlagReplace CPPFLAGS "$@"
	FlagSub OPTCFLAGS "$1"
	FlagSub OPTCXXFLAGS "$1"
	FlagSub OPTCPPFLAGS "$1"
}

FlagSetCFlags() {
	FlagSet CFLAGS "$@"
	CXXFLAGS=$CFLAGS
	CPPFLAGS=
	OPTCFLAGS=
	OPTCXXFLAGS=
	OPTCPPFLAGS=
}

FlagAddFFlags() {
	FlagAdd FFLAGS "$@"
	FlagAdd FCFLAGS "$@"
	FlagAdd F77FLAGS "$@"
}

FlagSubFFlags() {
	FlagSub FFLAGS "$@"
	FlagSub FCFLAGS "$@"
	FlagSub F77FLAGS "$@"
}

FlagReplaceFFlags() {
	FlagReplace FFLAGS "$@"
	FlagReplace FCFLAGS "$@"
	FlagReplace F77FLAGS "$@"
}

FlagSetFFlags() {
	FlagSet FFLAGS "$@"
	FlagSet FCFLAGS "$@"
	FlagSet F77FLAGS "$@"
}

FlagAddAllFlags() {
	FlagAddCFlags "$@"
	FlagAddFFlags "$@"
}

FlagSubAllFlags() {
	FlagSubCFlags "$@"
	FlagSubFFlags "$@"
	FlagSub LDFLAGS "$@"
	FlagSub OPTLDFLAGS "$@"
}

FlagReplaceAllFlags() {
	FlagReplaceCFlags "$@"
	FlagReplaceFFlags "$@"
	FlagSub LDFLAGS "$1"
	FlagSub OPTLDFLAGS "$1"
}

FlagSetAllFlags() {
	FlagSetCFlags "$@"
	FlagSetFFlags "$@"
	LDFLAGS=
	OPTLDFLAGS=
}

FlagAthlon() {
	FlagSubCFlags '-march=*'
	FlagAddCFlags '-march=athlon-4'
	command -v x86_64-pc-linux-gnu-gcc32 >/dev/null 2>&1 && \
		export CC=x86_64-pc-linux-gnu-gcc32
	command -v x86_64-pc-linux-gnu-g++32 >/dev/null 2>&1 && \
		export CXX=x86_64-pc-linux-gnu-g++32
}

FlagExecute() {
	local ex exy excurr
	for excurr
	do	case $excurr in
		'#'*)
			return;;
		'!'*)
			[ "$HOSTTYPE" = 'i686' ] || continue
			ex=${excurr#?};;
		'~'*)
			[ "$HOSTTYPE" = 'x86_64' ] || continue
			ex=${excurr#?};;
		*)
			ex=$excurr;;
		esac
		case $ex in
		/*/*)
			ex=${ex%/}
			ex=${ex#/}
			FlagEval FlagReplaceAllFlags "${ex%%/*}" "${ex#*/}";;
		'-'*)
			FlagAddCFlags "$ex";;
		'+flto*')
			FlagSubAllFlags '-flto*' '-fuse-linker-plugin' '-emit-llvm';;
		'+'*)
			FlagSubAllFlags "-${ex#+}";;
		'C*FLAGS-='*)
			FlagEval FlagSubCFlags ${ex#*-=};;
		'C*FLAGS+='*)
			FlagEval FlagAddCFlags ${ex#*+=};;
		'C*FLAGS='*)
			FlagEval FlagSetCFlags "${ex#*=}";;
		'C*FLAGS/=/'*/*)
			ex=${ex%/}
			ex=${ex#*/=/}
			FlagEval FlagReplaceCFlags "${ex%%/*}" "${ex#*/}";;
		'F*FLAGS-='*)
			FlagEval FlagSubFFlags ${ex#*-=};;
		'F*FLAGS+='*)
			FlagEval FlagAddFFlags ${ex#*+=};;
		'F*FLAGS='*)
			FlagEval FlagSetFFlags "${ex#*=}";;
		'F*FLAGS/=/'*/*)
			ex=${ex%/}
			ex=${ex#*/=/}
			FlagEval FlagReplaceFFlags "${ex%%/*}" "${ex#*/}";;
		'*FLAGS-='*)
			FlagEval FlagSubAllFlags ${ex#*-=};;
		'*FLAGS+='*)
			FlagEval FlagAddAllFlags ${ex#*+=};;
		'*FLAGS='*)
			FlagEval FlagSetAllFlags "${ex#*=}";;
		'*FLAGS/=/'*/*)
			ex=${ex%/}
			ex=${ex#*/=/}
			FlagEval FlagReplaceAllFlags "${ex%%/*}" "${ex#*/}";;
		'ATHLON32')
			FlagAthlon;;
		'NOC*OPT='*|'NOC*='*)
			FlagEval FlagSet NOCOPT "${ex#*=}"
			NOCXXOPT=$NOCOPT
			NOCPPOPT=$NOCOPT;;
		'NO*OPT='*)
			FlagEval FlagSet NOCOPT "${ex#*=}"
			NOCXXOPT=$NOCOPT
			NOCPPOPT=$NOCOPT
			NOLDOPT=$NOCOPT;;
		'NOLD*='*)
			FlagEval FlagSet NOLDOPT "${ex#*=}"
			NOLDADD=$NOLDOPT;;
		'NO*'*)
			FlagEval FlagSet NOCOPT "${ex#*=}"
			NOCXXOPT=$NOCOPT
			NOCPPOPT=$NOCOPT
			NOLDOPT=$NOCOPT
			NOLDADD=$NOCOPT
			NOFFLAGS=$NOCOPT
			NOFCFLAGS=$NOCOPT
			NOF77FLAGS=$NOCOPT;;
		'SAFE')
			NOCOPT=1
			NOCXXOPT=1
			NOCPPOPT=1
			NOLDOPT=1
			MESONDEDUP=1
			LDFLAGS=
			CONFIG_SITE=
			NOLAFILEREMOVE=1
			unset CMAKE_MAKEFILE_GENERATOR;;
		*' '*'='*)
			FlagEval "$ex";;
		*'/=/'*'/'*)
			ex=${ex%/}
			exy=${ex#*/=/}
			FlagEval FlagReplace "${ex%%/=/*}" "${exy%%/*}" "${exy#*/}";;
		*'-='*)
			FlagEval FlagSub "${ex%%-=*}" ${ex#*-=};;
		*'+='*)
			FlagEval FlagAdd "${ex%%+=*}" ${ex#*+=};;
		*'='*)
			FlagEval FlagSet "${ex%%=*}" "${ex#*=}";;
		*)
			FlagEval "$ex";;
		esac
	done
}

FlagMask() {
	if command -v masked-packages >/dev/null 2>&1
	then
FlagMask() {
	masked-packages -qm "$1" -- "$CATEGORY/$PF:${SLOT:-0}${PORTAGE_REPO_NAME:+::}${PORTAGE_REPO_NAME-}"
}
	else
FlagMask() {
	local add=
	case ${1%::*} in
	*':'*)
		add=:${SLOT:-0};;
	esac
	case $1 in
	*'::'*)
		add=$add::$PORTAGE_REPO_NAME;;
	esac
	case $1 in
	'~'*)
		case "~$CATEGORY/$PN-$PV$add" in
		$1)
			return;;
		esac;;
	'='*)
		case "=$CATEGORY/$PF$add" in
		$1)
			return;;
		esac;;
	*)
		case "$CATEGORY/$PN$add" in
		$1)
			return;;
		esac;;
	esac
	return 1
}
	fi
	FlagMask "$@"
}

FlagParseLine() {
	local scanp scanl scansaveifs
	scanl=$2
	while :
	do	case $scanl in
		[[:space:]]*)
			scanl=${scanl#?}
			continue;;
		'#'*)
			return;;
		*[[:space:]]*)
			break;;
		esac
		return
	done
	scanp=${scanl%%[[:space:]]*}
	scanl=${scanl#*[[:space:]]}
	[ -n "${scanl:++}" ] || return 0
	FlagMask "$scanp" || return 0
	scansaveifs=$IFS
	IFS=$1
	BashrcdEcho "$scanfile -> $scanp: $scanl"
	FlagEval FlagExecute $scanl
	IFS=$scansaveifs
}

FlagScanFiles() {
	local scanfile scanl oldifs scanifs
	scanifs=$IFS
	IFS=
	for scanfile
	do	[ -z "${scanfile:++}" ] && continue
		test -r "$scanfile" || continue
		while read -r scanl
		do	FlagParseLine "$scanifs" "$scanl"
		done <"$scanfile"
	done
	IFS=$scanifs
}

FlagScanDir() {
	local scantmp scanifs scanfile
	scanifs=$IFS
	if test -d "$1"
	then	IFS='
'
		for scantmp in `find -L "$1" \
		'(' '(' -name '.*' -o -name '*~' ')' -prune ')' -o \
			-type f -print`
		do	IFS=$scanifs
			FlagScanFiles "$scantmp"
		done
	else	FlagScanFiles "$1"
	fi
	scanfile='FLAG_ADDLINES'
	IFS='
'
	for scantmp in $FLAG_ADDLINES
	do	FlagParseLine "$scanifs" "$scantmp"
	done
	IFS=$scanifs
}

FlagSetUseNonGNU() {
	has clang ${IUSE//+} && use clang && return 0
	case $CC$CXX in
	*clang*)
		return 0;;
	esac
	return 1
}

FlagSetNonGNU() {
	: ${NOLDADD:=1}
	FlagSubAllFlags "${FLAG_FILTER_NONGNU[@]}"
	FlagReplaceAllFlags '-fstack-check*' '-fstack-check'
	# FlagAddCFlags '-flto' '-emit-llvm'
	case " $LDFLAGS $CFLAGS $CXXFLAGS" in
	*[[:space:]]'-flto'*)
		;;
	*)
		FlagSubAllFlags "${FLAG_FILTER_CLANG_LTO_DEP[@]}";;
	esac
}

FlagSetGNU() {
	FlagSubAllFlags "${FLAG_FILTER_GNU[@]}"
}

FlagMesonDedup() {
	local newld=
	FlagNodupAdd "$CFLAGS $CXXFLAGS $CPPFLAGS $FFLAGS $FCFLAGS $F77FLAGS" \
		newld $LDFLAGS
	LDFLAGS=$newld
}

FlagSetFlags() {
	local ld i
	ld=
	: ${PGO_PARENT:=/var/cache/pgo}
	: ${PGO_DIR:=$PGO_PARENT/$CATEGORY:$P}
	FlagScanDir "${PORTAGE_CONFIGROOT%/}/etc/portage/package.cflags"
	[ -z "${USE_NONGNU++}" ] && FlagSetUseNonGNU && USE_NONGNU=1
	if BashrcdTrue "${USE_NONGNU-}"
	then	FlagSetNonGNU
	else	FlagSetGNU
	fi
	if [ -n "$FLAG_ADD" ]
	then	BashrcdEcho "FLAG_ADD: $FLAG_ADD"
		FlagEval FlagExecute "$FLAG_ADD"
	fi
	PGO_DIR=${PGO_DIR%/}
	case ${PGO_DIR:-/} in
	/)
		error 'PGO_DIR must not be empty'
		false;;
	/*)
		:;;
	*)
		error 'PGO_DIR must be an absolute path'
		false;;
	esac || {
		die 'Bad PGO_DIR'
		exit 2
	}
	use_pgo=false
	if test -r "$PGO_DIR"
	then	unset PGO
		BashrcdTrue $NOPGO || use_pgo=:
	fi
	if BashrcdTrue $PGO
	then	FlagAddCFlags "-fprofile-generate=$PGO_DIR" \
			-fvpt -fprofile-arcs
		FlagAdd LDFLAGS -fprofile-arcs
		addpredict "$PGO_PARENT"
	elif $use_pgo
	then	FlagAddCFlags "-fprofile-use=$PGO_DIR" \
			-fvpt -fbranch-probabilities -fprofile-correction
	else	: ${KEEPPGO:=:}
	fi
	BashrcdTrue $NOLDOPT || FlagAdd LDFLAGS $OPTLDFLAGS
	BashrcdTrue $NOCADD || BashrcdTrue $MESONDEDUP || \
		case " $LDFLAGS $CFLAGS $CXXFLAGS" in
		*[[:space:]]'-flto'*)
			ld="$CFLAGS $CXXFLAGS";;
		esac
	BashrcdTrue $NOLDADD || BashrcdTrue $MESONDEDUP || FlagAddCFlags $LDFLAGS
	FlagAdd LDFLAGS $ld
	BashrcdTrue $NOCOPT || FlagAdd CFLAGS $OPTCFLAGS
	BashrcdTrue $NOCXXOPT || FlagAdd CXXFLAGS $OPTCXXFLAGS
	BashrcdTrue $NOCPPOPT || FlagAdd CPPFLAGS $OPTCPPFLAGS
	BashrcdTrue $NOFFLAGS || FFLAGS=$CFLAGS
	BashrcdTrue $NOFCFLAGS || FCFLAGS=$FFLAGS
	BashrcdTrue $NOF77FLAGS || F77FLAGS=$FFLAGS
	BashrcdTrue $NOFILTER_CXXFLAGS || FlagSub CXXFLAGS \
		"${FLAG_FILTER_C_CXX[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_CXXFLAGS[@]}"
	BashrcdTrue $NOFILTER_CFLAGS || FlagSub CFLAGS \
		"${FLAG_FILTER_C_CXX[@]}" "${FLAG_FILTER_C_FORTRAN[@]}" \
		"${FLAG_FILTER_CFLAGS[@]}"
	BashrcdTrue $NOFILTER_FFLAGS || FlagSub FFLAGS \
		"${FLAG_FILTER_C_FORTRAN[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_FORTRAN[@]}" "${FLAG_FILTER_FFLAGS[@]}"
	BashrcdTrue $NOFILTER_FCFLAGS || FlagSub FCFLAGS \
		"${FLAG_FILTER_C_FORTRAN[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_FORTRAN[@]}" "${FLAG_FILTER_FCFLAGS[@]}"
	BashrcdTrue $NOFILTER_F77FLAGS || FlagSub FCFLAGS \
		"${FLAG_FILTER_C_FORTRAN[@]}" "${FLAG_FILTER_CXX_FORTRAN[@]}" \
		"${FLAG_FILTER_FORTRAN[@]}" "${FLAG_FILTER_F77LAGS[@]}"
	! BashrcdTrue $MESONDEDUP || FlagMesonDedup
	unset OPTCFLAGS OPTCXXFLAGS OPTCPPFLAGS OPTLDFLAGS
	unset NOLDOPT NOLDADD NOCOPT NOCXXOPT NOFFLAGS NOFCFLAGS NOF77FLAGS
	unset NOFILTER_CXXFLAGS NOFILTER_CFLAGS
	unset NOFILTER_FFLAGS NOFILTER_FCFLAGS NOFILTER_F77FLAGS
}

FlagInfoExport() {
	local out
	for out in FEATURES CFLAGS CXXFLAGS CPPFLAGS FFLAGS FCFLAGS F77FLAGS \
		LDFLAGS MAKEOPTS EXTRA_ECONF EXTRA_EMAKE USE_NONGNU
	do	eval "if [ -n \"\${$out:++}\" ]
		then	export $out
			BashrcdEcho \"$out='\$$out'\"
		else	unset $out
		fi"
	done
	if BashrcdTrue $PGO
	then	BashrcdEcho "Create PGO into $PGO_DIR"
	elif $use_pgo
	then	BashrcdEcho "Using PGO from $PGO_DIR"
	fi
	out=`${CC:-gcc} --version | head -n 1` || out=
	BashrcdEcho "${out:-cannot determine gcc version}"
	out=`${CXX:-g++} --version | head -n 1` || out=
	BashrcdEcho "${out:-cannot determine g++ version}"
	out=`${LD:-ld} --version | head -n 1` || out=
	BashrcdEcho "${out:-cannot determine ld version}"
	BashrcdEcho "`uname -a`"
}

FlagCompile() {
	eerror \
"${PORTAGE_CONFIGROOT%/}/etc/portage/bashrc.d/*flag.sh strange order of EBUILD_PHASE:"
	die "compile or preinst before setup"
	exit 2
}

FlagPreinst() {
	FlagCompile
}

FlagSetup() {
FlagCompile() {
:
}
	local use_pgo
	FlagSetFlags
	if BashrcdTrue $PGO
	then
FlagPreinst() {
	test -d "$PGO_DIR" || mkdir -p -m +1777 -- "$PGO_DIR" || {
		eerror "cannot create pgo directory $PGO_DIR"
		die 'cannot create PGO_DIR'
		exit 2
	}
	ewarn "$CATEGORY/$PN will write profile info to world-writable"
	ewarn "$PGO_DIR"
	ewarn 'Reemerge it soon for an optimized version and removal of that directory'
}
	elif BashrcdTrue $KEEPPGO
	then
FlagPreinst() {
:
}
	else
FlagPreinst() {
	test -d "$PGO_DIR" || return 0
	BashrcdLog "removing pgo directory $PGO_DIR"
	rm -r -f -- "$PGO_DIR" || {
		eerror "cannot remove pgo directory $PGO_DIR"
		die 'cannot remove PGO_DIR'
		exit 2
	}
	local g
	g=${PGO_DIR%/*}
	[ -z "$g" ] || rmdir -p -- "$g" >/dev/null 2>&1
}
	fi
	FlagInfoExport
}

BashrcdPhase compile FlagCompile
BashrcdPhase preinst FlagPreinst
BashrcdPhase setup FlagSetup
