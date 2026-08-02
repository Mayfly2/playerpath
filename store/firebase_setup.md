# Firebase Configuration Guide

## iOS Setup

1. Go to https://console.firebase.google.com
2. Create a new project: `PlayerPath`
3. Add iOS app with bundle ID `com.playerpath.app`
4. Download `GoogleService-Info.plist`
5. Place it at: `ios/Runner/GoogleService-Info.plist`

```
ios/
└── Runner/
    └── GoogleService-Info.plist  ← Place here
```

## Android Setup

1. In the same Firebase project, add an Android app
2. Package name: `com.playerpath.app`
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

```
android/
└── app/
    └── google-services.json  ← Place here
```

## Firebase Services Used
- Firebase Authentication (Google Sign-In)
- Firebase Cloud Messaging (Push Notifications)
- Firebase Crashlytics (Crash Reporting)
- Firebase Analytics

## Codemagic Environment Variables

Add these to your Codemagic `app_store_credentials` group:

| Variable | Description |
|----------|-------------|
| `APP_STORE_CONNECT_API_KEY` | App Store Connect API key (base64) |
| `APP_STORE_CONNECT_KEY_ID` | Key ID from App Store Connect |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID from App Store Connect |

Add these to your Codemagic `google_play_credentials` group:

| Variable | Description |
|----------|-------------|
| `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` | Google Cloud service account JSON |
| `NOTIFY_EMAIL` | Email for build notifications |
