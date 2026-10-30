# KIFC Fire Prevention Challenge

## Weekly progress reports

- Before preparing a weekly report, read `docs/weekly-reports/README.md` and the finalized Indonesian and English PDFs in `docs/weekly-reports/week-01/`. These user-supplied final reports are the primary reference for subsequent reports and supersede earlier drafts.
- Preserve the finalized reference PDFs. Verify each new reporting period against project conversations, Git history, revision tracking, and recorded checks; do not carry forward completion claims or dates without evidence.

## Exhibition interaction context

- This application runs on a portrait Android TV touchscreen at an exhibition.
- Visitors stand close enough to read and interact with the screen directly.
- Do not treat the interface as distant signage or sacrifice useful wording solely to make it readable from far away.
- Prioritize comfortable close-range reading, clear touch targets, natural instructions, and feedback that can be understood during play.
- For large portrait viewports, keep shared stage controls in the centered `TouchscreenArea` instead of spreading them to the panel edges. The 84% height is provisional until panel dimensions and mounting height are known; reserve bottom space for controls rather than shrinking the entire interface excessively. Backgrounds still fill the display; cropped feedback mascots must reach the physical bottom. Do not equate viewport tests with physical reach validation.

## Visual evidence for each client revision

- The project owner requests screenshots for every revision, across multiple portrait viewport sizes, with particular attention to the 42-inch exhibition TV.
- Capture the actual Flutter UI, inspect the images, and give the owner clickable screenshot links or previews. Include 1080x1920 and 2160x3840 TV simulations, with smaller portrait comparisons; check all three languages when text or layout changes.
- Record the screenshot source and viewport dimensions. Label widget renders, browser screenshots, emulator captures, and photographs of physical hardware accurately. Screen resolution alone does not prove physical reach on a 42-inch TV.
- Keep an evidence index per revision. Preserve existing screenshot folders when rebuilding; avoid cleaning away review artifacts.
- After adding image files, fully restart the Flutter web server and verify each new asset in its served manifest and HTTP responses. Hot restart alone can leave the running web asset bundle stale; passing widget renders does not verify browser asset delivery.

## Indonesian copy rules

- Write Indonesian as an original player-facing script, never as a word-for-word translation from English.
- Preserve the learning intent, safety information, and gameplay meaning; the Indonesian and English versions do not need to use the same sentence structure.
- Use natural, calm, and conversational Indonesian that sounds appropriate for an exhibition game. Prefer active verbs such as *amati*, *cermati*, *temukan*, and *pilih* when giving instructions.
- Make feedback feel helpful and specific. Explain why an answer is right or needs another try; avoid stiff phrases and generic praise.
- Review copy as a complete conversation across screens: the instruction, example, player action, feedback and next button must connect naturally. Prefer concrete phrases such as *tanaman kering* and *sumber api* in general instructions; retain the precise technical term where it teaches a concept. Avoid abstract constructions such as *asal pemicu risiko*, repetitive *Tepat* prefixes and literal slogan translations. Simple labels that already read naturally need no forced rewrite.
- Confirm correct answers with a confident forest-green gradient, white text and a small check. Keep labels centered with balanced icon space; do not add `Tepat` / `Correct` badges that shift or crowd the label. Incorrect answers use a distinct deep-red surface and a cross. Do not combine pale green with an amber border for correct answers.
- Owner clarification30October / KIFC-R30-07: remove the element-reduction demo entirely. Keep assembly and the fire-triangle explanation, then continue directly to the first Karhutla reading. Back from that reading returns to the explanation; maximum score remains 8. No demo completion state, timer, or requirement remains.
- Keep technical fire-prevention terms accurate when needed, including *bahan bakar*, *sumber penyulut*, *rambatan api*, and *petugas terlatih*.
- English terms are acceptable in the Indonesian version only when they are more familiar or read more naturally in context.
- Check spelling, capitalization, punctuation, and word choice against EYD before presenting Indonesian copy as final.

## Visual direction and asset sourcing

