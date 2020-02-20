#!/bin/ksh
#
# http://github.com/mitchweaver/dots
#

ulimit -c 0

set -o bgnice
set -o trackall
set -o csh-history
set -o vi-tabcomplete

export HISTFILE=${HOME}/.cache/.ksh_history \
       HISTCONTROL=ignoreboth \
       HISTSIZE=500 \
       SAVEHIST=500

cd() { 
    if [ "$1" ] ; then
        builtin cd --  "$*"  ||
        builtin cd --  "$*"* ||
        builtin cd -- *"$*"  ||
        builtin cd -- *"$*"*
    else
        builtin cd -- ${HOME}
    fi 2>/dev/null
    if [ "$RANGER_LEVEL" ] ; then
        PS1="[ranger: $(_get_PS1)] "
    else
        PS1="$(_get_PS1)"
    fi
    export PS1
}

# get which git branch we're on, used in our PS1
_parse_branch() { 
    set -- $(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>/dev/null)
    [ "$1" ] && echo -n " ($*)"
}

_get_PS1() {
    case ${USER} in
        alan)  echo -n "\[\e[1;35m\]a\[\e[0;32m\]l\[\e[0;33m\]a\[\e[0;34m\]n\[\e[1;36m\] \W$(_parse_branch)\[\e[1;37m\] " ;;
        mitch) echo -n "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W$(_parse_branch)\[\e[1;37m\] " ;;
        root)  echo -n "\[\e[1;37m\]root \W " ;;
        *)     echo -n '% \W '
    esac
}

# check if we're in ranger
[ "$RANGER_LEVEL" ] && clear

# this activates our PS1
cd .

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# begin generic aliases
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# dynamic 'c' utility
c() {
    if [ -d "$1" ] ; then
        cd "$1"
    elif [ -f "$1" ] ; then
        cat -- "$1"
    else
        clear
    fi
}

ls() { exa -F "$@" 2>/dev/null || command ls -F "$@" ; }

# generic aliases
alias {cc,cll,clear,clar,clea,clera}=clear
alias {x,xx,xxx,q,qq,qqq,:q,:Q,:wq,:w,exi}=exit
alias {l,sls,sl}=ls
alias ll='l -l'
alias la='l -a'
alias {lla,lal}='l -al'
alias lsf='l "$PWD"/*'
alias {cls,csl,cl,lc}='c;l'
alias {e,ech,eho}=echo
alias {g,gr,gre,Grep,gerp,grpe}=grep
alias pgrpe=pgrep
alias dg='du | g -i'
alias lg='ls | g -i'
alias cp='cp -irv'
alias mv='mv -iv'
alias {mkdir,mkd,mkdr}='mkdir -p'
alias df='df -h'
alias bn=basename
alias date="command date '+%a %b %d - %I:%M %p'"
alias dmegs=dmesg
alias h='head -n 15'
alias t='tail -n 15'
alias tf='tail -f'
alias ex=export
alias cx='chmod +x'
alias {reboot,restart}='doas reboot'
alias chroot='doas chroot'
alias su='su -'

# common program aliases
alias diff='diff -u'
alias less='less -QRd'
alias {rs,rsync}='rsync -rtvuh --progress --delete --partial' #-c
alias scp='scp -rp'
alias {htpo,hto,ht,hpot,hotp}='htop'
alias {hm,hme}='htop -u ${USER}'
alias {hr,hroot}='htop -u root'
alias nf=neofetch
alias feh='feh -q -N -x -X -s -Z --scale-down --title feh'
alias w=which
alias py=python3.7
alias dm='dmesg | tail -n 20'

dl() { curl -q -L -C - -# --url "$1" --output "$(basename "$1")" ; }
alias wget=dl

# weather
alias weather='curl -s wttr.in/madison,sd?u0TQ'
alias forecast='curl -s http://wttr.in/madison,sd?u | \
   tail -n 33 | sed $\ d | sed $\ d'

alias jpg='find . -type f -name "*.jp*" -exec jpegoptim -s {} \;'

mkcd() { mkd "$_" && cd "$_" ; }
mvcd() { mv "$1" "$2" && cd "$2" ; }
cpcd() { cp "$1" "$2" && cd "$2" ; }

du() { 
    [ "$1" ] || set .
    command du -ahLd 1 "$1" | sort -rh | head -n 30 2>/dev/null
}

# file searching
f() { 
    case $# in
        1) set . "$@" ;;
        0) read inp && set . "$inp"
    esac

    find "$1" ! -path "$1" -iname "*$2*" ; 
}

