# Android review tools

These helpers operate an installed APK through ADB input and actual UIAutomator accessibility nodes. They never invoke private game state, change scores or shorten timers. Screenshots are native emulator captures, not photographs of a TV.

1. Build/install the APK and start the isolated review AVD. Current test environment is API35,1080x1920,density420,portrait,host GPU. Disable emulator Wi-Fi/mobile data and confirm `dumpsys connectivity` has no active default network.
2. Run `pwsh -NoProfile -File tool/android/prepare.ps1`. Optional `-SdkRoot` and `-Serial` select the SDK/emulator. Requires SDK35/build-tools35.0.0, javac, and cached JUnit4.13.2; it does not download packages.
3. Run `python tool/android_journey.py --lang id --output build/review-kifc-x03-latest/id-final`; repeat sequentially for en/ko. Output includes screenshots, input events, final score/cue assertions and app-specific logcat. AndroidReview defaults to emulator-5554 and D:/Android/Sdk/platform-tools/adb.exe; constructor parameters can select another local setup.

`KifcDump.java` runs only in the temporary shell UIAutomator process. It sets idle wait to0 because the live countdown updates continuously. The stock dump command can consume the challenge while waiting for idle. A fresh XML file is required on each invocation; transient missing roots retry with bounds. Android35 runner/base jars are explicitly on the test process classpath. This legacy SDK utility is intentionally limited to local review; it is not included in the APK or a new app dependency.

The journey checks a decoy drop (0/3), correct assembly (3/3), all reduction options, reading order, wrong/right peat answers, four cause answers, three unscored cards, neutral final selections with cancellation, final score8/8, closing and replay reset. Audio logs must contain one final cue and one source preparation across replay, with no unhandled Flutter/audio exception. Output is functional evidence; it does not establish release FPS, physical reach, localization approval or calibrated speaker volume.
