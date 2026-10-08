# Fire Prevention Challenge

Offline, portrait Android touchscreen game for the KIFC Exhibition Room, Zone 1.

The implementation follows the approved Terms of Reference: bilingual content,
four short educational levels, score, and automatic reset for consecutive
visitors. The current screen is a technical shell while the Figma UI is reviewed.

## Targets

- Primary: Android APK for an exhibition touchscreen.
- Review: Flutter web build from the same codebase.
- Orientation: 1080 x 1920 portrait.
- Connectivity: fully offline at runtime.

## Run

```powershell
flutter pub get
flutter run -d chrome
```

For an attached Android device or emulator:

```powershell
flutter devices
flutter run -d <device-id>
```

## Validate and build

```powershell
flutter analyze
flutter test
flutter build apk --release
```

The final release must use a production signing key and be tested on the
procured touchscreen hardware.
