# MedTrack 💊
### Smart Medicine Expiry Tracker

A **production-grade, cross-platform Flutter application** for households and small clinics to track medicine expiry dates via OCR, proactive push notifications, and smart analytics.

---

## 🏗 Architecture

```
Clean Architecture + Feature-First + Riverpod (MVVM)

lib/
├── core/               # Shared utilities, theme, router, providers
│   ├── constants/      # AppColors, AppSizes, AppRoutes, AppStrings
│   ├── error/          # Failure / Exception classes
│   ├── extensions/     # DateTime & String extensions
│   ├── providers/      # Riverpod DI providers
│   ├── router/         # GoRouter with auth-guard
│   ├── theme/          # Material 3 dark/light themes
│   └── utils/          # DateParser, ExpiryRiskEngine
├── features/
│   ├── auth/           # Firebase Auth (email + Google Sign-In)
│   ├── dashboard/      # Analytics, charts, risk score
│   ├── medicines/      # CRUD, Firestore stream, cards
│   ├── scanner/        # ML Kit OCR, demo mode
│   ├── notifications/  # Settings, FCM
│   ├── disposal/       # WHO-based disposal guide
│   └── family/         # Household accounts, roles
├── app.dart            # MaterialApp.router
└── main.dart           # Initialization
```

---

## ⚙️ Firebase Setup (REQUIRED before running)

### Step 1: Create Firebase Project
1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create a new project: **"medtrack-app"**
3. Enable **Google Analytics** (optional)

### Step 2: Enable Firebase Services
- **Authentication** → Enable Email/Password and Google Sign-In
- **Firestore Database** → Create in production mode
- **Storage** → Enable (default rules)
- **Cloud Messaging** → Enabled by default

### Step 3: Register Android App
1. In Firebase Console → Project Settings → Add App → Android
2. Package name: `com.medtrack.medtrack`
3. Download `google-services.json`
4. Place at: `android/app/google-services.json`

### Step 4: Register iOS App (optional)
1. Add iOS app with bundle ID: `com.medtrack.medtrack`
2. Download `GoogleService-Info.plist`
3. Place at: `ios/Runner/GoogleService-Info.plist`

### Step 5: Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=medtrack-app
```
This generates `lib/firebase_options.dart` automatically.

### Step 6: Update main.dart
In `lib/main.dart`, uncomment:
```dart
import 'firebase_options.dart';
// ...
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```
And remove the plain `Firebase.initializeApp()` call.

### Step 7: Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

---

## 📱 Running the App

```bash
# Install dependencies
flutter pub get

# Run on connected Android device / emulator
flutter run

# Build release APK
flutter build apk --release

# Build App Bundle (Play Store)
flutter build appbundle --release
```

### Android Permissions (already in AndroidManifest)
- `CAMERA` — for OCR scanning
- `INTERNET` — for Firebase
- `VIBRATE` — for notifications

---

## 🤖 OCR Scanner
- Uses **Google ML Kit Text Recognition** (on-device, no API key needed)
- Supports 5 date patterns: `MM/YYYY`, `DD/MM/YYYY`, `EXP MM/YY`, `YYYY-MM-DD`, `MM/YY`
- **Demo Mode** available for emulator testing (tap the ⚗️ button)
- Falls back to manual date entry if OCR confidence < 70%

---

## 🔔 Notifications

### Local Notifications
Schedule is automatic when adding a medicine with notifications enabled.

### Firebase Cloud Functions (optional — requires Blaze plan)
```bash
cd functions
npm install
firebase deploy --only functions
```

---

## 🧪 Running Tests

```bash
# All unit tests
flutter test

# With coverage
flutter test --coverage

# Specific test file
flutter test test/unit/core/utils/date_parser_test.dart
```

---

## 📊 Key Features

| Feature | Status |
|---------|--------|
| Firebase Auth (Email + Google) | ✅ |
| Firestore real-time sync | ✅ |
| On-device OCR (ML Kit) | ✅ |
| Dashboard with fl_chart analytics | ✅ |
| Expiry Risk Score | ✅ |
| Smart Notifications (FCM + Local) | ✅ |
| Family Shared Accounts | ✅ |
| Safe Disposal Guide (WHO) | ✅ |
| Dark Mode | ✅ |
| Offline Caching (Hive) | 🔧 Ready (init stubbed) |
| Cloud Functions | ✅ (deploy separately) |
| Unit Tests | ✅ |

---

## 📚 Data Sources & Datasets

We utilize a variety of global and India-specific datasets for drug classification, generic mapping, and pricing information. For a full list of resources, see [DATASETS.md](DATASETS.md).

---

## 🚀 Deployment

### Android (Play Store)
1. Create a keystore: `keytool -genkey -v -keystore medtrack.jks`
2. Configure signing in `android/app/build.gradle`
3. `flutter build appbundle --release`

### iOS (App Store)
1. Open Xcode: `open ios/Runner.xcworkspace`
2. Set Team & Bundle Identifier
3. Archive and upload via Xcode

---

## 🎓 SEPM Project Info

- **Subject**: Software Engineering & Project Management
- **Architecture**: Clean Architecture + MVVM + Riverpod
- **Design Pattern**: Feature-First, Repository Pattern, Use Cases
- **Testing**: Unit + Widget + Integration
- **Security**: Firestore Rules, Firebase Auth, HTTPS-only
