; ********************************* GUI ***********************************************
; Author: Thomas Southcott
; Date: 2024-07-26
#Requires AutoHotkey v2.0
#SingleInstance force

#Include CreateImageButton.ahk

; Layer Selection Gui, appears when the function key is pressed.
class LayerSelectGui {
   ; layerMacros: MacroLayers - the MacroLayers object
   ; labels: boolean - whether to show the labels
   __New(layerMacros, labels := False) {
      ; Variables
      this.layerMacros := layerMacros

      this.buttons := []
      this.labels := []
      ; Window
      this.window := Gui()
      this.window.Opt("-MinimizeBox -MaximizeBox -SysMenu +AlwaysOnTop -Caption +Owner")
      this.window.Title := ""      
      ; Labels
      this.window.SetFont("c808080 bold italic", "Arial")
      if(labels) {
         x := 10
         Loop layerMacros.max {
            this.labels.Push(this.window.AddText("center x" x " y3 w64 h25", A_Index))
            x += 66
         }
      }
      this.window.BackColor := "0x010101"
      WinSetTransColor("010101", this.window)

      ; Buttons
      x := 10
      Loop layerMacros.max {
         this.buttons.Push(this.window.AddButton("x" x " y31 w64 h64 disabled"))
         x += 66
      }

      ; Initialize
      this.SelectLayer(1)      
   }

   GetSelectedLayer() {
      return this.__selectedLayer
   }

   ; value: int - the layer to select
   SelectLayer(value) {
      if (value <= 0 || value > this.GetLayerCount())
      {
         throw Error("Invalid layer")
      }

      this.__selectedLayer := value
      layer := this.layerMacros.layers[value]

      ;Clear labels
      for (i, label in this.labels)
      {
         label.Text := ""
      }      

      ;Set new labels
      if (this.labels.Length > 0)
      {
         for (i, macro in layer.macros)
         {
            this.labels[i].Text := macro.hotkey
         }
      }
      

      ;Clear buttons
      for (i, button in this.buttons)
      {
         CreateImageButton(button, 0, ["0x010101", , , 32], ["0x010101", , , 32])
      }

      ;Change selected icon
      for (i, layer in this.layerMacros.layers) 
      {
         button := this.buttons[i]
         if (i == value) 
         {
            CreateImageButton(button, 0, [layer.selected, , , 32], [layer.selected, , , 32])
         } 
         else
         {
            CreateImageButton(button, 0, [layer.icon, , , 32], [layer.icon, , , 32])
         }
      }
   }

   GetWindow() {
      return this.window
   }

   GetButtons() {
      return this.buttons
   }

   GetLabels() {
      return this.labels
   }

   GetLayerCount() {
      return this.buttons.Length
   }

   GetMacroCount() {
      return this.labels.Length
   }

   Show() {
      this.window.Show()
   }

   Hide() {
      this.window.Hide()
   }
}