import Foundation
import CoreGraphics

struct KeyPress: Identifiable, Equatable {
    let id: UUID
    let keyCode: CGKeyCode
    let character: String
    let symbol: String?
    let modifiers: ModifierKeys
    let timestamp: Date

    init(
        id: UUID = UUID(),
        keyCode: CGKeyCode,
        character: String,
        symbol: String? = nil,
        modifiers: ModifierKeys = ModifierKeys(),
        timestamp: Date = Date()
    ) {
        self.id = id
        self.keyCode = keyCode
        self.character = character
        self.symbol = symbol
        self.modifiers = modifiers
        self.timestamp = timestamp
    }

    var displayText: String {
        if modifiers.hasAnyModifier {
            return "\(modifiers.description) \(symbol ?? character)"
        } else {
            return symbol ?? character
        }
    }

    var shortDescription: String {
        return "Key: \(character)" + (symbol != nil ? " → \(symbol!)" : "")
    }
}
