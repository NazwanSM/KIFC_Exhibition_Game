# Photo curation and rounded frames

**Type:** Tweak  
**Date:** 2026-10-15  
**Reference:** Owner's photographic direction in `AGENTS.md` and `priority-audit-revisions-2026-10-15.md`. No separate GDD or systems index exists.

## Change

Choose photographs by how clearly they communicate the condition or object at card size. Keep the Indonesian peatland identity and existing game mechanics. Replace ambiguous water, rain and damp timber cues. Separate the dry vegetation photograph from the sunlight cue and give the unattended-fire question its own image. Replace the dry landscape containing visitors with an empty dry grassland scene from Baluran.

Use a single 16 px clipping shape for photographic cards. Images fill the entire shape; the outline is painted over the image without insetting it. Apply the same treatment to triangle vertices, draggable pieces and final challenge cards. Keep hover/selection borders, dimmed states and drag hit targets working.

## Acceptance

- Filled triangle vertices have no pale wedges between their photograph and outline.
- Border follows the same curve as the image, including during an active drag.
- Photographs remain legible behind white labels; the unattended-fire thumbnail includes the flame.
- Water, falling rain, dry leaf litter and split timber are distinct at actual card sizes.
- Record the creator, source and license for every replacement; bundle photos for offline use.
- Preserve bilingual flow and no-scroll layouts at 360×640 and 411×731 logical pixels.

## Sources

See `ASSET_SOURCES.md`. All six replacement/additional photos are real stock photographs. Indonesian locations are retained for the main peatland and dry grassland scenes; generic object details from other countries are documented as illustrative.

## Verification

- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: all seven tests passed, including real drag gestures, both languages and both compact portrait sizes.
- Visual harness passed; reviewed `build/review-20261015/triangle-complete.png` and `final.png`. Filled vertex photos meet their outline evenly, labels remain readable and all six final objects remain visible without scrolling.
- Rejected the greener Baluran candidate and the distant forest-floor candidate. Selected the dry Baluran scene without people and close leaf-litter detail instead. Existing sunlight, air, mist, wet grass and lightning cues remain suitable at card size.
