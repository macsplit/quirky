import UIKit
import SwiftUI
import AVFoundation
import KeyboardKit

extension Dictionary where Value : Hashable {

    func swapKeyValues() -> [Value : Key] {
        var newDict = [Value : Key]()
        for (key, value) in self {
            newDict[value] = key
        }
        return newDict
    }
}

class QuirkyKeyboardActionHandler: StandardKeyboardActionHandler {
    
    public init(inputViewController: KeyboardInputViewController) {
         super.init(inputViewController: inputViewController)
     }
     
     override func action(
         for gesture: KeyboardGesture,
         on action: KeyboardAction
     ) -> KeyboardAction.GestureAction? {
        return super.action(for: gesture, on: action)
     }
     
}

class QuirkyKeyboardStyleProvider: StandardKeyboardStyleProvider {
    
    var mapping : [String:String]
    
    init(
        keyMap: [String:String], keyboardContext : KeyboardContext
    ) {
        self.mapping = keyMap.swapKeyValues()
        super.init(keyboardContext: keyboardContext)
    }
    
    private func keyColor(colorIndex: Int, bright: Bool) -> Color {
        var brightness = CGFloat(0.75);

        @Environment(\.colorScheme) var colorScheme

        if (colorScheme == .dark) {
            brightness = CGFloat(0.5);
        }
        
        if (bright) {
            brightness = CGFloat(1.0);
        }
        
        return Color.init(hue: Double(colorIndex) / 12, saturation: 0.5, brightness: brightness)
    }
    
    var colors : [String: Int] = [
           "A": 0,
           "B": 4,
           "C": 2,
           "D": 2,
           "E": 2,
           "F": 3,
           "G": 4,
           "H": 5,
           "I": 7,
           "J": 6,
           "K": 7,
           "L": 8,
           "M": 6,
           "N": 5,
           "O": 8,
           "P": 9,
           "Q": 0,
           "R": 3,
           "S": 1,
           "T": 4,
           "U": 6,
           "V": 3,
           "W": 1,
           "X": 1,
           "Y": 5,
           "Z": 0,
           "0": 9,
           "1": 0,
           "2": 1,
           "3": 2,
           "4": 3,
           "5": 4,
           "6": 5,
           "7": 6,
           "8": 7,
           "9": 8,
           "-": 10,
           ",": 7,
           ".": 8,
           "⏎": 10,
           "space": 5,
           "return": 11
       ]
    
    override func buttonStyle(
        for action: KeyboardAction,
        isPressed: Bool
    ) -> KeyboardStyle.Button {
        
        var colorIndex = 0
        
        let char = action.standardButtonText(for: keyboardContext) ?? ""
        
        if (char != "space" && char != "return") {
            colorIndex = colors[mapping[char] ?? ""] ?? 0
        } else {
            colorIndex = colors[char] ?? 0
        }
        
        if (action == KeyboardAction.backspace) {
            colorIndex = 11
        }
        
        var style = super.buttonStyle(for: action, isPressed: isPressed)
        style.backgroundColor = keyColor(colorIndex: colorIndex, bright: isPressed)
        
        if (action == KeyboardAction.backspace) {
            var size: CGFloat = 16
            if (keyboardContext.isKeyboardFloating) {
                size *= 0.5
            }
            style.font?.type = .custom("Helvetica", size: size)
        } else if (action == KeyboardAction.nextKeyboard) {
            var size: CGFloat = 20
            if (keyboardContext.isKeyboardFloating) {
                size *= 0.5
            }
            style.font?.type = .custom("Helvetica", size: size)
        }
        
        
        if (isPressed) {
            style.font?.weight = .bold
        }
        
        return style
    }
    
    override func buttonText(for action: KeyboardAction) -> String? {
        var text = action.standardButtonText(for: keyboardContext)

        if (text == "space") {
            text = " "
        } else if (text == "return") {
            text = "⏎"
        }
        
        return text
    }

}

class QuirkyKeyboardLayoutProvider: StandardKeyboardLayoutProvider {
    
    var mapping : [String:String]
    
    init(
        keyMap: [String:String],
        baseProvider: KeyboardLayoutProvider = EnglishKeyboardLayoutProvider(),
        localizedProviders: [KeyboardLayoutProvider & LocalizedService] = []
    ) {
        self.mapping = keyMap
        super.init(baseProvider: baseProvider, localizedProviders: localizedProviders)
    }
    
