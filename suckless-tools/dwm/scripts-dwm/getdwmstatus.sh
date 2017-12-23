#!/bin/sh
# get dwm's status (source: http://dwm.suckless.org/dwmgetstatus)

xprop -root -notype -f WM_NAME 8u |
	sed -n 's,^WM_NAME = "\(.*\)"$,\1,p'
