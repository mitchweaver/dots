#!/bin/ksh
#
# http://github.com/mitchweaver/dots
#
# This thing is a mess... But I try to keep the beast at bay.
#
# Check out http://github.com/mitchweaver/bin for where
# more complicated stuff gets moved when it grows too unruly.
#
#  #             #
#  #   m   mmm   # mm    m mm   mmm
#  # m"   #   "  #"  #   #"  " #"  "
#  #"#     """m  #   #   #     #
#  #  "m  "mmm"  #   #   #     "#mm"
#

ulimit -c 0

set -o bgnice
set -o trackall
set -o csh-history
set -o vi

export HISTFILE=${HOME}/.cache/.ksh_history \
       HISTCONTROL=ignoreboth \
       HISTSIZE=500 \
       SAVEHIST=500

cd() { 
    if [ "$1" ] ; then
        builtin cd --  "$1"  ||
        builtin cd --  "$1"* ||
        builtin cd -- *"$1"  ||
        builtin cd -- *"$1"* ||
        ls | grep -- "$1"
    else
        builtin cd
    fi 2>/dev/null
    if [ "$RANGER_LEVEL" ] ; then
        export PS1="[ranger: $(_get_PS1)] "
    else
        export PS1="$(_get_PS1)"
    fi
}

# get which git branch we're on, used in our PS1
_parse_branch() { 
    set -- $(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>/dev/null)
    [ "$1" ] && echo -n " ($*)"
}

_get_PS1() {
    case "$TERM" in
        dumb)
            echo '% '
            ;;
        *)
            case ${USER} in
                mitch) echo -n "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W$(_parse_branch)\[\e[1;37m\] " ;;
                root)  echo -n "\[\e[1;37m\]root \W " ;;
                *)     echo -n '% \W '
            esac
    esac
}

# check if we're in ranger
[ "$RANGER_LEVEL" ] && clear

# this activates our PS1
cd .

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# begin generic aliases
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# hack!
alias a=alias

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

case "$TERM" in
    dumb) a ls='ls -F' ;;
       *) ls() { exa -F "$@" 2>/dev/null || command ls -F "$@" ; }
esac

# generic aliases
a {cc,cll,clear,clar,clea,clera}=clear
a {x,xx,xxx,q,qq,qqq,:q,:Q,:wq,:w,exi,ex}=exit
a {l,sls,sl}=ls
a {ll,lll}='l -l'
a la='l -a'
a {lla,lal}='l -al'
a lsf='l "$PWD"/*'
a {cls,csl,cl,lc}='c;l'
a {e,ech,eho}=echo
a {g,gr,gre,Grep,gerp,grpe}=grep
a pgrpe=pgrep
a dg='d | g -i'
a lg='ls | g -i'
a cp='cp -irv'
a mv='mv -iv'
a {mkdir,mkd,mkdr}='mkdir -p'
a df='df -h'
a bn=basename
a date="command date '+%a %b %d - %I:%M %p'"
a dmegs=dmesg
a h='head -n 15'
a t='tail -n 15'
a tf='tail -f'
a ex=export
a cx='chmod +x'
a {reboot,restart}='doas reboot'
a chroot='doas chroot'
a su='su -'
a h1='head -n 1'
a t1='tail -n 1'
a cmd=command
a pk='pkill -x'
a pg='pgrep -x'

# common program aliases
a diff='diff -u'
a less='less -QRd'
a {rs,rsync}='rsync -rtvuh --progress --delete --partial' #-c
a scp='scp -rp'
a hme='htop -u ${USER}'
a hroot='htop -u root'
a w=which
a py=python3.7
a dm='dmesg | tail -n 20'
a {feh,mpv}=opn
a branch='git branch'
a click='xdotool click 1'

