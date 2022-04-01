import UIKit
import AVFoundation

class KeyboardViewController: UIInputViewController {
    
    var heightConstraint: NSLayoutConstraint!
    
    var buttons : [[UIButton]]!
    
    var layout = [
        ["1","2","3","4","5","6","7","8","9","0","-","⌫"],
        ["Q","W","E","R","T","Y","U","I","O","P", "⏎"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M",",","."],
        ["🌐"," "]
    ]
    
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
        super.viewDidLoad()
        
        self.mapping = self.load()
        
        var brightness = CGFloat(0.75);

        if (traitCollection.userInterfaceStyle == .dark)
        {
            brightness = CGFloat(0.5);
        }
        
        self.buttons = [[UIButton]]()
        for (row_index, row) in layout.enumerated()
            {
            self.buttons.append([UIButton]())
            for (key_index, key) in row.enumerated()
            {
                let button = UIButton()
                button.backgroundColor=UIColor.init(hue: CGFloat(key_index)/CGFloat(row.count), saturation: 0.5, brightness: brightness, alpha: 1)
                self.buttons[row_index].append(button)
                self.view.addSubview(self.buttons[row_index][key_index])
                self.buttons[row_index][key_index].setTitle(key, for: .normal)
                self.buttons[row_index][key_index].addAction( UIAction(title: key) { action in
                    let pressed = action.title
                    self.keyPressed(pressed: pressed)
                    let button = (action.sender as! UIButton)
                    let s = button.titleLabel!.font.pointSize
                    button.titleLabel!.font = UIFont.systemFont(ofSize: s/2)
                    button.alpha = 1.0
                }, for: .touchUpInside)
                self.buttons[row_index][key_index].addAction( UIAction(title: key) { action in
                    let pressed = action.title
                    self.keyPressed(pressed: pressed)
                    let button = (action.sender as! UIButton)
                    let s = button.titleLabel!.font.pointSize
                    button.titleLabel!.font = UIFont.systemFont(ofSize: s/2)
                    button.alpha = 1.0
                }, for: .touchUpOutside)
                self.buttons[row_index][key_index].addAction( UIAction(title: key) { action in
                    let button = (action.sender as! UIButton)
                    button.alpha = 0.9
                    let s = button.titleLabel!.font.pointSize
                    button.titleLabel!.font = UIFont.systemFont(ofSize: s*2)
                    AudioServicesPlaySystemSound(1104)
                }, for: .touchDown)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        let margin = CGFloat(0.95)
        
        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height
        
        let height = viewHeight/CGFloat(self.buttons.count)
        let innerHeight = height * margin
        let marginHeight = height * (1-margin)/2
        for (row_index, row) in self.buttons.enumerated()
        {
            var width = viewWidth/CGFloat(row.count)
            var innerWidth = width * margin
            let marginWidth = width * (1-margin)/2
            for (key_index, key) in row.enumerated() {
                if (row_index < 2) {
                    width = viewWidth/CGFloat(row.count+1)
                    if (key_index == row.count-1) {
                        innerWidth = width * margin * 2
                    } else {
                        innerWidth = width * margin
                    }
                }
                
                if (row_index == 4) {
                    width = viewWidth / 6
                    if (key_index == 0) {
                        innerWidth = width * margin
                    }
                    else
                    {
                        innerWidth = viewWidth * 5 / 6 * margin
                    }
                }
                
                
                key.frame = CGRect(x: CGFloat(key_index)*width+marginWidth, y: CGFloat(row_index)*height+marginHeight, width: innerWidth, height: innerHeight)
                key.layer.cornerRadius = height / 5
            }
        }
    }

    
    override func textWillChange(_ textInput: UITextInput?) {
        
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
      
    }
    
    
}
