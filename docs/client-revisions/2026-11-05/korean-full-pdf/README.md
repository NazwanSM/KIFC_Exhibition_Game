# Korean full PDF revision - 5 November 2026

The owner's 26-page [source PDF](source.pdf) supersedes the previous Korean copy for the 34 inventoried text/layout items. The [inventory](../../../../design/quick-specs/korean-full-pdf-2026-11-05.json) was recorded before implementation; [tracker](../../../../design/quick-specs/korean-full-pdf-tracker-2026-11-05.md). Source SHA-256: `bb8f46c48260f60ec75fd5c9bd1d24c3c7fff8632dd97b58747c765db35698ea`.

58 Korean translation keys now follow the approved wording, punctuation, spaces and explicit line breaks. Indonesian editing notes in parentheses are excluded. Pages 8 and 16 provide reference screenshots without replacement copy. Page 6 revises the second reading subtitle above its speech bubble, not the main question heading. The Chapter 3 question heading stays on one line as requested. Feedback F03 and F08 combine their continuation across PDF pages. The number and selection logic of the nine final feedback branches are unchanged.

Approved lines are fitted as a single text block to the available width/height using the bundled Noto Sans KR font. The fitter measures the actual rendered word joiners, inherited letter spacing and current text scaling. It scales down only when a complete approved line cannot fit. Progressive narration measures the complete paragraph so its layout does not jump as characters appear. Translation data and accessibility labels retain the plain original text.

## Audio state at initial PDF integration (superseded)

**Update:** The owner subsequently supplied all four regenerated recordings. [They are now integrated with new Chapter 2 word cues](../korean-audio-refresh/README.md). The following paragraph describes the earlier temporary state only.

Original owner instruction: record the work now; regenerate Korean voices later. Existing MP3 files are retained. Text on screen follows this PDF while speech still reads the earlier recording. The four [pending voice scripts](pending-voice-scripts.json) are welcome, Chapter 2 readings 2 and 3, and closing. Chapter 2 reading 1 changed only its subtitle.

Korean readings 2 and 3 temporarily reveal the revised display text using estimated proportional cues over the existing recording duration; these are not word-aligned to revised speech. The original audio script, MP3 digest and duration remain recorded in reading_timing.json with pending_audio_regeneration metadata. After replacement audio is supplied/generated, rebuild alignment, replace the recordings and verify playback, mouth animation and the one-second continuation delay. No audio was generated in this revision.

## Verification

- [Full Flutter regression](tests.txt): 485 tests passed. [Analysis](analyze.txt): no issues. [Release web build](web-build.txt): success, build ID `korean_full_pdf_20261105`. [Audio digest and cue integrity](audio-integrity.txt): all nine reading entries retain matching MP3 digests and ordered in-range cues.
- [Rendered audit](audit-tests.txt): 250 screen states across five portrait sizes, exercising all 34 PDF items at each size. [Geometry results](audit.json): zero split words, zero horizontal word clipping, zero added wraps in approved PDF lines and zero layout exceptions. Four initial cause states repeat while testing both answer paths; 46 distinct states per size.
- [Three-language matrix](locales.txt): 15 final-feedback layouts (three languages x five sizes).
- Focused regression covers exact text for all 58 translation keys, five narrow/full text block widths with letter spacing, bounded height with 200% text scaling, and stable progressive reveal offsets.

Screenshots below are actual Flutter widget renders with the static mascot fallback and full reading text (reduced motion). They validate text layout, not live 3D playback, browser audio, Android runtime or physical television reach. Physical Android testing remains deferred; no Samsung/Tizen hardware was used. Full-resolution local captures and scripts are preserved under output/client-review/2026-11-05/korean-full-pdf-validated/. The [audit script](audit-script.dart.txt) can be copied back there as audit_test.dart and run with KIFC_CAPTURE=1 and KIFC_CAPTURE_DIR set to that directory.

## Every PDF item at 411 x 731

