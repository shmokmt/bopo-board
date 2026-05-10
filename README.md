# BopoBoard - 注音符號鍵盤助手

台灣華語注音符號（BoPoMoFo/Zhuyin）鍵盤映射的即時顯示工具。

A macOS menu bar application that displays real-time Zhuyin/Bopomofo keyboard mapping for Taiwan phonetic input.

## 特色 Features

- **即時按鍵監控 Real-time key monitoring**: 查看您按下的按鍵及其對應的注音符號 / See which keys you press and their Zhuyin symbols
- **視覺化鍵盤佈局 Visual keyboard layout**: 完整QWERTY鍵盤顯示，高亮顯示按下的按鍵 / Full keyboard display with highlighted active keys
- **注音符號映射 Zhuyin mapping**: 大千式注音鍵盤佈局（台灣標準）/ Daqian keyboard layout (Taiwan standard)
- **選單列整合 Menu bar integration**: 輕量級、隨時可用的介面 / Lightweight, always-available interface
- **隱私優先 Privacy-focused**: 所有資料都保留在您的裝置上 / All data stays on your device

## Requirements

- macOS 13.0 or later
- **US QWERTY physical keyboard** (JIS and other layouts not supported)
- Xcode 15.0 or later (for building)
- Accessibility permission (required for keyboard monitoring)

## Building the Project

### Method A: Command-Line Build (Recommended if Xcode not installed)

If you only have Xcode Command Line Tools (no full Xcode):

```bash
# Build the app
./build.sh

# Launch the app
open BopoBoard.app
```

The build script will:
1. Compile all Swift sources
2. Create the app bundle structure
3. Code sign with entitlements
4. Generate `BopoBoard.app`

#### Creating Distribution Package (DMG)

To create a distributable DMG package:

```bash
# First, build the app
./build.sh

# Then create DMG
./create-dmg.sh
```

This will create `BopoBoard-1.0.dmg` (approx. 200KB) containing:
- The BopoBoard.app
- A symbolic link to the Applications folder for easy installation

Users can then drag and drop the app to install it.

### Method B: Build with Xcode

### Step 1: Open in Xcode

1. Open Xcode
2. Select "File" → "Open"
3. Navigate to the `bopo-board` directory and select it
4. Xcode will recognize the project structure

### Step 2: Create Xcode Project (First Time Only)

If Xcode doesn't automatically create a project file, follow these steps:

1. In Xcode, select "File" → "New" → "Project"
2. Choose "macOS" → "App"
3. Configure the project:
   - **Product Name**: BopoBoard
   - **Team**: Select your team or leave as "None" for local development
   - **Organization Identifier**: com.yourcompany (or your preferred identifier)
   - **Bundle Identifier**: com.yourcompany.BopoBoard
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Use Core Data**: Unchecked
   - **Include Tests**: Optional
4. Save the project in the `bopo-board` directory (replacing any existing project)
5. Delete the default files Xcode creates (ContentView.swift, etc.)
6. Add all existing source files to the project:
   - Right-click on "BopoBoard" group in the navigator
   - Select "Add Files to BopoBoard"
   - Navigate to `BopoBoard/` directory and select all subdirectories (App/, Core/, Models/, Views/, Services/)
   - Make sure "Create groups" is selected
   - Click "Add"

### Step 3: Configure Project Settings

1. Select the project in the navigator
2. Select the "BopoBoard" target
3. In the "General" tab:
   - **Deployment Target**: macOS 13.0
   - **Bundle Identifier**: Ensure it matches what you set earlier
4. In the "Signing & Capabilities" tab:
   - Select your development team (or "Sign to Run Locally")
   - **Important**: Turn OFF "App Sandbox" (required for global event monitoring)
   - Add the `BopoBoard.entitlements` file if not already added
5. In the "Build Settings" tab:
   - Search for "Info.plist File"
   - Set it to: `BopoBoard/App/Info.plist`
   - Search for "Code Signing Entitlements"
   - Set it to: `BopoBoard.entitlements`
