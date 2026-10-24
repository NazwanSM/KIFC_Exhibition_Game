# KIFC-09 flip cards implementation plan

Goal: replace the action question in the same flow position with three numbered information cards that flip on touch. The owner selected this format and explicitly made it unscored. Prior instructions authorize direct implementation without another design approval stop.

Architecture: retain the existing stage/portrait layout, photos, mascot and final challenge loader. Isolate flip animation in a reusable widget; parent tracks currently visible backs separately from cards already opened. Reuse reduced-motion handling and offline assets. No new dependencies.

Decisions: three full-width cards keep long information readable at small/TV viewports; fronts show1–3, backs show the three client facts. Cards can be reopened. Continue becomes available after all three have been opened; no reading timer. This completion gate is a vendor implementation choice, not a quiz or score. Manual CTA leads to the existing impact challenge. Back/replay clears card state. Remove the old action point, so maximum becomes8 (elements3 + causes4 + impact bonus1); preserve penalty/bonus rules. Categories retain proportional old thresholds in the KIFC-11 follow-up.

Files: exhibition_game.dart (route/state/integration and score), peat_characteristic_card.dart (perspective flip/semantics), app_locale.dart (three-language copy), peat_characteristics_review_test.dart (interaction and viewport evidence), existing game_flow/impact/fire/android tests (replace obsolete action flow), tracker/review docs.

- [x] Write/run failing behavior test: three numbered cards, information revealed, no timer/answer judgment, gate after distinct cards, repeat reads and return.
- [x] Implement state, flip, localized content and manual continuation; remove obsolete action screen/state.
- [x] Adapt complete journeys and score expectations; verify input races, delayed pre-cache, reduced motion and Android inset.
- [x] Render five sizes × three languages, inspect before/partial/all-read states; verify real browser.
- [ ] Commit KIFC-09 with evidence and tracker status. Adjust/verify KIFC-11 categories and results in its own commit; record both hashes.

Review focus: mirrored back text, hidden-face accessibility, long Korean/English labels, touch targets and safe insets, mid-flip repeated taps, completed cards flipped back, callback after Back/replay, no residual action point.
