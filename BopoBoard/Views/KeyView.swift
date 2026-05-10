//
//  KeyView.swift
//  BopoBoard
//
//  Individual key display component
//

import SwiftUI

struct KeyView: View {
    let keyLabel: String
    let symbolLabel: String?
    let isHighlighted: Bool
    let width: CGFloat
    let height: CGFloat

    init(
        keyLabel: String,
        symbolLabel: String? = nil,
        isHighlighted: Bool = false,
        width: CGFloat = 40,
        height: CGFloat = 40
    ) {
        self.keyLabel = keyLabel
        self.symbolLabel = symbolLabel
        self.isHighlighted = isHighlighted
        self.width = width
        self.height = height
    }

    var body: some View {
        VStack(spacing: 2) {
            if let symbol = symbolLabel {
                Text(symbol)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            Text(keyLabel)
                .font(.system(size: 12, weight: isHighlighted ? .bold : .regular))
                .foregroundColor(isHighlighted ? .white : .primary)
        }
        .frame(width: width, height: height)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isHighlighted ? Color.accentColor : Color.gray.opacity(0.2))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.15), value: isHighlighted)
    }
}

// Preview removed for command-line compilation
// #Preview {
//     VStack(spacing: 20) {
//         KeyView(keyLabel: "A")
//         KeyView(keyLabel: "A", symbolLabel: "!", isHighlighted: true)
//         KeyView(keyLabel: "Space", width: 120)
//     }
//     .padding()
// }
