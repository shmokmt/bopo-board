//
//  MenuBarView.swift
//  BopoBoard
//
//  Main menu bar popover view
//

import SwiftUI
import AppKit
#if SWIFT_PACKAGE
import BopoBoardCore
#endif

struct MenuBarView: View {
    @ObservedObject var keyboardState: KeyboardState
    @ObservedObject var permissionService: PermissionService
    var keyboardMonitor: KeyboardMonitor?
    var menuBarManager: MenuBarManager?

    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView

            Divider()

            // Permission warning (if needed)
            if !permissionService.hasPermission {
                permissionWarningView
                Divider()
            }

            // Current key display
            CurrentKeyView(keyPress: keyboardState.currentKeyPress)
                .padding(.vertical, 8)

            Divider()

            // Keyboard layout
            ScrollView {
                KeyboardLayoutView(keyboardState: keyboardState)
            }

            Divider()

            // Footer
            footerView
        }
        .frame(width: 500, height: 600)
        .sheet(isPresented: $showSettings) {
            SettingsView(permissionService: permissionService)
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Image(systemName: "keyboard")
                .font(.title2)
                .foregroundColor(.accentColor)

            Text("BopoBoard")
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            // Monitoring toggle
            if permissionService.hasPermission {
                Toggle("", isOn: Binding(
                    get: { keyboardState.isMonitoring },
                    set: { isOn in
                        if isOn {
                            _ = keyboardMonitor?.startMonitoring()
                        } else {
                            keyboardMonitor?.stopMonitoring()
                        }
                        menuBarManager?.updateIcon(isMonitoring: isOn)
                    }
                ))
                .toggleStyle(.switch)
                .labelsHidden()
            }

            Button(action: { showSettings.toggle() }, label: {
                Image(systemName: "gearshape")
                    .font(.title3)
            })
            .buttonStyle(.plain)

            Button(action: { NSApplication.shared.terminate(nil) }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title3)
            })
            .buttonStyle(.plain)
        }
        .padding()
    }

    // MARK: - Permission Warning

    private var permissionWarningView: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Accessibility Permission Required")
                    .font(.headline)
            }

            Text("BopoBoard needs accessibility access to monitor keyboard input.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Open System Preferences") {
                permissionService.openSystemPreferences()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
    }

    // MARK: - Footer

    private var footerView: some View {
        HStack {
            // Modifier key indicators
            HStack(spacing: 12) {
                modifierIndicator("⌃ Control", isActive: keyboardState.modifierKeys.control)
                modifierIndicator("⌥ Option", isActive: keyboardState.modifierKeys.option)
                modifierIndicator("⇧ Shift", isActive: keyboardState.modifierKeys.shift)
                modifierIndicator("⌘ Command", isActive: keyboardState.modifierKeys.command)
            }

            Spacer()

            // Status indicator
            HStack(spacing: 4) {
                Circle()
                    .fill(keyboardState.isMonitoring ? Color.green : Color.gray)
                    .frame(width: 8, height: 8)
                Text(keyboardState.isMonitoring ? "Monitoring" : "Paused")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }

    // MARK: - Helper Views

    private func modifierIndicator(_ label: String, isActive: Bool) -> some View {
        Text(label)
            .font(.caption)
            .foregroundColor(isActive ? .accentColor : .secondary)
            .fontWeight(isActive ? .bold : .regular)
    }
}

// Preview removed for command-line compilation
