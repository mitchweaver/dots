#!/bin/sh


#########export WLR_NO_HARDWARE_CURSORS=1
# --unsupported-gpu

exec dbus-run-session sway
