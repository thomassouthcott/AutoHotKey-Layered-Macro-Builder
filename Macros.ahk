; ********************************* Configured Macros *********************************
; Author: Thomas Southcott
; Date: 2024-07-26
; 
; This file contains all the configured layers and macros for the Macro Manager.
; The Macro Manager is a tool that allows you to create and manage macros for your AutoHotkey scripts by only creating these objects. The Macro Manager will then handle the rest.
; 
; Create a new MacroLayer object with the argument, buttons:int - the amount of non-function buttons available.
; Call the AddNewLayer function on the MacroLayers object with the arguments, 
;   title:string - the name of the layer
;   icon:filepath - the path to the regular icon image
;   selected:filepath - the path to the selected icon image
;   newMacros: array of Macro objects with the argument for each being,
;           hotkey:string - the name for the Macro
;           action:function - the function to be called
;
; IMPORTANT: Only add the function name to the Macro object, not the function call.
; Example: 
; ...
; Macro("Toggle Breakpoint", ToggleBreakpoint)
; ...
; ToggleBreakPoint(args) {
;    Send("{F9}")
; }
; ...
#Requires AutoHotkey v2.0
#SingleInstance force

#Include lib\MacroObjects.ahk
#Include lib\ui\ViewShortcuts.ahk
; Example of a configured MacroLayers object
; For a macro keyboard with these bindings:
; F17 = 1  | F18 = 2 | F19 = 3 | F20 = 4
; F21 = Fn | F22 = 5 | F23 = 6 | F24 = 7
GetMacros() {
    ; EDIT HERE
    configuredLayers := MacroLayers(7)
    configuredLayers.AddNewLayer("Default Shortcuts", "img/default.ico", "img/default_selected.ico", [
        Macro("View Layer Shortcuts", ShowShortcuts),
        Macro("Chrome", ActivateOrOpenChrome),
        Macro("Previous Tab", ChromePreviousTab),
        Macro("Next Tab", ChromeNextTab),
        Macro("Previous Desktop", PreviousDesktop),
        Macro("Task View", TaskView),
        Macro("Next Desktop", NextDesktop)
    ])
    configuredLayers.AddNewLayer("Debugger Shortcuts", "img/debugger.ico", "img/debugger_selected.ico", [
        Macro("View Layer Shortcuts", ShowShortcuts),
        Macro("Toggle Breakpoint", ToggleBreakpoint),
        Macro("Step Over", StepOver),
        Macro("Step Into", StepInto),
        Macro("Step Out", StepOut),
        Macro("Continue", StartContinue),
        Macro("Stop", Stop),
    ])
    configuredLayers.AddNewLayer("Putty Shortcuts", "img/cli.ico", "img/cli_selected.ico", [
        Macro("View Layer Shortcuts", ShowShortcuts),
        Macro("Open Putty", ActivateOrOpenPutty),
        Macro("SSH Raspberry Pi", SshRaspberryPi)
    ])
    configuredLayers.AddNewLayer("Windows Shortcuts", "img/settings.ico", "img/settings_selected.ico", [
        Macro("View Layer Shortcuts", ShowShortcuts),
        Macro("Turn Monitors Off", TurnMonitorsOff),
        Macro("", NoAction), ; Skip a button
        Macro("", NoAction), ; Skip a button
        Macro("Lock", Lock),
        Macro("Restart", Restart),
        Macro("Shutdown", Shutdown)
    ])
    return configuredLayers
}

; *************************** Actions ***************************
; *********************** Putty Functions ***********************
SshRaspberryPi(arg) {
    OpenSshSession("pi", "192.168.1.234")
    return
}

; *********************** Debugger Functions *********************
ToggleBreakpoint(arg) {
    Send("{F9}")
    return
}

StepOver(arg) {
    Send("{F10}")
    return
}

StepInto(arg) {
    Send("{F11}")
    return
}

StepOut(arg) {
    Send("{Shift Down}{F11}{Shift Up}")
    return
}

StartContinue(arg) {
    Send("{F5}")
    return
}

Stop(arg) {
    Send("{Ctrl Down}{Shift Down}{F5}{Shift Up}{Ctrl Up}")
    return
}

; *********************** Chrome Functions ***********************

