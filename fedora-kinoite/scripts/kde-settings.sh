#!/bin/sh
#
# attemping to put as many KDE settings as possible into a script to make it
# more reproducible
#
# ========================================================================

# ========================================================================
# window management
# ========================================================================
# swap super and alt as mod key
kwriteconfig6 --file kwinrc --group MouseBindings --key CommandAllModKey Alt
kwriteconfig6 --file kwinrc --group MouseBindings --key CommandAllKey Alt

# 4 virtual desktops
kwriteconfig6 --file kwinrc --group Desktops --key Number 4
kwriteconfig6 --file kwinrc --group Desktops --key Rows 1

# only on primary monitor
kwriteconfig6 --file kwinrc --group Script-virtualdesktopsonlyonprimary --key Enabled true

# ========================================================================
# workspace switcher
# ========================================================================
# switch between all active windows with alt+tab, not just what is on current workspace
kwriteconfig6 --file kwinrc --group TabBox --key DesktopMode 0
# make alt+tab instant disable fade animation
kwriteconfig6 --file kwinrc --group Plugins --key fadedesktopEnabled false
kwriteconfig6 --file kwinrc --group Plugins --key slideEnabled false

# animation speed
# 1.0 = default, 0.0 = disabled, 0.5 = twice as fast
kwriteconfig6 --file kdeglobals --group KDE --key AnimationDurationFactor 0.8

# ========================================================================
# effects
# ========================================================================
kwriteconfig6 --file kwinrc --group Plugins --key blurEnabled true
kwriteconfig6 --file kwinrc --group Plugins --key shakecursorEnabled false
kwriteconfig6 --file kwinrc --group Plugins --key wobblywindowsEnabled false
kwriteconfig6 --file kwinrc --group Effect-wobblywindows --key ResizeWobble false

# annoying
kwriteconfig6 --file kwinrc --group Plugins --key shakecursorEnabled false
qdbus-qt6 org.kde.KWin /Effects org.kde.kwin.Effects.unloadEffect shakecursor

# slide popups
kwriteconfig6 --file kwinrc --group Plugins --key slidingpopupsEnabled true

# ========================================================================
# file management
# ========================================================================
# double click to open
kwriteconfig6 --file kdeglobals --group KDE --key SingleClick false
kwriteconfig6 --file dolphinrc --group General --key ShowFullPath true

# ========================================================================
# themeing
# ========================================================================
# sometimes this is named differently
plasma-apply-cursortheme breeze_cursors --size 24 >/dev/null 2>&1
plasma-apply-cursortheme breeze_dark    --size 24 >/dev/null 2>&1
plasma-apply-cursortheme Breeze_Dark    --size 24 >/dev/null 2>&1

# ========================================================================
# keyboard
# ========================================================================
kwriteconfig6 --file kcminputrc --group Keyboard --key RepeatDelay 250
kwriteconfig6 --file kcminputrc --group Keyboard --key RepeatRate 35

# 0=on, 1=off
kwriteconfig6 --file kcminputrc --group Keyboard --key NumLock 1

# ========================================================================
# window decorations
# ========================================================================
# "" = none
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft ""
# IAX = min/max/close
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"

# ========================================================================
# security
# ========================================================================
# screen lock timeout in minutes
kwriteconfig6 --file kscreenlockerrc --group Daemon --key Timeout 10

# disable auto-mount
kwriteconfig6 --file kded_device_automounterrc --group Automounter --key AutomountEnabled false

# disable user feedback/telemetry
kwriteconfig6 --file kuserfeedbackrc --group Global --key FeedbackLevel None

# ========================================================================
# nightshift - default = 6500
# ========================================================================
kwriteconfig6 --file kwinrc --group DayColor --key Active true
kwriteconfig6 --file kwinrc --group NightColor --key Active true
kwriteconfig6 --file kwinrc --group DayColor --key NightTemperature 6500
kwriteconfig6 --file kwinrc --group NightColor --key NightTemperature 6300

# ========================================================================
# junk
# ========================================================================
# disable file indexing (kde baloo)
kwriteconfig6 --file baloofilerc --group "Basic Settings" --key Indexing-Enabled false
kwriteconfig6 --file krunnerrc --group Plugins --key baloosearchEnabled false
balooctl6 disable
pkill baloorunner
kquitapp6 krunner

# ========================================================================
# shortcuts
# ========================================================================
# kde uses tabs to delineate, which is super dumb. most human-readable solution I've found is use a variable
# TAB=$(printf '\t')

kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Close" "Alt+Q,Alt+F4,Close Window"

# apps
kwriteconfig6 --file kglobalshortcutsrc --group org.kde.dolphin.desktop --key _launch "Alt+E,none,Dolphin"
kwriteconfig6 --file kglobalshortcutsrc --group librewolf.desktop --key _launch "Alt+W,none,Librewolf"

# kwin
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+Up,none,Maximize Window"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Quick Tile Left" "Meta+Left,Meta+Left,Quick Tile Window to the Left"
kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Quick Tile Right" "Meta+Right,Meta+Right,Quick Tile Window to the Right"
# kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+Down${TAB}Alt+M,none,Minimize Window"

# audio
# kwriteconfig6 --file kglobalshortcutsrc --group kmix --key increase_volume "XF86AudioRaiseVolume${TAB}Alt+',XF86AudioRaiseVolume,Increase Volume"
# kwriteconfig6 --file kglobalshortcutsrc --group kmix --key decrease_volume "XF86AudioLowerVolume${TAB}Alt+;,XF86AudioLowerVolume,Decrease Volume"
kwriteconfig6 --file kglobalshortcutsrc --group kmix --key mute "XF86AudioMute,XF86AudioMute,Mute"

# krunner
kwriteconfig6 --file kglobalshortcutsrc --group org.kde.krunner.desktop --key _launch "Alt+P,none,KRunner"

# ========================================================================
# done
# ========================================================================
qdbus-qt6 org.kde.KWin /KWin reconfigure
printf '\nDone. For all changes you need to relogin.\n'

