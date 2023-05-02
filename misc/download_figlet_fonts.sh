#!/bin/sh

git clone https://github.com/xero/figlet-fonts.git /tmp/figlet-fonts

case $(uname) in
    OpenBSD)
        doas mv -vf /tmp/figlet-fonts/* /usr/local/share/figlet/
        ;;
    Linux)
        sudo mv -vf /tmp/figlet-fonts/* /usr/share/figlet/
esac
