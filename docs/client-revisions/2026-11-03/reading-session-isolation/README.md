# Chapter 2 narration session isolation — 3 November 2026

Owner report: after a narrated page completes and its one-second allowance expires, the next page immediately exposes the complete paragraph without speaking.

## Fix

AssetNarrationPlayer previously retained one platform player and its position stream across recordings. Platform completion/position events have no source identity, so a late event from the previous recording could be accepted by the new reading session. The coordinator's epoch alone cannot distinguish an old platform event delivered through a new subscription.

Each narration now owns a separate AudioPlayer. Position/completion subscriptions are detached before stopping; the outgoing player is stopped and disposed before the next is created. No players accumulate. The global narration controller, pause/resume, master volume, bundled recordings, GLB and one-second reading allowance remain in place. Player creation adds a small per-recording setup cost; browser transition timings below include it.

## Evidence

- [Regression before fix](regression-red.txt): injected late position from the old platform player reaches the new reading stream. [Targeted tests](targeted-tests.txt): 18 passed, including old completion/position isolation. The regression also checks the next session remains unfinished, accepts its own positions, and disposes both players.
- [Full suite](full-tests.txt): 476 passed; [analysis](analyze.txt): no issues; [production web build](web-build.txt): succeeded with build ID `reading_session_isolation_20261103`.
- Strengthened existing reading-delay checks also verify every new page starts an unfinished narration with zero revealed characters and a talking mascot, then reveals only part of its paragraph as audio progresses. [Three delay/pause/manual-skip tests](delay-tests.txt) passed after this assertion change.
- Real Chromium browser, production audio/renderer through `tool/reading_review_main.dart`, Indonesian, CSS 411×900. One actual Continue click enters Chapter 2; all three subsequent recordings and transitions run automatically, without manual skips. [Raw browser audit](browser-audit.json) records all three real HTML audio play/ended events, increasing playback positions, progressive text, active Talk animation on pages 2 and 3, and the final unanswered quiz.
- Second recording starts about 1.18 seconds after the first ended; third starts about 1.42 seconds after the second ended (one-second allowance plus setup). Recorded playback lengths are about 9.18, 15.00 and 12.36 seconds. The audit's `error` entries with source `http://localhost:8795/` occur when the disposed HTMLAudioElement source is cleared, after completion; no prepared MP3 emitted an error.
- [Third page during narration](third-reading-playing.png), actual browser screenshot exported at 822×1800: text is partly revealed while Talk and the recording are active. This is a browser screen check, not a hardware capture. No new layout or asset changes were made.

Android remains deferred by the owner; physical Tizen playback is not validated in this follow-up. The event-isolation fix is shared by web and native narration players. Main revision tracker closure counts are unchanged pending owner review.
