#!/bin/sh
# ---- work in progress, not using atm ----- #
# ------------------------------------------------------ #

dir=/home/mitch/workspace/dotfiles/lemonbar

# -b    -    bottom
# -d    -    force docking
# -g    -    geometry (widthxheight+x+y)
# -B    -    background color
# -F    -    foreground color

g='-g 1000x100+280+30'
B='-B #ffbad2'
F='-F #000000'

args="-b -d $g $B $F"

$dir/feeder.sh | lemonbar $args
