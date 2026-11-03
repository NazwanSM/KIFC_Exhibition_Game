# Triangle explanation mascot and Continue button

Owner requested the same mascot treatment on the screen following completion, adjusting Continue to avoid a collision.

The triangle explanation now shares the assembly/completion width, 1.4 scale and .72 crop, centered horizontally and anchored at the bottom. Continue occupies the space to the right of the full mascot crop, with an 8-logical-pixel gap. It retains a 46px height and its existing navigation action. This is an intentional narrow side button with a fitted single-line label.

On viewports under 900 logical pixels high, the redundant introductory subtitle above the forest panel is omitted; the complete explanatory speech card remains. Compact padding and spacing leave room for the same mascot height without shrinking the stable forest panel or clipping the mascot. Other screens retain their subtitles.

Evidence in `widget/`: actual Flutter widget renders with static mascot fallback; Indonesian/English/Korean × 360×640, 411×731, 720×1280, 1080×1920, 2160×3840. Not browser/Android playback captures or physical TV reach validation.

- [Indonesian 360×640](widget/explanation-id-360x640.png)
- [English 411×731](widget/explanation-en-411x731.png)
- [Indonesian 1080×1920](widget/explanation-id-1080x1920.png)
- [Korean 2160×3840](widget/explanation-ko-2160x3840.png)

Checks: assembly review suite compares explanation width/height to completion, centered X, bottom anchor, no speech-card overlap, Continue outside the mascot crop, button height/hit testing and actual navigation. Logs: `build/explanation-matches-assembly-tests-final.log`, `build/explanation-matches-assembly-analysis-final.log`.

Changes remain in the existing working tree for owner review. No web build or server started; inspect using hot reload in the owner's Flutter development session.
