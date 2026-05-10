import XCTest
import CoreGraphics
@testable import BopoBoardCore

final class ModifierKeysTests: XCTestCase {
    func testDefaultStateHasNoModifiers() {
        let modifiers = ModifierKeys()
        XCTAssertFalse(modifiers.shift)
        XCTAssertFalse(modifiers.control)
        XCTAssertFalse(modifiers.option)
        XCTAssertFalse(modifiers.command)
        XCTAssertFalse(modifiers.hasAnyModifier)
    }

    func testHasAnyModifierWithShift() {
        XCTAssertTrue(ModifierKeys(shift: true).hasAnyModifier)
    }

    func testHasAnyModifierWithControl() {
        XCTAssertTrue(ModifierKeys(control: true).hasAnyModifier)
    }

    func testHasAnyModifierWithOption() {
        XCTAssertTrue(ModifierKeys(option: true).hasAnyModifier)
    }

    func testHasAnyModifierWithCommand() {
        XCTAssertTrue(ModifierKeys(command: true).hasAnyModifier)
    }

    func testDescriptionContainsShiftSymbol() {
        let modifiers = ModifierKeys(shift: true)
        XCTAssertTrue(modifiers.description.contains("⇧"))
    }

    func testDescriptionContainsControlSymbol() {
        let modifiers = ModifierKeys(control: true)
        XCTAssertTrue(modifiers.description.contains("⌃"))
    }

    func testDescriptionContainsOptionSymbol() {
        let modifiers = ModifierKeys(option: true)
        XCTAssertTrue(modifiers.description.contains("⌥"))
    }

    func testDescriptionContainsCommandSymbol() {
        let modifiers = ModifierKeys(command: true)
        XCTAssertTrue(modifiers.description.contains("⌘"))
    }

    func testEmptyDescriptionWhenNoModifiers() {
        let modifiers = ModifierKeys()
        XCTAssertTrue(modifiers.description.isEmpty)
    }

    func testEquality() {
        let a = ModifierKeys(shift: true, control: false)
        let b = ModifierKeys(shift: true, control: false)
        XCTAssertEqual(a, b)
    }

    func testInequality() {
        let a = ModifierKeys(shift: true)
        let b = ModifierKeys(control: true)
        XCTAssertNotEqual(a, b)
    }
}