dl() { curl -q -L -C - -# --url "$1" --output "$(basename "$1")" ; }
a wget=dl

# weather
a weather='curl -s wttr.in/madison,sd?u0TQ'
a forecast='curl -s http://wttr.in/madison,sd?u | \
   tail -n 33 | sed $\ d | sed $\ d'

a jpg='find . -type f -name "*.jp*" -exec jpegoptim -s {} \;'

mkcd() { mkd "$_" && cd "$_" ; }
mvcd() { mv "$1" "$2" && cd "$2" ; }
cpcd() { cp "$1" "$2" && cd "$2" ; }

# openbsd
a sg='sysctl | grep -i'
a disks='sysctl -n hw.disknames'
a poweroff='doas halt -p'
a net='doas sh /etc/netstart $(interface)'
a games='export PATH="/usr/games:$PATH"; echo "/usr/games added to your \$PATH"'

# make
a {make,mak,mk}="make -j${NPROC:-1}"
a {makec,makc,mkc}='make clean'
a {makei,maki,mki}='make install'
a {makeu,maku,mku}='make uninstall'

unalias r
r() { ranger "$@" ; c ; }

# quick fix ps1 if bugged out
ps1() { export PS1='% ' ; }

# search history for command: "history grep", no its not mercurial.
hg() { [ "$1" ] && grep -i "$*" $HISTFILE | grep -v '^hg' | head -n 20 ; }

cheat() { curl -s cheat.sh/$1 ; }

reload() {
    cd
    . ~/src/dots/kshrc
    xrdb load ~/src/dots/Xresources
    xmodmap ~/src/dots/Xmodmap
    xset m 0 0 
    xset b off 
    rm -f ~/.cache/font-config/*.cache*
    find ~/files/fonts -type f -name fonts.dir | while read -r dir ; do
        xset +fp "${dir%/*}"
    done
    xset fp rehash
    fc-cache
} >/dev/null 2>&1

w3m() {
    [ "$1" ] || set https://duckduckgo.com/lite
    command w3m -F "$@"
}
a wdump='w3m -dump'

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

a getres='ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0'

rgb2hex() { printf "#%02x%02x%02x\n" "$@" ; }

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
a trans='trans -no-auto -b "$@"'
# note: $1 needs to be language code, ex: 'de'
a rtrans='command trans -from en -to'
a rde='rtrans de'

# ----------------- movement commands -----------------------
a {..,cd..}='cd ..'
a ...='.. ; ..'
a ....='.. ; ...'

# directory marking
# usage: 'm1' = mark 1
#        'g1' = return to m1
for i in 1 2 3 4 5 6 7 8 9 ; do
    eval "m${i}() { export _MARK${i}=\$PWD ; }"
    eval "g${i}() { cd \$_MARK${i} ; }"
done

_g() { _a=$1 ; shift ; cd $_a/"$*" ; ls ; }

a gB="_g /bin"
a gT="_g /tmp"
a gM='_g /mnt'

a gb="_g ~/bin"
a ge="_g ~/env"
a gt="_g ~/tmp"
a gs="_g ~/src"
a gf="_g ~/files"
a gi="_g ~/images"
a gm="_g ~/music"
a gv="_g ~/videos"
a gd="_g ~/Downloads"
a gcf='_g ~/src/dots/config'
a g_='_g ~/.trash'
a gyt='_g ~/videos/youtube/completed'
a gW='_g ~/images/wallpapers'
a gV='_g /var'
a gE='_g /etc'
a gss='_g ~/src/suckless'
a gssd='_g ~/src/suckless/dwm'

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
mW() { mv "$@" ~/images/wallpapers ; }
a trash=m_

a lD='ls ~/Downloads'
a lt='ls ~/tmp'
a lT='ls /tmp'
a l_='ls ~/.trash'

a profile='v ~/src/dots/profile'
a {vssh,sshv}='v ~/.ssh/config'

a vimrc="v ~/src/dots/nvim/nvimrc"
a kshrc="v ~/src/dots/kshrc"
# ----------- end movement commands ------------------

gud() {
    # activate my PS1 git branch detection after
    # git commands
    command gud "$@" ; cd .
}

recomp() { ~/src/suckless/build.sh "$@" ; }
a rcp=recomp

cover() { curl -q "$1" -o cover.jpg ; }
band()  { curl -q "$1" -o band.jpg  ; }
logo()  { curl -q "$1" -o logo.jpg  ; }

addyt() { ytdl-queue -a "$1" ; }
addtorrent() { torrent-queue -a "$1" ; }

sxiv() {
    [ "$1" ] || set .
    command sxiv -t "$1"
}

# net testing
ping() {
    [ "$1" ] || set eff.org
    command ping -L -n -s 1 -w 2 $@
}
pingd() { ping $(dns) ; }
pingpi() { ping $(grep -A 1 'Host pi' .ssh/config | grep -oE '[0-9]+.*') ; }
a p=ping
a pd=pingd
a pp=pingpi
a p8='ping 8.8.8.8'
a cv='curl -v'
a cvd='curl -v dns.watch'
a cvg='curl -v google.com'

cw() { [ "$1" ] && cat "$(which "$1")" ; }

a cmptn='pgrep -x compton ; compton --config ${HOME}/src/dots/compton.conf -b'

a heart='printf "%b\n" "\xe2\x9d\xa4"'

a hw='n -f ~/files/hw.txt'

bkm() {
    if [ "$1" ] ; then
        echo "$*" >>~/files/bkm.txt
    else
        $EDITOR ~/files/bkm.txt
    fi
}

ps() {
    [ "$1" ] || set -- -Auxww
    cmd ps "$@"
}
psg() { ps | g "$*" | g -v "grep $*" ; }
