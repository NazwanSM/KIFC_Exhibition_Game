# Assembly completion and explanation: mascot overlay

Owner rejected the scrolling/cropped forest panel and requested a mascot overlay that does not consume the space for content above it. This supersedes the compact photo-scroll approach in `../restore-assembly-copy/README.md`.

Both stages now keep the complete, stable-size forest/element panel without a scroll view. The footer uses a Stack: speech card at its natural top position, fixed-size decorative mascot positioned at the bottom, and Continue separately positioned on the right. The mascot does not participate in the content's vertical layout. Completion stays centered; explanation stays left. Width, scale and crop match between the two stages. Subtitle remains visible and speech-card typography remains 13px / 1.25 with 12px padding.

The overlay ignores pointer input so it cannot block game/background taps. It may overlap the speech-card border/transparent canvas margin; its foreground placement preserves the hat silhouette. On short explanation footers the image is offset down 8px inside the fixed crop to keep its visible silhouette clear of the last line. Continue renders last, outside the mascot crop, and remains tappable.

Removed the temporary fixed-footer spacer and reverse photo-scroll options. Unfinished assembly drag/drop is unchanged.

Evidence: actual Flutter widget renders with static mascot fallback in `widget/`, Indonesian/English/Korean × 360×640, 411×731, 720×1280, 1080×1920 and 2160×3840. These are not browser/native playback captures or physical TV testing.

- [Completion, 411×731](widget/complete-id-411x731.png)
- [Explanation, 360×640](widget/explanation-id-360x640.png)
- [Explanation, 411×731](widget/explanation-id-411x731.png)
- [Explanation, 1080×1920](widget/explanation-id-1080x1920.png)
- [Korean, 2160×3840](widget/explanation-ko-2160x3840.png)

Final logs: `build/assembly-overlay-verified-tests.log` and `build/assembly-overlay-verified-analysis.log`. Assembly tests assert zero scroll extent for completed and unfinished assembly, no explanation ScrollView, full panel height and panel below/above title/card ordering, restored subtitle/font, equal mascot dimensions, bottom anchors, left/center positioning and separate tappable Continue with working navigation. The old non-overlapping mascot **canvas** assertion is intentionally removed: the new request explicitly permits overlay; screenshots inspect the actual silhouette and reading text.

Web build server remains stopped. Hot reload the owner's current Flutter development session. Existing unrelated working-tree changes remain untouched; this follow-up is ready for owner review.
