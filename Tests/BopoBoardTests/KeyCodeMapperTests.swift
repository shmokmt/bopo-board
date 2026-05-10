import XCTest
import CoreGraphics
@testable import BopoBoardCore

final class KeyCodeMapperTests: XCTestCase {
    private let mapper = KeyCodeMapper.shared

    func testValidateMappings() {
        XCTAssertTrue(mapper.validateMappings())
    }

    func testZhuyinSymbolsForConsonants() {
        XCTAssertEqual(mapper.zhuyinSymbol(for: 18), "ㄅ")  // 1
        XCTAssertEqual(mapper.zhuyinSymbol(for: 19), "ㄉ")  // 2
        XCTAssertEqual(mapper.zhuyinSymbol(for: 12), "ㄆ")  // Q
        XCTAssertEqual(mapper.zhuyinSymbol(for: 13), "ㄊ")  // W
        XCTAssertEqual(mapper.zhuyinSymbol(for: 0), "ㄇ")   // A
        XCTAssertEqual(mapper.zhuyinSymbol(for: 1), "ㄋ")   // S
        XCTAssertEqual(mapper.zhuyinSymbol(for: 6), "ㄈ")   // Z
    }

    func testZhuyinSymbolsForVowels() {
        XCTAssertEqual(mapper.zhuyinSymbol(for: 32), "ㄧ")  // U
        XCTAssertEqual(mapper.zhuyinSymbol(for: 38), "ㄨ")  // J
        XCTAssertEqual(mapper.zhuyinSymbol(for: 46), "ㄩ")  // M
        XCTAssertEqual(mapper.zhuyinSymbol(for: 28), "ㄚ")  // 8
    }

    func testToneMarks() {
        XCTAssertEqual(mapper.zhuyinSymbol(for: 20), "ˇ")   // 3 = 3rd tone
        XCTAssertEqual(mapper.zhuyinSymbol(for: 21), "ˋ")   // 4 = 4th tone
        XCTAssertEqual(mapper.zhuyinSymbol(for: 22), "ˊ")   // 6 = 2nd tone
        XCTAssertEqual(mapper.zhuyinSymbol(for: 26), "˙")   // 7 = light tone
    }

    func testIsKnownKey() {
        XCTAssertTrue(mapper.isKnownKey(0))    // A
        XCTAssertTrue(mapper.isKnownKey(18))   // 1
        XCTAssertTrue(mapper.isKnownKey(36))   // Return
        XCTAssertFalse(mapper.isKnownKey(200)) // Unknown key
    }

    func testCharacterForKeyCode() {
        let modifiers = ModifierKeys()
        let (key, symbol) = mapper.character(for: 18, modifiers: modifiers)
        XCTAssertEqual(key, "1")
        XCTAssertEqual(symbol, "ㄅ")
    }

    func testSpecialKeyHasNoZhuyinSymbol() {
        let modifiers = ModifierKeys()
        let (key, symbol) = mapper.character(for: 36, modifiers: modifiers) // Return
        XCTAssertEqual(key, "Return")
        XCTAssertNil(symbol)
    }

    func testUnknownKeyReturnsQuestionMark() {
        let modifiers = ModifierKeys()
        let (key, _) = mapper.character(for: 200, modifiers: modifiers)
        XCTAssertEqual(key, "?")
    }

    func testAllKeyCodesNotEmpty() {
        XCTAssertFalse(mapper.allKeyCodes.isEmpty)
    }

    func testDaqianAllowsIntentionalDuplicates() {
        // Daqian layout intentionally maps some symbols to two keys for easier input:
        // ㄤ → [ (keyCode 33) and ; (keyCode 41)
        // ㄥ → ] (keyCode 30) and / (keyCode 44)
        XCTAssertEqual(mapper.zhuyinSymbol(for: 33), "ㄤ")
        XCTAssertEqual(mapper.zhuyinSymbol(for: 41), "ㄤ")
        XCTAssertEqual(mapper.zhuyinSymbol(for: 30), "ㄥ")
        XCTAssertEqual(mapper.zhuyinSymbol(for: 44), "ㄥ")
    }

    func testRequiredZhuyinSymbolsPresent() {
        let required = ["ㄅ", "ㄆ", "ㄇ", "ㄈ", "ㄉ", "ㄊ", "ㄋ", "ㄌ",
                        "ㄍ", "ㄎ", "ㄏ", "ㄐ", "ㄑ", "ㄒ", "ㄓ", "ㄔ",
                        "ㄕ", "ㄖ", "ㄗ", "ㄘ", "ㄙ",
                        "ㄧ", "ㄨ", "ㄩ"]
        for symbol in required {
            let found = mapper.allKeyCodes.contains { mapper.zhuyinSymbol(for: $0) == symbol }
            XCTAssertTrue(found, "Required Zhuyin symbol missing: \(symbol)")
        }
    }
}
