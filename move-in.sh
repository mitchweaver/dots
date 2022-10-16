#!/bin/sh -e

die() { >&2 printf '%s\n' "$*" ; exit 1 ; }

DOTS_DIR="${HOME}/src/dots"
if [ ! -d "$DOTS_DIR" ]  ; then
	die "wrong dots dir, idiot"
fi

cat <<EOF
NOTE:
1. run this in a clean home directory
2. ensure .config does not exist
3. clean up any extraneous files as they will be overwritten

EOF

echo -n 'Confirm? (YES/NO): '

read -r ans
[ "$ans" == YES ] || die 'Exiting.'

# --------------------------------------


for folder in \
	.config/i3 \
	.config/kitty \
	.config/mpv \
	.config/nvim \
	.config/picom \
	.config/ranger \
	.config/sway \
	.config/sxhkd ; do

	rm -rfv "${HOME}/$folder"
	ln -sv "$DOTS_DIR/$folder" "${HOME}/$folder"

done

for file in \
	.detoxrc .gitconfig \
	.profile .pylintrc .vimrc \
	.xmodmaprc .xinitrc .Xresources ; do

	rm -fv "${HOME}/$file"
	ln -sv "$DOTS_DIR/$file" "${HOME}/$file"

done

if [ ! -e ~/.vim/autoload/plug.vim ] ; then
    printf '\n%s\n\n' "Installing vim plug"

    curl -#fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "All done!"
