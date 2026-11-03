# Completion mascot matches assembly — owner follow-up

Completion now uses the same `_assemblyMascotWidth(context)` (156 below 680 logical pixels high, otherwise 185), `_feedbackMascotScale` (1.4), and `_feedbackMascotCrop` (.72) as the selecting-elements mascot. It remains anchored at the physical bottom and centered horizontally, with the existing transparent-margin correction retained. Removed the owner's trial `Offset(0, -40)` that exposed a floating crop edge. The following triangle explanation retains its own sizing and left alignment.

Compact completion text uses 12px and 8px padding, matching the compact feedback text scale, plus a 4px gap. This leaves enough space for the unchanged mascot size without clipping it or overlapping the message.

Evidence: actual Flutter widget renders with static mascot fallbacks in `widget/`, across 360×640, 411×731, 720×1280, 1080×1920 and 2160×3840, all three languages. These are not browser captures, Android playback tests or physical TV reach measurements.

- [Selecting, 1080×1920](widget/initial-id-1080x1920.png)
- [Completion, 1080×1920](widget/complete-id-1080x1920.png)
- [Completion, 2160×3840](widget/complete-id-2160x3840.png)
- [Completion, compact phone](widget/complete-id-411x731.png)

Assembly tests compare selecting and completion mascot widths/heights, centered completion X, unchanged bottom anchor, no message overlap, and normal interactions. Analysis/test logs: `build/completion-matches-assembly-tests.log` and `build/completion-matches-assembly-analysis-final.log`.

The production web server remains stopped as requested. Use hot reload in the owner's running Flutter development session to inspect the edit. No build/server was started. Changes remain in the existing working tree for owner review; unrelated files were not staged.
