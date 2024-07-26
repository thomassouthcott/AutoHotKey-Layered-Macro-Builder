; ************************* Macro, Layer and Sets of Layers ****************************
; Author: Thomas Southcott
; Date: 2024-07-26
#Requires AutoHotkey v2.0
#SingleInstance force

; Macro Layers Object
; A collection of Macro Layers, each layer has a set of Macros.
; Max amount of buttons available is the max number of layers.
; layers: array[MacroLayer] - array of MacroLayer objects
; max: int - maximum amount of buttons for layers
class MacroLayers {
    ; buttons: int - the amount of non-function buttons available
    __New(buttons) {
        this.layers := [],
        this.max := buttons
    }

    GetLayerCount() {
        return this.layers.Length
    }
    
    ; title: string - name of the Layer
    ; icon: filepath - path to the regular icon image
    ; selected: filepath - path to the selected icon image
    ; newMacros: array[Macro] - array of Macro objects
    AddNewLayer(title, icon, selected, newMacros) {
        if (newMacros.Length > this.max) {
            message := "Too many macros " newMacros.Length " for this amount of buttons (" this.max "). - " title " Layer"
            throw Error(message)
        }
        this.layers.Push(MacroLayer(title, icon, selected, this.max))
        for macro in newMacros {
            this.layers[this.layers.Length]._AddNewMacro(macro)
        }
    }
}

; Macro Layer Object
; A layer of Macros, macros buttons 1 - max are the macros
; title: string - name of the Layer
; icon: filepath - path to the regular icon image
; selected: filepath - path to the selected icon image
; macros: array[Macro] - array of Macro objects
; max: int - maximum amount of buttons for macros
class MacroLayer {
    ; title: string - name of the Layer
    ; icon: filepath - path to the regular icon image
    ; selected: filepath - path to the selected icon image
    ; max: int - maximum amount of buttons for macros
    __New(title, icon, selected, buttons) {
        this.title := title
        this.icon := icon
        this.selected := selected
        this.macros := [], 
        this.max := buttons
    }

    ; newMacro: Macro - Macro object
    _AddNewMacro(newMacro) {
        if (this.macros.Length >= this.max) {
            message := "Too many macros " this.macros.Length + 1 " for a new button (" this.max "). - " this.title " Layer"
            throw Error(message)
        }
        this.macros.Push(newMacro)
    }
}

; Macro Object
; A macro, description and function to call on activation
; hotkey: string - name for the Macro
; action: function - function to be called
class Macro {
    ; hotkey: string - name for the Macro
    ; action: function - function to be called
    __New(hotkey, action) {
        this.hotkey := hotkey
        this.action := action
    }
}