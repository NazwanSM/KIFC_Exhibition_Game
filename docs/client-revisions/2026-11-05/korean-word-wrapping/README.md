# Korean word wrapping — 5 November 2026

Follow-up to the owner's audit: Korean words and particles could wrap onto separate lines in headings, choices, dialogue and feedback. The previous welcome-only protection is now applied to Korean localized text throughout the game, including the audio-unavailable message. A display-only word joiner preserves each space-delimited Korean word. Underlying translations and accessibility labels stay plain; Indonesian and English display strings are unchanged.

The progressively revealed Chapter 2 text applies the same wrapping to the full paragraph, including across the visible/hidden boundary. It maps original character offsets to rendered offsets, so word cue positions and spoken narration remain based on the original script. Korean narration text uses the bundled Korean font. A focused test verifies unchanged visible semantics, content and word layout across the reveal boundary.

## Verification

- [Full Flutter regression](tests.txt): 477 tests passed. [Analysis](analyze.txt): no issues. [Release web build](web-build.txt): success, build ID `korean_word_wrap_20261105`.
- [Word-boundary and layout audit](audit-tests.txt): 240 rendered states across five portrait viewports, 44 distinct states including all nine final feedback branches. [Raw results](audit.json): zero split Korean words, zero word boxes extending horizontally past their paragraph, and zero recorded layout exceptions. The audit checks rendered word geometry; transparent spaces past the line edge and font ascenders outside line-height boxes are not treated as clipped characters. Reading pages display their full paragraph with reduced motion for this audit.
- [Three-language layout matrix](locales.txt): 15 final-feedback layouts passed (Indonesian, English, Korean × five sizes). The screenshot matrix below is a Flutter widget render using the static mascot fallback, not a physical television capture.
- Relevant audio and progressive-reveal unit/integration checks are included in the full regression with controlled playback. This follow-up did not perform live audio playback or Android/physical Tizen testing.

## Screenshots

| Viewport | Indonesia | English | 한국어 |
| --- | --- | --- | --- |
| 360×640 | [F03](images/final-F03-indonesian-360x640.png) | [F03](images/final-F03-english-360x640.png) | [F03](images/final-F03-korean-360x640.png) |
| 411×731 | [F03](images/final-F03-indonesian-411x731.png) | [F03](images/final-F03-english-411x731.png) | [F03](images/final-F03-korean-411x731.png) |
| 720×1280 | [F03](images/final-F03-indonesian-720x1280.png) | [F03](images/final-F03-english-720x1280.png) | [F03](images/final-F03-korean-720x1280.png) |
| 1080×1920 | [F03](images/final-F03-indonesian-1080x1920.png) | [F03](images/final-F03-english-1080x1920.png) | [F03](images/final-F03-korean-1080x1920.png) |
| 2160×3840 | [F03](images/final-F03-indonesian-2160x3840.png) | [F03](images/final-F03-english-2160x3840.png) | [F03](images/final-F03-korean-2160x3840.png) |

Additional Korean examples: [reading at 411×731](images/reading-2-411x731.png), [reading at 2160×3840](images/reading-2-2160x3840.png), [cause feedback](images/cause-1-correct-411x731.png), [F06 at 360×640](images/final-feedback-F06-360x640.png), [F08 at 360×640](images/final-feedback-F08-360x640.png), [closing](images/closing-411x731.png). Only selected screenshots from the audit are copied here; other screenshot references in the raw audit refer to the local audit output folder.

Audit scripts and full local capture set: `output/client-review/2026-11-05/korean-wrapping-fixed/`. Ticket counts in the October revision tracker remain unchanged while this follow-up awaits owner/client review.