ChromePreviousTab(arg) {
    Send("{Ctrl Down}{Shift Down}{Tab}{Shift Up}{Ctrl Up}")
    return
}

ChromeNextTab(arg) {
    Send("{Ctrl Down}{Tab}{Ctrl Up}")
    return
}

; *********************** Desktop Management Functions *********************
PreviousDesktop(arg) {
    Send("{Ctrl Down}{LWin Down}{Left}{LWin Up}{Ctrl Up}")
    return
}

TaskView(arg) {
    Send("{LWin Down}{Tab}{LWin Up}")
    return
}

NextDesktop(arg) {
    Send("{Ctrl Down}{LWin Down}{Right}{LWin Up}{Ctrl Up}")
    return
}

; *********************** Windows Functions *********************
Restart(arg)
{
   DllCall("ExitWindowsEx", "UInt", 2, "UInt", 0)
   return
}

Shutdown(arg)
{
   Run("shutdown /s /t 1")
   return
}

Lock(arg)
{
   DllCall("LockWorkStation")
   return
}

TurnMonitorsOff(arg)
{
   Sleep 1000
   SendMessage(0x112,0xF170,2,,"Program Manager")
   return
}

; *********************** Helper Functions *********************

ActivateOrOpen(window, program, args)
{
   ; check if window exists
   if WinExist(window)
	{
		if WinActive(window)
        {
            ; Uses the last found window.
            WinActivateBottom window 
        } 
        else
        {
            ; Uses the last found window.
            WinActivate  
        }
	}
    ; else start requested program
	else    
	{
        ;use cmd in hidden mode to launch requested program
        Run('cmd /c "start ^"^" ^"' program '^" ^"' args '^""',,"Hide")
        ; wait up to 5 seconds for window to exist
		WinWait(window,,5)
		IfWinNotActive(window)
		{
            ; Uses the last found window.
		    WinActivate
		}
	}
	return
}

ActivateOrOpenPutty(arg)
{
    window := "ahk_exe putty.exe"
    if WinExist(window)
    {
        if WinActive(window)
        {
            ; Uses the last found window.
            WinActivateBottom window
        }
        else
        {
            ; Uses the last found window.
            WinActivate
        }
    }
    else
    {
        ;use cmd in hidden mode to launch requested program
        Run('cmd /c "start ^"^" ^"putty^""',,"Hide")
        ; wait up to 5 seconds for window to exist
        WinWait(window,,,5)
        IfWinNotActive(window)
        {
            ; Uses the last found window.
            WinActivate
        }
    }
    return
}

ActivateOrOpenChrome(arg)
{
   ; check if window exists
   window := "ahk_exe chrome.exe"
   if WinExist(window)
   {      
      if WinActive(window) {
        ; Uses the last found window.
        WinActivateBottom window
      }
      else {
        ; Uses the last found window.
        WinActivate
      }
   }
   ; else start requested program
   else
   {   
        ;use cmd in hidden mode to launch requested program
        Run('cmd /c "start ^"^" ^"chrome.exe^""',,"Hide") 
        ; wait up to 5 seconds for window to exist
        WinWait(window,,,5)
        IfWinNotActive(window)
        {
            ; Uses the last found window.
            WinActivate 
        }
   }
   return
}

OpenSshSession(username, server)
{
    window := "ahk_exe putty.exe"
    Run('cmd /c "start putty ' username '@' server '"',,"Hide")
    WinWait(window,,,5)
    IfWinNotActive(window)
    {
        WinActivate
    }
    return
}

OpenSshSessionWithKey(username, server, key)
{
    window := "ahk_exe putty.exe"
    Run('cmd /c "start putty ' username '@' server ' -i ' key '"',,"Hide")
    WinWait(window,,,5)
    IfWinNotActive(window)
    {
        WinActivate
    }
    return
}

ShowShortcuts(args)
{
    for (i, layer in GetMacros().layers)
    {
        for (j, macro in layer.macros)
        {
            if (macro.hotkey == args.hotkey)
            {
                viewShortcutGui := ViewShortcutsGui(layer)
                viewShortcutGui.Show()
                return
            }
        }
    }
    return
}

EncodeInteger(ref, val)
{
	return DllCall("ntdll\RtlFillMemoryUlong", "Uint", ref, "Uint", 4, "Uint", val)
}

NoAction(args)
{
    return
}