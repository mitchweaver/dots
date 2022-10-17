#!/bin/sh

NAME="Hybrid"

CONFIG_DIR=${HOME}/.config/kitty
THEME_DIR=$CONFIG_DIR/themes

ln -sf "$THEME_DIR/$NAME".conf "$CONFIG_DIR"/theme.conf
