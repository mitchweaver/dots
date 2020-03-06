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

set -o bgnice
set -o trackall
set -o csh-history
set -o vi

export HISTFILE=~/.cache/.ksh_history \
       HISTCONTROL=ignoreboth \
       HISTSIZE=500 \
       SAVEHIST=500

# fuzzy finding cd
cd() { 
    if [ "$1" ] ; then
        builtin cd --  "$1"  ||
        builtin cd --  "$1"* ||
        builtin cd -- *"$1"  ||
        builtin cd -- *"$1"* ||
        builtin cd -- "$(find . -type d -maxdepth 1 \
                            -iname "*$1*" | head -n 1)"
    else
        builtin cd
    fi 2>/dev/null
    if [ "$RANGER_LEVEL" ] ; then
        export PS1="[ranger: $(PS1)] "
    else
        export PS1="$(PS1)"
    fi
}

PS1() {
    case $TERM in
        *256color)
            code=1
            printf '%s\n' "$USER" | fold -w 1 | while read -r c ; do
                printf '%s' "\[\e[1;3${code}m\]$c"
                code=$(( $code + 1 ))
            done
            printf '%s' "\[\e[1;3$(( ${#USER} + 1 ))m\] \W \[\e[1;3$(( ${#USER} + 2 ))m\]"
            set -- $(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>/dev/null)
            [ "$1" ] && printf '(%s) ' "$1"
            printf '%s' '\[\e[1;37m\]' # clear formatting
            ;;
        *)
            printf '%s' '% '
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
    if [ -f "$1" ] ; then
        cat -- "$1"
    elif [ "$1" ] ; then
        cd "$1"
    else
        clear
    fi
}

case "$TERM" in
    dumb)
        alias ls='ls -F'
        ;;
       *)
           if type exa >/dev/null ; then
               alias ls='exa -F --group-directories-first'
               alias tree='exa -F -T'
           else
               alias ls='ls -F'
           fi
esac

# generic aliases
alias {cc,cll,clear,clar,clea,clera}=clear
alias {x,xx,xxx,q,qq,qqq,:q,:Q,:wq,:w,exi,ex}=exit
alias {l,sls,sl}=ls
alias {ll,lll}='l -l'
alias la='l -a'
alias {lla,lal}='l -al'
alias lsf='l "$PWD"/*'
alias {cls,csl,cl,lc}='c;l'
alias {e,ech,eho}=echo
alias {g,gr,gre,Grep,gerp,grpe}=grep
alias {pg,pgrpe}=pgrep
alias dg='d | g -i'
alias lg='ls | g -i'
alias cp='cp -irv'
alias mv='mv -iv'
alias {mkdir,mkd,mkdr}='mkdir -p'
alias df='df -h'
alias bn=basename
alias dmegs=dmesg
alias h='head -n 15'
alias t='tail -n 15'
alias tf='tail -f'
alias ex=export
alias cx='chmod +x'
alias {reboot,restart}='doas reboot'
alias su='su -'
alias h1='head -n 1'
alias t1='tail -n 1'
alias cmd=command
alias pk='pkill -x'
alias mna=man

# common program aliases
alias diff='diff -u'
alias less='less -QRd'
alias rsync='rsync -rtvuh --progress --delete --partial' #-c
alias scp='scp -rp'
alias w=which
alias py=python3.7
alias dm='dmesg | tail -n 20'
alias branch='git branch'
alias click='xdotool click 1'
alias {feh,mpv}=opn

