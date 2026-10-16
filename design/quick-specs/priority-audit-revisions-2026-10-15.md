# Priority audit revisions

**Type:** Addition to existing exhibition flow  
**Date:** 2026-10-15  
**Reference:** TOR screens 2, 4–6, 9–13 and the owner-approved audit. No GDD or systems index exists in this Flutter project. Earlier typography, copy, and partner-header specs remain applicable.

## Rules

- Teach the definition of uncontrolled forest/land fire and show how ignition can lead to spread. Sunlight represents drying/heat; dry fuel does not ignite automatically without an ignition source.
- Present the three fire elements at three connected vertices. Preserve drag and drop and stable card positions.
- Use three distinct prevention choices, lock the first answer, and show only its selected/error state. A photographic simulation shows spread and a fuel break stopping further spread. Safety guidance refers real incidents to trained personnel.
- Final challenge starts automatically after local images are prepared and the entry transition completes. Give ten seconds measured with a stopwatch; ignore duplicate selections and input after time expires.
- Each correct risk object earns one raw point; each incorrect object subtracts one. Raw score is clamped to 0–4 and converted proportionally into a 0–1 bonus. Preserve the TOR maximum of nine: triangle completion 3 + causes 4 + decision 1 + final bonus 1. Display the conversion explicitly and localize decimal separators.
- Result and closing return to welcome after 15 seconds without interaction. Touch/scroll resets the inactivity period. Cancel timers whenever their owning page is left.
- Play Again immediately starts a clean session in the chosen language; Explore the Exhibition ends the session and returns the kiosk to welcome. Home is labelled explicitly. Repeat on the triangle activity resets that activity only.
- Keep the final grid and its score visible without scrolling at 360×640 and 411×731 logical pixels. Reduce excessive result ornamentation so its educational message remains visible.
- Repair the photo-label scrim, use text/symbols in addition to selection colors, and explain wrong cause answers with the correct cause.

## Acceptance

- Only the chosen decision is highlighted; unsafe answers use an error state.
- Selecting every final object cannot earn the full bonus; partial correct selections can earn a partial bonus.
- Both end pages reset after inactivity, and interaction postpones the reset.
- Final countdown does not run while images are loading; no manual start is required.
- The complete bilingual flow fits the two preview sizes, including feedback states.
- Verify with widget regression tests and a visual pass; physical TV performance remains to be verified on the exhibition device.

## Verification

- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: seven tests passed. The flow tests cover Indonesian and English at 360×640 and 411×731 logical pixels, wrong-answer feedback, independent locked choices, repeat activity, partial/perfect/select-all scoring, duplicate taps, ten-second countdown, inactivity reset, and the two closing actions.
- Visual captures reviewed in `build/review-20261015/`: introduction, triangle, prevention before/after, final grid, results, and closing.
- Remaining audit work: curate a more cohesive set of field photographs, revisit the welcome language/caption grouping, measure session duration with visitors, and verify performance and installation on the exhibition hardware.
