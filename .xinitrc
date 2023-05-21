#!/bin/sh

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ENV VARIABLES
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
export DISPLAY="${DISPLAY:-:0}"
export _JAVA_AWT_WM_NONREPARENTING=1
export STEAM_RUNTIME=1
export DIMENSIONS="$(dimensions 2>/dev/null)"
export DIMENSIONS="${DIMENSIONS:-"1920 1080"}"
export XINIT_LOGS="/tmp/${USER}-xinit-logs"
mkdir -p "$XINIT_LOGS"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# SET PROPER DPI
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# if [ "$DIMENSIONS" ] ; then
#     # shellcheck disable=2086
#     set -- $DIMENSIONS
#     case $1 in
#         # laptop
#         1920)
#             if [ "$(cat /etc/hostname)" != desktop ] ; then
#                 sed -i 's/.*Xft.dpi:.*/Xft.dpi: 120/' ~/.Xresources
#             fi
#             ;;
#         # desktop
#         3840)
#             sed -i 's/.*Xft.dpi:.*/Xft.dpi: 196/' ~/.Xresources
#             ;;
#     esac
# fi

# case $(hostname) in
#     *desktop*)
# # --output DP-2 --mode 1920x1080 --pos 1920x0 -r 144 --rotate normal \
#         xrandr \
#             --output DP-0 --primary --mode 1920x1080 -r 390 --pos 0x0 --rotate normal \
#             --output HDMI-0 --off \
#             --output DP-1 --off \
#             --output DP-3 --off --output DP-4 --off --output DP-5 --off
# esac

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# XORG SETTINGS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
xrdb load ~/.Xresources
xmodmap ~/.xmodmaprc
xset +fp ~/.fonts
xset m 0 0
xset b off
xset b 0 0 0
dconf write /org/gnome/desktop/sound/event-sounds "false"

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# ONE SHOT COMMANDS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
background &
dbus-update-activation-environment --all &
gnome-keyring-daemon --start --components=secrets &
bright s 80 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# DAEMONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# pgrep -f parcellite  >/dev/null || parcellite &
# pgrep -f dunst       >/dev/null || dunst >"$XINIT_LOGS"/dunst.log 2>&1 &
# pgrep -f sxhkd       >/dev/null || sxhkd >"$XINIT_LOGS"/sxhkd.log 2>&1 &
# pgrep -f xdimmer     >/dev/null || xdimmer -p 20 -s 10 -b 1 -t 570 >"$XINIT_LOGS"/xdimmer.log 2>&1 &
# pgrep -f wireplumber >/dev/null || nohup gentoo-pipewire-launcher >"$XINIT_LOGS"/pipewire.log 2>&1 &
# pgrep -f xbanish     >/dev/null || xbanish -t 30 >"$XINIT_LOGS"/xbanish.log 2>&1 &
# pgrep -f picom       >/dev/null || picom --log-file "$XINIT_LOGS"/picom.log -b

# pgrep -f xautolock   >/dev/null || xautolock \
#     -locker 'lockscreen' \
#     -time "${LOCK_TIME:-10}" \
#     -notify 15 \
#     -notifier notify-send >"$XINIT_LOGS"/xautolock.log 2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# APPLICATIONS
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# pgrep -f nextcloud >/dev/null || firejail-nextcloud.sh >"$XINIT_LOGS"/nextcloud.log 2>&1 &
#pgrep -f nextcloud >/dev/null || nextcloud >"$XINIT_LOGS"/nextcloud.log 2>&1 &
#pgrep -f redshift >/dev/null || firejail-redshift.sh >"$XINIT_LOGS"/redshift.log 2>&1 &
# firejail-mailspring.sh >"$XINIT_LOGS"/mailspring.log 2>&1 &
# firejail-joplin.sh     >"$XINIT_LOGS"/joplin.log     2>&1 &
# firejail-discord.sh    >"$XINIT_LOGS"/discord.log    2>&1 &

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# WINDOW MANAGER
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# pkill mmbar
# mmbar -d &
exec dwm
# while sleep 1 ; do
#     dwm >"$XINIT_LOGS"/dwm.log 2>&1 && break || continue
# done