6. In the "Info" tab:
   - Verify "Application is agent (UIElement)" is set to YES

### Step 4: Build and Run

1. Select "Product" → "Build" or press ⌘B
2. Fix any compilation errors if they appear
3. Select "Product" → "Run" or press ⌘R
4. The app will launch and appear in the menu bar (look for a keyboard icon)

## Setting Up Permissions

When you first run BopoBoard, it will request accessibility permission:

1. A system dialog will appear asking for accessibility access
2. Click "Open System Preferences"
3. In System Preferences:
   - Go to "Privacy & Security" → "Accessibility"
   - Find "BopoBoard" in the list
   - Check the box next to it to enable access
4. Return to BopoBoard - it should start monitoring automatically

**Note**: If the app doesn't appear in the Accessibility list, try:
- Restarting the app
- Manually adding it by clicking the "+" button and selecting BopoBoard

## 使用方法 Usage

1. **點擊選單列的鍵盤圖示** 開啟彈出視窗 / **Click the keyboard icon** in the menu bar to open the popover
2. **切換監控** 使用右上角的開關 / **Toggle monitoring** using the switch in the top-right corner
3. **按下任意按鍵** 查看：/ **Press any key** on your keyboard to see:
   - 實體按鍵名稱 Physical key (e.g., "1", "Q", "A")
   - 對應的注音符號 Zhuyin symbol (e.g., "ㄅ", "ㄆ", "ㄇ")
   - 聲調符號 Tone marks (ˊ, ˇ, ˋ, ˙)
4. **視覺化鍵盤佈局** 顯示所有按鍵及其對應的注音符號 / **Visual keyboard layout** shows all keys with their Zhuyin mappings
5. **設定** 可透過齒輪圖示存取 / **Settings** can be accessed via the gear icon

## 注音符號鍵盤佈局 Zhuyin Keyboard Layout (Daqian/大千式)

```
數字行 Number row:
1→ㄅ  2→ㄉ  3→ˇ  4→ˋ  5→ㄓ  6→ˊ  7→˙  8→ㄚ  9→ㄞ  0→ㄢ  -→ㄦ

第一排 Top row (QWERTY):
Q→ㄆ  W→ㄊ  E→ㄍ  R→ㄐ  T→ㄔ  Y→ㄗ  U→ㄧ  I→ㄛ  O→ㄟ  P→ㄣ  [→ㄤ  ]→ㄥ

第二排 Home row (ASDF):
A→ㄇ  S→ㄋ  D→ㄎ  F→ㄑ  G→ㄕ  H→ㄘ  J→ㄨ  K→ㄜ  L→ㄠ  ;→ㄤ

第三排 Bottom row (ZXCV):
Z→ㄈ  X→ㄌ  C→ㄏ  V→ㄒ  B→ㄖ  N→ㄙ  M→ㄩ  ,→ㄝ  .→ㄡ  /→ㄥ
```

## 運作原理 How It Works

BopoBoard 使用 macOS 的 CGEvent API 來監控鍵盤輸入：

1. **CGEvent Tap**: 建立一個接收系統級鍵盤事件的監聽器 / Creates a tap that receives all keyboard events system-wide
2. **注音符號映射 Zhuyin Mapping**: 將原始按鍵代碼（0-127）映射到對應的注音符號 / Maps raw key codes to their corresponding Zhuyin symbols
3. **即時 UI 更新 Real-time UI Update**: 按鍵被按下時立即更新 SwiftUI 介面 / Updates the SwiftUI interface immediately when keys are pressed
4. **大千式佈局 Daqian Layout**: 使用台灣標準的大千式注音鍵盤佈局 / Uses Taiwan's standard Daqian phonetic keyboard layout

## Privacy & Security

- **No data collection**: BopoBoard does not log, store, or transmit any keyboard input
- **Local processing**: All key mapping happens entirely on your device
- **Open source**: All source code is available for inspection
- **Permission transparency**: Clear explanation of why accessibility access is needed

