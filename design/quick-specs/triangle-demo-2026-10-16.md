# Fire-triangle reduction demo

**Type:** Tweak to the existing learning activity  
**Date:** 2026-10-16  
**Reference:** Owner feedback on Chapter 2; TOR fire-triangle learning intent. No GDD or systems index exists in this Flutter project. The brief is recorded in `priority-audit-revisions-2026-10-15.md`. This supersedes the assessment treatment of reduction choices in `answer-feedback-2026-10-16.md`; panel dimensions and photography rules in `photo-proportions-2026-10-16.md` remain applicable.

## Rationale

All three elements can affect combustion. Presenting every selection as a correct answer makes the interaction look like a quiz without a meaningful decision. Teach the mechanisms through freely switchable examples instead. This activity was already unscored; preserve the nine-point game total.

## Rules

- Label the activity as an interactive demo. Three equal tabs select heat, fuel or oxygen; selection remains changeable.
- A selected tab has the approved green gradient and centered white label, with no correct/incorrect badge or icon.
- Selecting an element fades that triangle node and reduces the visible flame. This is a schematic demonstration of reduction, not a prediction of suppression speed or effectiveness.
- Explain the selected mechanism below the tabs: cooling lowers burning material's temperature; separating dry fuel interrupts spread without necessarily extinguishing already burning material; restricting oxygen can smother a flame but is difficult in open land. Still air contains oxygen.
- The heat example concerns cooling burning material, not hiding sunlight to extinguish an established fire.
- Visitors can continue after exploring one element and may explore all three. No extra score, wrong-answer state or forced three-step gate.
- Preserve the shared 190 px scene height and 1.8:1 element-card ratio. Keep all three explanations and navigation visible without scrolling at the supported compact portrait sizes.
- For graded answers elsewhere, keep check/cross icons compact, remove text badges, and reserve equal left/right space so selection does not shift the label.

## Scientific reference

[National Park Service: Wildland Fire Facts — There Must Be All Three](https://www.nps.gov/articles/wildlandfire-facts-fuel-heat-oxygen.htm) explains the roles of heat, fuel and oxygen, cooling, fuel removal and oxygen restriction. [NWCG S-130, Unit 7](https://training.nwcg.gov/dl/s130/s-130-ig07.pdf) describes suppression by disrupting the fire triangle and separating fuel. The demo describes principles; the later decision screen retains guidance to keep a safe distance and contact trained personnel for a real incident.

## Acceptance and evidence

- All three selections show distinct localized explanations and remain switchable, without assessment marks.
- The scene size remains identical to introduction and assembly before and after every selection.
- Both languages fit at 360×640 and 411×731, including the oxygen explanation.
- Full game scoring and correct/incorrect decision paths remain intact.
- `flutter analyze --no-pub`: no issues. `flutter test --no-pub`: ten tests passed.
- Visual capture passed; inspected `build/review-20261016-photo/triangle-demo-oxygen.png` and `decision-after.png` for spacing, centered labels, clipping and gradient treatment.
- Local debug web server hot-restarted; browser refresh loads the revision.
