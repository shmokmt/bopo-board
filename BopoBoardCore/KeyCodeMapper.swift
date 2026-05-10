import CoreGraphics

class KeyCodeMapper {
    static let shared = KeyCodeMapper()

    private init() {}

    private let baseKeyMap: [CGKeyCode: String] = [
        0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G", 6: "Z", 7: "X", 8: "C", 9: "V",
        11: "B", 12: "Q", 13: "W", 14: "E", 15: "R", 16: "Y", 17: "T",
        31: "O", 32: "U", 34: "I", 35: "P", 37: "L", 38: "J", 40: "K", 45: "N", 46: "M",
        18: "1", 19: "2", 20: "3", 21: "4", 22: "6", 23: "5", 24: "=", 25: "9", 26: "7",
        27: "-", 28: "8", 29: "0",
        30: "]", 33: "[", 39: "'", 41: ";", 42: "\\", 43: ",", 44: "/", 47: ".", 50: "`"
    ]

    /// Zhuyin/Bopomofo mapping (Daqian/大千 keyboard layout)
    private let zhuyinKeyMap: [CGKeyCode: String] = [
        // Number row: consonants and tone marks
        18: "ㄅ", 19: "ㄉ", 20: "ˇ", 21: "ˋ", 23: "ㄓ",
        22: "ˊ", 26: "˙", 28: "ㄚ", 25: "ㄞ", 29: "ㄢ", 27: "ㄦ",

        // QWERTY row: consonants and vowels
        12: "ㄆ", 13: "ㄊ", 14: "ㄍ", 15: "ㄐ", 17: "ㄔ",
        16: "ㄗ", 32: "ㄧ", 34: "ㄛ", 31: "ㄟ", 35: "ㄣ", 33: "ㄤ", 30: "ㄥ",

        // ASDF row: consonants and vowels
        0: "ㄇ", 1: "ㄋ", 2: "ㄎ", 3: "ㄑ", 5: "ㄕ",
        4: "ㄘ", 38: "ㄨ", 40: "ㄜ", 37: "ㄠ", 41: "ㄤ",

        // ZXCV row: consonants and finals
        6: "ㄈ", 7: "ㄌ", 8: "ㄏ", 9: "ㄒ", 11: "ㄖ",
        45: "ㄙ", 46: "ㄩ", 43: "ㄝ", 47: "ㄡ", 44: "ㄥ"
    ]

    private let specialKeyMap: [CGKeyCode: String] = [
        36: "Return", 48: "Tab", 49: "Space", 51: "Delete", 53: "Escape",
        123: "←", 124: "→", 125: "↓", 126: "↑",
        122: "F1", 120: "F2", 99: "F3", 118: "F4", 96: "F5", 97: "F6",
        98: "F7", 100: "F8", 101: "F9", 109: "F10", 103: "F11", 111: "F12",
        71: "Clear", 76: "Enter", 117: "Forward Delete",
        115: "Home", 116: "Page Up", 119: "End", 121: "Page Down"
    ]

    func character(for keyCode: CGKeyCode, modifiers: ModifierKeys) -> (key: String, symbol: String?) {
        if let special = specialKeyMap[keyCode] {
            return (special, nil)
        }
        let physicalKey = baseKeyMap[keyCode] ?? "?"
        let zhuyinSymbol = zhuyinKeyMap[keyCode]
        return (physicalKey, zhuyinSymbol)
    }

    func zhuyinSymbol(for keyCode: CGKeyCode) -> String? {
        return zhuyinKeyMap[keyCode]
    }

    func isKnownKey(_ keyCode: CGKeyCode) -> Bool {
        return baseKeyMap[keyCode] != nil || specialKeyMap[keyCode] != nil
    }

    var allKeyCodes: [CGKeyCode] {
        let allKeys = Set(baseKeyMap.keys).union(Set(specialKeyMap.keys))
        return Array(allKeys).sorted()
    }

    func validateMappings() -> Bool {
        guard zhuyinKeyMap.count >= 30 else { return false }

        let zhuyinSymbols = Set(zhuyinKeyMap.values)
        guard zhuyinSymbols.count == zhuyinKeyMap.count else { return false }

        let requiredSymbols = ["ㄅ", "ㄆ", "ㄇ", "ㄈ", "ㄉ", "ㄊ", "ㄋ", "ㄌ", "ㄧ", "ㄨ", "ㄩ"]
        for symbol in requiredSymbols {
            guard zhuyinSymbols.contains(symbol) else { return false }
        }
        return true
    }

    var mappingStats: String {
        """
        Zhuyin Keyboard Mapping Statistics:
        - Physical keys: \(baseKeyMap.count)
        - Zhuyin mappings: \(zhuyinKeyMap.count)
        - Special keys: \(specialKeyMap.count)
        - Validation: \(validateMappings() ? "✓ PASS" : "✗ FAIL")
        """
    }
}
