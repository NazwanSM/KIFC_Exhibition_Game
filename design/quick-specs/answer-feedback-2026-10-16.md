# Answer feedback treatment

**Type:** Tweak  
**Date:** 2026-10-16  
**Reference:** Owner feedback: pale green with an amber outline looks uncertain and flat. Existing CCGS UI rules and `AGENTS.md` apply.

## Treatment

- Confirm correct answers with a forest-green gradient, white text and a small check. Use a matching green outline and subtle shadow; remove amber from answer confirmation. Owner follow-up: omit the `Tepat` / `Correct` badge and reserve equal icon space on both sides so labels stay centered before and after selection.
- Incorrect selections use a warm deep red with an explicit cross, without a text badge. In the cause quiz, a wrong selected option must not use the correct-answer appearance.
- Use the same surfaces and icon treatment in explanatory feedback. Completed landscape clues use green glass and white checks. Preserve amber for progress and drag/focus affordances.
- Keep the existing 16 px control radius, stable button dimensions, readable labels, choice locking and localized explanation. No extra feedback header changes the page height.
- Element-reduction controls are demo selectors, not graded answers. They use the green selection surface without check/cross marks; see `triangle-demo-2026-10-16.md`.

## Verification

Review selected correct/incorrect states at compact portrait sizes in Indonesian and English. Run existing flow checks, including wrong-answer paths and the chapter 2 panel-size regression. Inspect visual captures for label wrapping, clipping and contrast.

Completed: ten flow/motion tests passed, visual capture passed and static analysis reports no issues. Inspected chapter 2 confirmation and chapter 4 selected-answer/explanation captures; no visible clipping or pale-green/amber answer outline remains. Local web preview recompiled.
