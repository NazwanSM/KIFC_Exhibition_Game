# R30-20 — integrated review, including Samsung Tizen

Status: **review package prepared; integrated verification in progress**, not a declaration that all 20 tickets are closed. Android execution was postponed by the owner. No physical TV or native Tizen OS emulator was tested.

Verification/tooling checkpoint: `ab13abf4cb3d4bf03ae12f9b5198b0490feb7dce`. The current-source archive also includes the pending integration described below; checking out this checkpoint alone does not reproduce all current working-tree gameplay changes.

## Results

| Layer | Result and actual scope |
|---|---|
| Flutter regression | **465 passed**, analysis clean; [summary](verification.json). Full widget journeys cover languages, scoring (maximum 8), retries, timers, audio cancellation and reading progression. |
| Timing integrity | Nine reading items: matching MP3 hashes, ordered cues, bounds within recording duration. Fifteen split Korean cues remain estimates requiring listening review. |
| Browser | Production web build boots, local Roboto/CanvasKit and GLB load without external font/CDN requests; language changes, sound controls, pointer assembly, video and Talk state inspected. This is not a claim of three complete production browser journeys. |
| Official Samsung TV Web Simulator 10.0.6 | Installed the production **unsigned WGT** and ran the Indonesian flow: real pointer Start/drop, 3/3, video, explanation, Talk skeletal and mouth morph changes, skip to unanswered risk, wrong/right feedback, four causes, three information cards, Finish Selecting, **7/8** (no impact answers selected), closing Wave → WaveSilent and return after 30 seconds. English/Korean idle recordings played after the 20-second interval. |
| Remote input | SDK delivered legacy keyCodes 37/39/40/13. This does **not** establish complete remote-only navigation. The drag activity still requires a touchscreen or pointer. |
| APK | Release build **1.0.10-r30-review / 2026110331**, minimum Android API 24; exact runtime GLB, poster, timing, font, video/music and all 15 narration bytes verified against WGT and source assets. **Not installed or retested on Android**, per owner instruction. |

The first full regression found nine failures: enlarged decorative feedback narrowed cause explanations enough to scroll, Continue was below the provisional TV touch area, and an old speech-pointer test searched only static text after progressive text was introduced. Fixed the cause bubble reservation while keeping its larger mascot, restored the TV Continue anchor and updated the audit to inspect the actual progressive reading content. The subsequent full suite passed all 465 tests.

Release lint found missing `includeSubdomains` attributes in the existing loopback-only Android network configuration. Explicit `false` fixes the schema without allowing other cleartext hosts. Release build then passed. Its current signing configuration uses the project's **debug key for review**, not a store release certificate.

## Tizen findings and boundaries

