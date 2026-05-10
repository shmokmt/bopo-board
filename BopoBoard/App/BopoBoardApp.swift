//
//  BopoBoardApp.swift
//  BopoBoard
//
//  Main application entry point
//

import SwiftUI

@main
struct BopoBoardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No WindowGroup needed for menu bar only app
        // All UI is handled through the menu bar popover
        Settings {
            EmptyView()
        }
    }
}
