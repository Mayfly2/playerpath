# 🚀 PlayerPath App Store Deployment Checklist

## Pre-Deployment (Do these ONCE)

### Apple Developer Account (£79/year)
- [ ] Enroll at https://developer.apple.com/programs/
- [ ] Accept all agreements in App Store Connect
- [ ] Set up two-factor authentication

### App Store Connect Setup
- [ ] Create App ID: `com.playerpath.app` (https://developer.apple.com/account/resources/identifiers)
- [ ] Enable capabilities: Push Notifications, Sign In with Apple
- [ ] Create App Store Connect app entry (https://appstoreconnect.apple.com)
- [ ] Set bundle ID: `com.playerpath.app`
- [ ] Fill in app metadata (see `store/apple/app_store_listing.md`)

### App Store Connect API Key
- [ ] Go to Users & Access → Integrations → App Store Connect API
- [ ] Generate API key with "Developer" role
- [ ] Download the `.p8` file
- [ ] Note: Key ID, Issuer ID
- [ ] Encode .p8 file as base64: `base64 -i AuthKey_XXXXXX.p8`
- [ ] Add all 3 values to Codemagic `app_store_credentials` group

### Google Play Developer Account ($25 one-time)
- [ ] Register at https://play.google.com/console
- [ ] Pay registration fee
- [ ] Complete account verification

### Google Play Setup
- [ ] Create app in Play Console
- [ ] Package name: `com.playerpath.app`
- [ ] Fill in app metadata (see `store/google/play_store_listing.md`)

### Google Play Service Account
- [ ] Go to Google Cloud Console → IAM → Service Accounts
- [ ] Create service account with "Play Android Developer" role
- [ ] Generate JSON key
- [ ] Add to Codemagic `google_play_credentials` group as `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`
- [ ] Invite service account email to Play Console (Users & Permissions)

### Firebase Setup
- [ ] Create Firebase project at https://console.firebase.google.com
- [ ] Add iOS app (`com.playerpath.app`) → download `GoogleService-Info.plist` → place in `ios/Runner/`
- [ ] Add Android app (`com.playerpath.app`) → download `google-services.json` → place in `android/app/`
- [ ] Enable Authentication (Email, Google, Apple)
- [ ] Enable Cloud Firestore (if needed)
- [ ] Enable Cloud Messaging (push notifications)
- [ ] Enable Crashlytics
- [ ] Upload APNs auth key to Firebase (for iOS push)

### DNS / Domain
- [ ] Register `playerpath.app` domain
- [ ] Set up landing page
- [ ] Create privacy policy page
- [ ] Create support/contact page

---

## Build & Deploy

### Codemagic Setup
- [ ] Connect GitHub repo (`Mayfly2/playerpath`) to Codemagic
- [ ] Add environment variable groups:
  - `app_store_credentials`: API_KEY, KEY_ID, ISSUER_ID
  - `google_play_credentials`: GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
  - `NOTIFY_EMAIL`: your email address

### First iOS Build
- [ ] Trigger `ios-release` workflow in Codemagic
- [ ] Wait for build to complete (~20-30 min)
- [ ] Check TestFlight for the build
- [ ] Install TestFlight on iPhone
- [ ] Test the app thoroughly

### First Android Build
- [ ] Trigger `android-release` workflow in Codemagic
- [ ] Wait for build to complete (~10-15 min)
- [ ] Check Play Console → Internal Testing
- [ ] Install on Android device
- [ ] Test the app thoroughly

---

## Pre-Submission Checklist

### App Quality
- [ ] `flutter analyze` — 0 errors
- [ ] `flutter test` — all passing
- [ ] Test on real iPhone (not just simulator)
- [ ] Test on real Android device
- [ ] Test auth flow (login, signup, logout)
- [ ] Test network error states (airplane mode)
- [ ] Test dark mode
- [ ] Test all tabs navigate correctly
- [ ] Test push notifications
- [ ] App doesn't crash when denied camera/location permissions

### Metadata
- [ ] App name: "PlayerPath — Grassroots Football Recruitment"
- [ ] Subtitle (iOS): "Find clubs. Get scouted. Play."
- [ ] Description filled (see store listings)
- [ ] Keywords set (iOS)
- [ ] Category: Sports
- [ ] Screenshots: minimum 3 sizes for iOS, 4 screenshots for Android
- [ ] App icon: 1024×1024 no alpha channel
- [ ] Privacy policy URL live
- [ ] Support URL live

### Compliance
- [ ] App Tracking Transparency configured (Info.plist NSUserTrackingUsageDescription)
- [ ] GDPR: User data export/deletion in settings
- [ ] Age rating survey completed
- [ ] Content rights: all assets are original or licensed
- [ ] No third-party copyrighted material (club badges may need permission)

---

## Submission

### iOS
- [ ] Build passes App Store validation
- [ ] Submit for Review in App Store Connect
- [ ] Select "Manually release this version"
- [ ] Wait for review (1-3 days typically)
- [ ] Address any rejections
- [ ] Release!

### Android
- [ ] Promote from Internal → Closed → Production track
- [ ] Submit for review
- [ ] Wait for review (few hours to 2 days)
- [ ] Release!

---

## Post-Launch

- [ ] Monitor Crashlytics dashboard
- [ ] Respond to App Store reviews
- [ ] Track analytics
- [ ] Plan v1.0.1 fixes
