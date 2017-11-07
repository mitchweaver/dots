### THIS IS TO AUTOMATICALLY STARTX ON LOGIN #######
X=$( pidof Xorg )
if [ ${#X} -gt 0 ]
	then
		true
		#X has already been started as it has a pid
	else
		exec startx -q
fi



# PATHING
export PATH="${PATH}:/home/mitch/bin"





# source bashrc
. ~/.bashrc
