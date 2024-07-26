; ********************************* View Shortcuts ***********************************************
; Author: Thomas Southcott
; Date: 2024-07-26
#Requires AutoHotkey v2.0

class ViewShortcutsGui {
    ; layer: MacroLayer
    __New(layer) {
        ; Window
        this.window := Gui()
        this.window.Opt("-MinimizeBox -MaximizeBox +AlwaysOnTop +Owner")
        this.window.Title := layer.title
        this.window.BackColor := "0xFFFFFF"
        this.window.OnEvent("Close", this.HandleClose)

        ; List of Macros
        list := this.window.Add("ListView", "h150", ["Btn", "Command"])
        for (i, macro in layer.macros) {
            list.Add("", "" . i, macro.hotkey)
        }
    }
 
    Show() {
        this.window.Show()
    }
 
    HandleClose() {
        this.Destroy()
    }
 }