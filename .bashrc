########### Pretty colors ####################
export PS1="\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W \[\e[1;37m\]"
##############################################

export DISTRIB_ID="Sabotage"
export EDITOR="/bin/nvim"
#export BROWSER="/usr/local/bin/tabbed -c /usr/local/bin/surf -e"

### NOTE: this may be dangerous to keep. This is just what
#         I use for my own backups.
alias rsync='rsync -rtvuclh --progress --delete'

### IMAGE MANIPULATION ######
alias resize-half='mogrify -resize 50%X50%'
alias resize-quarter='mogrify -resize 25%X25%'
#############################

alias neovim=nvim
alias vim=nvim
alias vi=nvim

trash() {
    mv $1 ~/.local/share/Trash/files
}
alias empty-trash="sh ~/bin/empty-trash.sh"
alias cdTrash="cd ~/.local/share/Trash/files"

alias ncmpcpp="ncmpcpp -q"
alias weather="curl http://wttr.in/~Schmalkalden"
alias weather-sd="curl http://wttr.in/~Dakota_State_University"
alias weather-ok="curl http://wttr.in/~Claremore"

####### YOUTUBE ##############################
alias yt="youtube-viewer -C -q --vd=high"
alias ytd="youtube-viewer -C -q --vd=high -d"
alias ytm="youtube-viewer -n -C -q --vd=high"
alias ytdm='youtube-viewer -q -C --vd=high -n -d --convert-to=opus --convert-cmd="ffmpeg -loglevel -8 -i file:*IN* -vn -acodec libopus -ab 128k -y *OUT*"'
##############################################

######## RANGER #################
alias r="ranger"
[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(RANGER): ' && clear && \
    ls --color=always --group-directories-first -F
#################################

alias bashrc="nvim ~/.bashrc"
alias bsahrc="nvim ~/.bashrc"

alias vimrc="nvim ~/.vimrc"
alias x="exit"

#### TRANSLATE DE-->>>>ENG ####################
alias trans-shell='trans -b -from de -to en -I'
alias trans='trans -from de -to en -b'
alias rtrans-shell='trans -b -from en -to de -I'
alias rtrans='trans -from en -to de -b'
###############################################

alias ls='ls --color=always --group-directories-first --color=auto -F'
alias sls='ls'
alias l='ls'
alias sl='ls'
alias c='clear'
alias cls='clear;ls'
alias cl='clear;ls'

alias jpg="jpegoptim *.jpg --strip-all"
alias recursive-jpg="sh /home/mitch/bin/recursive-jpg-optimizer.sh"

## git commands
gitup() {
    git add -A && git commit -m "$1" && git push -u origin master && clear && ls
}

# ffmpeg - convert to .opus
opus-ffmpeg() {
    ffmpeg -i file:"$1" -vn -acodec libopus -ab 128k -y -map_metadata 0 "${1%.webm}.opus" && mv "$1" ~/.local/share/Trash/files && clear && ls
}

alias java='/home/$USER/programs/java/jdk1.8/bin/java'

###### PATHING ###########################################
export PATH=$PATH:/home/mitch/bin
##########################################################

alias mv="mv -v"
alias cp="cp -av"
alias du="ncdu"
alias mkdir="mkdir -p"
alias reboot=" reboot"
alias mpv="mpv --gapless-audio"

alias rtv="rtv --enable-media"
alias wtfismyip='curl https://wtfismyip.com/text'

alias parrot='terminal-parrot'
alias doge="doge --shibe doge.txt"
alias tiv='tiv -256'
alias cc=clear

alias q='exit'

alias make="make -j3"

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

alias dwmconf="nvim /home/mitch/workspace/dotfiles/suckless-tools/dwm/config.h"
alias surfconf="nvim ~/workspace/dotfiles/suckless-tools/surf/surf/config.h"
alias surfscript="nvim ~/.surf/script.js"
alias tabbedconf="nvim ~/workspace/dotfiles/suckless-tools/tabbed/tabbed/config.h"
alias dmenuconf="nvim ~/workspace/dotfiles/suckless-tools/dmenu/dmenu/config.h"
alias stconf="nvim ~/workspace/dotfiles/suckless-tools/st/st/config.h"
alias sf="neofetch"
alias nf="sf"

alias backup="sh ~/bin/backup.sh"

alias htpo=htop
alias hto=htop
alias du='du -ahLd 1'

alias pingme='ping mitchweaver.xyz'
alias ping='ping eff.org'

alias wpa_cli="wpa_cli -i wlan0 -p /etc/service/wpa_supplicant"





TOKEN="MzgwODc0NjQyOTE2NjM4NzUw.DO--3A.t2o62XJir4lUQyLAsk0zAKd-r04"

alias buch=butch