## 鍵盤佈局支援 Keyboard Layout Support

### 注音輸入方式 Zhuyin Input Methods (Software)

目前支援 Currently supported:
- ✅ **大千式 Daqian layout** (Taiwan standard, most common)

未來計畫支援 Future support planned:
- 許氏注音鍵盤 Hsu Zhuyin layout (alternative Taiwan layout)
- 倚天注音鍵盤 Eten Zhuyin layout
- IBM 式注音鍵盤 IBM Zhuyin layout

### 實體鍵盤配列 Physical Keyboard Layouts (Hardware)

目前支援 Currently supported:
- ✅ **US QWERTY** (101/104 keys)

⚠️ 不支援 Not supported:
- ❌ **JIS (Japanese)** - Different key codes and layout
- ❌ **UK/EU variants** - Different symbol key positions
- ❌ **Other regional layouts**

**Note:** Daqian/Hsu/Eten are *input methods* (software mapping), not physical keyboard layouts. BopoBoard requires a US QWERTY physical keyboard.

## Troubleshooting

### App doesn't appear in menu bar
- Check that `LSUIElement` is set to `true` in Info.plist
- Make sure the app is running (check Activity Monitor)

### Keyboard monitoring doesn't work
- Verify accessibility permission is granted in System Preferences
- Try restarting the app after granting permission
- Check Console.app for error messages from BopoBoard

### Build errors in Xcode
- Ensure all source files are added to the target
- Verify Info.plist and entitlements paths are correct
- Clean build folder (Product → Clean Build Folder) and rebuild

### 按鍵映射不正確 Keys not mapped correctly
- **確認您使用的是 US 實體鍵盤** / **Verify you're using a US physical keyboard**
  - ❌ JIS layout (Japanese keyboard) will not work correctly
  - ❌ UK/EU layouts are also not supported
- 本應用顯示大千式注音符號映射，不需要在系統中切換輸入法 / This app shows Daqian Zhuyin mapping, no need to switch input method in system
- 如果您使用的是其他注音佈局（許氏、倚天等），映射可能不準確 / If using other Zhuyin layouts (Hsu, Eten, etc.), mapping may not be accurate

### How to check your keyboard layout

```bash
# Check current keyboard layout
defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID
```

For US layout: `com.apple.keylayout.US`
For JIS layout: `com.apple.keylayout.Japanese` or similar

## Architecture

```
BopoBoard/
├── App/                    # Application lifecycle
│   ├── BopoBoardApp.swift  # Main entry point (@main)
│   ├── AppDelegate.swift   # App delegate for menu bar setup
│   └── Info.plist          # App configuration
├── Core/                   # Core functionality
│   ├── KeyboardMonitor.swift   # CGEvent keyboard monitoring
│   ├── KeyCodeMapper.swift     # Key code to character mapping
│   └── KeyboardState.swift     # Observable state management
├── Models/                 # Data models
│   ├── KeyPress.swift      # Key press data model
│   └── ModifierKeys.swift  # Modifier keys state
├── Views/                  # SwiftUI views
│   ├── MenuBarView.swift       # Main popover view
│   ├── KeyboardLayoutView.swift # Keyboard layout display
│   ├── KeyView.swift           # Individual key component
│   ├── CurrentKeyView.swift    # Current key display
│   └── SettingsView.swift      # Settings interface
└── Services/               # Services
    ├── PermissionService.swift  # Accessibility permission handling
    └── MenuBarManager.swift     # Menu bar & popover management
```

## Technical Details

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Minimum macOS**: 13.0
- **APIs Used**:
  - CoreGraphics (CGEvent)
  - ApplicationServices (Accessibility)
  - AppKit (NSStatusBar, NSPopover)
  - SwiftUI

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

[Specify your license here]

## Credits

Created with Claude Code by Anthropic.
