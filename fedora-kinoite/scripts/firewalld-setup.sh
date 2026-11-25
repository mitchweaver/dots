#!/bin/sh

# edit this to your ssid:
##### HOME_SSID=XXXXXXXX

if [ ! "$HOME_SSID" ] ; then
    >&2 echo 'edit HOME_SSID idiot'
    exit 1
fi

# set zone for all new wifi ssid going further to be "public"
# which is more restrictive than "home"
sudo firewall-cmd --set-default-zone=public

# make sure to set my home ssid to "home"
sudo nmcli connection modify "$HOME_SSID" connection.zone home

# punch for kdeconnect
sudo firewall-cmd --permanent --zone=home --add-service=kdeconnect

# load rules into live environment
sudo firewall-cmd --reload

