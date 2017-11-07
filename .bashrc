########### Pretty colors ####################
export PS1="\[\e[1;35m\]m\[\e[0;32m\]i\[\e[0;33m\]t\[\e[0;34m\]c\[\e[1;31m\]h\[\e[1;36m\] \W \[\e[1;37m\]"
##############################################


export DISTRIB_ID="Parabola"
export EDITOR="/usr/bin/vim"
export BROWSER="/usr/local/bin/tabbed -c /usr/local/bin/surf -e"
export PYTHONPATH="/home/mitch/.local/lib64/python3.4/site-packages"

### NOTE: this may be dangerous to keep. This is just what
#	  I use for my own backups.
alias rsync='rsync -rtvuclh --progress --delete'

### IMAGE MANIPULATION ######
alias resize-half='mogrify -resize 50%x50%'
alias resize-quarter='mogrify -resize 25%x25%'
#############################

trash() {
    mv $1 ~/.local/share/Trash/files
}
alias empty-trash="sh ~/bin/empty-trash.sh"
alias cdTrash="cd ~/.local/share/Trash/files"

alias ncmpcpp="ncmpcpp -q"
alias weather="curl http://wttr.in/~Schmalkalden"

####### YOUTUBE ##############################
alias yt="youtube-viewer -C -q --vd=high"
alias ytd="youtube-viewer -C -q --vd=high -d"
alias ytm="youtube-viewer -n -C -q --vd=high"
alias ytdm='youtube-viewer -q -C --vd=high -n -d --convert-to=ogg --convert-cmd="ffmpeg -loglevel -8 -i file:*IN* -vn -acodec libvorbis -ab 320k -y *OUT*"'
##############################################

######## RANGER #################
alias r="ranger"
[ -n "$RANGER_LEVEL" ] && PS1="$PS1"'(RANGER): ' && clear && \
    ls --color=always --group-directories-first -F
#################################

alias bashrc="vim ~/.bashrc"
alias vimrc="vim ~/.vimrc"
alias x="exit"

#### TRANSLATE DE-->>>>ENG ####################
alias trans-shell='trans -b -from de -to en -I'
alias trans='trans -from de -to en -b'
alias rtrans-shell='trans -b -from en -to de -I'
alias rtrans='trans -from en -to de -b'
###############################################

alias ls='ls --color=always --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias sls='ls'
alias l='ls'
alias sl='ls'

alias grep='grep --color=tty'

alias c='clear'
alias cls='clear;ls'
alias cl='clear;ls'


alias jpg="jpegoptim *.jpg --strip-all"
alias recursive-jpg="sh /home/mitch/bin/recursive-jpg-optimizer.sh"

## git commands
gitup() {
    git add -A && git commit -m "$1" && git push -u origin master && clear && ls
}

# ffmpeg - convert to .ogg
ogg-ffmpeg() {
    ffmpeg -i file:"$1" -vn -acodec libvorbis -ab 320k -y -map_metadata 0 "${1%.webm}.ogg" && mv "$1" ~/.local/share/Trash/files && clear && ls
}

alias java='/home/$USER/programs/java/jdk1.8/bin/java'

###### PATHING ###########################################
# export PATH=$PATH:/home/home/bin
##########################################################

alias mv="mv -v"
alias cp="cp -av"
alias du="ncdu"
alias mkdir="mkdir -p"
alias reboot="sudo reboot"
alias mpv="mpv --gapless-audio"

alias rtv="python3.6 -m rtv --enable-media"
alias wtfismyip='curl https://wtfismyip.com/text'

alias parrot='terminal-parrot'
alias doge="doge --shibe doge.txt"
alias nyancat="/home/mitch/programs/nyancat/src/nyancat"
alias tiv='tiv -256'
alias cc=clear

alias q='exit'

alias make="make -j3"

recomp() {
    case $1 in
        dwm)
            cd ~/workspace/dotfiles/suckless-tools/dwm/dwm && sudo make -j3  && sudo make clean install && killall dwm;;
        surf) 
            cd ~/workspace/dotfiles/suckless-tools/surf/surf && sudo make -j3 && sudo make clean install && clear ;;
        tabbed)
            cd ~/workspace/dotfiles/suckless-tools/tabbed/tabbed && sudo make -j3 && sudo make clean install && clear ;;
        st)
            cd ~/workspace/dotfiles/suckless-tools/st/st && sudo make -j3 && sudo make clean install && clear ;;
        dmenu)
            cd ~/workspace/dotfiles/suckless-tools/dmenu/dmenu && sudo make -j3 && sudo make clean install && clear ;;
        *)
    esac
}

alias dwmconf="vim /home/mitch/workspace/dotfiles/suckless-tools/dwm/config.h"
alias surfconf="vim ~/workspace/dotfiles/suckless-tools/surf/surf/config.h"
alias tabbedconf="vim ~/workspace/dotfiles/suckless-tools/tabbed/tabbed/config.h"
alias dmenuconf="vim ~/workspace/dotfiles/suckless-tools/dmenu/dmenu/config.h"
alias stconf="vim ~/workspace/dotfiles/suckless-tools/st/st/config.h"
alias sf="screenfetch -D Parabola"



alias backup="sh ~/bin/backup.sh"
