# KIFC-03 continuity and completion tap

Goal: visitors can advance completed assembly by touching anywhere; retain the same photo panel and placed element order on the explanation screen.

Design: panel first, one primary KIFC narrative immediately below, large presenting mascot, explicit continue control. Use the primary narrative in all three languages. The shorter alternative is not displayed. Keep KIFC-04 routing pending its separate concept decision.

1. In exhibition_game.dart add a guarded assembly continuation callback; use a completed-only tap overlay like the peat question. Keep the 14-second automatic fallback; _go cancels it. Verify the completion drag does not skip feedback and further taps cannot skip explanation.
2. Reorder _TriangleExplanation around the same 190px scene, pass actual placements, use the supplied title/subtitle/primary narrative. Reuse responsive completion narration layout with a presenting pose and a continue control.
3. Add Korean copy in app_locale.dart. Test five portrait sizes in all three languages; capture UI and inspect text, card ordering, crop, overflow and navigation. Run analyze and full suite. Record evidence and update tracker without claiming physical TV validation.
