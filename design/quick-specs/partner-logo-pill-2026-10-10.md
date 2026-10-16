# Quick Design Spec: Partner logo pill

**Type:** Tweak  
**System:** Exhibition UI branding  
**Date:** 2026-10-10  
**GDD Reference:** No GDD exists; applies to the shared partner logo row in the exhibition screens.  
**Systems index:** Not found; dependency tier check skipped.  
**Prior quick specs:** `unified-typeface-2026-10-09.md` covers typography; `indonesian-copy-pass-2026-10-10.md` covers copy. Neither conflicts with this layout tweak.

## Change Summary

Replace four separate logo backplates with one compact, centered capsule that holds all four partner marks in their existing order. Keep the capsule white so the supplied transparent PNG marks and the white-background Manggala Agni JPEG sit on one visually continuous surface.

## Motivation

The separate white rectangles make the top row feel rigid and visually fragmented against the forest photography. A single capsule groups the partner marks while reducing their footprint and preserving clear contrast.

## Design Delta

Current implementation gives each logo its own white or transparent rectangular background across a full-width row.

This spec changes the row to one 246 × 44 logical-pixel capsule centered above the screen content. The capsule uses a 24-pixel radius, 14-pixel horizontal inset, four evenly spaced logo slots at 38 × 30 pixels, a fine outline, and a soft shadow only on dark photographic screens. The order remains Ministry of Forestry, Korea Forest Service, KIFC, Manggala Agni.

## Affected Systems

| System | Impact | Action Required |
| --- | --- | --- |
| Dark exhibition screens | Consolidates partner logos over photography | Update shared header layout |
| Light exhibition screens | Adds the same compact grouping with a subtle outline | Update shared header layout |
| Legacy welcome UI | Keeps branding consistent if that screen is reused | Update matching logo widget |

## Acceptance Criteria

- [ ] All four logos remain in the approved order inside a single centered pill.
- [ ] No per-logo white rectangles remain in the logo row.
- [ ] Transparent marks remain legible, and the JPEG background blends into the shared white surface.
- [ ] The pill stays compact on portrait layouts and does not cause horizontal overflow.
- [ ] No game flow or interaction behavior changes.
