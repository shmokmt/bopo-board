#!/bin/bash

set -e

echo "🔨 Building BopoBoard..."

# Compile Swift sources
swiftc \
  -target arm64-apple-macosx13.0 \
  -sdk /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
  BopoBoardCore/Models/KeyPress.swift \
  BopoBoardCore/Models/ModifierKeys.swift \
  BopoBoardCore/KeyCodeMapper.swift \
  BopoBoard/Core/KeyboardMonitor.swift \
  BopoBoard/Core/KeyboardState.swift \
  BopoBoard/Services/MenuBarManager.swift \
  BopoBoard/Services/PermissionService.swift \
  BopoBoard/Views/CurrentKeyView.swift \
  BopoBoard/Views/KeyboardLayoutView.swift \
  BopoBoard/Views/KeyView.swift \
  BopoBoard/Views/MenuBarView.swift \
  BopoBoard/Views/SettingsView.swift \
  BopoBoard/App/AppDelegate.swift \
  BopoBoard/App/BopoBoardApp.swift \
  -o BopoBoard.app/Contents/MacOS/BopoBoard

echo "✅ Compilation successful"

# Code sign
codesign --force --deep --sign - --entitlements BopoBoard.entitlements BopoBoard.app

echo "✅ Code signing successful"
echo "🎉 Build complete! Run: open BopoBoard.app"