- Treat the game as a close-range portrait touchscreen experience in the exhibition room.
- Use documentary-quality photographs of Indonesian forests, peatlands, dry vegetation, and field activity as the main visual language. Keep the scene and the educational action legible.
- Reduce flat illustrations, cartoon trees, and generic pictogram icons in the game content. Prefer suitable real photographs; use isolated photographic cutouts with transparent backgrounds where an object needs to sit over a scene.
- Animate meaningful changes gently: each newly placed fire element changes the scene, and visible flame appears only when heat, fuel, and oxygen are all present.
- Bundle every visual needed at runtime for offline Android use. Record photographer or creator, source URL, and license in `ASSET_SOURCES.md`; do not introduce paid assets without telling the project owner.
- Fill photo cards edge to edge using uniform zoom and cropping (`BoxFit.cover`), with a suitable focal point for each subject. Preserve native proportions: never stretch width and height independently. The owner prefers cropped, full-bleed photos over contain/letterboxing; do not add empty side bands or a dark mat to preserve the whole source image.
- Present Chapter 1 fire elements as three equally ranked cards in one row, without triangle vertices or connector lines. Retain the term fire triangle in the concept explanation. Following the 24 October mockups, keep the shared panel at 248 logical pixels (216 on compact viewports) across assembly and explanation; keep the panel dimensions stable. Element cards and draggable choices keep the same 1.8:1 aspect ratio.
- Owner clarification30October / KIFC-R30-08: initially the forest photo fills the entire panel to its bottom with no empty placeholder boxes, plus icons or placeholder labels. Display a storage card only after a valid element is placed; any unfilled positions remain visually and semantically empty. The entire visible panel accepts drops, including over placed cards. Valid distinct elements fill the next storage position from left to right regardless of release location. Decoys, duplicates, outside drops and stale callbacks do not add points. Reveal the category only after placement. Preserve panel/card proportions, and use a large half-body feedback mascot at the bottom with its reading bubble raised above the edge.
- Chapter 2 karhutla is a reading sequence with a mascot and short speech cards, advanced manually. Do not add hotspots, quizzes, or required object selection to these explanation cards. The separate risk question follows the reading sequence.
- Chapter 4 peat-fire characteristics (KIFC-09) uses three numbered flip cards. It is information, not a question, and awards no score. Cards can be reopened without losing read progress; all three are opened before manual continuation. Preserve the flow position after Chapter 3 and before the impact challenge. The old safe-action point is removed; maximum is 8 (elements 3, causes 4, impact bonus up to 1).
- Use a clearly readable air cue for oxygen, and explain that oxygen is present in air. A windsock represents moving air; it is not a visible photograph of oxygen and does not imply wind is required for a fire.

## Reading and continuation (owner25October)

- Owner clarification30October / KIFC-R30-04: the final closing page alone now waits 30 seconds before returning to welcome, with early background tap still available. Other completed feedback/results keep 15 seconds. Finishing a future closing narration must not trigger navigation; the closing deadline and explicit actions own continuation.

- Owner clarification25October: completed feedback and results automatically advance after 15 seconds and can be advanced earlier by tapping game content/background. Apply this to completed assembly, finished peat quiz, binary cause feedback, impact review, score and closing; each advances to its next page. Keep explanatory reading cards and numbered information cards manual. Preserve the retry after the first wrong peat answer and activity completion requirements; background taps never skip an unanswered question or an active timed challenge. Pause the remaining feedback allowance while a dialog is open or the app is inactive; cancel old timers on manual continuation, navigation, reset and disposal.
- Child actions (Back/Home, Restart, Play Again, cards, audio and credits) retain priority; dialogs do not advance the underlying page. The answer/drop/last-card gesture shows feedback and must not also dismiss it. Preserve separate semantics reading nodes when the full-page continuation action becomes available.
- KIFC-10 is finalized at 30 seconds by the owner. Start after photos/transitions are ready; keep the existing countdown ring, colors, deadline and delayed grading.
- Owner clarification30October / KIFC-R30-06: 30 seconds is the maximum; the visitor may choose Finish Selecting earlier. Both submission and deadline grade the current selection once, stop its clock, and play the finish cue once. Keep choices neutral before completion, including while selecting; the new button uses existing blank space below the selection count rather than reducing card size.

## Revision commits

- Commit each completed revision ticket separately and record the commit hash in the revision tracker. Preserve unrelated owner files and weekly reports. The initial October24 checkpoint groups the earlier uncommitted screen work; later tickets must remain separate.

## Audio (KIFC-G04, owner resumed24October)

- Use downloaded recordings/music/effects with recorded source and license; do not synthesize raw audio. Safari by syncopika is CC BY 3.0 with in-game attribution; other current audio assets are CC0. All are bundled offline in assets/audio. No paid assets or mascot voice-over/TTS is implied.
- Start only after visitor interaction. Keep music, forest ambience, and effects separately adjustable, with a reachable mute control in every screen. Preserve settings through language/page/replay for the lifetime of the app, without changing system volume.
- Pause all output while inactive/backgrounded; resume only when active and allowed by mute/volume. Dispose players when leaving the game. Never stack loop players on replay.
- Unscored cards and final challenge choices have neutral effects. Do not reveal correctness through audio before visual feedback.
- Audio controls use the shared centered touchscreen area; screenshots alone cannot prove playback or physical speaker comfort. Keep source/decode, browser/native playback and physical speaker evidence distinct.

- KIFC-R30-09: use the full Safari composition with circular outro/intro overlap, not the 30-second audition. Default music/nature levels are .50/.22; keep effects independent. setNarrationActive temporarily ducks music/nature without changing user sliders or enabling autoplay. No narration is implemented by this API alone.
