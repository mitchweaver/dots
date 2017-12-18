#!/bin/bash

if [ ${#X} -gt 0 ]
	then
		true
		#X has already been started as it has a pid
	else
		exec startx &
fi

# source bashrc
. ~/.bashrc
