umask 022
ulimit -c 0

# -*-*-*-*-*-*-* system vars *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export ENV=~/.kshrc

PATH=/bin:/sbin:$PATH
PATH=/usr/bin:/usr/sbin:/usr/X11R6/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=${HOME}/bin:${HOME}/.local/bin:$PATH
PATH=$PATH:$(printf '%s:' ${HOME}/bin/*/)
PATH=$PATH:${HOME}/src/ascii
export PATH

export MANPATH=~/.local/share/man:

export CFLAGS='-O2 -pipe -fstack-protector-strong -fexceptions'
export NPROC=$(sysctl -n hw.ncpu)

export LANG='en_US.UTF-8' \
       LANGUAGE='en_US.UTF-8' \
       LC_ALL='en_US.UTF-8' \
       LOCALE='en_US.UTF-8' \
       LC_CTYPE='en_US.UTF-8'

# -*-*-*-*-*-*-* my vars *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export XDG_CONFIG_HOME=~/.config \
       XDG_DOWNLOAD_DIR=~/Downloads \
       XDG_DOCUMENTS_DIR=~/fil \
       XDG_MUSIC_DIR=~/mus \
       XDG_PICTURES_DIR=~/img \
       XDG_VIDEOS_DIR=~/vid \
       XDG_CACHE_HOME=~/.cache \
       XDG_DATA_HOME=~/.cache \
       XDG_DESKTOP_DIR=~/.cache \
       XDG_PUBLICSHARE_DIR=~/.cache \
       XDG_TEMPLATES_DIR=~/.cache

export TRASH_DIR=${XDG_CACHE_HOME}/trash \
       MENU_PROG=menu \
       SUBS_FILE=~/fil/subs.txt

export YTDL_OPTS='-c -R 50 --geo-bypass --prefer-ffmpeg -o %(title)s.%(ext)s' \
       MPV_OPTS="--really-quiet --force-seekable=yes" \
       MUPDF_OPTS='-C f8f6f6'

# -*-*-*-*-*-*-* default programs *-*-*-*-*-*-*-*-*-*-*-*-*-*
for i in v nvim vim vi mg nano ; do
    type $i && { export EDITOR=$i ; break ; }
done >/dev/null

for i in brws chrome chromium firefox surf ; do
    type $i && { export BROWSER=$i ; break ; }
done >/dev/null

if type less >/dev/null ; then
    export PAGER=less \
           MANPAGER=less
    # opts: quiet/raw/squeeze/ignore-case/short-prompt/show-percentage
    export LESS='-QRsim +Gg' 
    # active colors in less, taken from arch-wiki
    export LESS_TERMCAP_mb=$'\e[1;31m' \
           LESS_TERMCAP_md=$'\e[1;33m' \
           LESS_TERMCAP_so=$'\e[01;44;37m' \
           LESS_TERMCAP_us=$'\e[01;37m' \
           LESS_TERMCAP_me=$'\e[0m' \
           LESS_TERMCAP_se=$'\e[0m'\
           LESS_TERMCAP_ue=$'\e[0m'
fi
