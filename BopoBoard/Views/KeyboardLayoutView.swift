//
//  KeyboardLayoutView.swift
//  BopoBoard
//
//  Visual keyboard layout display
//

import SwiftUI
import CoreGraphics
#if SWIFT_PACKAGE
import BopoBoardCore
#endif

struct KeyboardLayoutView: View {
    @ObservedObject var keyboardState: KeyboardState

    private let keySize: CGFloat = 35
    private let keySpacing: CGFloat = 4

    var body: some View {
        VStack(spacing: keySpacing) {
            // Number row
            numberRow

            // QWERTY row
            qwertyRow

            // ASDF row
            asdfRow

            // ZXCV row
            zxcvRow

            // Bottom row (modifiers and spacebar)
            bottomRow
        }
        .padding()
    }

    // MARK: - Keyboard Rows

    private var numberRow: some View {
        HStack(spacing: keySpacing) {
            keyView("`", keyCode: 50)
            keyView("1", keyCode: 18)  // ㄅ
            keyView("2", keyCode: 19)  // ㄉ
            keyView("3", keyCode: 20)  // ˇ
            keyView("4", keyCode: 21)  // ˋ
            keyView("5", keyCode: 23)  // ㄓ
            keyView("6", keyCode: 22)  // ˊ
            keyView("7", keyCode: 26)  // ˙
            keyView("8", keyCode: 28)  // ㄚ
            keyView("9", keyCode: 25)  // ㄞ
            keyView("0", keyCode: 29)  // ㄢ
            keyView("-", keyCode: 27)  // ㄦ
            keyView("=", keyCode: 24)
        }
    }

    private var qwertyRow: some View {
        HStack(spacing: keySpacing) {
            keyView("Q", keyCode: 12)
            keyView("W", keyCode: 13)
            keyView("E", keyCode: 14)
            keyView("R", keyCode: 15)
            keyView("T", keyCode: 17)
            keyView("Y", keyCode: 16)
            keyView("U", keyCode: 32)
            keyView("I", keyCode: 34)
            keyView("O", keyCode: 31)
            keyView("P", keyCode: 35)
            keyView("[", keyCode: 33)
            keyView("]", keyCode: 30)
            keyView("\\", keyCode: 42)
        }
    }

    private var asdfRow: some View {
        HStack(spacing: keySpacing) {
            keyView("A", keyCode: 0)
            keyView("S", keyCode: 1)
            keyView("D", keyCode: 2)
            keyView("F", keyCode: 3)
            keyView("G", keyCode: 5)
            keyView("H", keyCode: 4)
            keyView("J", keyCode: 38)
            keyView("K", keyCode: 40)
            keyView("L", keyCode: 37)
            keyView(";", keyCode: 41)
            keyView("'", keyCode: 39)
        }
    }

    private var zxcvRow: some View {
        HStack(spacing: keySpacing) {
            keyView("Z", keyCode: 6)
            keyView("X", keyCode: 7)
            keyView("C", keyCode: 8)
            keyView("V", keyCode: 9)
            keyView("B", keyCode: 11)
            keyView("N", keyCode: 45)
            keyView("M", keyCode: 46)
            keyView(",", keyCode: 43)
            keyView(".", keyCode: 47)
            keyView("/", keyCode: 44)
        }
    }

    private var bottomRow: some View {
        HStack(spacing: keySpacing) {
            // Modifier keys
            modifierKeyView("⌃", isActive: keyboardState.modifierKeys.control)
            modifierKeyView("⌥", isActive: keyboardState.modifierKeys.option)
            modifierKeyView("⌘", isActive: keyboardState.modifierKeys.command)

            // Spacebar
            keyView("Space", keyCode: 49, width: keySize * 5)

            // Right modifiers
            modifierKeyView("⌘", isActive: keyboardState.modifierKeys.command)
            modifierKeyView("⌥", isActive: keyboardState.modifierKeys.option)
            modifierKeyView("⌃", isActive: keyboardState.modifierKeys.control)
        }
    }

    // MARK: - Helper Views

    private func keyView(_ label: String, keyCode: CGKeyCode, width: CGFloat? = nil) -> some View {
        let isPressed = keyboardState.currentKeyPress?.keyCode == keyCode
        let currentSymbol = getCurrentSymbol(for: keyCode)

        return KeyView(
            keyLabel: label,
            symbolLabel: currentSymbol,
            isHighlighted: isPressed,
            width: width ?? keySize,
            height: keySize
        )
    }

    private func modifierKeyView(_ label: String, isActive: Bool) -> some View {
        Text(label)
            .font(.system(size: 16, weight: isActive ? .bold : .regular))
            .foregroundColor(isActive ? .white : .primary)
            .frame(width: keySize, height: keySize)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isActive ? Color.accentColor : Color.gray.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.15), value: isActive)
    }

    // MARK: - Helper Methods

    private func getCurrentSymbol(for keyCode: CGKeyCode) -> String? {
        let mapper = KeyCodeMapper.shared
        let (_, symbol) = mapper.character(for: keyCode, modifiers: keyboardState.modifierKeys)
        return symbol
    }
}

// Preview removed for command-line compilation
