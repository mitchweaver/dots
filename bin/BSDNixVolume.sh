#!/bin/sh

if [ $(uname) == "Linux" ] ; then
   
    if [ "$1" == "-set" ] ; then
        amixer -q sset Master "$2"%+
        exit

    elif [  "$1" == "-get" ] ; then
        vol=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master))

        vol_val=$(echo $vol | sed 's/.$//')
    fi

#If BSD
elif test mixerctl ; then

    if [ "$1" == "-set" ] ; then

        mixerctl -q outputs.master="$2"
        exit

    elif [ "$1" == "-get" ] ; then

        tmp=$(mixerctl -n outputs.master)
        vol_val=${tmp%,*}

        # BSD has a peculiarity, that its volume is actually 0-255, not 0-100
        # To get the proper percent, we will accomodate for that here.
        vol_val=$(echo $vol_val \* 0.392 | bc)
        # convert back to int
        vol_val=${vol_val%.*}
        vol=$vol_val%

    fi

fi


# Now that we have the volume as a number, return our result
# (if we didn't exit above, because the argument was -set)
if [ $vol_val -gt 65 ] ; then
    echo "🔊 $vol"
    
elif [ $vol_val -gt 40 ] ; then
    echo "🔉 $vol"

elif [ $vol_val -gt 10 ] ; then
    echo "🔈 $vol"

elif [ $vol_val -eq 0 ] ; then
    echo "🔇 $vol"
fi
