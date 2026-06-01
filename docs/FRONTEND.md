# Frontend — Flutter

## Tech Stack
- **Framework:** Flutter 3.11+ (Dart)
- **State:** StatefulWidget (no external state management)
- **HTTP:** `http` package + custom `ApiClient` wrapper
- **Camera:** `camera` + `image_picker` plugins
- **Auth:** `shared_preferences` for token/user persistence
- **Audio:** `audioplayers: ^6.1.0`
- **Icons:** `lucide_icons_flutter`

## Project Structure

```
lib/
├── core/              # AppColors, AppTheme
├── models/            # AppUser, ScanResult, Achievement, etc.
├── screens/
│   ├── auth/          # LoginScreen, RegisterScreen
│   ├── main/          # Home, Camera, Result, History, Profile, etc.
│   └── splash/        # LoadingScreen
├── services/          # ApiClient, ApiService, AuthService, ScanService
└── widgets/           # CustomTextField, NotificationPopup
```

## Key Features

- **Camera** — real-time preview, capture, gallery upload
- **Scan Result** — fruit classification output with confidence scores
- **History** — past scans with search/filter
- **Achievements** — gamification system with confetti animation
- **Notifications** — welcome, article tips, achievement unlocks
- **Profile** — edit name/phone, upload photo, stats cards

## Build APK

```bash
flutter build apk --debug    # quick build for testing
flutter build apk --release  # requires keystore setup (see release signing guide)
```

## Important Notes

- IP address is hardcoded in `lib/services/api_client.dart` — update when WiFi changes
- Android requires `android:usesCleartextTraffic="true"` in AndroidManifest.xml
- All system messages use NotificationPopup (slide-down overlay), never SnackBar
