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

; Autostart
homeDir := EnvGet("USERPROFILE")
; resizePath := homeDir "\.local\bin\resize.ahk"
; if !(PID := ProcessExist("resize.ahk"))
;   Run(resizePath, , "Hide")
if !(PID := ProcessExist("kanata.exe"))
  Run("kanata -c" homeDir "\.config\kanata\config.kbd", , "Hide")

; Launching Programs
#t::Run("wt -d " homedir)
; #t::Run("wezterm-gui")
#+e::Run("explorer")


Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

; Manipulating windows
#f::Komorebic("toggle-float")
#m::Komorebic("toggle-monocle")
#+m::Komorebic("manage")
#e::Komorebic("retile")
#+c::WinClose("A")
#+q::ExitApp
#+r::{
  Reload
  Komorebic("reload-configuration")
}

; Resizing Windows
#h::Komorebic("resize-axis horizontal decrease")
#l::Komorebic("resize-axis horizontal increase")

; Jumping Between Windows
#j::Komorebic("cycle-focus previous")
#k::Komorebic("cycle-focus next")
#+j::Komorebic("move down")
#+k::Komorebic("move up")
#+l::Komorebic("move right")
#+::Komorebic("promote")
#+p::Komorebic("toggle-pause")

; Toggling Workspaces
#1::Komorebic("focus-workspace 0")
#2::Komorebic("focus-workspace 1")
#3::Komorebic("focus-workspace 2")
#4::Komorebic("focus-workspace 3")
#5::Komorebic("focus-workspace 4")

; Moving Workspaces
#+1::Komorebic("move-to-workspace 0")
#+2::Komorebic("move-to-workspace 1")
#+3::Komorebic("move-to-workspace 2")
#+4::Komorebic("move-to-workspace 3")
#+5::Komorebic("move-to-workspace 4")

; Multi-Monitor Setup
#,::Komorebic("cycle-monitor previous")
#.::Komorebic("cycle-monitor next")
#+,::Komorebic("cycle-move-to-monitor previous")
#+.::Komorebic("cycle-move-to-monitor next")

; Restart on Display Change
OnMessage 0x7E, handle_display_change
handle_display_change(wParam, lParam, *)
{
    Komorebic("stop")
    Komorebic("start")
    Komorebic("retile")
}


