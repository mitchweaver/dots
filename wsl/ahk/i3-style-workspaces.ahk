#Requires AutoHotkey v2.0


; ==================================================================
; i have no idea how this works, vibe-slop coded this
;
; alt-1/alt-2/alt-3/alt-4 change between 4 workspaces
; alt-!/alt-!/alt-!/alt-! to move window between workspaces
;
; tries to focus a window after changing
; ==================================================================


hVDA := DllCall("LoadLibrary", "Str", A_ScriptDir . "\VirtualDesktopAccessor.dll", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "GoToDesktopNumber", "Ptr")
MoveWindowProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "MoveWindowToDesktopNumber", "Ptr")
GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "GetDesktopCount", "Ptr")
CreateDesktopProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "CreateDesktop", "Ptr")
IsWindowOnCurrentDesktopProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "IsWindowOnCurrentVirtualDesktop", "Ptr")

ensureDesktopExists(n) {
    global GetDesktopCountProc, CreateDesktopProc
    count := DllCall(GetDesktopCountProc, "Int")
    loop (n - count + 1)
        DllCall(CreateDesktopProc)
}

; Activate the top-most normal window on the current desktop.
; WinGetList() returns windows in z-order (top first), so the first match
; is the window you last used on this desktop.
focusTopWindow() {
    global IsWindowOnCurrentDesktopProc
    for hwnd in WinGetList() {
        try {
            if DllCall(IsWindowOnCurrentDesktopProc, "Ptr", hwnd, "Int") != 1
                continue
            if WinGetMinMax(hwnd) = -1          ; minimized
                continue
            if WinGetTitle(hwnd) = ""
                continue
            if WinGetExStyle(hwnd) & 0x80       ; WS_EX_TOOLWINDOW
                continue
            cls := WinGetClass(hwnd)
            if (cls = "Shell_TrayWnd" || cls = "Shell_SecondaryTrayWnd"
                || cls = "Progman" || cls = "WorkerW")
                continue
            WinActivate(hwnd)
            return
        }
    }
    ; No window found: focus stays on the taskbar, so keystrokes go nowhere harmful.
}

goToDesktop(n) {
    global GoToDesktopNumberProc
    ensureDesktopExists(n)
    ; Take focus off the current window first, so keys can't leak into it
    ; (this also stops taskbar icons from flashing after the switch).
    try WinActivate("ahk_class Shell_TrayWnd")
    DllCall(GoToDesktopNumberProc, "Int", n)
    Sleep 50    ; let the switch settle before picking a window
    focusTopWindow()
}

moveActiveWindow(n) {
    global MoveWindowProc
    ensureDesktopExists(n)
    hwnd := WinExist("A")
    if !hwnd
        return
    DllCall(MoveWindowProc, "Ptr", hwnd, "Int", n)
    ; The moved window keeps keyboard focus even though it's gone; refocus here.
    focusTopWindow()
}

; =========================================================
; GO TO DESKTOP ALT+NUMBER
; =========================================================
!1::goToDesktop(0)
!2::goToDesktop(1)
!3::goToDesktop(2)
!4::goToDesktop(3)

; =========================================================
; MOVE WINDOWS ALT+SHIFT+NUMBER
; =========================================================
!+1::moveActiveWindow(0)
!+2::moveActiveWindow(1)
!+3::moveActiveWindow(2)
!+4::moveActiveWindow(3)

