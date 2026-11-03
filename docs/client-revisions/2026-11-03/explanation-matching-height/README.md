# Match explanation mascot height to preceding completion

Owner requested the same height as the preceding completion screen while preserving the explanation's bottom-left position. Both now use the same width (156/185 logical pixels), 4:3 canvas height, 1.4 visual scale and .72 crop. The explanation no longer reduces the mascot based on leftover footer height. Completion remains centered; Continue keeps its right alignment and original vertical anchoring, with a safe width cap beside the mascot.

Compact layouts reserve space for the full matching height: smaller speech-card padding/12px text and tighter gaps. Under 900 logical pixels high, the redundant subtitle above the forest panel is omitted; the full speech explanation remains. The forest panel retains its stable size. This supersedes the small-screen height guard in `../explanation-original-position/README.md`.

Evidence: actual Flutter widget renders with static mascot fallbacks, three languages × five portrait sizes (360×640, 411×731, 720×1280, 1080×1920, 2160×3840), in `widget/`. No browser/native playback or physical TV claims.

- [411×731](widget/explanation-id-411x731.png)
- [1080×1920](widget/explanation-id-1080x1920.png)
- [2160×3840, Korean](widget/explanation-ko-2160x3840.png)

The assembly suite now asserts equal completion/explanation crop width **and height**, left/bottom anchors, no message/button overlap, button hit testing and successful continuation. Logs: `build/explanation-matching-height-tests.log`, `build/explanation-matching-height-analysis.log`. Web build server remains stopped; hot reload the owner's development session. Changes remain in the working tree for review.
