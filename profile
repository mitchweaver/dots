p() { for i in "$@" ; do
            export PATH=$PATH:"$i"
      done ; }

p /usr/{bin,sbin,local/bin,local/sbin,X11R6/bin} /bin \
   /sbin ${HOME}/{bin,.local/bin,usr/bin,usr/bin/ascii}

unset -f p

export PATH=$PATH:/usr/local/jdk-1.{$(jot -n \
    -s , 2 7)}.{$(jot -n -s , 10 0)}/bin

case ${SHELL} in
    /bin/ksh|/bin/mksh)
       export ENV=${HOME}/etc/kshrc ;;
    *) export ENV=${HOME}/etc/aliases
esac
. ${ENV}

for i in {nvim,vim,vis,vi} ; do
    type $i > /dev/null 2>&1 &&
        { export {EDITOR,VISUAL}=$i ; break ; }
done

for i in {surf,firefox} ; do
    type $i > /dev/null 2>&1 &&
        { export BROWSER=$i ; break ; }
done
unset i

ulimit -c 0

export {LANG,LC_ALL,LOCALE,LC_CTYPE}='en_US.UTF-8'
export LESSCHARSET='utf-8'
export LESS_TERMCAP_md="${yellow}";
export PYTHONIOENCODING='UTF-8';
export LESS='-FQRd'
export MANPAGER='less -X';

type xdg-open > /dev/null 2>&1 &&
    { export XDG_DESKTOP_DIR="/non/existent"
      export XDG_PUBLICSHARE_DIR="/non/existent"
      export XDG_CONFIG_HOME="${HOME}/etc/config"
      export XDG_DOCUMENTS_DIR="${HOME}/var/files"
      export XDG_DOWNLOAD_DIR="${HOME}/var/downloads"
      export XDG_MUSIC_DIR="${HOME}/var/music"
      export XDG_PICTURES_DIR="${HOME}/var/images"
      export XDG_VIDEOS_DIR="${HOME}/var/videos" ; }

[ -z "$(pgrep X)" ] && 
    { rm -rf ${HOME}/.{Xauthority*,serverauth*} \
        > /dev/null 2>&1
      cp ${HOME}/etc/xinitrc ${HOME}/.xinitrc
      startx -- > /dev/null ; }
