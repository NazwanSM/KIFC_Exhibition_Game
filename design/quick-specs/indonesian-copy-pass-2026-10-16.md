# Indonesian game copy revision

**Type:** Tweak  
**System:** Exhibition UI copy  
**Date:** 2026-10-16  
**Reference:** Owner request and `AGENTS.md`; extends `indonesian-copy-pass-2026-10-10.md`. No GDD or systems index exists in this Flutter project. Existing scoring, interaction, photo and answer-state specifications remain applicable.

## Scope and voice

Review the Indonesian script across all thirteen active screens in `exhibition_game.dart`, including conditional instructions, wrong answers, completion, demo explanations, image labels, accessibility labels, score breakdown and idle countdown. The older `welcome_screen.dart` is not referenced by the running app.

Use original, natural Indonesian for a visitor interacting with a touchscreen at close range. Address the visitor consistently as *kamu* when needed, without adding it to every sentence. Keep technical concepts accurate and use everyday phrasing around them. Brand and institution names retain their official wording.

## Editorial changes

| Area | Change |
| --- | --- |
| Welcome | Describe the purpose directly: understand fire causes and protect the forest. Use a simple photograph caption. |
| Landscape and risk | Expand *karhutla*, explain its consequences plainly, replace abstract risk wording with a concrete question and specific retry hint. |
| Triangle assembly | Tell visitors where to drag the photos. Confirm a match without a generic praise prefix. Clarify that dry vegetation still needs an ignition source and enough heat. |
| Reduction demo | Explain cooling, fuel separation and oxygen restriction in short sentences. Keep the open-land limitation and the distinction between oxygen and wind. |
| Cause quiz | Ask *Apa penyebabnya?* and identify the human/natural choice in the instruction. Use *situasi* consistently across the question, card and next button. Explain the mechanism after a correct answer; identify the actual cause before explaining a wrong answer. |
| Spread and prevention | Ask what trained personnel can do. Explain why fuel separation helps, why adding fuel worsens the fire and why visitors must keep their distance. |
| Final challenge | Describe which pictures to touch and the +1/−1 rule directly. Label the cigarette as still burning and the non-risk forest example as wet, rather than implying all vegetation is safe. |
| Results and closing | Use natural achievement labels, a readable bonus conversion, a simple *Selesai* action, clear safety guidance and an idle notice describing an untouched screen. |

Simple labels that already work, including *Panas*, *Bahan bakar*, *Oksigen*, *Kembali* and *Main Lagi*, stay consistent. English strings retain their existing wording. No changes to scores, timers or interaction rules.

## Review and evidence

- CCGS Localize scan/QA guidance applied to the existing inline bilingual script; no central string table exists. This pass updates the game script directly under the owner's authorization.
- A localization reviewer checked the full active script for unnatural phrasing, ambiguous instructions and scientific meaning. Applied corrections include expanding *karhutla*, clarifying ignition, distinguishing prevention from limiting spread, and making the personnel question explicit.
- Existing bilingual flow checks exercise the four chapters, every demo element, correct/wrong feedback, countdown, score conversion and end actions at 360×640 and 411×731. Final `flutter test --no-pub`: ten tests passed after all wording and visual fit adjustments.
- Visual capture passed after shortening the result subtitle to prevent compact-screen overflow. Reviewed cause feedback and oxygen demo captures in `build/review-20261016-photo/`; neither needs scrolling or clips the explanation.
- Static analysis: no issues. Physical exhibition-device and visitor comprehension testing have not been performed in this pass.
- Local debug web preview hot-restarted successfully; refresh the page to load the revised script.
