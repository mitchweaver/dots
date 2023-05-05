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

printf '%s' 'Confirm? (YES/NO): '

read -r ans
[ "$ans" = YES ] || die 'Exiting.'

# --------------------------------------


for folder in \
	.firejail \
	.config/i3 \
	.config/polybar \
	.config/hypr \
	.config/kitty \
	.config/mpv \
	.config/nvim \
	.config/parcellite \
	.config/picom \
	.config/ranger \
	.config/redshift \
	.config/sway \
	.config/sxhkd \
	.config/waybar \
	.config/joplin ; do

	rm -rfv "${HOME:?}/$folder"
	ln -sv "$DOTS_DIR/$folder" "${HOME}/$folder"
done

for file in \
	.detoxrc .gitconfig \
	.profile .pylintrc .vimrc \
	.xmodmaprc .xinitrc .Xresources \
	.config/redshift.conf \
	.shellcheckrc ; do

	rm -fv "${HOME}/$file"
	ln -sv "$DOTS_DIR/$file" "${HOME}/$file"
done

if [ -d scripts ] ; then
	sh ./scripts/install-vim-plug.sh
fi

echo "All done!"