# openbsd
alias sg='sysctl | grep -i'
alias disks='sysctl -n hw.disknames'
alias poweroff='doas halt -p'

# make
alias {make,mak,mk}="make -j${NPROC:-1}"
alias {makec,makc,mkc}='make clean'
alias {makei,maki,mki}='make install'
alias {makeu,maku,mku}='make uninstall'

unalias r
r() { ranger "$@" ; c ; }

# quick fix ps1 if bugged out
ps1() { export PS1='% ' ; }

# search history for command: "history grep", no its not mercurial.
hg() { [ "$1" ] && grep -i "$*" $HISTFILE | grep -v '^hg' | head -n 20 ; }

ext() { e "${1##*.}" ; }
filename() { e "${1%.*}" ; }
cheat() { curl -s cheat.sh/$1 ; }

reload() {
    . ~/src/dots/kshrc
    xrdb load ~/src/dots/Xresources
    xmodmap ~/src/dots/Xmodmap
    xset m 0 0 
    xset b off 
    xset +fp ~/.fonts
    xset fp rehash
    fc-cache
    if pgrep -x sxhkd >/dev/null ; then
        pkill -x sxhkd
        sxhkd -c ~/src/dots/sxhkdrc &
    fi
} >/dev/null 2>&1

w3m() {
    [ "$1" ] || set https://ddg.gg/lite
    command w3m -F "$@"
}

v() { 
    if [ "$1" ] ; then
        if [ -f "$1" ] ; then
            command nvim "$1"
        else
            for i in $(jot 5) ; do
                f="$(find . -type f -iname *"$@"* -maxdepth $i | head -n 1)"
                if [ -f "$f" ] ; then
                    command nvim "$f"
                    break
                fi
            done
        fi
    else
        command nvim -c VimwikiIndex
    fi
}
alias {V,vim,nvim}=v

