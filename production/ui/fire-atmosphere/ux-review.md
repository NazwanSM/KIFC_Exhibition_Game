# Fire atmosphere and closing screen: UX review

**Date:** 2026-10-16  
**Role:** CCGS UX review; bounded visual polish  
**Platform:** Offline portrait Android touchscreen; web preview  
**Basis:** Owner's two screenshots, `AGENTS.md`, existing closing/navigation implementation, and the accepted priority revision spec. This review does not replace a full TOR traceability audit.

## Recommended closing layout

Use the healthy Indonesian peatland photograph as a full-screen scene, with a restrained dark gradient behind text. Keep its waterway and forest canopy visible in the middle of the screen. Use the existing compact white partner pill at the top. Remove the chapter 4/4 progress indicator on this completed-session screen.

At 360×640 logical pixels, reserve approximately 60 px for the partner header, 130–150 px for the headline and takeaway, at least 100 px of unobstructed scenery, and 185–205 px for the institution credit, two actions, inactivity notice, and gaps. At 411×731, allocate the extra height to the photograph, without increasing every control. Use 20–24 px side padding, Archivo, the existing 16 px control radius, and 44–48 px action heights. Keep all content in one viewport in both languages. The landscape should replace the former empty middle region, not add a second content card.

The institution credit is secondary: `Korea–Indonesia Forest Cooperation Center` and one short line beneath it. Place it above the actions, never between the main learning takeaway and its photograph. Avoid a second home control if the footer already ends the session.

## Suggested bilingual copy

| Element | Indonesian | English |
| --- | --- | --- |
| Eyebrow | TERIMA KASIH SUDAH BERMAIN | THANK YOU FOR PLAYING |
| Headline | Hutan terjaga, hidup terlindungi. | Protect forests. Protect lives. |
| Takeaway | Jauhkan sumber api dari bahan kering. Jika melihat kebakaran, laporkan kepada petugas. | Keep ignition sources away from dry vegetation. Report any fire to trained personnel. |
| Institution supporting line | Bersama menjaga hutan Indonesia. | Working together for Indonesia’s forests. |
| Repeat action | Main Lagi | Play Again |
| End action | Selesai | Finish |
| Inactivity notice | Kembali ke awal dalam {n} detik tanpa interaksi. | Returns home in {n} seconds without interaction. |

`Main Lagi` must start a clean session in the chosen language. `Selesai` must return the kiosk to welcome. If retaining the existing `Jelajahi Pameran` label, present it as an invitation to leave the completed game and explore the physical exhibition; do not imply another digital exhibition page exists.

## Spread animation and atmosphere

Show one irregular fire front progressing through connected dry fuel. Vary flame height, lean, intensity, and local timing; keep bases anchored to the ground. Avoid synchronized scale pulses, equal spacing, and obvious copies of the same full flame silhouette. Smoke should rise and drift in the same direction across the scene. When a fuel break is shown, the far side remains unburned; fire must not visibly jump the gap. Keep the simulation label visible and preserve the safe-action decision flow.

Global fog can add ambient depth, but must remain a low-opacity effect around the scenery and screen edges. Protect the contrast of instructions, photos used as answer evidence, feedback, logos, and controls. Fog on healthy-forest screens should read as light mist, rather than smoke indicating an unmentioned fire. Use no flashing, full-screen opaque wipes, or fog that disguises an answer. The overlay must ignore pointer input, be excluded from semantics, and pause when the route/app is inactive. With reduced motion enabled, render a static atmosphere and static representative spread state that preserves the learning message.

## Acceptance and remaining concerns

- Check Indonesian and English at 360×640 and 411×731: no clipping or scrolling, all actions at least 44 px high, and the closing photo remains visible.
- Verify repeat/end actions and the existing 15-second inactivity reset, including resetting the timer after interaction. The fog itself must not count as interaction.
- Check text contrast over the brightest and darkest animation frames: 4.5:1 for normal text; 3:1 for large text and meaningful control boundaries.
- Review a short animation sequence, not a single still: continuous flame grounding, asynchronous motion, consistent drift, and a legible fuel-break result.
- **Verdict: NEEDS REVISION for the supplied screens.** The layout and motion direction above are ready for implementation; final visual contrast, motion, and device performance are not yet assessed. No new gameplay blocker identified.

## Implementation visual review

**Reviewed evidence:** `build/review-20261016/id-closing.png`, `en-closing.png`, `id-spread-full.png`, and `id-decision-stopped.png`. These are rendered stills; they do not establish animation quality across time or physical device performance.

The revised closing now gives the healthy peatland image a meaningful full-screen role. Both languages have a clear headline, practical prevention takeaway, subordinate institution credit, and legible closing actions. The former empty content region has become visible forest and waterway scenery. There is no chapter progress indicator on the completed-session screen. All visible content fits the reviewed captures without an obvious crop or overlap. The white partner pill is centered with all four logos visible, including in the stopped-decision capture verified separately at original resolution.

The spread simulation now has substantially more space and an irregular connected flame front rather than four isolated, equally spaced copies. In the stopped-decision state, flames remain on the near side of the labeled break, while the far side stays unburned. The choice, explanatory feedback, and final-challenge action are visible together. The wording correctly assigns real-world intervention to trained personnel.

Two bounded refinements remain appropriate: darken the closing image behind its white Home/status row, and replace the flat brown break surface with photographic ground texture. These improve photographic coherence and contrast without changing the flow. After those changes, recheck the final captures; this review has not measured numerical contrast ratios.

**Verdict:** No remaining obvious layout or navigation blocker in the reviewed evidence. **NOT ASSESSED** for a complete accessibility sign-off because the project's accessibility tier is uncommitted; numerical contrast, keyboard/screen-reader coverage, reduced-motion behavior, continuous animation, and physical touchscreen performance are outside this still-image review. The initial revision finding above describes the owner's original screenshots, not the revised implementation.
