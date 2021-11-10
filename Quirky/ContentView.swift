//
//  ContentView.swift
//  Quirky
//
//  Created by Lee Hanken on 23/10/2021.
//

import SwiftUI

private let columns = 6

private let mainKeys = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"]

func load () -> [String:String] {
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
        print("\(error)")
        return result
    }
    return result
}

struct KeyMap: Identifiable  {
    var id: Int
    var key: String
    var glyph: String
}

struct KeyMapName: Identifiable  {
    var id: Int
    var preview: String
}

func loadMap () -> [KeyMap] {
    var result = [KeyMap]()
    let mappings = load()
    for (index, mapping) in mappings.enumerated() {
        let map = KeyMap(id: index, key: mapping.key, glyph: mapping.value)
        result.append(map)
    }
    result.sort { (lhs: KeyMap, rhs: KeyMap) -> Bool in
        return lhs.key < rhs.key
    }
    return result
}

extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars

        return scalars[scalars.startIndex].value
    }
}

private var allGlyphs  = assembleGlyphs()

func glyph(u: Int) -> Character {
    guard let s = Unicode.Scalar(UInt32(u)) else { return Character(".") }
    return Character(s)
}

func filterUnicode(char: Character) -> Bool{
    if (NSCharacterSet.uppercaseLetters.contains(UnicodeScalar(char.unicodeScalarCodePoint())!)) {
        return true
    }
    if (NSCharacterSet.symbols.contains(UnicodeScalar(char.unicodeScalarCodePoint())!)) {
        return true
    }
    if (NSCharacterSet.decimalDigits.contains(UnicodeScalar(char.unicodeScalarCodePoint())!)) {
        return true
    }
    return false
}

func assembleGlyphs() -> [String] {
    var glyphs = [String]()
    for code in 0...65536 {
        let g = glyph(u: code)
        if (filterUnicode(char: g)) {
            glyphs.append(String(g))
        }
    }
    return glyphs
}

func glyphAtIndex(index: Int) -> String {
    let c = allGlyphs.count
    return allGlyphs[index % c]
}

func glyphRow(start: Int) -> [String] {
    var result = [String]()
    for index in start...start+columns {
        result.append(glyphAtIndex(index: index))
    }
    return result
}


class KeyListModel: ObservableObject {
    @Published var keylist = [KeyMap]()
    
    init() {
        keylist = loadMap()
    }
    
    func changeGlyph(key: String, glyph: String) {
        let index = self.keylist.firstIndex(where: {$0.key == key})
        self.keylist[index!].glyph = glyph
        self.objectWillChange.send()
        self.saveAndApplyCurrent()
    }
    
    func preview() -> String {
        var result = ""
        for key in mainKeys {
            let index = self.keylist.firstIndex(where: {$0.key == key})
            result = result + self.keylist[index!].glyph
        }
        return result
    }
    
    func save () {
        let data = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("savedmappings.json")
        var jsonResult = [String:[[String:[String:String]]]]()
        if FileManager.default.fileExists(atPath: data.path) {
            do {
                let jsonData = try NSData(contentsOfFile: data.path, options: .mappedIfSafe)
                jsonResult = (try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)! as! [String : [[String : [String : String]]]]
            } catch {
                print("read error")
                return
            }
        }
        var listDict = [[String:[String:String]]]()
        for key in self.keylist {
            listDict.append([String(key.id):[key.key:key.glyph]])
        }
        jsonResult[self.preview()] = listDict

        do {
            let newJsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
            try newJsonData.write(to: data)
        } catch {
            print ("write error")
            return
        }
    }
    
    func load(index: String) {
        let data = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("savedmappings.json")
        var jsonResult = [String:[[String:[String:String]]]]()
        if FileManager.default.fileExists(atPath: data.path) {
            do {
                let jsonData = try NSData(contentsOfFile: data.path, options: .mappedIfSafe)
                jsonResult = (try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)! as! [String : [[String : [String : String]]]]
            } catch {
                print("read error")
                return
            }
        }
        
        var newMap = [KeyMap]()
        var i = 0
        for (preview, results) in jsonResult {
            if preview==index {
                for result in results {
                    for (x, keys) in result {
                        for (k, g) in keys {
                            newMap.append(KeyMap(id: Int(x)!, key: k, glyph: g))
                        }
                    }
                }
                self.keylist = newMap
                self.objectWillChange.send()
                self.saveAndApplyCurrent()
            }
            i = i + 1
        }
    }
    
