#!/bin/sh
#
# http://github.com/mitchweaver/dots
#
#                          m""    "    ""#
#   mmmm    m mm   mmm   mm#mm  mmm      #     mmm
#   #" "#   #"  " #" "#    #      #      #    #"  #
#   #   #   #     #   #    #      #      #    #""""
#   ##m#"   #     "#m#"    #    mm#mm    "mm  "#mm"
#   #
#   "
#

umask 022
ulimit -c 0

# clear tmp
rm -rf ${HOME}/tmp/*  2>/dev/null
rm -rf ${HOME}/tmp/.* 2>/dev/null

PATH="/bin:/sbin:$PATH"
PATH="/usr/bin:/usr/sbin:/usr/X11R6/bin:$PATH"
PATH="/usr/local/bin:/usr/local/sbin:$PATH"
PATH="${HOME}/bin:${HOME}/.local/bin:$PATH"
PATH="$PATH:$(printf '%s:' ${HOME}/bin/*/)"
PATH="$PATH:${HOME}/src/ascii"
export PATH

MANPATH="/usr/share/man:/usr/local/share/man:/usr/local/man"
MANPATH="${HOME}/.local/share/man:$MANPATH"
export MANPATH

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"

if [ -d ${HOME}/src/plan9/plan9port ] ; then
    export PLAN9=${HOME}/src/plan9/plan9port
elif [ -d /usr/local/plan9 ] ; then
    export PLAN9=/usr/local/plan9
fi
if [ "$PLAN9" ] ; then
    export PATH="$PATH:$PLAN9/bin"
    export font=$PLAN9/font/lucsans/unicode.8.font
fi

[ -f ${HOME}/src/dots/kshrc ] && export ENV=${HOME}/src/dots/kshrc

export EDITOR=v
export MANPAGER=less
export BROWSER=surf

export CFLAGS='-O2 -pipe -fstack-protector-strong -fexceptions'
export NPROC=$(sysctl -n hw.ncpu 2>/dev/null || echo 1)

export LANG='en_US.UTF-8' \
       LANGUAGE='en_US.UTF-8' \
       LC_ALL='en_US.UTF-8' \
       LOCALE='en_US.UTF-8' \
       LC_CTYPE='en_US.UTF-8' \
       LESSCHARSET='utf-8' \
       PYTHONIOENCODING='UTF-8'

export XDG_CONFIG_HOME="${HOME}/.config" \
       XDG_DOWNLOAD_DIR="${HOME}/Downloads"

export _JAVA_AWT_WM_NONREPARENTING=1 # fix for many java apps

# various programs
export HTOPRC=${HOME}/src/dots/htoprc

pgrep X >/dev/null || launchx
