umask 022
ulimit -c 0 2>/dev/null

export PATH="$PATH:${HOME}/.local/bin"

export PLAN9=${HOME}/src/plan9/plan9port
export PATH="$PATH:$PLAN9/bin"

NPROC="$(nproc 2>/dev/null)"
export NPROC="${NPROC:=1}"

export LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
export _JAVA_AWT_WM_NONREPARENTING=1 # fix for many java apps
export MAKEFLAGS="-j$(($(nproc) + 1))"
export CFLAGS='-w -s -O2 -pipe -fstack-protector-strong'
export LESSCHARSET='utf-8' PYTHONIOENCODING='UTF-8'
export MANPAGER='less' LESS='-QRd'

export ALIASES=${HOME}/etc/aliases
export PS1='% '
pgrep dbus >/dev/null || export "$(dbus-launch)"

if type xdg-open >/dev/null 2>&1 ; then
    export XDG_DESKTOP_DIR="/non/existent" \
           XDG_PUBLICSHARE_DIR="/non/existent" \
           XDG_CONFIG_HOME="${HOME}/etc/config" \
           XDG_DOCUMENTS_DIR="${HOME}/var/files" \
           XDG_DOWNLOAD_DIR="${HOME}/var/downloads" \
           XDG_MUSIC_DIR="${HOME}/var/music" \
           XDG_PICTURES_DIR="${HOME}/var/images" \
           XDG_VIDEOS_DIR="${HOME}/var/videos"
fi

p() { for i ; do export PATH="$i":$PATH ; done ; }

p /usr/{bin,sbin,local/bin,local/sbin,X11R6/bin} /bin /sbin \
   ${HOME}/{usr/{bin,bin/ascii,local/bin},.local/bin} \
   ${HOME}/bin/{file,mpv,misc,net,rice,text,util,wrapper,xorg,dev,golf/fun,bonsai,9}

unset -f p

# clear tmp
rm -rf ${HOME}/tmp 2>/dev/null && mkdir -p ${HOME}/tmp

[ -d ${HOME}/etc ] &&
    case $SHELL in
        *ksh) export ENV=${HOME}/etc/kshrc ;;
        *) export ENV="$ALIASES"
    esac

for i in nvim vim vis vi nano ; do
    if type $i >/dev/null 2>&1 ; then
        export EDITOR=$i VISUAL=$i
        break
    fi
done

for i in surf chromium chromium-browser google-chrome \
              google-chrome-stable firefox ; do
    if type $i >/dev/null 2>&1 ; then
        export BROWSER=$i
        break
    fi
done

export LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    LC_ALL='en_US.UTF-8' \
    LOCALE='en_US.UTF-8' \
    LC_CTYPE='en_US.UTF-8'

if ! pgrep X >/dev/null ; then
    rm -rf ${HOME}/.{Xauthority*,serverauth*}
    type launchx && launchx >/dev/null 2>&1
fi
