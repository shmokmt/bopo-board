//
//  CurrentKeyView.swift
//  BopoBoard
//
//  Displays the currently pressed key
//

import SwiftUI
#if SWIFT_PACKAGE
import BopoBoardCore
#endif

struct CurrentKeyView: View {
    let keyPress: KeyPressEvent?

    var body: some View {
        VStack(spacing: 12) {
            Text("Current Key")
                .font(.headline)
                .foregroundColor(.secondary)

            if let keyPress = keyPress {
                VStack(spacing: 8) {
                    // Modifier keys
                    if keyPress.modifiers.hasAnyModifier {
                        Text(keyPress.modifiers.description)
                            .font(.system(size: 24))
                            .foregroundColor(.accentColor)
                    }

                    // Key name
                    Text(keyPress.character)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)

                    // Symbol produced (if different from key)
                    if let symbol = keyPress.symbol {
                        HStack(spacing: 4) {
                            Text("→")
                                .foregroundColor(.secondary)
                            Text(symbol)
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.accentColor.opacity(0.1))
                )
                .transition(.scale.combined(with: .opacity))
            } else {
                VStack {
                    Image(systemName: "keyboard")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("Press any key")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(height: 120)
            }
        }
        .padding()
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: keyPress?.id)
    }
}

// Preview removed for command-line compilation
