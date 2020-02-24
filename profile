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
ulimit -c 0 2>/dev/null

# clear tmp
rm -rf ${HOME}/tmp 2>/dev/null && mkdir -p ${HOME}/tmp

export PATH="/bin:/sbin:/usr/{bin,sbin,local/bin,local/sbin,X11R6/bin}:$PATH"
export PATH="$PATH:$(printf '%s:' ${HOME}/bin/*/)"
export PATH="$PATH:${HOME}/src/ascii:${HOME}/.local/bin"

if [ -d ${HOME}/src/plan9/plan9port ] ; then
    export PLAN9=${HOME}/src/plan9/plan9port
    export PATH="$PATH:$PLAN9/bin"
fi

[ -f ${HOME}/src/dots/kshrc ] && export ENV=${HOME}/src/dots/kshrc

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
export _JAVA_AWT_WM_NONREPARENTING=1 # fix for many java apps
export CFLAGS='-O2 -pipe -fstack-protector-strong'
export LESSCHARSET='utf-8' PYTHONIOENCODING='UTF-8'
export MANPAGER='less' LESS='-QRd'

if type xdg-open >/dev/null ; then
    export XDG_DESKTOP_DIR="/non/existent" \
           XDG_PUBLICSHARE_DIR="/non/existent" \
           XDG_CONFIG_HOME="${HOME}/.config" \
           XDG_DOCUMENTS_DIR="${HOME}/files" \
           XDG_DOWNLOAD_DIR="${HOME}/Downloads" \
           XDG_MUSIC_DIR="${HOME}/music" \
           XDG_PICTURES_DIR="${HOME}/images" \
           XDG_VIDEOS_DIR="${HOME}/videos"
fi

export LANG='en_US.UTF-8' \
       LANGUAGE='en_US.UTF-8' \
       LC_ALL='en_US.UTF-8' \
       LOCALE='en_US.UTF-8' \
       LC_CTYPE='en_US.UTF-8'

for i in nvim vis vim vi ; do
    type $i && { export EDITOR=$i ; break ; }
done >/dev/null

for i in iridium chromium chrome firefox surf ; do
    type $i && { export BROWSER=$i ; break ; }
done >/dev/null

pgrep X >/dev/null || launchx
