//
//  SettingsView.swift
//  BopoBoard
//
//  Settings view for app configuration
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var permissionService: PermissionService

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)

            Divider()

            // Permission status
            HStack {
                Image(systemName: permissionService.hasPermission ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(permissionService.hasPermission ? .green : .red)

                Text("Accessibility Permission")
                    .font(.subheadline)

                Spacer()

                if !permissionService.hasPermission {
                    Button("Grant Permission") {
                        permissionService.openSystemPreferences()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }

            Divider()

            // About section
            VStack(alignment: .leading, spacing: 8) {
                Text("About")
                    .font(.headline)

                Text("BopoBoard v1.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("注音符號鍵盤映射即時顯示")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("Real-time Zhuyin keyboard mapping (Daqian layout)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(width: 350, height: 250)
    }
}

// Preview removed for command-line compilation
