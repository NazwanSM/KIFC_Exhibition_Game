# Android emulator performance observations — 24 October2026

Scope: APK integration review KIFC-X03, code e8f471f, build source a7796f7. Functional tests are complete; release/physical-TV performance is not assessed. The report follows ccgs-perf-profile and keeps missing measurements explicit.

## Inputs

| Input | Availability |
|---|---|
| Current source, APK,53 matching offline asset hashes | FOUND |
| Three actual native complete journeys and per-process audio logs | FOUND |
| Android dumpsys meminfo/media.player/connectivity | FOUND |
| Emulator GPU startup logs and display metadata | FOUND |
| SurfaceFlinger latency attempt | FOUND; returned zero timestamps, unusable for FPS |
| project.yaml/project.local.yaml performance budgets | ABSENT |
| Committed FPS, frame-time, memory or startup budget | ABSENT |
| Physical42-inchTV/model/mount/speakers | ABSENT |
| Profile/release capture on target hardware | ABSENT |

## Measurements and limits

Environment: Android Emulator37.2.12/API35,x86_64,1080x1920,density420,portrait. Functional APK is debug/JIT. Host is Windows with16GB RAM; NVIDIA RTX3050 selected with `-gpu host`. Emulator software renderer originally used SwiftShader.

- Korean journey memory snapshot: total PSS266307KiB (260.1MiB), RSS362004KiB (353.5MiB), swapPSS453KiB. This is one snapshot during the timed challenge, not a maximum or leak test. [Raw memory](../../build/review-kifc-x03-latest/ko-memory-snapshot.txt).
- Nine native media-player clients are retained for fixed sources. Each ID/EN/KO journey records one source preparation through replay, one assembly cue and one final cue. The two loops continue with effects; no unhandled Flutter/audio exceptions in the tested journeys. [Native players](../../build/review-kifc-x03-latest/ko-native-players.txt), [journey results](../../build/review-kifc-x03-latest/native-journeys.json).
- AudioTrack metadata in this emulator reports latency612ms on a short effect stream. This is virtual output metadata, not a measured touch-to-sound delay and not a TV measurement. End-to-end speaker latency needs a physical-device measurement before changing player modes or promising responsiveness.
- SurfaceFlinger exposed a16666666ns display period but returned all-zero per-frame timestamps. **FPS/frame percentiles NOT ASSESSED — NO VALID DATA.** Display refresh period is not application FPS. [Attempt](../../build/review-kifc-x03-latest/surface-latency-attempt.txt).

| Metric | Committed budget | Measured observation | Verdict |
|---|---|---|---|
| App frame time/FPS | None | No usable frame timestamps | NOT ASSESSED; no headroom claim |
| Memory ceiling | None | PSS260.1MiB snapshot,debug emulator | No budget set; headroom not assessed |
| Cold launch time | None | No comparable profile-mode target run | NOT ASSESSED |
| Draw calls | None | No GPU capture | NOT ASSESSED |
| Speaker latency/comfort | None | Virtual output metadata only | NOT ASSESSED on TV |

## Findings and follow-up

1. SwiftShader emitted repeated `glWaitSync ... error0x501` and the emulator process exited. Switching the review process to host GPU allowed all three complete journeys. This is an observed emulator-renderer difference; no production graphics setting was changed. [Host renderer log](../../build/review-kifc-x03-latest/emulator-host.log).
2. FullHD and720p captures work. A4K welcome capture succeeded, then a later host ADB command terminated with std::bad_alloc/Windows exit3221226505 while taking hierarchy evidence. The game PID remained7852 before/after restoration, and1080x1920/density420 was restored. Additional4K native panels are NOT ASSESSED. Existing4K widget renders remain separately labeled evidence. Avoid running4K emulator capture alongside other heavy host tasks; inspect host commit-memory limits before retrying.
3. Stock UIAutomator waits for an idle screen and missed the live countdown. A test-only shell helper captures hierarchy with idle wait0 and requires a fresh XML each time. All three native final challenges then completed with real input and the unchanged30second timer. This is a test-tool fix, not a game timing change.
4. Before sign-off, connect the actual TV/player, run Flutter profile mode, capture frame timings during six fires plus audio, repeat sessions for memory growth, and measure touch-to-audio at the speakers. Set performance budgets with the owner before reporting a pass or headroom. Physical mounting/reach, reading time and room acoustics remain open.

No speculative optimization or new graphics/audio subsystem was introduced.

Flutter recommends profile mode on physical hardware; debug/emulator performance does not represent release behavior: [Flutter performance guidance](https://docs.flutter.dev/perf/ui-performance). Android system snapshots use [dumpsys](https://developer.android.com/tools/dumpsys).

Verdict: **COMPLETE — observations report saved.** Functional emulator review passes; target-device performance remains **NOT ASSESSED — NO DATA**.
