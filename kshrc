#
#  █             █
#  █   ▄   ▄▄▄   █ ▄▄    ▄ ▄▄   ▄▄▄
#  █ ▄▀   █   ▀  █▀  █   █▀  ▀ █▀  ▀
#  █▀█     ▀▀▀▄  █   █   █     █
#  █  ▀▄  ▀▄▄▄▀  █   █   █     ▀█▄▄▀
#
#  http://github.com/mitchweaver/dots
#
#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# shell options
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
set -o vi csh-history bgnice trackall ignoreeof

# save hist file per shell, deleting on close
export HISTFILE=${XDG_CACHE_HOME:-~/.cache}/.shell_history-$$ \
       HISTCONTROL=ignoredups:ignorespace \
       HISTSIZE=300

trap 'rm "$HISTFILE"' EXIT TERM KILL QUIT HUP

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# PS1
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
get_PS1() {
    if [ $TERM = st-256color ] ; then
        # print username in color palette, one color per character
        code=1
        printf '%s\n' "$USER" | fold -w 1 | while read -r c ; do
            printf '%s' "\[\e[1;3${code}m\]$c"
            code=$(( $code + 1 ))
        done
        printf '%s' "\[\e[1;3$(( ${#USER} + 1 ))m\] \W \[\e[1;3$(( ${#USER} + 2 ))m\]"

        # print git repo name in parenthesis, if we're inside one
        set -- $(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>/dev/null)
        [ "$1" ] && printf '(%s) ' "$1"

        # clear formatting
        printf '%s' '\[\e[1;37m\]'
    else
        echo '% '
    fi
}

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
        export PS1="[ranger: $(get_PS1)] "
    else
        export PS1="$(get_PS1)"
    fi
}

# check if we're in ranger
[ "$RANGER_LEVEL" ] && clear

# this activates our PS1
cd .

# quick fix ps1 if bugged out
alias ps1='export PS1="% "'

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

# ls
case "$TERM" in
        dumb)
            alias ls='ls -F'
            export NO_COLOR=true
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
alias tf='tail -f'
alias cx='chmod +x'
alias su='su -'
alias h='head -n 15'
alias t='tail -n 15'
alias h1='head -n 1'
alias t1='tail -n 1'
alias cmd=command
alias pk=pkill
alias w=which
alias py=python3.7
alias dm='dmesg | tail -n 20'

mkcd() { mkd "$_" && cd "$_" ; }
mvcd() { mv "$1" "$2" && cd "$2" ; }
cpcd() { cp "$1" "$2" && cd "$2" ; }
cw() { [ "$1" ] && cat "$(which "$1")" ; }
ps() {
    [ "$1" ] || set -- -Auxww
    cmd ps "$@"
}
psg() { ps | g "$*" | g -v "grep $*" ; }
hg() { [ "$1" ] && grep -i "$*" "$HISTFILE" | grep -v '^hg' | head -n 20 ; }
fcg() { fc-list | sed 's|.*: ||g' | grep -i "$*" ; }

