# Thirukkural

Production-quality Flutter app for reading Thirukkural offline on **Android**, **iOS**, and **Web**.

## Architecture

```text
UI → KuralRepository → KuralLocalDataSource → assets/data/*.json
```

- Local JSON only (no backend / API / Firebase)
- Existing Kural JSON field names preserved exactly
- Chapter metadata in a separate `chapters.json`

## Run

```bash
cd thirukkural
flutter pub get
flutter run -d chrome
flutter run -d <android-device>
```

## Build

```bash
flutter build web
flutter build apk --release
```

## Verify

```bash
flutter analyze
flutter test
```

## Features

- Daily deterministic Kural
- Random Kural
- 133 chapters across 3 sections
- Local search
- Offline favorites (`shared_preferences`)
- Copy / Share
- Light / Dark / System theme
- Font size settings
- Responsive mobile + desktop layouts
- Web deep links (`/kural/1330`)
