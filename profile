p() { for i ; do export PATH=$PATH:"$i" ; done ; }

p /usr/{bin,sbin,local/bin,local/sbin,X11R6/bin} /bin \
   /sbin ${HOME}/{bin,bin/bin,.local/bin,usr/bin,usr/bin/ascii}

unset -f p

[ "$(uname)" = "OpenBSD" ] && #todo: how to use seq?
    export PATH=$PATH:/usr/local/jdk-1.{$(jot -n \
        -s , 2 7)}.{$(jot -n -s , 10 0)}/bin

find ${HOME}/tmp ! -path ${HOME}/tmp -exec \
    rm -rf "{}" {} \; > /dev/null 2>&1 &

case ${SHELL} in
    /bin/ksh|/bin/mksh)
       export ENV=${HOME}/etc/kshrc ;;
    *) export ENV=${HOME}/etc/aliases
esac
[ "$ENV" ] && . ${ENV}

for i in nvim vim vis vi nano ; do
    type $i > /dev/null 2>&1 &&
        { export {EDITOR,VISUAL}=$i ; break ; }
done

for i in surf firefox chromium ; do
    type $i > /dev/null 2>&1 &&
        { export BROWSER=$i ; break ; }
done
unset i

ulimit -c 0

export {LANG,LC_ALL,LOCALE,LC_CTYPE}='en_US.UTF-8' \
        LESSCHARSET='utf-8' \
        PYTHONIOENCODING='UTF-8' \
        LESS='-QRd' \
        MANPAGER='less -X'

type xdg-open > /dev/null 2>&1 &&
    export XDG_DESKTOP_DIR="/non/existent" \
           XDG_PUBLICSHARE_DIR="/non/existent" \
           XDG_CONFIG_HOME="${HOME}/etc/config" \
           XDG_DOCUMENTS_DIR="${HOME}/var/files" \
           XDG_DOWNLOAD_DIR="${HOME}/var/downloads" \
           XDG_MUSIC_DIR="${HOME}/var/music" \
           XDG_PICTURES_DIR="${HOME}/var/images" \
           XDG_VIDEOS_DIR="${HOME}/var/videos"

[ -z "$(pgrep X)" ] && 
    { rm -rf ${HOME}/.{Xauthority*,serverauth*}
      cp ${HOME}/etc/xinitrc ${HOME}/.xinitrc
      startx -- > /dev/null ; } > /dev/null 2>&1
