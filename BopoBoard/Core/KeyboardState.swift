//
//  KeyboardState.swift
//  BopoBoard
//
//  Observable state for keyboard monitoring
//

import Foundation
import Combine
import CoreGraphics
#if canImport(BopoBoardCore)
import BopoBoardCore
#endif

@MainActor
class KeyboardState: ObservableObject {
    @Published var currentKeyPress: KeyPress?
    @Published var modifierKeys: ModifierKeys = ModifierKeys()
    @Published var isMonitoring: Bool = false
    @Published var keyHistory: [KeyPress] = []

    private let maxHistoryCount = 10

    /// Update the current key press
    func updateCurrentKey(_ keyPress: KeyPress?) {
        self.currentKeyPress = keyPress

        // Add to history if not nil
        if let keyPress = keyPress {
            keyHistory.insert(keyPress, at: 0)
            if keyHistory.count > maxHistoryCount {
                keyHistory.removeLast()
            }
        }
    }

    /// Update modifier keys state
    func updateModifiers(_ modifiers: ModifierKeys) {
        self.modifierKeys = modifiers
    }

    /// Clear current key press
    func clearCurrentKey() {
        self.currentKeyPress = nil
    }

    /// Clear history
    func clearHistory() {
        self.keyHistory.removeAll()
    }
}
