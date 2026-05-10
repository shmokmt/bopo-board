//
//  KeyboardMonitor.swift
//  BopoBoard
//
//  Monitors global keyboard events using CGEvent
//

import Foundation
import CoreGraphics
import AppKit
import os.log
#if SWIFT_PACKAGE
import BopoBoardCore
#endif

class KeyboardMonitor {
    private static let logger = Logger(subsystem: "com.local.BopoBoard", category: "KeyboardMonitor")
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let keyboardState: KeyboardState
    private let keyCodeMapper = KeyCodeMapper.shared

    init(keyboardState: KeyboardState) {
        self.keyboardState = keyboardState
    }

    /// Start monitoring keyboard events
    func startMonitoring() -> Bool {
        // Check if already monitoring
        guard eventTap == nil else { return true }

        // Create event mask for key events
        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue) |
                                     (1 << CGEventType.keyUp.rawValue) |
                                     (1 << CGEventType.flagsChanged.rawValue)

        // Create event tap
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { proxy, type, event, refcon -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else {
                    return Unmanaged.passUnretained(event)
                }

                let monitor = Unmanaged<KeyboardMonitor>.fromOpaque(refcon).takeUnretainedValue()
                monitor.handleEvent(type: type, event: event)

                return Unmanaged.passUnretained(event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            Self.logger.error("Failed to create event tap. Accessibility permission may not be granted.")
            return false
        }

        self.eventTap = tap

        // Create and add run loop source
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        self.runLoopSource = runLoopSource

        // Enable the event tap
        CGEvent.tapEnable(tap: tap, enable: true)

        // Update monitoring state
        Task { @MainActor in
            keyboardState.isMonitoring = true
        }

        Self.logger.info("Keyboard monitoring started successfully")
        return true
    }

    /// Stop monitoring keyboard events
    func stopMonitoring() {
        if eventTap != nil {
            CGEvent.tapEnable(tap: eventTap!, enable: false)
            // Note: CFMachPort doesn't need explicit release in modern Swift with ARC
            eventTap = nil
        }

        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
            runLoopSource = nil
        }

        // Update monitoring state
        Task { @MainActor in
            keyboardState.isMonitoring = false
            keyboardState.clearCurrentKey()
        }

        Self.logger.info("Keyboard monitoring stopped")
    }

    /// Handle keyboard event
    private func handleEvent(type: CGEventType, event: CGEvent) {
        switch type {
        case .keyDown:
            handleKeyDown(event: event)
        case .keyUp:
            handleKeyUp(event: event)
        case .flagsChanged:
            handleModifierChange(event: event)
        default:
            break
        }
    }

    /// Handle key down event
    private func handleKeyDown(event: CGEvent) {
        let keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))
        let flags = event.flags

        let modifiers = ModifierKeys(from: flags)
        let (keyName, symbol) = keyCodeMapper.character(for: keyCode, modifiers: modifiers)

        let keyPress = KeyPressEvent(
            keyCode: keyCode,
            character: keyName,
            symbol: symbol,
            modifiers: modifiers
        )

        // Update state on main thread
        Task { @MainActor in
            keyboardState.updateCurrentKey(keyPress)
            keyboardState.updateModifiers(modifiers)
        }
    }

    /// Handle key up event
    private func handleKeyUp(event: CGEvent) {
        // Clear current key press
        Task { @MainActor in
            keyboardState.clearCurrentKey()
        }
    }

    /// Handle modifier key changes
    private func handleModifierChange(event: CGEvent) {
        let flags = event.flags
        let modifiers = ModifierKeys(from: flags)

        // Update modifiers on main thread
        Task { @MainActor in
            keyboardState.updateModifiers(modifiers)
        }
    }

    deinit {
        stopMonitoring()
    }
}
