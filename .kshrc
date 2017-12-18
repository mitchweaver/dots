. /etc/profile

# because these core dumps are annoying as hell
# There may be some way to disable them from being created, but i don't know.
(rm -rf /home/mitch/*.core > /dev/null &)

# kill ~/desktop, i hate that firefox makes this on startup
(rm -rf /home/mitch/Desktop > /dev/null &)

# --------------------- PS1 -------------------------------------------------- #
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

get_PS1() {
    # Note: colorizing the git output breaks line wrapping, no idea why...
    # echo "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W $(parse_git_branch)\[\e[1;37m\] "
    echo "\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W$(parse_git_branch)\[\e[1;37m\] "
}

cd(){
    if [ $# -eq 0 ] ; then
        builtin cd ~
    else
        builtin cd "$1"
    fi
    export PS1="$(get_PS1)"
}

export PS1="$(get_PS1)"
# --------------------------------------------------------------------------- #

export PATH=$PATH:/home/mitch/bin
export EDITOR="/bin/nvim"
export BROWSER="/usr/local/bin/tabbed -c /usr/local/bin/surf -e"

alias rsync='rsync -rtvuclh --progress --delete'


# --------------------------------------------------------------------------- #
alias vim="nvim -p"
alias neovim=nvim
alias vi=nvim
alias kshrc="nvim ~/.kshrc"
alias vimrc="nvim ~/.vimrc"
# --------------------------------------------------------------------------- #

trash() {
    mv -v $1 ~/.local/share/Trash/files
}
alias empty-trash="sh ~/bin/empty-trash.sh"
alias cdTrash="cd ~/.local/share/Trash/files"

alias weather="c ; curl -s http://wttr.in/~Schmalkalden"
alias weather-sd="c ; curl -s http://wttr.in/~Dakota_State_University"
alias weather-ok="c ; curl -s http://wttr.in/~Claremore"

# --------------------------------------------------------------------------- #
alias yt="youtube-viewer -C -q --vd=high"
alias ytd="youtube-viewer -C -q --vd=high -d"
alias ytm="youtube-viewer -n -C -q --vd=high"
alias ytdm='youtube-viewer -q -C --vd=high -n -d --convert-to=opus --convert-cmd="ffmpeg -loglevel -8 -i file:*IN* -vn -acodec libopus -ab 128k -y *OUT*"'
alias bandcamp="youtube-dl --prefer-ffmpeg -x --audio-quality 0 --audio-format 'opus'"
opus-ffmpeg() {
    ffmpeg -i file:"$1" -vn -acodec libopus -ab 128k -y -map_metadata 0 "${1%.webm}.opus" && mv "$1" ~/.local/share/Trash/files && clear && ls
}
# --------------------------------------------------------------------------- #

# ------------------ RANGER ------------------------------------------------- #
alias ranger="ranger ; clear"
alias r="ranger"
[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(RANGER): ' && clear && \
    ls
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
alias trans-shell='trans -b -I'
alias rtrans-shell='trans -b -from en -to de -I'
trans(){
    /usr/local/bin/trans -no-auto -b "$@"
}
rtrans(){
    /usr/local/bin/trans -from en -to de -no-auto -b "$@"
}
# --------------------------------------------------------------------------- #


# --------------------------------------------------------------------------- #
alias less="less -Q -R"
# NOTE: on linux:
alias ls='ls --color=always --group-directories-first -F'
# on BSD:
alias ls='ls -F'
alias sls='ls'
alias l='ls'
alias sl='ls'
alias c='clear'
alias cc='clear'
alias cll='clear'
alias cls='clear;ls'
alias csl='clear;ls'
alias cl='clear;ls'
alias mv="mv -v"
# alias cp="cp -av"
alias cp="cp -v"
alias mkdir="mkdir -p"
alias du='du -ahLd 1'
alias make="make -j3"
alias x="exit"
alias q='exit'
alias cat="lolcat"
:q(){ exit; }
:wq(){ exit; }
:w(){ clear; }
alias htpo='htop'
alias hto='htop'
alias hpot='htop'
alias hotp='htop'
alias top='htop'

# --------------------------------------------------------------------------- #

# HOME
alias gh="cd ~ ; cls"
mh() { mv "$1" ~ ; }
Yh() { cp -r "$1" ~ ; }

# workspace
alias gw="cd ~/workspace ; cls"
mw() { mv "$1" ~/workspace ; }
Yw() { cp -r "$1" ~/workspace ; }

# Trash
alias gT="cd ~/.local/share/Trash/files ; cls"
mT() { mv "$1" ~/.local/share/Trash/files ; }
YT() { cp -r "$1" ~/.local/share/Trash/files ; }

# bin
alias gb="cd ~/bin ; cls"
mb() { mv "$1" ~/bin ; }
Yb() { cp -r "$1" ~/bin ; }

# backup
alias gB="cd ~/backup ; cls"
mB() { mv "$1" ~/backup ; }
YB() { cp -r "$1" ~/backup ; }

# files
alias gf="cd ~/files ; cls"
mf(){ mv "$1" ~/files ; }
Yf(){ cp -r "$1" ~/files ; }

# downloads
alias gd="cd ~/downloads ; cls"
md() { mv "$1" ~/downloads ; }
Yd() { cp -r "$1" ~/downloads ; }

# images
alias gi="cd ~/images ; cls"
mi(){ mv "$1" ~/images ; }
Yi(){ cp -r "$1" ~/images ; }

# wallpapers
alias gW="cd ~/images/wallpapers ; cls"
mW() { mv "$1" ~/images/wallpapers ; } 
YW() { cp -r "$1" ~/images/wallpapers ; }

# memes
alias gM="cd ~/images/memes ; cls"
mM(){ mv "$1" ~/images/memes ; }
YM(){ cp -r "$1" ~/images/memes ; }

# videos
alias gV="cd ~/videos ; cls"
mV() { mv "$1" ~/videos ; }
YV() { cp -r "$1" ~/videos ; }

# music
alias gm="cd ~/music ; cls"
mm() { mv "$1" ~/music ; }
Ym() { cp -r "$1" ~/music ; }

# books
alias gB="cd ~/books ; cls"
mB() { mv "$1" ~/books ; }
YB() { cp -r "$1" ~/books ; } 

# root
alias gr="cd / ; cls"

# var
alias gv="cd /var ; cls"

# tmp
alias gt="cd ~/tmp ; cls"
mt() { mv "$1" ~/tmp ; }
Yt() { cp -r "$1" ~/tmp ; }

# .config
alias gcf="cd ~/.config ; cls"
mcf() { mv "$1" ~/.config ; } 
Ycf() { cp -r "$1" ~/.config ; } 

# suckless
alias gs="cd ~/workspace/dotfiles/suckless-tools ; cls"
ms() { mv "$1" ~/workspace/dotfiles/suckless-tools ; }
Ys() { cp -r "$1" ~/workspace/dotfiles/suckless-tools ; } 

# --------------------------------------------------------------------------- #

alias wtfismyip='curl https://wtfismyip.com/text'
alias jpg="jpegoptim *.jpg --strip-all"
alias recursive-jpg="sh /home/mitch/bin/recursive-jpg-optimizer.sh"

alias mpv="mpv --gapless-audio"
alias rtv="rtv --enable-media"
alias parrot='terminal-parrot'
alias doge="doge --shibe doge.txt"
alias tiv='tiv -256'
alias ncmpcpp="ncmpcpp -q"
alias ncmpc="ncmpcpp"
alias ncmppcp="ncmpcpp"
alias ncmpp="ncmpcpp"
alias ncmpcp="ncmpcpp"
alias ncmp="ncmpcpp"

recomp() {
    case $1 in
        dwm)
            cd /home/mitch/workspace/dotfiles/suckless-tools/dwm/dwm && make clean ; make -j3  &&  make install && killall dwm;;
        surf) 
            cd /home/mitch/workspace/dotfiles/suckless-tools/surf/surf && make clean ; make -j3 &&  make install && clear ;;
        tabbed)
            cd /home/mitch/workspace/dotfiles/suckless-tools/tabbed/tabbed && make clean ; make -j3 &&  make install && clear ;;
        st)
            cd /home/mitch/workspace/dotfiles/suckless-tools/st/st && make clean ; make -j3 &&  make install && clear ;;
        dmenu)
            cd /home/mitch/workspace/dotfiles/suckless-tools/dmenu/dmenu && make clean ; make -j3 &&  make install && clear ;;
        slock)
            cd /home/mitch/workspace/dotfiles/suckless-tools/slock/slock && make clean ; make -j3 &&  make install && clear ;;
        slstatus)
            cd /home/mitch/workspace/dotfiles/suckless-tools/slstatus/ && make clean ; make -j3 &&  make install && killall slstatus && slstatus && clear ;;
        *)    
    esac
}

gitup() {
    git add -A && git commit -m "$@" && git push -u origin master
}
gitadd() {
    if [ $# -eq 0 ] ; then
        git add -A
    else
        git add "$@"
    fi
}
gitmit() {

    git add "$1" && git commit -m "$2"
    # git add "$1" && git commit -m "${@:(-1)}"

    # if [ $# -eq 0 ] ; then
    #     git add -A && git commit -m "$@"
    # else
    #     # this garble means "all but last" and then "the last"
    #     foo="$@"
    #     git add "${foo[@]::${#foo[@]}-1}" 2> /dev/null && git commit -m "${@:(-1)}" 

    # fi
}
gitout() {
    # pushes out to the current branch
    git push -u origin $(git rev-parse --abbrev-ref HEAD)
}
gitdiff() {
    git diff origin/master
}
gitbase() {
    if [ $# -eq 0 ] ; then
        git rebase -i HEAD~10
    else
        git rebase -i HEAD~"$@"
    fi
}
# because i have had too many disasters from doing this...
git() {
    if [ "$1" == 'reset' ]; then
        /usr/sbin/cp -rav . /tmp/git-reset-backup
    fi
    /usr/bin/git "$@"
}

filesize(){ echo $(stat --printf="%s" "$1") ; }

alias nf="neofetch --ascii_distro openbsd_small"

alias ping='ping mitchweaver.xyz'

vpn() {
    pkill -9 openvpn > /dev/null; $(cd /etc/openvpn ; openvpn Switzerland.ovpn &) & clear
}

alias resize-half='mogrify -resize 50%X50%'
alias resize-quarter='mogrify -resize 25%X25%'

alias discord="cd ~/workspace/Discline ; c ; python3.6 Discline.py"

# BSD specific stuff
alias xztar="xz -d -c ssh-backup.tar.xz | tar xf -"
alias killall="pkill -9"
alias disks="sysctl hw.disknames"
alias sensors="sysctl hw.sensors"


# -------------- ksh specific ------------------------------ #
# NOTE: You need these in order for arrow keys to work.
# Otherwise they behave *extremely* weird in ksh.
# Don't ask me why this works, I have no idea.
# ----- also note: this must be at bottom of file! --------- #
set -o emacs
alias __A=`echo "\020"`     # up arrow = ^p = back a command
alias __B=`echo "\016"`     # down arrow = ^n = down a command
alias __C=`echo "\006"`     # right arrow = ^f = forward a character
alias __D=`echo "\002"`     # left arrow = ^b = back a character
alias __H=`echo "\001"`     # home = ^a = start of line
alias __Y=`echo "\005"`     # end = ^e = end of line
