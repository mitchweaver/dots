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
set -o vi
set -o csh-history
set -o bgnice
set -o trackall
set -o ignoreeof

# save hist file per shell, deleting on close
export HISTFILE=${XDG_CACHE_HOME:-~/.cache}/.shell_history-$$ \
       HISTCONTROL=ignoredups:ignorespace \
       HISTSIZE=300

trap '/bin/rm "$HISTFILE" 2>/dev/null' EXIT TERM KILL QUIT

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# PS1
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
get_PS1() {
    # --------------------------------------------------------
    # settings:
    # PS1_STYLE=username
    PS1_STYLE=pwd
    # --------------------------------------------------------
    if [ $TERM = st-256color ] ; then
        case $PS1_STYLE in
            pwd)
                printf '%s' "\[\e[1;36m\]\W "
                ;;
            username)
                # print username in color palette, one color per character
                code=1
                printf '%s\n' "$USER" | fold -w 1 | while read -r c ; do
                    printf '%s' "\[\e[1;3${code}m\]$c"
                    code=$(( $code + 1 ))
                done
                printf '%s' "\[\e[1;3$(( ${#USER} + 1 ))m\] \W \[\e[1;3$(( ${#USER} + 2 ))m\]"
        esac

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
# fuzzy finding cat
cat() { 
    [ "$1" = -- ] && shift
    if [ "$1" ] ; then
        /bin/cat --  "$1"  ||
        /bin/cat --  "$1"* ||
        /bin/cat -- *"$1"  ||
        /bin/cat -- *"$1"*
    fi 2>/dev/null
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
    if [ -z "$1" ] ; then
        clear
    elif [ -d "$1" ] ; then
        cd "$1"
    else
        cat "$1" || cd "$1"
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
               alias {lt,tree}='exa -F -T'
           else
               alias ls='ls -F'
           fi
esac

# generic aliases
alias {cc,cll,clear,claer,clar,clea,clera}=clear
alias {x,xx,xxx,q,qq,qqq,:q,:Q,:wq,:w,exi,ex}=exit
alias {l,sls,sl}=ls
alias {ll,lll}='l -l'
alias la='l -a'
alias {lla,lal}='l -al'
alias {l1,lv}='ls -1'
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

# dump contents of a file in $PATH
cw() { cat "$(which "${1:-?}")" ; }

# search for running process
psg() { ps -Auxww | grep -i "$*" | grep -v "grep $*" ; }

# grab urls of any running processes
psurls() { ps -Auxww | urls ; }

# search shell history
hg() {
    [ "$1" ] || exit 1
    grep -i "$*" "$HISTFILE" | grep -v '^hg' | head -n 20
}

# search for a font name
fcg() { fc-list | sed 's|.*: ||g' | grep -i "$*" ; }

unalias r 2>/dev/null
r() { ranger "$@" ; clear ; }

alias mpv="mpv $MPV_OPTS"
alias mupdf="mupdf $MUPDF_OPTS"
alias ytdl="youtube-dl $YTDL_OPTS"

b() { [ "$1" ] && brws "$*" >/dev/null 2>&1 & }

alias hme='htop -u mitch'
alias hrt='htop -u root'

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
rotate_90() { convert -rotate 90 "$1" "$1"   ; }
mog_1080()  { mogrify -resize '1920X1080' "$@" ; }
transparent() {
    #turn a PNG white background -> transparent
    convert "$1" -transparent white "${1%.*}"_transparent.png
}
png2jpg() {
    for i ; do
        [ -f "$i" ] || continue
        convert "$i" "${i%png}"jpg || exit 1
        jpegoptim -s "${i%png}"jpg || exit 1
        /bin/rm "$1"
    done
}
alias jpg='find . -type f -iname "*.jp*" -exec jpegoptim -s {} \;'
cover() { curl -q -# -L "$1" -o cover.jpg ; }
band()  { curl -q -# -L "$1" -o band.jpg  ; }
logo()  { curl -q -# -L "$1" -o logo.jpg  ; }

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# translate-shell
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
trans() { command trans -no-auto -b "$*" 2>/dev/null ; }
rtrans() { c=$1 ; shift ; command trans -from en -to $c "$*" 2>/dev/null ; }
rde() { rtrans de "$*" ; }
rja() { rtrans ja "$*" ; }

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
alias gk="_g ~/bks"
alias gE='_g /etc'
alias gM='_g /mnt'
alias gT="_g /tmp"
alias gV='_g /var'
alias gss='_g ~/src/suckless'
alias gsd='_g ~/src/dots'
alias gcf='_g ~/.config'
alias gch='_g ~/.cache'

Yf() { cp "$@" $XDG_DOCUMENTS_DIR ; }
Yi() { cp "$@" $XDG_PICTURES_DIR ; }
Ym() { cp "$@" $XDG_MUSIC_DIR ; }
Yvi(){ cp "$@" $XDG_VIDEOS_DIR ; }
Yb() { cp "$@" ~/bin ; }
Yk() { cp "$@" ~/bks ; }
Ys() { cp "$@" ~/src ; }
YT() { cp "$@" /tmp ; }

mf() { mv "$@" $XDG_DOCUMENTS_DIR ; }
mi() { mv "$@" $XDG_PICTURES_DIR ; }
mm() { mv "$@" $XDG_MUSIC_DIR ; }
mvi(){ mv "$@" $XDG_VIDEOS_DIR ; }
mW() { mv "$@" $XDG_PICTURES_DIR/wallpapers ; }
mb() { mv "$@" ~/bin ; }
mk() { mv "$@" ~/bks ; }
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
# development (warning: may conflict with plan9 mk)
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias mk="make -j${NPROC:-1}"
alias mkc='make clean'
alias mki='make install'
alias mku='make uninstall'
alias mks='make -s install'
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
alias links="n -f $XDG_DOCUMENTS_DIR/links.txt"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# networking
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
alias rsync='rsync -rtvuh --progress --delete --partial' #-z
alias scp='scp -rp'

alias traffic='netstat -w 1 -b'
alias dumpall="doas tcpdump -n -i iwn0"
alias dumpweb="doas tcpdump -n -i iwn0 port 80 or port 443 or port 53"
alias dumphttp="doas tcpdump -n -i iwn0 port 80 or port 443"
alias dumpdns="doas tcpdump -n -i iwn0 port 53"
alias dumpssh="doas tcpdump -n -i iwn0 port 22"

ping() { command ping -L -n -s 1 -w 2 "${1:-eff.org}" ; }
pingpi() { ping $(grep -A 1 'Host pi' ~/.ssh/config | grep -oE '[0-9]+.*') ; }
alias p=ping
alias pp=pingpi
alias p8='ping 8.8.8.8'
alias cv='curl -v'
alias cvip='curl -v wtfismyip.com/text'

w3m() {
    command w3m -F -s -graph -no-mouse \
        "${@:-https://duckduckgo.com/lite}"
}
wddg() { w3m https://duckduckgo.com/lite/?q="$*" ; }
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
alias reboot='doas reboot'
alias net='doas sh /etc/netstart'

# pf logging
alias pfdump='doas tcpdump -n -e -ttt -r /var/log/pflog' # dump all to stdout
alias pfdrop='doas tcpdump -nettti pflog0 action drop'   # follow dropped

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# unsorted junk below
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

alias heart='printf "%b\n" "\xe2\x9d\xa4"'
cheat() { curl -s cheat.sh/$1 ; }

pdf2txt() {
    mutool draw -F txt -i -- "$1" 2>/dev/null |
        sed 's/[^[:print:]]//g' | tr -s '[:blank:]'
}

alias shrug="printf '%s\n' '¯\\_(ツ)_/¯' | tee /dev/tty | clip -i"
alias tm="printf '%s\n' '™'"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# pi stuff
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*#
# pi_ip() { grep -A 1 'Host pi' ~/.ssh/config | grep -oE '[0-9]+.*' ; }
# pi_port() {
#     grep -A 3 'Host pi' /home/mitch/.ssh/config  | \
#         awk '{print $2}' | tail -n 1
# }
# allow ssh to my piNAS while under vpn
pi_route() {
    doas route add 192.168.1.122 192.168.1.1
    # set -- $(route -n show -inet -gateway | grep default | awk '{print $2}')
    # gate=$1
    # doas route delete $(pi_ip)/24 >/dev/null
    # doas route add $(pi_ip)/24 $gate
}
# mount_sshfs_pi() {
#     doas sshfs -o allow_other,IdentityFile=${HOME}/.ssh/id_rsa \
#         banana@$(pi_ip):/mnt /mnt/pi -p $(pi_port) -C
# }
