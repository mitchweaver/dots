#!/bin/sh


#########export WLR_NO_HARDWARE_CURSORS=1
#
exec dbus-run-session sway --unsupported-gpu