mpv() { 
    [ $# -eq 0 ] && return 1

    # kill any currently running mpv before launching a new
    if pgrep xwinwrap >/dev/null ; then
        # kill all mpv except the one with the mpvbg pid
        # as not to kill our desktop background! see ~/bin/mpv/mpvbg for details
        kill $(pgrep -a mpv | grep -v mpvbg | awk '{print $1}')
    else
        pkill mpv
    fi >/dev/null 2>&1

    command mpv --title=mpv "$@"
}

ytdl() { 
    for i ; do
        youtube-dl -c -R 50 --geo-bypass --prefer-ffmpeg "$i"
    done
}
ytdlm() { 
    for i ; do
        youtube-dl -c -R 50 --geo-bypass --prefer-ffmpeg --extract-audio \
            --audio-quality 0 --audio-format mp3 --no-playlist "$i"
    done
}
ytdlpm() { 
    for i ; do
        youtube-dl -c -R 50 --geo-bypass --prefer-ffmpeg --extract-audio \
            --audio-quality 0 --audio-format mp3 "$i"
    done
}

alias getres='ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0'

# imagemagick
resize_75() { mogrify -resize '75%X75%' "$@" ; }
resize_50() { mogrify -resize '50%X50%' "$@" ; }
resize_25() { mogrify -resize '25%X25%' "$@" ; }
rotate_90() { convert -rotate 90 "$1" "$1" ; }
transparent() {
    #turns a PNG white background -> transparent
    convert "$1" -transparent white "${1%.*}"_transparent.png
}
png2jpg() {
    for i ; do
        [ -f "$i" ] || continue
        convert "$i" "${i%png}"jpg || exit 1
        jpegoptim -s "${i%png}"jpg || exit 1
        rm "$1"
    done
}

# translate-shell
trans() {
    [ $# -eq 0 ] && read inp && set "$inp"
    command trans -no-auto -b "$@"
}
rtrans() {
    [ $# -eq 0 ] && read inp && set "$inp"
    # note: $1 needs to be language code, ex: 'de'
    command trans -from en -to "$@"
}
rde() {
    [ $# -eq 0 ] && read inp && set "$inp"
    rtrans de "$*"
}

# ----------------- movement commands -----------------------
alias {..,cd..}='cd ..'
alias ...='.. ; ..'
alias ....='.. ; ...'

# directory marking
# usage: 'm1' = mark 1
#        'g1' = return to m1
for i in 1 2 3 4 5 6 7 8 9 ; do
    eval "m${i}() { export _MARK${i}=\$PWD ; }"
    eval "g${i}() { cd \$_MARK${i} ; }"
done

_g() { _a=$1 ; shift ; cd $_a/"$*" ; ls ; }

alias gB="_g /bin"
alias gT="_g /tmp"
alias gM='_g /mnt'

alias gb="_g ~/bin"
alias ge="_g ~/env"
alias gt="_g ~/tmp"
alias gs="_g ~/src"
alias gf="_g ~/files"
alias gi="_g ~/images"
alias gm="_g ~/music"
alias gv="_g ~/videos"
alias gd="_g ~/Downloads"
alias gcf='_g ~/src/dots/config'
alias g_='_g ~/.trash'
alias gyt='_g ~/videos/youtube/completed'
alias gW='_g ~/images/wallpapers'

mT() { mv "$@" /tmp  ; }
YT() { cp "$@" /tmp  ; }

Yf() { cp "$@" ~/files     ; }
Yd() { cp "$@" ~/Downloads ; }
Yi() { cp "$@" ~/images    ; }
Ym() { cp "$@" ~/music     ; }
Ys() { cp "$@" ~/src       ; }
Yvi(){ cp "$@" ~/videos    ; }
Yb() { cp "$@" ~/bin ; }
Yt() { cp "$@" ~/tmp ; }
Ye() { cp "$@" ~/env ; }
Y_() { cp "$@" ~/.trash ; }

mf() { mv "$@" ~/files     ; }
md() { mv "$@" ~/Downloads ; }
mi() { mv "$@" ~/images    ; }
mm() { mv "$@" ~/music     ; }
ms() { mv "$@" ~/src       ; }
mvi(){ mv "$@" ~/videos    ; }
mb() { mv "$@" ~/bin ; }
me() { mv "$@" ~/env ; }
mt() { mv "$@" ~/tmp ; }
m_() { mv "$@" ~/.trash ; }
alias trash=m_

alias profile='v ~/src/dots/profile'
alias {vssh,sshv}='v ~/.ssh/config'

alias vimrc="v ~/src/dots/vimrc"
alias kshrc="v ~/src/dots/kshrc"
# ----------- end movement commands ------------------

# skeletons
helloc() {
cat > hello.c << EOF
#include <stdio.h>
int main() {
    printf("%s\n", "hi");
    return 0;
}
EOF
}
hellosh() {
    [ $# -eq 0 ] && set hello.sh
cat > $1 << EOF
#!/bin/sh
main() {
    printf "%s\n" "hi"
}
main "$@"
EOF
chmod +x hello.sh
}

gud() {
    # activate my PS1 git branch detection after
    # git commands
    command gud "$@" ; cd .
}

alias {repomc,reocmp,reomcp,recopm,recmop,recpom}=recomp

findgrep() {
    find . -type f | while read -r file ; do
        grep -- "$*" "$file" >/dev/null && echo $file
    done
}

# adds a magnet link to torrent-queue
addtorrent() { echo "$*" | sed 's|udp.*|udp|' >> ~/.torrents/queue ; }

alias torrent="aria2c -d ${HOME}/Downloads --file-allocation=falloc \
    --check-integrity=true --continue=true --seed-time=0"

cover() { curl -q "$1" -o cover.jpg ; }
band()  { curl -q "$1" -o band.jpg  ; }
logo()  { curl -q "$1" -o logo.jpg  ; }

addyt() { echo "$1" >>${HOME}/videos/youtube/.queue ; }

sxiv() {
    [ "$1" ] || set .
    command sxiv -t "$1"
}

ping() {
    [ "$1" ] || set eff.org
    command ping -L -n -s 1 -w 2 $@
}
pingpi() { ping $(grep -A 1 'Host pi' .ssh/config | grep -oE '[0-9]+.*') ; }
pingd() { ping $(dns) ; }

alias cv='curl -v'
alias cvd='curl -v dns.watch'

# ----- old stuff I rarely use but still want to keep:------
# rgb2hex() { printf "#%02x%02x%02x\n" "$@" ; }
# alias heart='printf "%b\n" "\xe2\x9d\xa4"'
# alias click='xdotool click 1'
#
## Hack!
# echossh() {
#     if [ $# -lt 3 ] ; then
#         >&2 echo 'usage: echossh user@host file $@'
#         return 1
#     else
#         local user_at_host="$1"
#         local file="$2"
#         shift 2
#         echo "$@" | ssh "$user_at_host" \
#             sh -c "cat /dev/stdin >> $file"
#     fi
# }
