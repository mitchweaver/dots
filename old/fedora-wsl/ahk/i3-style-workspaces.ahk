hVDA := DllCall("LoadLibrary", "Str", A_ScriptDir . "\VirtualDesktopAccessor.dll", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "GoToDesktopNumber", "Ptr")
MoveWindowProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "MoveWindowToDesktopNumber", "Ptr")
GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "GetDesktopCount", "Ptr")
CreateDesktopProc := DllCall("GetProcAddress", "Ptr", hVDA, "AStr", "CreateDesktop", "Ptr")

ensureDesktopExists(n) {
    global GetDesktopCountProc, CreateDesktopProc
    count := DllCall(GetDesktopCountProc, "Int")
    loop (n - count + 1)
        DllCall(CreateDesktopProc)
}

; =========================================================
; GO TO DESKTOP ALT+NUMBER
; =========================================================
!1:: {
    ensureDesktopExists(0)
    DllCall(GoToDesktopNumberProc, "Int", 0)
}
!2:: {
    ensureDesktopExists(1)
    DllCall(GoToDesktopNumberProc, "Int", 1)
}
!3:: {
    ensureDesktopExists(2)
    DllCall(GoToDesktopNumberProc, "Int", 2)
}
!4:: {
    ensureDesktopExists(3)
    DllCall(GoToDesktopNumberProc, "Int", 3)
}

; =========================================================
; MOVE WINDOWS ALT+SHIFT+NUMBER
; =========================================================
!+1:: {
    ensureDesktopExists(0)
    DllCall(MoveWindowProc, "Ptr", WinGetID("A"), "Int", 0)
}
!+2:: {
    ensureDesktopExists(1)
    DllCall(MoveWindowProc, "Ptr", WinGetID("A"), "Int", 1)
}
!+3:: {
    ensureDesktopExists(2)
    DllCall(MoveWindowProc, "Ptr", WinGetID("A"), "Int", 2)
}
!+4:: {
    ensureDesktopExists(3)
    DllCall(MoveWindowProc, "Ptr", WinGetID("A"), "Int", 3)
}