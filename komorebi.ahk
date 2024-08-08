#Requires AutoHotkey >=v2.0- <2.1
#NoTrayIcon

; Optimizations
ListLines 0
SetTitleMatchMode 2
SetDefaultMouseSpeed 0
SetControlDelay 0
SetKeyDelay 0
SetMouseDelay 0
CoordMode "Pixel", "Screen"

; Autostart KomoTray
homeDir := EnvGet("USERPROFILE")
komotrayPath := homeDir "\.local\bin\komotray-ahk-v2-main\komotray.ahk"
resizePath := homeDir "\.local\bin\resize.ahk"
if !(PID := ProcessExist("komotray.ahk"))
  Run(komotrayPath, , "Hide")
if !(PID := ProcessExist("resize.ahk"))
  Run(resizePath, , "Hide")

; Launching Programs
#t::Run("wt")
#+e::Run("explorer")

; AutoHotkey Reload
#+r::Reload


; Manipulating windows
#f::RunWait("komorebic toggle-float", , "Hide")
#m::RunWait("komorebic toggle-monocle", , "Hide")
#+m::RunWait("komorebic manage", , "Hide")
#e::RunWait("komorebic retile", , "Hide")
#q::WinClose("A")  ; Close the active window
#+q::ExitApp


; Resizing Windows
#h::RunWait("komorebic resize-axis horizontal decrease", , "Hide")
#l::RunWait("komorebic resize-axis horizontal increase", , "Hide")


; Jumping Between Windows
#j::RunWait("komorebic cycle-focus previous", , "Hide")
#k::RunWait("komorebic cycle-focus next", , "Hide")
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


Alt & WheelUp::Send "{Volume_Up}"     ; Wheel over taskbar: increase/decrease volume.
Alt & WheelDown::Send "{Volume_Down}" ;
Alt & MButton::Send "{Volume_Mute}"

; Restart on Display Change
OnMessage 0x7E, handle_display_change
handle_display_change(wParam, lParam, *)
{
    RunWait("komorebic.exe stop", , "Hide")
    RunWait("komorebic.exe start", , "Hide")
    RunWait("komorebic retile", , "Hide")
}
