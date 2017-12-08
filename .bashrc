# --------------------- PS1 -------------------------------------------------- #
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W\e[0;33m\]$(parse_git_branch)\[\e[1;37m\] "

cd(){
    builtin cd "$1"
    export PS1="\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W\e[0;33m\]$(parse_git_branch) \[\e[1;37m\]"
}
# --------------------------------------------------------------------------- #

export PATH=$PATH:/home/mitch/bin
export EDITOR="/bin/nvim"
export BROWSER="/usr/local/bin/tabbed -c /usr/local/bin/surf -e"

alias rsync='rsync -rtvuclh --progress --delete'

alias resize-half='mogrify -resize 50%X50%'
alias resize-quarter='mogrify -resize 25%X25%'

# --------------------------------------------------------------------------- #
alias neovim=nvim
alias vim=nvim
alias vi=nvim
alias bashrc="nvim ~/.bashrc"
alias bsahrc="nvim ~/.bashrc"
alias vimrc="nvim ~/.vimrc"
# --------------------------------------------------------------------------- #

trash() {
    mv -v $1 ~/.local/share/Trash/files
}
alias empty-trash="sh ~/bin/empty-trash.sh"
alias cdTrash="cd ~/.local/share/Trash/files"

alias weather="curl -s http://wttr.in/~Schmalkalden"
alias weather-sd="curl -s http://wttr.in/~Dakota_State_University"
alias weather-ok="curl -s http://wttr.in/~Claremore"

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
alias r="ranger"
[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(RANGER): ' && clear && \
    ls --color=always --group-directories-first -F
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
alias trans-shell='trans -b -I'
alias trans='trans -no-auto -b'
alias rtrans-shell='trans -b -from en -to de -I'
alias rtrans='trans -from en -to de -no-auto -b'
# --------------------------------------------------------------------------- #

# --------------------------------------------------------------------------- #
alias less="less -Q -R"
alias ls='ls --color=always --group-directories-first --color=auto -F'
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
alias cp="cp -av"
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
            cd /home/mitch/workspace/dotfiles/suckless-tools/slstatus/ && make clean ; make -j3 &&  make install && clear ;;
        *)    
    esac
}

gitup() {
    git add -A && git commit -m "$@" && git push -u origin master
}
gitmit() {
    if [ $# -eq 0 ] ; then
        git add -A && git commit -m "$@"
    else
        git add "$1" && git commit -m "${@:2}" 
    fi
}
gitout() {
    if [ $# -eq 0 ] ; then 
        git push -u origin master
    else
        git push -u origin "$@"
    fi
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

alias sf="neofetch"
alias nf="sf"

alias ping='ping mitchweaver.xyz'

# when switching between eth0 to wlan0, openvpn must be restarted
alias restart-vpn="killall openvpn ; cd /etc/openvpn ; openvpn Switzerland.ovpn &"

alias discord="cd ~/workspace/terminal-discord ; c ; ./start.sh"
