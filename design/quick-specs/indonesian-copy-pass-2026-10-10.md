# Quick Design Spec: Indonesian copy pass

Follow-up: the full active script was reviewed and revised again on 2026-10-16. See `indonesian-copy-pass-2026-10-16.md` for current wording decisions and verification.

**Type:** Tweak  
**System:** Exhibition UI copy  
**Date:** 2026-10-10  
**Reference:** `lib/features/game/exhibition_game.dart`; no GDD or systems index is present in this Flutter project.

## Change

Rewrite the Indonesian player-facing copy as original Indonesian rather than a line-by-line rendering of the English text. Keep the learning goals, gameplay states, choices, and safety guidance intact.

## Voice

- Clear, friendly, and calm for visitors using a touchscreen TV at close range.
- Active verbs for instructions: *amati*, *cermati*, *temukan*, and *pilih*.
- Direct feedback that explains the reason behind a choice without sounding punitive.
- Technical terms such as *bahan bakar*, *sumber penyulut*, and *rambatan api* stay precise where safety content requires them.

## Acceptance

- Indonesian instructions, feedback, results, and safety note read naturally without relying on English sentence order.
- Indonesian and English retain the same gameplay meaning.
- No interaction flow, scoring rule, or timing behavior changes.
