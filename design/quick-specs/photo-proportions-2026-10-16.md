# Photo proportions and clearer fire-element assets

**Type:** Tweak  
**Date:** 2026-10-16  
**Reference:** Owner's supplied `3781_1.jpg`, feedback about stretched-looking photos, `AGENTS.md` and the prior photo/motion specs.

## Owner correction, same day — current rule

The contain fallback below was rejected after review because it left conspicuous bands and made photos look like inset strips. Use full-bleed cover framing with uniform scaling, crop and subject focal points. Restore final-card photos behind their labels. Triangle vertices, choice cards and drag previews share a 1.8:1 aspect ratio. This supersedes the 25% crop limit, mat fallback and separate photo/caption layout described in the initial findings below. Native-dimension metadata and its now-unused check were removed; Flutter preserves the actual source proportions directly.

## Chapter 2 panel consistency — subsequent correction

All three fire-triangle pages use the build activity's 190 logical-pixel panel height and the available content width. The shared scene owns this height, so introduction and prevention cannot independently shrink or enlarge it. Remove the introduction's extra top padding. Element-card ratio stays 1.8:1, and the prevention scene retains room for all three choices. Existing bilingual flow checks compare rendered panel sizes across introduction, build and prevention, including after an element is reduced.

Verification: ten tests passed, including matching rendered panel dimensions at 360×640 and 411×731 in both languages. Prevention spacing was reduced by 4 logical pixels to prevent overflow on the smaller viewport. Visual capture passed and `triangle-reduced.png` was inspected. Static analysis reports no issues; local web preview recompiled.

## Findings and changes

- Evidence photos previously used cover in every card. That preserves geometric proportions, but cropping landscape photos into tall cards or portrait photos into shallow thumbnails removed too much identifying context. Use measured native aspect ratios to allow at most 25% crop, then contain the complete image on the shared dark green mat.
- The animated flame mesh mapped its source to an arbitrary destination rectangle. Uniformly fit the source crop to the rectangle before local flame deformation, keeping the base anchored.
- Restore the standalone spread introduction to the landscape's native 1400:933 frame. Reduce the excessive 4× ground-texture magnification. Keep full-screen scenic backgrounds uniformly cover-scaled.
- Replace timber with the owner's original 600×399 image, without resampling. Replace grass/oxygen with a close, wide windsock photograph from Mark König under the Unsplash License. A windsock illustrates air movement, not visible oxygen; the introduction states that oxygen comes from air.
- Preserve radius, clipping, hit targets, drag mechanics, scoring and countdown. All photos remain bundled for offline use.

## Verification

- Eleven tests passed, including exact native aspect metadata for all fourteen evidence photos, bilingual compact flows and motion behavior. Static analysis reports no issues.
- Visual capture passed; inspected triangle and final cards in `build/review-20261016-photo/`. Final cards use a consistent photograph area above their label, preserving the timer and no-scroll layout.
- Runtime photos remain local. The web preview is restarted to rebuild its asset bundle after adding/replacing the image files.
