p() { for i ; do export PATH=$PATH:"$i" ; done ; }

p /usr/{bin,sbin,local/bin,local/sbin,X11R6/bin} /bin /sbin \
   ${HOME}/{{bin,bin/local/bin},usr/{bin,bin/ascii,local/bin},.local/bin}

unset -f p

[ "$(uname)" = "OpenBSD" ] && #todo: how to use seq?
        [ -d /usr/local/jdk* ] &&
            export PATH=$PATH:/usr/local/jdk-1.{$(jot -n \
                -s , 2 7)}.{$(jot -n -s , 10 0)}/bin

(find ${HOME}/tmp ! -path ${HOME}/tmp -exec \
    rm -rf "{}" {} \; > /dev/null 2>&1 &)

[ -z "$SHELL" ] &&
    for i in mk k a ba da ; do
        [ -f /bin/${i}sh ] &&
            { export SHELL=/bin/${i}sh ; break ; }
    done

[ -d ${HOME}/etc ] &&
    case $SHELL in
        *ksh) export ENV=${HOME}/etc/kshrc ;;
        *) export ENV=${HOME}/etc/aliases
    esac

for i in nvim vim vis vi nano ; do
    type $i > /dev/null 2>&1 &&
        { export EDITOR=$i VISUAL=$i ; break ; }
done

for i in surf firefox chromium ; do
    type $i > /dev/null 2>&1 &&
        { export BROWSER=$i ; break ; }
done
unset i

ulimit -c 0 2> /dev/null

for i in LANG LANGUAGE LC_ALL LOCALE LC_CTYPE ; do
    export $i='en_US.UTF-8'
done
export LESSCHARSET='utf-8' \
    PYTHONIOENCODING='UTF-8' \
    LESS='-QRd' \
    MANPAGER='less'

type xdg-open > /dev/null 2>&1 &&
    export XDG_DESKTOP_DIR="/non/existent" \
           XDG_PUBLICSHARE_DIR="/non/existent" \
           XDG_CONFIG_HOME="${HOME}/etc/config" \
           XDG_DOCUMENTS_DIR="${HOME}/var/files" \
           XDG_DOWNLOAD_DIR="${HOME}/var/downloads" \
           XDG_MUSIC_DIR="${HOME}/var/music" \
           XDG_PICTURES_DIR="${HOME}/var/images" \
           XDG_VIDEOS_DIR="${HOME}/var/videos"

#[ -z "$(pgrep X)" ] &&  
#    [ -f ~/etc/xinitrc ] &&
#        {   
#
#            rm -rf ${HOME}/.{Xauthority*,serverauth*}
#            cp ${HOME}/etc/xinitrc ${HOME}/.xinitrc
#            startx -- > /dev/null
#
#        } > /dev/null 2>&1
export PATH="$PATH:${HOME}/.local/bin:${HOME}/.local/pk/prefix/bin"
export PYTHONPATH="$PYTHONPATH:/home/mitch/.local/pk/prefix/lib/python2.7/site-packages"
export PYTHONPATH="$PYTHONPATH:/home/mitch/.local/pk/prefix/lib/python3.6/site-packages"
