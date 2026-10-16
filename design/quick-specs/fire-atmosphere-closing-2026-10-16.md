# Fire motion, atmosphere and closing

**Type:** Tweak to existing screens and a decorative ambient layer  
**Date:** 2026-10-16  
**Reference:** Owner's two screenshots; `AGENTS.md`; `priority-audit-revisions-2026-10-15.md`; `photo-curation-2026-10-15.md`. Existing game flow, scoring and inactivity rules remain applicable. No separate GDD or interaction pattern library exists.

## Design

- Fill the spread introduction's available body with its photographic scene. Replace four identical floating campfires with a connected irregular low fire front, locally warped photographic texture, asynchronous flicker, smoke, ground glow and scorched ground.
- In the decision scene, hold the fire on the left before an answer. The fuel break prevents it reaching untouched vegetation on the right. Unsafe choices allow further spread. Ground texture and a perspective shape communicate the cleared strip.
- Make closing a full-screen healthy peatland photograph with a strong text scrim, completion status, concise bilingual prevention message and secondary KIFC credit. Use the original source photograph and Archivo. Keep all content visible in portrait without scrolling. Preserve repeat, physical exhibition exit, home and 15-second inactivity behavior.
- Add a single faint mist layer across the game viewport. It does not block touch, add semantics or trigger inactivity resets. Keep the strongest haze near the edges; distinguish healthy atmospheric mist from fire smoke.
- Decorative clocks pause for inactive applications, disabled TickerMode and reduced-motion preferences. Reduced motion uses static representative visuals. Use bounded painters and repaint boundaries rather than full-screen blur. Physical device frame timing remains unmeasured.

## Acceptance

- Fire tips move independently, their bases stay grounded, and spread progresses across connected fuel.
- With a correct prevention answer, no new fire reaches the far side of the break.
- Both closing languages fit 360×640 and 411×731 logical pixels. Buttons retain a 16 px radius; repeat and exit actions remain distinct.
- Haze preserves control hit targets, text readability and idle timer behavior.
- Main flame photographs remain the existing documented project asset. No additional runtime packages, remote media or online requirement.

## Verification

- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: ten tests passed. These cover both languages and portrait sizes, the held decision front and fuel-break cap, scoring/countdown/inactivity, fog touch-through, reduced motion, hidden/background pause, and rendered flame removal beyond the break.
- Two visual harness runs passed, with early/full spread, before/after prevention and closing captured in `build/review-20261016/`. Final Indonesian and English captures were inspected. The closing top gradient was strengthened for white controls, and the ground break uses a magnified photographic ground crop instead of a flat colored strip.
- The local web preview was restarted from current source and recompiled. No Android package was rebuilt for this visual revision.
- UX review: no remaining obvious still-layout or navigation blocker; notes in `production/ui/fire-atmosphere/ux-review.md`. This is not a full accessibility certification: a formal tier is not committed and contrast ratios have not been exhaustively measured. Sustained animation performance still requires the exhibition device.
