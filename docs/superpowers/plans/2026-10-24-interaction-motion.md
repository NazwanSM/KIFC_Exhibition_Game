# Interaction Motion Implementation Plan

> Native execution in the current session, as previously requested by the owner. One KIFC-G01 refinement ticket; no separate agent work.

**Goal:** Make feedback and interactions feel responsive and coherent while preserving the existing game flow.

**Architecture:** Add two small shared Flutter widgets, `MotionReveal` and `PressFeedback`. Integrate at existing mascot, dialogue, control, placement and result boundaries; leave game state, timers and assets intact.

**Tech Stack:** Existing Flutter/Dart SDK; no new packages.

**Spec:** [Motion design](../specs/2026-10-24-interaction-motion-design.md).

## Global Constraints

- Preserve page order, score maximum 8, unscored cards/demo and neutral final selections.
- Preserve existing layout/crop/touch targets, offline assets and audio behavior.
- All new motion settles, respects reduced motion and adds no delayed gameplay callback.
- Capture actual Flutter UI at multiple portrait sizes and label TV simulations accurately.

## Review Focus

- Countdown rebuilds cannot replay a completed feedback entrance.
- Reduced motion enabled mid-entrance must immediately finish.
- Motion cannot dispose/reset a stateful child or intercept input.
- Pointer cancellation, disabling or removing a button cannot leave its press scale stuck.
- Rapid retry/navigation cannot leave obsolete messages, callbacks or animation errors.

## Tasks

- [x] Add focused failing widget tests for motion replay, state/input preservation, reduced motion and press cancellation/disable.
- [x] Implement `lib/features/game/widgets/interaction_motion.dart`; run the targeted tests.
- [x] Integrate in `game_mascot.dart` and existing feedback/control/slot/score boundaries in `exhibition_game.dart`.
- [x] Add game-level regression checks and multi-size/language visual captures, including intermediate feedback frames.
- [x] Run analysis and the full serial Flutter suite; launch local web and record real interactions.
- [x] Inspect evidence, fix significant differences, update tracker/review and commit this refinement.


Execution evidence: 254 full-suite tests passed, Flutter analysis clean, 81 multi-size/language widget renders and three accepted browser recordings. Browser cold-pose delay reproduced and fixed by cache warmup (RED→GREEN). No new runtime assets, packages, gameplay timers or score changes. See the KIFC-G01 motion review for evidence and physical-TV limits.
