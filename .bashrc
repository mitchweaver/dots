#!/bin/bash

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

source ~/src/dots/shell/main.shellrc

