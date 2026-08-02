# 🏠 Install PlayerPath on Your iPhone — Free (No Subscription)

You have 3 options. Pick the one that works for you.

---

## Option 1: If You Have a Mac (Easiest)

No developer account needed. Uses your free Apple ID.

### Steps:

1. **Connect iPhone to Mac via USB cable**

2. **Open the iOS project in Xcode:**
   ```bash
   cd "004 PlayerPath"
   open ios/Runner.xcworkspace
   ```

3. **Sign in with your Apple ID:**
   - Xcode → Settings → Accounts → + → Apple ID
   - Use your regular Apple ID (free)

4. **Select your Personal Team:**
   - Click "Runner" in the left sidebar (topmost)
   - Under Signing & Capabilities, check "Automatically manage signing"
   - Team: select "Your Name (Personal Team)"
   - Xcode will auto-create a provisioning profile

5. **Trust the certificate on your iPhone:**
   - Settings → General → VPN & Device Management → tap your Apple ID → Trust

6. **Build & Run:**
   - Select your iPhone from the device dropdown (top of Xcode)
   - Press ▶ (or Cmd + R)
   - Wait 2-3 minutes for build + install

7. **Done!** The app appears on your home screen.

### Renewal:
- Free provisioning profiles expire after **7 days**
- Just plug in and re-run from Xcode to refresh
- Or: after 7 days, go to Settings → General → VPN & Device Management → re-trust

---

## Option 2: If You're on Windows — Use Codemagic (Free Tier)

Codemagic's free tier gives 500 build minutes/month. Your Apple ID (free) can create development builds.

### Steps:

#### A. One-Time Setup

1. **Get your iPhone's UDID:**
   - Connect iPhone to Windows via USB
   - Open iTunes (or find UDID in Finder on Mac)
   - Click the serial number until UDID appears
   - Copy the 40-character UDID
   - (Alternative: https://udid.tech on your iPhone)

2. **Sign up for Codemagic:**
   - Go to https://codemagic.io
   - Sign in with GitHub
   - Connect the `Mayfly2/playerpath` repo

3. **Add your Apple ID as a Codemagic integration:**
   - Codemagic → Teams → Integrations → Connect Developer Portal
   - Choose "Apple ID authentication"
   - Enter your Apple ID email + app-specific password
   - (To create an app-specific password: appleid.apple.com → Sign-In → App-Specific Passwords)

4. **Add your iPhone UDID:**
   - Codemagic → Teams → Devices → Add device
   - Enter device name (e.g. "My iPhone") and UDID

#### B. Build & Install

5. **Trigger the dev build:**
   ```bash
   git push
   ```
   Or manually: Codemagic → PlayerPath → Start new build → `ios-dev-install`

6. **Install on iPhone:**
   - Once build completes, Codemagic shows a QR code
   - Scan the QR code with your iPhone camera
   - Tap the download link
   - Go to Settings → General → VPN & Device Management → Trust
   - App appears on home screen!

### Renewal:
- Same 7-day expiry — just trigger another build

---

## Option 3: Use as Web App (Immediate, No Install)

This already works — the app runs in your browser.

```bash
cd "004 PlayerPath"
flutter run -d chrome --web-port=55555
```

Then on your iPhone:
- Open Safari → `http://[YOUR-PC-IP]:55555`
- Tap Share → "Add to Home Screen"
- It works like a native app (fullscreen, no browser chrome)

No expiry. No certificates. Works immediately.

---

## Recommended: Option 1 or 2

Option 1 (Mac + USB) is fastest. Option 2 (Codemagic) is wireless and doesn't need a Mac. Both are completely free.
