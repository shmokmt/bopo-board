import Foundation
import Combine
import CoreGraphics
#if SWIFT_PACKAGE
import BopoBoardCore
#endif

@MainActor
class KeyboardState: ObservableObject {
    @Published var currentKeyPress: KeyPressEvent?
    @Published var modifierKeys: ModifierKeys = ModifierKeys()
    @Published var isMonitoring: Bool = false
    @Published var keyHistory: [KeyPressEvent] = []

    private let maxHistoryCount = 10

    func updateCurrentKey(_ keyPress: KeyPressEvent?) {
        self.currentKeyPress = keyPress

        if let keyPress = keyPress {
            keyHistory.insert(keyPress, at: 0)
            if keyHistory.count > maxHistoryCount {
                keyHistory.removeLast()
            }
        }
    }

    func updateModifiers(_ modifiers: ModifierKeys) {
        self.modifierKeys = modifiers
    }

    func clearCurrentKey() {
        self.currentKeyPress = nil
    }

    func clearHistory() {
        self.keyHistory.removeAll()
    }
}
