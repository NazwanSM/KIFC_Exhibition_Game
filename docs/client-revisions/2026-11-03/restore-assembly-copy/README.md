# Restore subtitle and normal speech-card text

Restored the triangle explanation subtitle in every viewport/language. Completion and explanation speech cards now both use the original 13px, 1.25 line-height and 12px padding. No text is omitted or shrunk to accommodate the mascot.

Retained matching mascot dimensions, centered completion, bottom-left explanation, and Continue on the right. On short viewports (under 900 outer logical pixels), the speech card and exact mascot height are reserved at the bottom; the unchanged-size forest panel can scroll when it exceeds the remaining space. It starts aligned to its bottom so the three placed elements remain visible. Larger viewports retain the previous full-panel expanded-footer layout. Drag/drop selection is not made scrollable.

This supersedes the subtitle omission and compact bubble typography described in earlier explanation/completion follow-up notes.

Evidence in `widget/`: actual Flutter widget renders with static mascot fallback; 360×640, 411×731, 720×1280, 1080×1920, 2160×3840; Indonesian, English, Korean. Not browser/native playback or physical TV evidence.

- [Completion 411×731](widget/complete-id-411x731.png)
- [Explanation 411×731](widget/explanation-id-411x731.png)
- [Explanation 1080×1920](widget/explanation-id-1080x1920.png)
- [Explanation Korean 2160×3840](widget/explanation-ko-2160x3840.png)

Checks: `build/restore-assembly-copy-tests-final.log` (15 viewport/language journeys), `build/restore-assembly-copy-text-regression.log` (subtitle presence and 13px text in both states), `build/restore-assembly-copy-analysis-final.log`. Test coverage retains matching mascot heights, no bubble/button overlap, bottom/left anchors, button hit testing and navigation. Completed photos may scroll; unfinished drag/drop panels must not scroll.

Production web remains stopped; inspect through the owner's Flutter development hot reload. Working-tree changes remain ready for owner review.
