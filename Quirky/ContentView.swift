//
//  ContentView.swift
//  Quirky
//
//  Created by Lee Hanken on 23/10/2021.
//

import SwiftUI
import UniformTypeIdentifiers

private let columns = 6

private let mainKeys = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"]

private let homoglyphs = [
    "," : ",",
    "-" : "-",
    "." : ".",
    "0" : "0OoΟοОоՕօ߀०০੦૦ଠ୦೦ഠ൦໐ဝ၀ჿዐᴏᴑⲞⲟⵔ〇ꓳ０Ｏｏ𐐄𐐬𐓂𐓪𝐎𝐨𝑂𝑜𝑶𝒐𝒪𝓞𝔒𝔬𝕆𝕠𝕺𝖔𝖮𝗈𝗢𝗼𝘖𝘰𝙊𝙤𝙾𝚘𝚶𝛐𝛔𝛰𝜊𝜎𝜪𝝄𝝈𝝤𝝾𝞂𝞞𝞸𝞼𝟎𝟘𝟢𝟬𝟶",
    "1" : "1Il|ƖǀΙІӀ׀וןا١۱ߊᛁℐℑℓ𝐈𝐥𝐼𝑙𝑰𝒍𝓁𝓘𝓵𝔩𝕀𝕝𝕴Ⅰⅼ∣Ⲓⵏꓲﺍ１Ｉｌ￨𐌉𐌠𝖑𝖨𝗅𝗜𝗹𝘐𝘭𝙄𝙡𝙸𝚕𝚰𝛪𝜤𝝞𝞘𝟏𝟙𝟣𝟭𝟷",
    "2" : "2ƧϨᒿ２𝟐𝟚𝟤𝟮𝟸",
    "3" : "3ƷȜЗӠⳌ𝟑𝟛𝟥𝟯𝟹",
    "4" : "4Ꮞ４𝟒𝟜𝟦𝟰𝟺",
    "5" : "5Ƽ５𝟓𝟝𝟧𝟱𝟻",
    "6" : "6бᏮⳒ６𝟔𝟞𝟨𝟲𝟼",
    "7" : "7７𐓒𝟕𝟟𝟩𝟳𝟽",
    "8" : "8Ȣȣ৪੪８𐌚𝟖𝟠𝟪𝟴𝟾⽇日",
    "9" : "9৭੧୨൭Ⳋ𝟗𝟡𝟫𝟵𝟿",
    "A" : "AΑАᎪᗅᴀꓮＡ𝐀𝐴𝑨𝒜𝓐𝔄𝔸𝕬𝖠𝗔𝘈𝘼𝙰𝚨𝛢𝜜𝝖𝞐ɅΛЛ٨۸ᐱⴷꓥ𐒰Δᐃ∆△ⵠᗄ∀ⱯꓯÁÀȦÂÄǍĂĀÃÅĄẤẦẮẰǠǺǞẪẴẢȀȂẨẲẠḀẬẶ🄐🄰🅐",
    "B" : "BʙΒВвᏴᏼᗷᛒℬꓐＢ𐌁𝐁𝐵𝑩𝓑𝔅𝔹𝕭𝖡𝗕𝘉𝘽𝙱𝚩𝛣𝜝𝝗𝞑ßβϐᏰꞵ𝛃𝛽𝜷𝝱𝞫ᙠꓭḃḂƀɃɓƁḅḄḇḆƃƂ🄑🄱🅑",
    "C" : "CϹСᏟᑕℂℭⅭ⊂Ⲥ⸦ꓚＣ𐌂𐐕𝐂𝐶𝑪𝒞𝓒𝕮𝖢𝗖𝘊𝘾𝙲©ⒸƆϽↃꓛ𐐣⼕匚⼖匸ĆĊĈČÇȻḈƇ🄒🄲🅒",
    "D" : "DᎠᗞᗪᴅⅅⅮꓓＤ𝐃𝐷𝑫𝒟𝓓𝔇𝔻𝕯𝖣𝗗𝘋𝘿𝙳ᗡꓷḊĎḐĐƊḌḒḎÐ🄓🄳🅓",
    "E" : "EΕЕᎬᴇℰ⋿ⴹꓰＥ𝐄𝐸𝑬𝓔𝔈𝔼𝕰𝖤𝗘𝘌𝙀𝙴𝚬𝛦𝜠𝝚𝞔ĔĚƎ∃ⴺꓱɛεϵ𝜖𝜺𝝐𝝴𝞊𝞮𝟄⼹彐ÉÈĖÊËĚĔĒẼĘȨɆẾỀḖḔỄḜẺȄȆỂẸḘḚỆ🄔🄴🅔",
    "F" : "FϜᖴℱꓝＦ𝐅𝐹𝑭𝓕𝔉𝔽𝕱𝖥𝗙𝘍𝙁𝙵ᖵℲꓞᖷḞ🄕🄵🅕",
    "G" : "GɢԌԍᏀᏳᏻꓖＧ𝐆𝐺𝑮𝒢𝓖𝔊𝔾𝕲𝖦𝗚𝘎𝙂𝙶ĞǦ⅁ꓨǴĠĜǦĞḠĢǤƓ🄖🄶🅖",
    "H" : "HʜΗНнᎻᕼℋℌℍⲎꓧＨ𝐇𝐻𝑯𝓗𝕳𝖧𝗛𝘏𝙃𝙷𝚮𝛨𝜢𝝜𝞖ḣḢĤḦȞḨĦḤḪⱧ🄗🄷🅗",
    "I" : "Il|ƖǀΙІӀ׀וןا١۱ߊᛁℐℑℓⅠⅼ∣￨𐌉𐌠𝐈𝐥𝐼𝑙𝑰𝒍𝓁𝓘𝓵𝔩𝕀𝕝𝕴𝖑𝖨𝗅𝗜𝗹𝘐𝘭𝙄𝙡𝙸𝚕𝚰𝛪𝜤𝝞𝞘ĬǏİÍÌÎÏǏĬĪĨįĮƗḮỈȈȊỊḬ🄘🄸🅘",
    "J" : "JͿЈᎫᒍᴊꓙＪ𝐉𝐽𝑱𝒥𝓙𝔍𝕁𝕵𝖩𝗝𝘑𝙅𝙹ĴǰɈ🄙🄹🅙",
    "K" : "KΚКᏦᛕKⲔꓗＫ𝐊𝐾𝑲𝒦𝓚𝔎𝕂𝕶𝖪𝗞𝘒𝙆𝙺𝚱𝛫𝜥𝝟𝞙ĸκϰкᴋⲕ𝛋𝛞𝜅𝜘𝜿𝝒𝝹𝞌𝞳𝟆ḰǨĶƘḲḴⱩ🄚🄺🅚",
    "L" : "LLʟᏞᒪℒⅬⳐⳑꓡＬ𐐛𐑃𝐋𝐿𝑳𝓛𝔏𝕃𝕷𝖫𝗟𝘓𝙇𝙻⺃乚ĹĿĽⱠĻȽŁḶḼḺḸ🄛🄻🅛",
    "M" : "MΜϺМᎷᗰᛖℳⅯⲘꓟＭ𐌑𝐌𝑀𝑴𝓜𝔐𝕄𝕸𝖬𝗠𝘔𝙈𝙼𝚳𝛭𝜧𝝡𝞛ḾṀṂ🄜🄼🅜",
    "N" : "NɴΝℕⲚꓠＮ𝐍𝑁𝑵𝒩𝓝𝔑𝕹𝖭𝗡𝘕𝙉𝙽𝚴𝛮𝜨𝝢𝞜ͶИ𐐥ŃǸṄŇÑŅƝȠṆṊṈŊ🄝🄽🅝",
    "O" : "0OΟОՕ߀੦ଠ౦ಂഠዐⲞⵔ〇ꓳ０Ｏ𐐄𐓂𝐎𝑂𝑶𝒪𝓞𝔒𝕆𝕺𝖮𝗢𝘖𝙊𝙾𝚶𝛰𝜪𝝤𝞞𝟎𝟘𝟢𝟬𝟶ÖŐӦŎǑ⼝⼞ロ口囗ÓÒȮÔÖǑŎŌÕǪŐỐỒØṒṐȰṌȪỖṎǾȬỎȌȎƠỔỌỚỜỠỘỞỢ🄞🄾🅞",
    "P" : "PΡРᏢᑭᴘᴩℙⲢꓑＰ𝐏𝑃𝑷𝒫𝓟𝔓𝕻𝖯𝗣𝘗𝙋𝙿𝚸𝛲𝜬𝝦𝞠℗ⓅṔṖⱣƤ🄟🄿🅟",
    "Q" : "QℚⵕＱ𝐐𝑄𝑸𝒬𝓠𝔔𝕼𝖰𝗤𝘘𝙌𝚀🄠🅀🅠",
    "R" : "RƦʀᎡᏒᖇᚱℛℜℝꓣＲ𐒴𝐑𝑅𝑹𝓡𝕽𝖱𝗥𝘙𝙍𝚁®ⓇŔṘŘŖɌⱤȐȒṚṞṜᴙ🄡🅁🅡",
    "S" : "SЅՏᏕᏚꓢＳ𐐠𝐒𝑆𝑺𝒮𝓢𝔖𝕊𝕾𝖲𝗦𝘚𝙎𝚂ŚṠŜŠŞṤṦṢȘṨ🄢🅂🅢",
    "T" : "TΤτТтᎢᴛ⊤⟙ⲦꓔＴ𐌕𝐓𝑇𝑻𝒯𝓣𝔗𝕋𝕿𝖳𝗧𝘛𝙏𝚃𝚻𝛕𝛵𝜏𝜯𝝉𝝩𝞃𝞣𝞽ŢȚṪŤŢƬṬƮȚṰṮȾŦ🄣🅃🅣",
    "U" : "UՍሀᑌ∪⋃ꓴＵ𐓎𝐔𝑈𝑼𝒰𝓤𝔘𝕌𝖀𝖴𝗨𝘜𝙐𝚄ÚÙÛÜǓŬŪŨŮŲŰɄǗǛǙṸǕṺỦȔȖƯỤṲỨỪṶṴỮỬỰ🄤🅄🅤",
    "V" : "VѴ٧۷ᏙᐯⅤⴸꓦＶ𝐕𝑉𝑽𝒱𝓥𝔙𝕍𝖁𝖵𝗩𝘝𝙑𝚅ṼṾƲ🄥🅅🅥",
    "W" : "WԜᎳᏔꓪＷ𝐖𝑊𝑾𝒲𝓦𝔚𝕎𝖂𝖶𝗪𝘞𝙒𝚆ẂẀẆŴẄẈ🄦🅆🅦",
    "X" : "XΧХ᙭ᚷⅩ╳ⲬⵝꓫＸ𐌗𐌢𝐗𝑋𝑿𝒳𝓧𝔛𝕏𝖃𝖷𝗫𝘟𝙓𝚇𝚾𝛸𝜲𝝬𝞦χⲭ𝛘𝜒𝝌𝞆𝟀ẌẊ🄧🅇🅧",
    "Y" : "YΥϒУҮᎩᎽⲨꓬＹ𝐘𝑌𝒀𝒴𝓨𝔜𝕐𝖄𝖸𝗬𝘠𝙔𝚈𝚼𝛶𝜰𝝪𝞤ΨѰᛘⲮ𐓑𝚿𝛹𝜳𝝭𝞧ÝỲẎŶŸȲỸɎỶƳỴ🄨🅈🅨",
    "Z" : "ZΖᏃℤℨꓜＺ𝐙𝑍𝒁𝒵𝓩𝖅𝖹𝗭𝘡𝙕𝚉𝚭𝛧𝜡𝝛𝞕ŹŻẐŽƵȤẒẔⱫ🄩🅉🅩"
]

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