    var keyLayout = [
        ["1","2","3","4","5","6","7","8","9","0","-","⌫"],
        ["Q","W","E","R","T","Y","U","I","O","P","⏎"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M",",","."],
        ["🌐"," "]
    ]
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let stdLayout = super.keyboardLayout(for: context)
        let stdFirstKey = stdLayout.itemRows[0][0]
        var stdSize = stdFirstKey.size.height
        var scale : CGFloat = 1
        
        if (context.isKeyboardFloating) {
            stdSize *= 0.5
            scale = 0.5
        }
        
        let Portrait = context.interfaceOrientation.isPortrait
 
        let iPhone = (UIDevice.current.userInterfaceIdiom == .phone)

        var extrascale = 1.0
        
        if (iPhone) {
            if (Portrait) {
                extrascale = 0.4
            } else {
                extrascale = 1.5
            }
        }
        
        
        var itemRows = [KeyboardLayoutItem.Row]()
        keyLayout.forEach { row in
            var itemRow = KeyboardLayoutItem.Row()
            row.forEach { char in
                var size: KeyboardLayoutItem.Size
                if (char == " ") {
                    size = KeyboardLayoutItem.Size(width: .available, height: stdSize)
                } else if (char == "🌐" || char == "⏎") {
                    size = KeyboardLayoutItem.Size(width: .points(stdSize * 1.5 * scale * extrascale), height: stdSize)
                } else if (char == "⌫") {
                    size = KeyboardLayoutItem.Size(width: .points(stdSize * 1.4 * scale * extrascale), height: stdSize)
                }else {
                    size = KeyboardLayoutItem.Size(width: .available, height: stdSize)
                }
                let insets = EdgeInsets(top:3*scale, leading:3*scale, bottom:3*scale, trailing:3*scale)
                var action: KeyboardAction
                if (char == "⌫") {
                    action = KeyboardAction.backspace
                } else if (char == "⏎") {
                    action = KeyboardAction.primary(.return)
                } else if (char == "🌐" ) {
                    action = KeyboardAction.nextKeyboard
                } else if (char == " ") {
                    action = KeyboardAction.space
                } else {
                    action = KeyboardAction.character(mapping[char] ?? "")
                }
                let item = KeyboardLayoutItem(action: action, size: size, insets: insets)
                itemRow.append(item)
            }
            itemRows.append(itemRow)
        }
        let layout = KeyboardLayout(itemRows: itemRows)
        return layout
    }
}

class KeyboardViewController: KeyboardInputViewController {
    
    var buttons : [[UIButton]]!
    
    var mapping = [
        "A":"ᗩ",
        "B":"Ᏼ",
        "C":"Ꮯ",
        "D":"Ꭰ",
        "E":"Σ",
        "F":"F",
        "G":"Ꮹ",
        "H":"Ꮋ",
        "I":"I",
        "J":"J",
        "K":"Ƙ",
        "L":"L",
        "M":"ᗰ",
        "N":"Ν",
        "O":"Ꮎ",
        "P":"ᑭ",
        "Q":"Q",
        "R":"Я",
        "S":"ᔕ",
        "T":"Τ",
        "U":"Ʉ",
        "V":"▽",
        "W":"Ꮤ",
        "X":"᙭",
        "Y":"Ψ",
        "Z":"Ζ",
        "0":"Օ",
        "1":"1",
        "2":"2",
        "3":"3",
        "4":"4",
        "5":"5",
        "6":"6",
        "7":"7",
        "8":"8",
        "9":"9",
        "-":"-",
        ",":",",
        ".":"."
    ]
    

    
    private func load () -> [String:String] {
        var result = [String:String]()
        do {
            let data = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("keymapping.json")
            let jsonData = try NSData(contentsOfFile:  data.path, options: .mappedIfSafe)
            let jsonResult: NSDictionary = (try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)!
            let arr = jsonResult["mappings"] as! [NSDictionary]
            for k in arr {
                result[k["key"] as! String] = k["glyph"] as? String
            }
        } catch {
            return self.mapping
        }
        return result
    }
    
    func keyPressed (pressed: String) {
        if (pressed == "⌫")
        {
            self.textDocumentProxy.deleteBackward()
        }
        else if (pressed == "⏎")
        {
            self.textDocumentProxy.insertText("\n")
        }
        else if (pressed == " ")
        {
            self.textDocumentProxy.insertText(" ")
        }
        else if (pressed == "🌐")
        {
            self.advanceToNextInputMode()
        }
        else
        {
            self.textDocumentProxy.insertText(self.mapping[pressed]!)
        }
    }
    
    override func viewDidLoad() {
        self.mapping = self.load()
        keyboardLayoutProvider = QuirkyKeyboardLayoutProvider(keyMap: self.mapping)
        keyboardStyleProvider = QuirkyKeyboardStyleProvider(keyMap: self.mapping, keyboardContext: self.keyboardContext)
        keyboardActionHandler = QuirkyKeyboardActionHandler(inputViewController: self)
        calloutActionProvider = DisabledCalloutActionProvider()
        super.viewDidLoad()
    }
    
    override func viewWillSetupKeyboard() {
         super.viewWillSetupKeyboard()
         setup { controller in
             VStack(spacing: 0) {
                 SystemKeyboard(
                     controller: controller,
                     autocompleteToolbar: .none
                 )
             }
         }
     }
    
    override func textWillChange(_ textInput: UITextInput?) {
        
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
      
    }
    
}
