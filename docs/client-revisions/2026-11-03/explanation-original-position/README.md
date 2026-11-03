# Owner correction: enlarge only, preserve explanation positions

Supersedes the centered explanation in `../explanation-matches-assembly/README.md`. The explanation mascot is restored to bottom-left, its original .57 crop, and no translation upward. The enlarged target width (156/185 logical pixels) and scale (1.4) are retained, with the original height-based size guard on short screens to avoid showing only a clipped head. Completion remains centered and otherwise unchanged.

Restored original subtitle in all viewports, original explanation speech-card font/padding, footer gap and original Continue top/bottom anchor. Continue remains right-aligned; its width is capped to the available space beside the larger mascot plus an 8px gap.

Evidence in `widget/`: actual Flutter widget renders, static mascot fallbacks, three languages and five portrait viewports from 360×640 through 2160×3840. Not browser/native playback or physical TV captures.

- [Indonesian 411×731](widget/explanation-id-411x731.png)
- [Indonesian 1080×1920](widget/explanation-id-1080x1920.png)
- [Korean 2160×3840](widget/explanation-ko-2160x3840.png)

Assembly tests check left/bottom anchors, responsive width, separation from Continue, usable button and navigation. Final logs: `build/explanation-original-position-tests-final.log`, `build/explanation-original-position-analysis-final.log`. Production web remains stopped; owner can use hot reload. Changes remain in the existing working tree for visual review.
