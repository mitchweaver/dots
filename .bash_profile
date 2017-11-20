#!/bin/bash

### THIS IS TO AUTOMATICALLY STARTX ON LOGIN #######

source /etc/os-release
if [ $NAME == "sabotage" ]
    then
        X=$( pidof Xorg )
fi


if [ ${#X} -gt 0 ]
	then
		true
		#X has already been started as it has a pid
	else
		exec startx -q &
fi



# PATHING
export PATH="${PATH}:/home/mitch/bin"





# source bashrc
. ~/.bashrc
