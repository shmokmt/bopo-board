# BopoBoard - Developer Guide

## 🔧 Development & Debugging Commands

### Build and Run

```bash
# Build
./build.sh

# Run
open BopoBoard.app
```

### ⚠️ CRITICAL: App Restart Procedure

**Always clear cache before restarting!**

```bash
# Correct restart procedure
killall BopoBoard
sleep 2
open BopoBoard.app
```

**Why this matters:**
- macOS caches accessibility permission states
- Simply restarting the app may not reflect permission changes
- `sleep 2` ensures the app fully terminates before restarting
- Skipping cache clearing can cause "permission granted but not working" issues

### Reset Accessibility Permissions

If you encounter permission-related issues:

```bash
# 1. Stop the app
killall BopoBoard

# 2. Reset permissions
tccutil reset Accessibility com.local.BopoBoard

# 3. Open System Preferences
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

# 4. Manually grant permission (check the checkbox)

# 5. Restart app with cache clearing
sleep 2
open BopoBoard.app
```

### Complete Cleanup & Rebuild

```bash
# 1. Stop the app
killall BopoBoard 2>/dev/null

# 2. Remove build artifacts
rm -rf BopoBoard.app
rm -f BopoBoard-*.dmg

# 3. Clear cache (IMPORTANT!)
sleep 2

# 4. Rebuild
./build.sh

# 5. Launch
open BopoBoard.app
```

## 📝 Logging

### Application Logs

```bash
# Stream logs in real-time
log stream --predicate 'subsystem == "com.local.BopoBoard"' --level debug

# Show recent logs
log show --predicate 'subsystem == "com.local.BopoBoard"' --last 5m
```

### Log Categories

- `KeyboardMonitor`: Keyboard monitoring related
- `AppDelegate`: Application lifecycle
- `MenuBarManager`: Menu bar management

### Key Validation

Automatic Zhuyin mapping validation runs on startup:

```
Keyboard mapping validation passed
```

On validation failure:
```
Keyboard mapping validation failed!
```

## 🐛 Debugging Tips

### Issue: Permission granted but app doesn't work

**Solution:**
```bash
# Complete reset procedure
killall BopoBoard
tccutil reset Accessibility com.local.BopoBoard
sleep 3  # IMPORTANT: wait longer
open BopoBoard.app
```

### Issue: Menu bar icon doesn't appear

**Check:**
1. Is the process running? `ps aux | grep BopoBoard`
2. Is `LSUIElement` set to `true` in Info.plist?
3. Try restarting with cache clearing

### Issue: Key presses not detected

**Check:**
1. Accessibility permission granted?
2. Toggle switch in top-right is ON?
3. Check logs for `Keyboard monitoring started successfully`

```bash
log show --predicate 'subsystem == "com.local.BopoBoard" AND category == "KeyboardMonitor"' --last 1m
```

## 📦 Creating Distribution Package

```bash
# 1. Clean build
killall BopoBoard 2>/dev/null
rm -rf BopoBoard.app
sleep 2
./build.sh

# 2. Create DMG
./create-dmg.sh

# 3. Test
open BopoBoard-1.0.dmg
```

## 🔄 Development Workflow

### Standard procedure after code changes

```bash
# 1. Stop the app (IMPORTANT!)
killall BopoBoard

# 2. Wait (cache clearing)
sleep 2

# 3. Rebuild
./build.sh

# 4. Launch
open BopoBoard.app

# 5. Monitor logs (in separate terminal)
log stream --predicate 'subsystem == "com.local.BopoBoard"' --level debug
```

### Compile-check Swift code only

```bash
swiftc \
  -target arm64-apple-macosx13.0 \
  -sdk /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
  BopoBoard/**/*.swift \
  -o /tmp/test_build 2>&1 | grep -i "error\|warning"
```

## 🧪 Testing

### Mapping Validation

```swift
// KeyCodeMapper.swift
let mapper = KeyCodeMapper.shared
print(mapper.mappingStats)
print("Validation: \(mapper.validateMappings())")
```

### Manual Test Checklist

- [ ] Menu bar icon appears
- [ ] Click opens popover
- [ ] Permission request appears (first time only)
- [ ] Toggle enables/disables monitoring
- [ ] Basic keys (1,Q,A,Z) map correctly
- [ ] Tone marks (3,4,6,7) display correctly
- [ ] Modifier keys (Shift, Option, Command, Control) state shows
- [ ] Pressed keys highlight on visual keyboard
- [ ] Settings view opens
- [ ] Quit button terminates app

## 📊 Performance Monitoring

```bash
# CPU usage
top -pid $(pgrep BopoBoard) -l 1

# Memory usage
ps aux | grep BopoBoard | grep -v grep | awk '{print $6/1024 " MB"}'

# Process info
ps aux | grep BopoBoard | grep -v grep
```

Target metrics:
- CPU: <2% idle, <5% during key input
- Memory: <100MB

## 🔐 Security

### Verify Code Signature

```bash
codesign -dv --verbose=4 BopoBoard.app
```

### Check Entitlements

```bash
codesign -d --entitlements - BopoBoard.app
```

### Verify Accessibility Permission Reset

```bash
# Verify permission was reset
tccutil reset Accessibility com.local.BopoBoard
# Should output "Successfully reset"
```

## 📚 Related Files

- `build.sh` - Build script
- `create-dmg.sh` - DMG creation script
- `BopoBoard.entitlements` - App entitlements
- `ACCESSIBILITY_SETUP.md` - User guide for permission setup
- `ZHUYIN_MAPPING.md` - Detailed Zhuyin mapping reference

## ⚡️ Quick Reference

```bash
# Most important commands (memorize these)

# Restart with cache clearing
killall BopoBoard && sleep 2 && open BopoBoard.app

# Complete reset
killall BopoBoard && tccutil reset Accessibility com.local.BopoBoard && sleep 2 && open BopoBoard.app

# Build & run
./build.sh && open BopoBoard.app

# Create DMG
./build.sh && ./create-dmg.sh
```

## 🚨 Troubleshooting Checklist

When issues occur, check in this order:

1. [ ] `killall BopoBoard` - Fully stop the app
2. [ ] `sleep 2` - Wait for cache clearing
3. [ ] `./build.sh` - Rebuild (verify zero warnings)
4. [ ] Verify accessibility permission is granted
5. [ ] `open BopoBoard.app` - Launch
6. [ ] Check logs: `log stream --predicate 'subsystem == "com.local.BopoBoard"'`
7. [ ] If still failing, try `tccutil reset` to reset permissions
8. [ ] Last resort: Restart macOS

## 🔥 Common Pitfalls

### ❌ DON'T DO THIS:
```bash
# This may not work due to cached permissions
open BopoBoard.app  # Just opening without killing first
```

### ✅ DO THIS:
```bash
# Always use the full restart sequence
killall BopoBoard
sleep 2  # CRITICAL: Don't skip this!
open BopoBoard.app
```

---

## 🎯 Golden Rule

> **When restarting the app, ALWAYS follow this sequence:**
> `killall` → `sleep 2` → `open`
>
> Simply running `open` without killing and waiting may leave cached permission states,
> causing "permission granted but not working" issues.
