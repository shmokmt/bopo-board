import XCTest
import CoreGraphics
@testable import BopoBoardCore

final class KeyPressTests: XCTestCase {
    func testInitializationWithSymbol() {
        let keyPress = KeyPress(keyCode: 18, character: "1", symbol: "ㄅ")
        XCTAssertEqual(keyPress.character, "1")
        XCTAssertEqual(keyPress.symbol, "ㄅ")
        XCTAssertEqual(keyPress.keyCode, 18)
    }

    func testInitializationWithoutSymbol() {
        let keyPress = KeyPress(keyCode: 36, character: "Return")
        XCTAssertEqual(keyPress.character, "Return")
        XCTAssertNil(keyPress.symbol)
    }

    func testDisplayTextUsesSymbolWhenAvailable() {
        let keyPress = KeyPress(keyCode: 0, character: "A", symbol: "ㄇ")
        XCTAssertEqual(keyPress.displayText, "ㄇ")
    }

    func testDisplayTextUsesCharacterWhenNoSymbol() {
        let keyPress = KeyPress(keyCode: 36, character: "Return")
        XCTAssertEqual(keyPress.displayText, "Return")
    }

    func testDisplayTextWithModifiers() {
        let modifiers = ModifierKeys(shift: true)
        let keyPress = KeyPress(keyCode: 0, character: "A", symbol: "ㄇ", modifiers: modifiers)
        XCTAssertTrue(keyPress.displayText.contains("⇧"))
        XCTAssertTrue(keyPress.displayText.contains("ㄇ"))
    }

    func testShortDescriptionContainsCharacter() {
        let keyPress = KeyPress(keyCode: 0, character: "A", symbol: "ㄇ")
        XCTAssertTrue(keyPress.shortDescription.contains("A"))
    }

    func testShortDescriptionContainsSymbolWhenPresent() {
        let keyPress = KeyPress(keyCode: 0, character: "A", symbol: "ㄇ")
        XCTAssertTrue(keyPress.shortDescription.contains("ㄇ"))
    }

    func testEqualityWithSameIDAndTimestamp() {
        let id = UUID()
        let timestamp = Date()
        let a = KeyPress(id: id, keyCode: 0, character: "A", timestamp: timestamp)
        let b = KeyPress(id: id, keyCode: 0, character: "A", timestamp: timestamp)
        XCTAssertEqual(a, b)
    }

    func testInequalityWithDifferentID() {
        let a = KeyPress(keyCode: 0, character: "A")
        let b = KeyPress(keyCode: 0, character: "A")
        XCTAssertNotEqual(a, b) // Different UUIDs
    }

    func testDefaultModifiersHaveNoModifiers() {
        let keyPress = KeyPress(keyCode: 0, character: "A")
        XCTAssertFalse(keyPress.modifiers.hasAnyModifier)
    }
}