| Item | PDF page(s) | Flutter screenshot |
| --- | --- | --- |
| welcome | 1 | [Open](images/welcome-411x731.png) |
| assembly-partial | 2 | [Open](images/assembly-partial-1-411x731.png) |
| assembly-complete | 3 | [Open](images/assembly-complete-411x731.png) |
| triangle-explanation | 4 | [Open](images/triangleExplanation-411x731.png) |
| reading-1-subtitle | 5 | [Open](images/reading-1-411x731.png) |
| reading-2-subtitle | 6 | [Open](images/reading-2-411x731.png) |
| reading-2-body | 6 | [Open](images/reading-2-411x731.png) |
| reading-3-body | 7 | [Open](images/reading-3-411x731.png) |
| risk-correct | 9 | [Open](images/risk-1-411x731.png) |
| risk-hint | 10 | [Open](images/risk-0-411x731.png) |
| cause-title | 11 | [Open](images/cause-1-initial-411x731.png) |
| cause-1-situation | 11 | [Open](images/cause-1-initial-411x731.png) |
| cause-1-correct | 12 | [Open](images/cause-1-correct-411x731.png) |
| cause-2-correct | 14 | [Open](images/cause-2-correct-411x731.png) |
| cause-3-correct | 17 | [Open](images/cause-3-correct-411x731.png) |
| cause-4-situation | 18 | [Open](images/cause-4-initial-411x731.png) |
| cause-4-reason | 18, 19 | [Open](images/cause-4-correct-411x731.png) |
| cause-4-summary | 18, 19 | [Open](images/cause-4-correct-411x731.png) |
| peat-complete | 20 | [Open](images/peat-cards-3-open-411x731.png) |
| safety | 21 | [Open](images/finalChallenge-411x731.png) |
| closing | 22 | [Open](images/closing-411x731.png) |
| final-F01 | 23 | [Open](images/final-feedback-F01-411x731.png) |
| final-F02 | 23 | [Open](images/final-feedback-F02-411x731.png) |
| final-F03 | 23, 24 | [Open](images/final-feedback-F03-411x731.png) |
| final-F04 | 24 | [Open](images/final-feedback-F04-411x731.png) |
| final-F05 | 24 | [Open](images/final-feedback-F05-411x731.png) |
| final-F06 | 25 | [Open](images/final-feedback-F06-411x731.png) |
| final-F07 | 25 | [Open](images/final-feedback-F07-411x731.png) |
| final-F08 | 25, 26 | [Open](images/final-feedback-F08-411x731.png) |
| final-F09 | 26 | [Open](images/final-feedback-F09-411x731.png) |
| cause-1-wrong | 13 | [Open](images/cause-1-wrong-411x731.png) |
| cause-2-wrong | 15 | [Open](images/cause-2-wrong-411x731.png) |
| cause-4-correct | 19 | [Open](images/cause-4-correct-411x731.png) |
| cause-4-wrong | 18 | [Open](images/cause-4-wrong-411x731.png) |

## Portrait comparisons

| Viewport | Indonesian F03 | English F03 | Korean F03 | Korean reading 2 | Korean welcome |
| --- | --- | --- | --- | --- | --- |
| 360x640 | [Open](images/final-F03-indonesian-360x640.png) | [Open](images/final-F03-english-360x640.png) | [Open](images/final-F03-korean-360x640.png) | [Open](images/reading-2-360x640.png) | [Open](images/welcome-360x640.png) |
| 411x731 | [Open](images/final-F03-indonesian-411x731.png) | [Open](images/final-F03-english-411x731.png) | [Open](images/final-F03-korean-411x731.png) | [Open](images/reading-2-411x731.png) | [Open](images/welcome-411x731.png) |
| 720x1280 | [Open](images/final-F03-indonesian-720x1280.png) | [Open](images/final-F03-english-720x1280.png) | [Open](images/final-F03-korean-720x1280.png) | [Open](images/reading-2-720x1280.png) | [Open](images/welcome-720x1280.png) |
| 1080x1920 | [Open](images/final-F03-indonesian-1080x1920.png) | [Open](images/final-F03-english-1080x1920.png) | [Open](images/final-F03-korean-1080x1920.png) | [Open](images/reading-2-1080x1920.png) | [Open](images/welcome-1080x1920.png) |
| 2160x3840 | [Open](images/final-F03-indonesian-2160x3840.png) | [Open](images/final-F03-english-2160x3840.png) | [Open](images/final-F03-korean-2160x3840.png) | [Open](images/reading-2-2160x3840.png) | [Open](images/welcome-2160x3840.png) |

Commit implementasi: `4ebf03cfb646986054cc5458695668cccc73d285`. Penundaan audio saat commit ini telah digantikan oleh integrasi rekaman baru pada pembaruan berikutnya.
