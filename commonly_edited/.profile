PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
export PATH HOME TERM

export PATH=$PATH:/home/mitch/bin
export EDITOR="/bin/nvim"
# export BROWSER="/usr/local/bin/tabbed -c /usr/local/bin/surf -e"
export BROWSER="/usr/local/bin/surf"

export LC_CTYPE=en_US.UTF-8
export LESSCHARSET=utf-8

. /etc/profile

if test -n "$ZSH_VERSION"; then
    source .zshrc
elif test -n "$BASH_VERSION"; then
    source .bashrc
elif test -n "$KSH_VERSION"; then
    ENV=~/.kshrc ; . $ENV
    export ENV
elif test -n "$FCEDIT"; then
    ENV=~/.kshrc ; . $ENV
    export ENV
fi

### XDG CONFIG DIRS
export XDG_DESKTOP_DIR="$HOME"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DOCUMENTS_DIR="$HOME/files"
export XDG_DOWNLOAD_DIR="$HOME/downloads"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_PICTURES_DIR="$HOME/images"
export XDG_VIDEOS_DIR="$HOME/videos"
export XDG_PUBLICSHARE_DIR="/non/existent"

if [ ${#X} -gt 0 ]
	then
		true
		#X has already been started as it has a pid
	else
		exec startx &
fi