    func list() -> [KeyMapName] {
        
        let data = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("savedmappings.json")
        var jsonResult = [String:[[String:[String:String]]]]()
        if FileManager.default.fileExists(atPath: data.path) {
            do {
                let jsonData = try NSData(contentsOfFile: data.path, options: .mappedIfSafe)
                jsonResult = (try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary)! as! [String : [[String : [String : String]]]]
            } catch {
                print("read error")
                return [KeyMapName]()
            }
        }
        var items = [KeyMapName]()
        var index = 0
        for (preview, _) in jsonResult {
            items.append(KeyMapName(id: index, preview: preview))
            index = index + 1
        }
        return items
    }
    
    func saveAndApplyCurrent () {
        let data = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("keymapping.json")
        var mappings = [[String:String]]()
        for keyMap in self.keylist {
            var dict = [String:String]()
            dict["key"]=keyMap.key
            dict["glyph"]=keyMap.glyph
            mappings.append(dict)
        }
        var dictionary = [String:[[String:String]]]()
        dictionary["mappings"] = mappings
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            try jsonData.write(to: data)
        } catch {
            print("\(error)")
        }
    }
}

func setup() -> Bool {
    let version = UserDefaults.standard.value(forKey: "version_pref") as? String ?? "0"
    
    if (version == "0") {
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        UserDefaults.standard.setValue( version, forKey: "version_pref")
        
        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: {_ in
        })
    }
    
    return true
}

struct ContentView: View {
    @State var showSheet = false
    @State var showLoadList = false
    @State var currentKey = KeyMap(id:0, key:"A", glyph:"ᗩ")
    @ObservedObject var model = KeyListModel()
    var done = setup()
    
    var body: some View {
        VStack {
            List(model.keylist, id: \.id) {k in
                HStack {
                    Spacer()
                    Text(k.key)
                        .font(.system(size: 60))
                        .foregroundColor(Color.primary)
                    Spacer()
                    Spacer()
                    Button(action: {
                        currentKey = k
                        showSheet = true
                    }) {
                        Text(k.glyph)
                            .font(.system(size: 60))
                            .foregroundColor(Color.primary)
                    }
                    Spacer()
                }
            }.sheet(isPresented: $showSheet) {
                DetailView(showSheet: self.$showSheet, key: $currentKey, callback: model.changeGlyph )
            }
            HStack {
                Button (action: {
                    showLoadList = true
                }) {
                    Text("Load")
                        .font(.system(size: 30))
                        .foregroundColor(Color.primary)
                }.padding()
                    .sheet(isPresented: $showLoadList) {
                        LoadListView(showLoadList: $showLoadList, model: self.model, callback: model.load)
                    }
                Spacer()
                Button (action: {
                    model.save()
                }) {
                    Text("Save")
                        .font(.system(size: 30))
                        .foregroundColor(Color.primary)
                }.padding()
            }
        }
    }
}

struct LoadListView: View {
    @Binding var showLoadList: Bool
    var model: KeyListModel
    var callback: (String) -> Void
    
    var body: some View {
        List(model.list()) { m in
            Button(action: {
                callback(m.preview)
                showLoadList = false
            }) {
                Text(m.preview)
                    .font(.system(size: 30))
                    .foregroundColor(Color.primary)
            }
        }
    }
}

struct DetailView: View {
    @Binding var showSheet: Bool
    @Binding var key: KeyMap

    var callback: (String, String) -> Void
    
    var body: some View {
        VStack {
            Button( action: {
                self.showSheet.toggle()
            }, label: {
                Text(key.glyph)
                    .font(.system(size: 120))
            }).buttonStyle(PlainButtonStyle())
            List {
                ForEach( Array(stride(from: 32, to: allGlyphs.count, by: columns)), id: \.self) { start in
                    HStack {
                        Spacer()
                        let glyphs = glyphRow(start: start)
                        ForEach (glyphs, id: \.self) { glyph in
                                Button ( action: {
                                    key.glyph = glyph
                                    callback(key.key, glyph)
                                },
                                label: {
                                    Text(glyph)
                                        .font(.system(size: 40))
                                })
                                Spacer()
                        }
                    }
                }
            }
                .buttonStyle(PlainButtonStyle())
        }
    }
}
