# source my aliases
. ~/.aliases

# because these core dumps on BSD are annoying as hell
# There may be some way to disable them from being created, but i don't know.
(rm -rf /home/mitch/*.core > /dev/null &)

# kill ~/desktop, i hate that firefox makes this on startup
# (rm -rf /home/mitch/Desktop > /dev/null &)

# -------------- ksh specific ------------------------------ #
# NOTE: You need these in order for arrow keys to work.
# Otherwise they behave *extremely* weird in ksh.
# Don't ask me why this works, I have no idea.
# ----- also note: this must be at bottom of file! --------- #
set -o emacs # i dont even use emacs 
alias __A=`echo "\020"`     # up arrow = ^p = back a command
alias __B=`echo "\016"`     # down arrow = ^n = down a command
alias __C=`echo "\006"`     # right arrow = ^f = forward a character
alias __D=`echo "\002"`     # left arrow = ^b = back a character
alias __H=`echo "\001"`     # home = ^a = start of line
alias __Y=`echo "\005"`     # end = ^e = end of line
