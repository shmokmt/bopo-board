//
//  PermissionService.swift
//  BopoBoard
//
//  Manages accessibility permissions
//

import Foundation
import ApplicationServices
import AppKit

class PermissionService: ObservableObject {
    @Published var hasPermission: Bool = false

    private var timer: Timer?

    init() {
        self.hasPermission = checkAccessibilityPermission()
    }

    /// Check if accessibility permission is granted
    func checkAccessibilityPermission() -> Bool {
        return AXIsProcessTrusted()
    }

    /// Request accessibility permission with system prompt
    func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        let hasPermission = AXIsProcessTrustedWithOptions(options)
        self.hasPermission = hasPermission

        // If permission not granted, start polling
        if !hasPermission {
            startPolling()
        }
    }

    /// Start polling for permission changes
    private func startPolling() {
        stopPolling() // Stop any existing timer

        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let hasPermission = self.checkAccessibilityPermission()

            if hasPermission != self.hasPermission {
                DispatchQueue.main.async {
                    self.hasPermission = hasPermission
                    if hasPermission {
                        self.stopPolling()
                    }
                }
            }
        }
    }

    /// Stop polling for permission changes
    private func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    /// Open System Preferences to the Accessibility settings
    func openSystemPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }

    deinit {
        stopPolling()
    }
}