The `.wgt` route is **Flutter Web wrapped as a Samsung TV Web widget**. Native `flutter-tizen build tpk` produces a different `.tpk` route and needs a separate platform/plugin port; it is not an APK-to-WGT conversion. [Flutter-Tizen commands](https://github.com/flutter-tizen/flutter-tizen/blob/main/doc/commands.md), [Samsung Web application tools](https://developer.samsung.com/smarttv/develop/tools/additional-tools/vscode/tv-simulator.html).

The simulator is not a native Tizen OS emulator. Its actual engine reports **Chromium 137 / NW.js 0.100.1**, despite a legacy Chrome/55 user-agent string. Samsung lists Tizen 10 TV hardware as Chromium 130. Therefore the WGT is a **Tizen 10 compatibility candidate**, not certified for every Samsung model/year. TV model and touch-input compatibility are still unknown. [Samsung engine specifications](https://developer.samsung.com/smarttv/develop/specifications/web-engine-specifications.html).

The default Windows simulator transparent window left stale CanvasKit content after transitions/language changes. This was confirmed in both SDK and Windows window captures. An **SDK-local `window.transparent=false` workaround** corrected the inspected language and reading transitions; no game code was changed for this workaround. Use the [opaque SDK captures](tizen/opaque-sdk/) for the latest visual review; earlier transparent-window captures are retained as diagnostic evidence, not passed visual results.

The simulator also overrides HTML media volume/mute readings (video reported volume .6; audio reported 1). The footage has **zero audio tracks** by ffprobe. Real volume comfort, ducking acoustics and OS background/power behavior cannot be certified using these mocked readings. Widgets verify mixer logic; device listening remains open.

Local-package startup and play use `file://` resources with **no HTTP/HTTPS asset requests** after bundling Roboto and disabling the Flutter resource CDN. A forced global network-block/reload stress attempt made the SDK instance unstable; that attempt is **not accepted as full OS offline proof**. Offline APK/native-TV certification remains open. Original and failed SDK logs are distinguished from the final successful local-package journeys.

## Evidence

- [Opaque SDK smoke result](tizen/opaque-sdk/journey-result.json), [samples including actual changing mouth weights](tizen/opaque-sdk/journey.json).
- [Full Indonesian journey, score and closing](tizen/opaque-sdk/finish-journey.json).
- [English/Korean idle voice and remote event data](tizen/locale-remote.json).
- [Latest SDK reading screenshot](tizen/opaque-sdk/simulator-reading.png), [Korean language rendering](tizen/opaque-sdk/korean.png).
- [Production browser welcome in Korean](browser/welcome-ko.png), with the real-time Wave GLB visible; the actual capture pixel dimensions are recorded in the evidence index.
- `widget/`: five portrait sizes × three languages for assembly and feedback/result screens. These are **Flutter widget renders with static mascot fallbacks**, separate from the SDK's real-time GLB playback.
- SDK screenshots include its remote-control chrome; they are actual desktop simulator screenshots, not TV photographs. App viewport was 1080×1920 with SDK display scaling; image pixel sizes are listed in [evidence index](evidence-index.json).
- [Artifact hashes and byte verification](package-manifest.json), [source snapshot index](source-snapshot.json).

## Review package

Artifacts are under `build/delivery/KIFC-1.0.10-r30-review/`:

- `KIFC-1.0.10-r30-review.apk`: Android review build; install/test later as requested.
- `KIFC-1.0.10-tizen10-unsigned.wgt`: accepted by simulator; **unsigned**, so physical Samsung installation still needs the appropriate signing/profile workflow.
- `KIFC-web-offline-resources.zip`: serve via HTTP for browser review; local resources included, but no blanket web offline guarantee.
- `KIFC-current-source-review.zip`: exact current source/assets, including pending working-tree narrative integration, with per-file hashes. This is reproducible review material, **not an assertion that tickets 17–19 already have separate completed commits**.
- `checksums.json` and font license.

The old 1.0.5 package was not overwritten. Nothing was pushed, deployed or distributed externally.

## Reproduce Samsung simulator testing

From the project root:

```powershell
flutter build web --no-pub --no-wasm-dry-run --no-web-resources-cdn
python tool/tizen/package_web.py
python tool/tizen/setup_simulator.py
pwsh -NoProfile -File tool/tizen/launch_simulator.ps1
```

The setup downloads the official versioned SDK ZIP, verifies its recorded SHA-256, and applies the local opaque-window workaround. It does not install a Tizen OS emulator or change Windows virtualization settings. The SDK remains outside the repository at `D:\KIFC-tizen-tools`.

Install, set portrait orientation, **then launch** (orientation changes reset the simulator app surface):

```powershell
$sdkApi = 'http://localhost:38888'
$widgetPath = (Resolve-Path 'build/tizen/KIFC-1.0.10-unsigned.wgt').Path
Invoke-RestMethod "$sdkApi/app/install" -Method Post -ContentType 'application/json' -Body (@{path=$widgetPath;type='wgt'} | ConvertTo-Json)
Invoke-RestMethod "$sdkApi/display/orientation" -Method Post -ContentType 'application/json' -Body '{"orientation":"portrait"}'
Invoke-RestMethod "$sdkApi/app/launch" -Method Post -ContentType 'application/json' -Body '{"appId":"KIFCGameTV"}'
node tool/tizen/simulator_journey.mjs
node tool/tizen/simulator_finish_journey.mjs
node tool/tizen/simulator_locale_remote.mjs
```

The journey tools inspect public renderer/media state and use actual pointer/SDK remote input; they do not set game scores, shorten timers or invoke private game navigation fixtures.

## Still open

- Owner-requested deferral of Android runtime/offline checks: tickets 09/11 and the device portion of 20 remain open.
- Native Tizen OS emulator or real-TV validation, Samsung signing, real display/touch input mapping, speaker comfort, measured FPS/memory and longer soak tests. Simulator results cannot replace these.
- Subjective final visual/listening review for 16–19, including the 15 estimated Korean cues. Their integration remains in the source review snapshot; separate completion commits must not be invented.
- Full remote-only interaction would require an additional input design for drag-and-drop. It is not silently claimed by receiving remote key events.
