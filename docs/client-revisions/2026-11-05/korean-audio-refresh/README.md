# Korean narration refresh - 5 November 2026

The owner supplied regenerated welcome, closing, karhutla-cause and karhutla-prevention recordings. Their originals are preserved under assets/audio/narration/incoming/revisions/2026-11-05/ko/. Four runtime MP3s replace the previous Korean recordings at the existing offline asset paths; [source/output hashes, normalization and word timestamps](recordings-and-timings.json).

| Recording | Prepared duration |
| --- | --- |
| welcome | 5.433 seconds |
| closing | 7.340 seconds |
| karhutla-prevention | 11.180 seconds |
| karhutla-cause | 12.382 seconds |

Each replacement uses the existing two-pass -18 LUFS / -1.5 dBTP preparation at 44.1 kHz and 192 kbps MP3. All four decode successfully. The ASR output matches the PDF script after removing spaces/punctuation. The closing greeting was verified separately on the first 1.8 seconds because the initial full-clip ASR pass omitted its words. Generation model/voice settings were not provided with these exports.

## Subtitle and mascot behavior

Korean Chapter 2 readings 2 and 3 now use word cues derived from the new recordings, their new duration and new MP3 hash. Provisional old-audio metadata was removed. PDF wording, spaces and approved line breaks remain intact. The full paragraph keeps a fixed layout while the visible prefix follows player position. One boundary per reading is interpolated inside an ASR-merged word: 못 / 하게 and 높이곤 / 합니다. These estimates are recorded, rather than presented as manually verified word boundaries.

Existing narration completion controls the mascot Talk/mouth state for all four recordings. In Chapter 2, completion exposes the full paragraph, ends the speaking state and waits one second before advancing. Session isolation and manual-skip cancellation remain covered by regression. Welcome repeats on its existing schedule; closing retains its 30-second screen deadline.

## Verification

- [Full regression](full-tests.txt): 496 tests passed. [Analysis](analyze.txt): no issues. [Release web build](web-build.txt): succeeded with build ID `korean_audio_refresh_20261105`. [Bundle integrity](bundle-integrity.txt): all four asset manifest entries and MP3 hashes match the replacement manifest. Rebuilding reading_timing.json from the source tools preserves all nine current entries exactly.
- [Targeted regression](targeted-tests.txt): 19 tests passed, including 10 new Korean reading renders (two cards x five portrait viewports), partial word reveal at the actual cue-derived midpoint, narrating state, complete text at 999ms, and the next page at 1000ms. [Pre-change regression failure](regression-red.txt) detects provisional old-audio cues.
- [Audio integrity](audio-integrity.txt): four MP3s decode; all nine reading hashes and cue ranges pass; seven other reading timelines are byte-for-data unchanged.
- Captures are actual Flutter widget renders with controlled narration positions/completion and static mascot fallback. They do not demonstrate physical speaker playback or live WebGL mouth motion. Android/physical Tizen testing remains deferred. Word-level listening review remains useful for the two estimated boundaries.

## Screenshots

| Portrait viewport | Reading 2 partial | Reading 2 complete | Reading 3 partial | Reading 3 complete |
| --- | --- | --- | --- | --- |
| 360x640 | [Open](images/karhutla-cause-partial-360x640.png) | [Open](images/karhutla-cause-complete-360x640.png) | [Open](images/karhutla-prevention-partial-360x640.png) | [Open](images/karhutla-prevention-complete-360x640.png) |
| 411x731 | [Open](images/karhutla-cause-partial-411x731.png) | [Open](images/karhutla-cause-complete-411x731.png) | [Open](images/karhutla-prevention-partial-411x731.png) | [Open](images/karhutla-prevention-complete-411x731.png) |
| 720x1280 | [Open](images/karhutla-cause-partial-720x1280.png) | [Open](images/karhutla-cause-complete-720x1280.png) | [Open](images/karhutla-prevention-partial-720x1280.png) | [Open](images/karhutla-prevention-complete-720x1280.png) |
| 1080x1920 | [Open](images/karhutla-cause-partial-1080x1920.png) | [Open](images/karhutla-cause-complete-1080x1920.png) | [Open](images/karhutla-prevention-partial-1080x1920.png) | [Open](images/karhutla-prevention-complete-1080x1920.png) |
| 2160x3840 | [Open](images/karhutla-cause-partial-2160x3840.png) | [Open](images/karhutla-cause-complete-2160x3840.png) | [Open](images/karhutla-prevention-partial-2160x3840.png) | [Open](images/karhutla-prevention-complete-2160x3840.png) |

Commit integrasi audio dan timing: `4e855d7a6be8f3bb7a61fbaee3713923d1a747eb`.
