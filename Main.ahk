; ********************************* Main ***********************************************
; Author: Thomas Southcott
; Date: 2024-07-26
#Requires AutoHotkey v2.0
#SingleInstance force

#Include lib\ui\LayerSelect.ahk
#Include lib\ui\ViewShortcuts.ahk
#Include Macros.ahk

UseGDIP()
TraySetIcon("img\icon.ico")
; MODE 0 = Macro Mode
; MODE 1 = Layer Selection Mode
; MODE 2 = Changing Layer
global mode := 0
global config := GetMacros()
global selectionGui := LayerSelectGui(config, True)

; *********************** Macro Functions ********************************
; key: string - the key used to toggle layer selection
ToggleLayerSelection(key)
{
   ; variables
   global selectionGui
   global mode
   ; enable layer selection mode
   mode := 1 
   selectionGui.Show()
   KeyWait(key)
   mode := 0 
   selectionGui.Hide()
}

; button: int - the button number pressed
ActivateOrSelectMacro(button)
{
   global mode
   global selectionGui
   global config
   ; if Layer Selection mode is enabled
   if (mode == 1) {
      mode := 2
      oldLayer := selectionGui.GetSelectedLayer()
      try {         
         selectionGui.SelectLayer(button)
         mode := 1
      } catch Error {
         MsgBox("There is no layer for this button.")
         selectionGui.SelectLayer(oldLayer)
         mode := 1
         return
      }
      return
   } 
   ; if Macro mode is enabled
   else if (mode == 0) {
      ; get the selected layer
         selectedLayer := selectionGui.GetSelectedLayer()
         ; function of button on the selected layer
         config.layers[selectedLayer].macros[button].action()
      try {
      } catch Error {
         MsgBox("There is no macro for this button.")
         return
      }
   }
   ; do nothing if changing layer
}

; *********************** Key Bindings ********************************
; EDIT HERE
; +----------+---------+---------+---------+
; | F17 = 1  | F18 = 2 | F19 = 3 | F20 = 4 |
; | F21 = Fn | F22 = 5 | F23 = 6 | F24 = 7 |
; +----------+---------+---------+---------+
F17:: ; 1
{
   button := 1
   ActivateOrSelectMacro(button)
}

F18:: ; 2
{
   button := 2
   ActivateOrSelectMacro(button)
}

F19:: ; 3
{
   button := 3
   ActivateOrSelectMacro(button)
}

; Function Key - Double Tap to view shortcuts on selected layer
*F21:: ; Fn
{   
   key := 'F21'
   ; variables
   global selectionGui
   global config
   global mode
   ; if F21 is released within 100ms
   if KeyWait(key, 'T0.1') {
      ; and F21 is pressed again within another 100ms
      if KeyWait(key, 'D T0.1') {
         ; show the shortcuts for the selected layer
         preview := ViewShortcutsGui(config.layers[selectionGui.GetSelectedLayer()])
         preview.Show()                             
         return
      }
   } else {                                                       ; F21 was held for more than 100ms
      ToggleLayerSelection(key)
   }
   
}

F20:: ; 4
{
   button := 4
   ActivateOrSelectMacro(button)
}

F22:: ; 5
{
   button := 5
   ActivateOrSelectMacro(button)
}

F23:: ; 6
{
   button := 6
   ActivateOrSelectMacro(button)
}

F24:: ; 7
{
   button := 7
   ActivateOrSelectMacro(button)
}

; -----------------------------------------------------------------------------------------------
; Loads and initializes the Gdiplus.dll.
; Must be called once before you use any of the DLL functions.
; -----------------------------------------------------------------------------------------------
#DllLoad "Gdiplus.dll"
UseGDIP() {
   Static GdipObject := 0
   If !IsObject(GdipObject) {
      GdipToken := 0
      SI := Buffer(24, 0) ; size of 64-bit structure
      NumPut("UInt", 1, SI)
      If DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", &GdipToken, "Ptr", SI, "Ptr", 0, "UInt") {
         MsgBox("GDI+ could not be startet!`n`nThe program will exit!", A_ThisFunc, 262160)
         ExitApp
      }
      GdipObject := {__Delete: UseGdipShutDown}
   }
   UseGdipShutDown(*) {
      DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", GdipToken)
   }
}