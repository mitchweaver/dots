#!/bin/sh

NAME="mitch-color-nostalgia"

CONFIG_DIR=${HOME}/.config/kitty
THEME_DIR=$CONFIG_DIR/my-themes

ln -sf "$THEME_DIR/$NAME".conf "$CONFIG_DIR"/theme.conf
