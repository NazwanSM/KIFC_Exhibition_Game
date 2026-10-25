# Fire Prevention Challenge

Offline, portrait Android touchscreen game for the KIFC Exhibition Room, Zone 1.

The implementation follows the approved Terms of Reference: content in Indonesian, English and Korean,
four short educational levels, score, and automatic reset for consecutive
visitors. The current preview includes the four chapters, photographic scenes,
drag-and-drop fire-triangle assembly and an interactive element-reduction demo.

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

## Web preview

The latest `main` branch is published automatically through GitHub Pages:

https://nazwansm.github.io/KIFC_Exhibition_Game/

The revised UI and Indonesian script are reviewed separately:

- Source branch: `preview/revisi-ui-2026-10-16`
- Preview site: https://nazwansm.github.io/KIFC_Exhibition_Game_Preview/
- Deployment repository: https://github.com/NazwanSM/KIFC_Exhibition_Game_Preview

The preview repository has its own GitHub Pages workflow. It checks out this
source branch and builds with `/KIFC_Exhibition_Game_Preview/` as the base path.
To publish another revision after pushing this branch, run **Deploy isolated KIFC
preview** from the deployment repository's Actions tab. Its `source_ref` input
accepts this branch or a specific source commit. Publishing the preview does not
require merging into `main` or changing the original Pages configuration.

For a local browser preview:

```powershell
flutter run -d web-server --web-port 8080
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