dl() { curl -q -L -C - -# --url "$1" --output "$(basename "$1")" ; }
alias wget=dl

# weather
alias weather='curl -s wttr.in/madison,sd?u0TQ'
alias forecast='curl -s http://wttr.in/madison,sd?u | \
   tail -n 33 | sed $\ d | sed $\ d'

alias jpg='find . -type f -iname "*.jp*" -exec jpegoptim -s {} \;'

mkcd() { mkd "$_" && cd "$_" ; }
mvcd() { mv "$1" "$2" && cd "$2" ; }
cpcd() { cp "$1" "$2" && cd "$2" ; }

ps() {
    [ "$1" ] || set -- -Auxww
    cmd ps "$@"
}
psg() { ps | g "$*" | g -v "grep $*" ; }

# openbsd
alias sg='sysctl | grep -i'
alias disks='sysctl -n hw.disknames'
alias poweroff='doas halt -p'
alias net='doas sh /etc/netstart $(interface)'

# make
alias {make,mak,mk}="make -j${NPROC:-1}"
alias {makec,makc,mkc}='make clean'
alias {makei,maki,mki}='make install'
alias {makeu,maku,mku}='make uninstall'

# network
alias traffic='netstat -w1 -b -I iwn0'
alias dumpall="doas tcpdump -n -i iwn0"
alias dumpweb="doas tcpdump -n -i iwn0 port 80 or port 443 or port 53"
alias dumphttp="doas tcpdump -n -i iwn0 port 80 or port 443"
alias dumpdns="doas tcpdump -n -i iwn0 port 53"
alias dumpssh="doas tcpdump -n -i iwn0 port 22"
ping() {
    [ "$1" ] || set eff.org
    command ping -L -n -s 1 -w 2 $@
}
pingpi() { ping $(grep -A 1 'Host pi' .ssh/config | grep -oE '[0-9]+.*') ; }
alias p=ping
alias pp=pingpi
alias p8='ping 8.8.8.8'
alias cv='curl -v'

unalias r
r() { ranger "$@" ; c ; }

# quick fix ps1 if bugged out
ps1() { export PS1='% ' ; }

# search history for command: "history grep", no its not mercurial.
hg() { [ "$1" ] && grep -i "$*" $HISTFILE | grep -v '^hg' | head -n 20 ; }

cheat() { curl -s cheat.sh/$1 ; }

w3m() {
    [ "$1" ] || set -- https://duckduckgo.com/lite
    command w3m -F -s -graph -no-mouse -o auto_image=FALSE "$@"
}
ddg() { w3m https://duckduckgo.com/lite/?q="$*" ; }
alias wdump='w3m -dump'

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
alias trans='trans -no-auto -b "$@"'
# note: $1 needs to be language code, ex: 'de'
alias rtrans='command trans -from en -to'
alias rde='rtrans de'

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
alias gt="_g ~/tmp"
alias gs="_g ~/src"
alias gf="_g $XDG_DOCUMENTS_DIR"
alias gi="_g $XDG_PICTURES_DIR"
alias gm="_g $XDG_MUSIC_DIR"
alias gv="_g $XDG_VIDEOS_DIR"
alias gd="_g $XDG_DOWNLOAD_DIR"
alias gcf='_g $DOTS/config'
alias gyt='_g $XDG_VIDEOS_DIR/youtube'
alias gytc='_g $XDG_VIDEOS_DIR/youtube/completed'
alias gW='_g $XDG_PICTURES_DIR/wallpapers'
alias gV='_g /var'
alias gE='_g /etc'
alias gss='_g ~/src/suckless'
alias ge='_g $DOTS'

mT() { mv "$@" /tmp  ; }
YT() { cp "$@" /tmp  ; }

Yf() { cp "$@" $XDG_DOCUMENTS_DIR     ; }
Yd() { cp "$@" $XDG_DOWNLOAD_DIR ; }
Yi() { cp "$@" $XDG_PICTURES_DIR    ; }
Ym() { cp "$@" $XDG_MUSIC_DIR     ; }
Yvi(){ cp "$@" $XDG_VIDEOS_DIR    ; }
Ys() { cp "$@" ~/src       ; }
Yb() { cp "$@" ~/bin ; }
Yt() { cp "$@" ~/tmp ; }

mf() { mv "$@" $XDG_DOCUMENTS_DIR     ; }
md() { mv "$@" $XDG_DOWNLOAD_DIR ; }
mi() { mv "$@" $XDG_PICTURES_DIR    ; }
mm() { mv "$@" $XDG_MUSIC_DIR     ; }
ms() { mv "$@" ~/src       ; }
mvi(){ mv "$@" $XDG_VIDEOS_DIR    ; }
mb() { mv "$@" ~/bin ; }
mt() { mv "$@" ~/tmp ; }
mW() { mv "$@" $XDG_PICTURES_DIR/wallpapers ; }

alias lD='ls $XDG_DOWNLOAD_DIR'
alias lt='ls ~/tmp'
alias lT='ls /tmp'

alias profile='$EDITOR $DOTS/profile'
alias vssh='$EDITOR ~/.ssh/config'

alias vimrc="$EDITOR $DOTS/nvim/nvimrc"
alias kshrc="$EDITOR $DOTS/kshrc"
# ----------- end movement commands ------------------

gud() {
    # activate my PS1 git branch detection after git commands
    command gud "$@" ; cd .
}

recomp() { ~/src/suckless/build.sh "$@" ; }
alias rcp=recomp

cover() { curl -q "$1" -o cover.jpg ; }
band()  { curl -q "$1" -o band.jpg  ; }
logo()  { curl -q "$1" -o logo.jpg  ; }

addyt() { ytdl-queue -a "$1" ; }

cw() { [ "$1" ] && cat "$(which "$1")" ; }

# alias heart='printf "%b\n" "\xe2\x9d\xa4"'

alias hw="n -f $XDG_DOCUMENTS_DIR/hw.txt"
alias words="n -f $XDG_DOCUMENTS_DIR/words.txt"
alias bkm="n -f $XDG_DOCUMENTS_DIR/bkm.txt"
alias shows="n -f $XDG_DOCUMENTS_DIR/shows.txt"
alias movies="n -f $XDG_DOCUMENTS_DIR/movies.txt"
alias anime="n -f $XDG_DOCUMENTS_DIR/anime.txt"
alias games="n -f $XDG_DOCUMENTS_DIR/games.txt"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
