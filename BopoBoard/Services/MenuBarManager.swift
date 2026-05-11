//
//  MenuBarManager.swift
//  BopoBoard
//
//  Manages the menu bar status item and popover
//

import AppKit
import SwiftUI
import os.log

class MenuBarManager: ObservableObject {
    private static let logger = Logger(subsystem: "com.local.BopoBoard", category: "MenuBarManager")
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private let keyboardState: KeyboardState
    private let permissionService: PermissionService
    private var keyboardMonitor: KeyboardMonitor?

    init(keyboardState: KeyboardState, permissionService: PermissionService) {
        self.keyboardState = keyboardState
        self.permissionService = permissionService
        self.keyboardMonitor = KeyboardMonitor(keyboardState: keyboardState)
    }

    /// Setup the menu bar status item
    func setupMenuBar() {
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let button = statusItem?.button else {
            Self.logger.error("Failed to create status bar button")
            return
        }

        // Set icon
        if let image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "BopoBoard") {
            button.image = image
        }

        button.action = #selector(togglePopover)
        button.target = self

        // Create popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 500, height: 600)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(
            rootView: MenuBarView(
                keyboardState: keyboardState,
                permissionService: permissionService
            )
        )

        // Start monitoring immediately
        if let monitor = keyboardMonitor {
            let started = monitor.startMonitoring()
            if started {
                updateIcon(isMonitoring: true)
            }
        }

        Self.logger.info("Menu bar setup complete")
    }

    /// Toggle popover visibility
    @objc func togglePopover() {
        guard let button = statusItem?.button else { return }

        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    /// Show popover
    func showPopover() {
        guard let button = statusItem?.button, let popover = popover else { return }

        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    /// Hide popover
    func hidePopover() {
        popover?.performClose(nil)
    }

    /// Update status bar icon based on monitoring state
    func updateIcon(isMonitoring: Bool) {
        guard let button = statusItem?.button else { return }

        let symbolName = isMonitoring ? "keyboard.fill" : "keyboard"
        if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "BopoBoard") {
            button.image = image
        }
    }
}
