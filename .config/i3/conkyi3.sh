#!/bin/zsh
echo "{\"version\":1}"
echo "[[]"
exec conky -c $HOME/.conkyrc
