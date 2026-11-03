# Feedback docking and retained renderer resize — 3 November 2026

Owner follow-up: remove the gap above the Chapter 4 result button; prevent the Chapter 2 mascot escaping its frame after an incorrect answer is corrected.

## Changes and cause

- Impact review now offsets its cropped mascot by the same 9/14 logical pixel gap used by the stage footer. Previously the fixed 10 pixel offset left a gap on regular layouts. Card sizes, text and button position are unchanged.
- A ResizeObserver watches the retained web platform-view parent and updates model-viewer CSS dimensions when the Flutter slot changes. It disconnects on release. The former implementation updated only on initial load and browser resize, leaving the wrong-answer dimensions active after a correct answer. No new GLB request, frame polling, asset changes or quality reduction is introduced.

## Verification

- [Full regression](feedback-fix-full-tests.log): 475 tests passed. [Analysis](feedback-fix-analyze.log): no issues. [Production web build](feedback-fix-live-build.log): succeeded, build ID `feedback_resize_docking_20261103`.
- The strengthened docking assertion failed before the fix ([red test](feedback-gap-red.log)); now it asserts that crop bottom equals button top within 0.5 logical pixel. The impact suite checks five portrait viewports × three languages ([15 passing captures](feedback-gap-capture.log)). Small screens exercise mixed results; larger screens exercise perfect results.
- Real browser reproduction at 1080×1920 used production screens/renderer via the isolated `tool/feedback_review_main.dart` entry point and actual answer clicks. Before the fix, correcting an answer left the retained renderer about 187 CSS pixels taller than its parent. After the fix, retry-correct and direct-correct surfaces match to approximately 0.001 CSS pixel; parent-to-renderer rounding is about 1.15 pixels. Both retain one GLB resource request. [Raw metrics](browser-metrics.json).
- [Retry then correct, live 3D browser](browser-retry-correct.png) and [direct correct, live 3D browser](browser-direct-correct.png). These are isolated production-screen checks, not a complete gameplay journey. The browser capture exporter may scale the PNG independently of the CSS viewport.
- [Impact review, live 3D browser](browser-impact-review.png): initial review fixture with no selections, so its mascot is on the left. Perfect-result widget renders below verify the right-side pose. Widget renders use the static mascot fallback and do not certify skeletal playback.

## Screenshot index

| Viewport | Indonesian | English | Korean |
| --- | --- | --- | --- |
| 360×640 | [review](widget/impact-review-id-360x640.png) | [review](widget/impact-review-en-360x640.png) | [review](widget/impact-review-ko-360x640.png) |
| 411×731 | [review](widget/impact-review-id-411x731.png) | [review](widget/impact-review-en-411x731.png) | [review](widget/impact-review-ko-411x731.png) |
| 720×1280 | [review](widget/impact-review-id-720x1280.png) | [review](widget/impact-review-en-720x1280.png) | [review](widget/impact-review-ko-720x1280.png) |
| 1080×1920 | [review](widget/impact-review-id-1080x1920.png) | [review](widget/impact-review-en-1080x1920.png) | [review](widget/impact-review-ko-1080x1920.png) |
| 2160×3840 | [review](widget/impact-review-id-2160x3840.png) | [review](widget/impact-review-en-2160x3840.png) | [review](widget/impact-review-ko-2160x3840.png) |

Android testing remains deferred by the owner; native Android and physical QM43B-T/Tizen playback were not tested in this follow-up. Tracker closure counts remain unchanged pending owner review.
