#Requires AutoHotkey v2.0

ProcessSetPriority "High"
ListLines 0
SetDefaultMouseSpeed 0
SetControlDelay 0
SetKeyDelay 0
SetMouseDelay 0
SendMode "Input"
CoordMode "Pixel", "Screen"

;RunWait("komorebic.exe start", , "Hide")
; Enable hot reloading of changes to this file
;RunWait("komorebic.exe watch-configuration enable", , "Hide")
;#+r::
;RunWait, komorebic reload-configuration, , Hide
;

; Create space for Yasb
Run("komorebic.exe work-area-offset 0 28 0 28", , "Hide")
;if !(PID := ProcessExist("python.exe"))
Run("C:\Users\ghoul\Downloads\start.bat", , "Hide")



; Open Yasb
; if !(PID := ProcessExist("python.exe"))
;  Run("python C:\Users\ghoul\.local\share\yasb\src\main.py", , "Hide")

; AutoHotkey Reload
#r::Reload

#+c::WinClose("A")  ; Close the active window

; Launch Wezterm with Win + T
#t::RunWait("wezterm-gui")  ; Replace "path_to_wezterm_executable" with the actual path to the Wezterm executable
#+e::RunWait("explorer")  ; Replace "path_to_wezterm_executable" with the actual path to the Wezterm executable

; Manipulate windows
#f::RunWait("komorebic toggle-float", , "Hide")
#m::RunWait("komorebic toggle-monocle", , "Hide")
#+m::RunWait("komorebic manage", , "Hide")
#e::RunWait("komorebic retile", , "Hide")

#h::RunWait("komorebic resize-axis horizontal decrease", , "Hide")
#l::RunWait("komorebic resize-axis horizontal increase", , "Hide")

; Jumping Between Windows
#j::RunWait("komorebic cycle-focus previous", , "Hide")
#k::RunWait("komorebic cycle-focus next", , "Hide")


#+h::RunWait("komorebic move left", , "Hide")
#+j::RunWait("komorebic move down", , "Hide")
#+k::RunWait("komorebic move up", , "Hide")
#+l::RunWait("komorebic move right", , "Hide")
#+::RunWait("komorebic promote", , "Hide")


; Toggling Workspaces
#1::RunWait("komorebic focus-workspace 0", , "Hide")
#2::RunWait("komorebic focus-workspace 1", , "Hide")
#3::RunWait("komorebic focus-workspace 2", , "Hide")
#4::RunWait("komorebic focus-workspace 3", , "Hide")
#5::RunWait("komorebic focus-workspace 4", , "Hide")


; Moving Workspaces
#+1::RunWait("komorebic move-to-workspace 0", , "Hide")
#+2::RunWait("komorebic move-to-workspace 1", , "Hide")
#+3::RunWait("komorebic move-to-workspace 2", , "Hide")
#+4::RunWait("komorebic move-to-workspace 3", , "Hide")
#+5::RunWait("komorebic move-to-workspace 4", , "Hide")


; Multi-Monitor Setup
#,::RunWait("komorebic cycle-monitor previous", , "Hide")
#.::RunWait("komorebic cycle-monitor next", , "Hide")
#+,::RunWait("komorebic cycle-move-to-monitor previous", , "Hide")
#+.::RunWait("komorebic cycle-move-to-monitor next", , "Hide")

OnMessage 0x7E, handle_display_change
handle_display_change(wParam, lParam, *)
{
    RunWait("komorebic.exe stop", , "Hide")
    RunWait("komorebic.exe start", , "Hide")
    RunWait("komorebic retile", , "Hide")
}