unalias r 2>/dev/null
r() { ranger "$@" ; c ; }
mpv()   { command mpv   $MPV_OPTS   "$@" ; }
mupdf() { command mupdf $MUPDF_OPTS "$@" ; }

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# youtube-dl / ffmpeg
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
addyt() { ytdlq -a "$1" ; }
tfyt() { tf ~/vid/youtube/ytdlq-*.log ; }
alias res='ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0'

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# imagemagick
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
resize_75() { mogrify -resize '75%X75%' "$@" ; }
resize_50() { mogrify -resize '50%X50%' "$@" ; }
resize_25() { mogrify -resize '25%X25%' "$@" ; }
rotate_90() { convert -rotate 90 "$1" "$1" ; }
transparent() {
    #turn a PNG white background -> transparent
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
alias jpg='find . -type f -iname "*.jp*" -exec jpegoptim -s {} \;'
cover() { curl -q -# -L "$1" -o cover.jpg ; }
band()  { curl -q -# -L "$1" -o band.jpg  ; }
logo()  { curl -q -# -L "$1" -o logo.jpg  ; }

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# translate-shell
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias trans='trans -no-auto -b'
alias rtrans='command trans -from en -to'
alias rde='rtrans de'
alias rja='rtrans ja'

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# movement commands
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias {..,cd..}='cd ..'
alias ...='.. ; ..'
alias ....='.. ; ...'

_g() { _a=$1 ; shift ; cd $_a/"$*" ; ls ; }

alias gf="_g $XDG_DOCUMENTS_DIR"
alias gi="_g $XDG_PICTURES_DIR"
alias gm="_g $XDG_MUSIC_DIR"
alias gv="_g $XDG_VIDEOS_DIR"
alias gyt='_g $XDG_VIDEOS_DIR/youtube'
alias gytc='_g $XDG_VIDEOS_DIR/youtube/completed'
alias gW='_g $XDG_PICTURES_DIR/wallpapers'
alias gb="_g ~/bin"
alias gs="_g ~/src"
alias gE='_g /etc'
alias gM='_g /mnt'
alias gT="_g /tmp"
alias gV='_g /var'
alias gss='_g ~/src/suckless'
alias gsd='_g ~/src/dots'
alias gcf='_g ~/.config'

Yf() { cp "$@" $XDG_DOCUMENTS_DIR ; }
Yi() { cp "$@" $XDG_PICTURES_DIR ; }
Ym() { cp "$@" $XDG_MUSIC_DIR ; }
Yvi(){ cp "$@" $XDG_VIDEOS_DIR ; }
Yb() { cp "$@" ~/bin ; }
Ys() { cp "$@" ~/src ; }
YT() { cp "$@" /tmp ; }

mf() { mv "$@" $XDG_DOCUMENTS_DIR ; }
mi() { mv "$@" $XDG_PICTURES_DIR ; }
mm() { mv "$@" $XDG_MUSIC_DIR ; }
mvi(){ mv "$@" $XDG_VIDEOS_DIR ; }
mW() { mv "$@" $XDG_PICTURES_DIR/wallpapers ; }
mb() { mv "$@" ~/bin ; }
ms() { mv "$@" ~/src ; }
mT() { mv "$@" /tmp  ; }

# directory marking
# usage: 'm1' = mark 1
#        'g1' = return to m1
for i in 1 2 3 4 5 6 7 8 9 ; do
    eval "m${i}() { export _MARK${i}=\$PWD ; }"
    eval "g${i}() { cd \$_MARK${i} ; }"
done

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# development
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias {make,mak,mk}="make -j${NPROC:-1}"
alias {makec,makc,mkc}='make clean'
alias {makei,maki,mki}='make install'
alias {makeu,maku,mku}='make uninstall'
alias {recomp,rcp}=~/src/suckless/build.sh
gud() {
    # activate my PS1 git branch detection after git commands
    command gud "$@" ; cd .
}

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# notes
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias hw="n -f $XDG_DOCUMENTS_DIR/hw.txt"
alias words="n -f $XDG_DOCUMENTS_DIR/words.txt"
alias bkm="n -f $XDG_DOCUMENTS_DIR/bkm.txt"
alias shows="n -f $XDG_DOCUMENTS_DIR/shows.txt"
alias movies="n -f $XDG_DOCUMENTS_DIR/movies.txt"
alias anime="n -f $XDG_DOCUMENTS_DIR/anime.txt"
alias games="n -f $XDG_DOCUMENTS_DIR/games.txt"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# networking
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias rsync='rsync -rtvuh --progress --delete --partial'
alias scp='scp -rp'
dl() { curl -q -L -C - -# --url "$1" --output "$(basename "$1")" ; }

alias traffic='netstat -w 1 -b -I iwn0'
alias dumpall="doas tcpdump -n -i iwn0"
alias dumpweb="doas tcpdump -n -i iwn0 port 80 or port 443 or port 53"
alias dumphttp="doas tcpdump -n -i iwn0 port 80 or port 443"
alias dumpdns="doas tcpdump -n -i iwn0 port 53"
alias dumpssh="doas tcpdump -n -i iwn0 port 22"

ping() {
    [ "$1" ] || set eff.org
    command ping -L -n -s 1 -w 2 $@
}
pingpi() { ping $(grep -A 1 'Host pi' ~/.ssh/config | grep -oE '[0-9]+.*') ; }
alias p=ping
alias pp=pingpi
alias p8='ping 8.8.8.8'
alias cv='curl -v'

# allow ssh to my piNAS while under vpn
pi_route() {
    ip=$(grep -A 1 'Host pi' .ssh/config | grep -oE '[0-9]+.*')
    gate=$(route -n show -inet -gateway | grep default | awk '{print $2}')
    doas route delete $ip/24 >/dev/null
    doas route add $ip/24 $gate
}

w3m() {
    [ "$1" ] || set -- https://duckduckgo.com/lite
    command w3m -F -s -graph -no-mouse -o auto_image=FALSE "$@"
}
ddg() { w3m https://duckduckgo.com/lite/?q="$*" ; }
alias wdump='w3m -dump'

# weather
alias weather='curl -s wttr.in/madison,sd?u0TQ'
alias forecast='curl -s wttr.in/madison,sd?u | tail -n 33 | head -n 31'

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# openbsd specific
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias sg='sysctl | grep -i'
alias disks='sysctl -n hw.disknames'
alias disklabel='doas disklabel'
alias poweroff='doas shutdown'
alias reboot='doas reboot'
alias net='doas sh /etc/netstart $(interface)'

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# unsorted junk below
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

alias heart='printf "%b\n" "\xe2\x9d\xa4"'
cheat() { curl -s cheat.sh/$1 ; }

pdf2txt() {
    mutool draw -F txt -i -- "$1" 2>/dev/null | tr -s '[:blank:]' | less
}
