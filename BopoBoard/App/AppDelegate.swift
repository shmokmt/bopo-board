//
//  AppDelegate.swift
//  BopoBoard
//
//  Application delegate for menu bar setup
//

import AppKit
import SwiftUI
import os.log
#if canImport(BopoBoardCore)
import BopoBoardCore
#endif

class AppDelegate: NSObject, NSApplicationDelegate {
    private static let logger = Logger(subsystem: "com.local.BopoBoard", category: "AppDelegate")
    private var menuBarManager: MenuBarManager?
    private var keyboardState: KeyboardState?
    private var permissionService: PermissionService?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Validate keyboard mappings
        let mapper = KeyCodeMapper.shared
        if !mapper.validateMappings() {
            Self.logger.error("Keyboard mapping validation failed!")
        } else {
            Self.logger.info("Keyboard mapping validation passed")
        }

        // Initialize services
        keyboardState = KeyboardState()
        permissionService = PermissionService()

        guard let keyboardState = keyboardState, let permissionService = permissionService else {
            Self.logger.error("Failed to initialize services")
            return
        }

        // Setup menu bar
        menuBarManager = MenuBarManager(keyboardState: keyboardState, permissionService: permissionService)
        menuBarManager?.setupMenuBar()

        // Check and request permission
        if !permissionService.hasPermission {
            permissionService.requestAccessibilityPermission()
        }

        Self.logger.info("Application launched successfully")
    }

    func applicationWillTerminate(_ notification: Notification) {
        Self.logger.info("Application terminating")
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Keep app running even if no windows are open (menu bar app)
        return false
    }
}
