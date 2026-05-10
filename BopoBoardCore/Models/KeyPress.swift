import Foundation
import CoreGraphics

// Renamed from KeyPress to avoid conflict with SwiftUI.KeyPress (macOS 14+)
public struct KeyPressEvent: Identifiable, Equatable {
    public let id: UUID
    public let keyCode: CGKeyCode
    public let character: String
    public let symbol: String?
    public let modifiers: ModifierKeys
    public let timestamp: Date

    public init(
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

    public var displayText: String {
        if modifiers.hasAnyModifier {
            return "\(modifiers.description) \(symbol ?? character)"
        } else {
            return symbol ?? character
        }
    }

    public var shortDescription: String {
        return "Key: \(character)" + (symbol != nil ? " → \(symbol!)" : "")
    }
}
