#Requires AutoHotkey v2.0
#SingleInstance Force

; Alt+Enter opens Windows Terminal
; (except inside Windows Terminal, where Alt+Enter toggles fullscreen)
#HotIf !WinActive("ahk_exe WindowsTerminal.exe")
!Enter::Run "wt.exe"
#HotIf