private var allGlyphs: [String] = []

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

func assembleGlyphs(key: String) -> [String] {
    var glyphs = [String]()
    for suggestion in homoglyphs[key]! {
        glyphs.append(String(suggestion))
    }
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
    
    func export() -> KeyboardMappingFile {
        var message = String()
        let data = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("keymapping.json")
        do {
            let jsonData = try NSData(contentsOfFile: data.path, options: .mappedIfSafe)
            message = String(data: jsonData as Data, encoding: String.Encoding.utf8)!
        } catch {
            print("export read error")
        }
        return KeyboardMappingFile(message: message)
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
    
    func saveDataAndReload(jsonData: NSData) {
        let data = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.uk.co.hanken.quirky")!.appendingPathComponent("keymapping.json")
        do {
            try jsonData.write(to: data)
        } catch {
            return
        }
        keylist = loadMap()
        self.objectWillChange.send()
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


struct KeyboardMappingFile: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var message: String
    init(message: String) {
        self.message = message
    }
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
}

struct ContentView: View {
    @State var showSheet = false
    @State var showLoadList = false
    @State var isImporting = false
    @State var showActivity = false
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
                        allGlyphs = assembleGlyphs(key: k.key)
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
                    Image(systemName: "list.dash")
                        .foregroundColor(Color.primary)
                }.padding()
                    .sheet(isPresented: $showLoadList) {
                        LoadListView(showLoadList: $showLoadList, model: self.model, callback: model.load)
                    }
                Spacer()
                Button (action: {
                    model.save()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.primary)
                }.padding()
                Spacer()
                Button (action: {
                    isImporting = true
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(Color.primary)
                }.padding()
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [.json],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        let data: URL = try result.get().first!
                        let lock = data.startAccessingSecurityScopedResource()
                        if (lock) {
                            let jsonData = try NSData(contentsOfFile: data.path, options: .mappedIfSafe)
                            model.saveDataAndReload(jsonData: jsonData)
                            data.stopAccessingSecurityScopedResource()
                        }
                    } catch {
                        print("import error: \(error)")
                    }
                }
                Spacer()
                Button (action: {
                    showActivity = true
                    UIView.appearance().tintColor = UIColor.systemTeal
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color.primary)
                }.padding()
                .fileExporter(
                    isPresented: $showActivity,
                    document: model.export(),
                    contentType: UTType.json,
                    defaultFilename: "quirky.json",
                    onCompletion: { result in
                        if case .success = result {
                            print("exported")
                        } else {
                            print("not exported")
                        }
                    }
                )
            }
        }
    }
}

struct LoadListView: View {
    @Binding var showLoadList: Bool
    var model: KeyListModel
    var callback: (String) -> Void
    
    var body: some View {
        if (model.list().isEmpty) {
            Text("No saved keyboard mappings, use the + icon to save one.")
                .font(.system(size: 20))
                .italic()
                .foregroundColor(Color.secondary)
        } else {
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
                ForEach( Array(stride(from: 0, to: allGlyphs.count, by: columns)), id: \.self) { start in
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
