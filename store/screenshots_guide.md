# App Store Screenshots Guide

## Required Sizes (iOS)

| Device | Size | Required |
|--------|------|----------|
| iPhone 6.7" (15 Pro Max) | 1290 × 2796 | ✅ |
| iPhone 6.5" (11 Pro Max) | 1242 × 2688 | ✅ |
| iPhone 5.5" (8 Plus) | 1242 × 2208 | ✅ |
| iPad 12.9" (6th gen) | 2048 × 2732 | Optional |

## Required Sizes (Android)

| Type | Size |
|------|------|
| Phone Screenshots | Minimum 320px, Maximum 3840px |
| Feature Graphic | 1024 × 500 |
| App Icon | 512 × 512 |

## Screens to Capture (6-10 screens)

1. **Home Feed** — Personalised recommendations, nearby clubs, trending players
2. **Discover Tab** — Player search with filters
3. **Player Profile** — Full football CV with stats
4. **Club Profile** — Club page with squad & trials
5. **Messages** — Conversation with a club
6. **Search Filters** — Advanced player search
7. **AI Match Score** — Compatibility percentage
8. **Dark Mode Home** — Same screen in dark mode

## How to Generate Screenshots

### Option 1: iOS Simulator (Recommended)
```bash
# Run the app in simulator
flutter run -d "iPhone 15 Pro Max"

# Screenshot shortcut: Cmd + S
# Files saved to Desktop
```

### Option 2: Codemagic Screenshot Automation
Add to `codemagic.yaml`:
```yaml
scripts:
  - name: Generate screenshots
    script: flutter test integration_test/screenshots_test.dart
```

### Option 3: Manual on Device
1. Build to device: `flutter run --release`
2. Take screenshots using device buttons
3. Transfer to computer

## Status Bar Cleanup
Use `iOS` Simulator status bar override:
```bash
xcrun simctl status_bar "iPhone 15 Pro Max" override \
  --time "09:41" \
  --dataNetwork "wifi" \
  --wifiMode "active" \
  --cellularMode "active" \
  --batteryState "charged" \
  --batteryLevel 100
```

## Caption Guidelines
Each screenshot needs a caption (App Store):
- "Discover clubs near you"
- "Build your professional football CV"
- "AI-powered match scoring"
- "Apply to open trials instantly"
- etc.
