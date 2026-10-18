# KIFC Fire Prevention Challenge

## Exhibition interaction context

- This application runs on a portrait Android TV touchscreen at an exhibition.
- Visitors stand close enough to read and interact with the screen directly.
- Do not treat the interface as distant signage or sacrifice useful wording solely to make it readable from far away.
- Prioritize comfortable close-range reading, clear touch targets, natural instructions, and feedback that can be understood during play.
- For large portrait viewports, keep shared stage controls in the centered `TouchscreenArea` instead of spreading them to the panel edges. The 84% height is provisional until panel dimensions and mounting height are known; reserve bottom space for controls rather than shrinking the entire interface excessively. Backgrounds still fill the display; cropped feedback mascots must reach the physical bottom. Do not equate viewport tests with physical reach validation.

## Indonesian copy rules

- Write Indonesian as an original player-facing script, never as a word-for-word translation from English.
- Preserve the learning intent, safety information, and gameplay meaning; the Indonesian and English versions do not need to use the same sentence structure.
- Use natural, calm, and conversational Indonesian that sounds appropriate for an exhibition game. Prefer active verbs such as *amati*, *cermati*, *temukan*, and *pilih* when giving instructions.
- Make feedback feel helpful and specific. Explain why an answer is right or needs another try; avoid stiff phrases and generic praise.
- Review copy as a complete conversation across screens: the instruction, example, player action, feedback and next button must connect naturally. Prefer concrete phrases such as *tanaman kering* and *sumber api* in general instructions; retain the precise technical term where it teaches a concept. Avoid abstract constructions such as *asal pemicu risiko*, repetitive *Tepat* prefixes and literal slogan translations. Simple labels that already read naturally need no forced rewrite.
- Confirm correct answers with a confident forest-green gradient, white text and a small check. Keep labels centered with balanced icon space; do not add `Tepat` / `Correct` badges that shift or crowd the label. Incorrect answers use a distinct deep-red surface and a cross. Do not combine pale green with an amber border for correct answers.
- The Chapter 1 element-reduction activity is an unscored interactive demo. All three elements can be explored freely; show the mechanism for the selected element, with no correctness badge or judgment. Explain cooling, fuel separation and oxygen limitation accurately, including the limits of oxygen control in open land. Still air contains oxygen.
- Keep technical fire-prevention terms accurate when needed, including *bahan bakar*, *sumber penyulut*, *rambatan api*, and *petugas terlatih*.
- English terms are acceptable in the Indonesian version only when they are more familiar or read more naturally in context.
- Check spelling, capitalization, punctuation, and word choice against EYD before presenting Indonesian copy as final.

## Visual direction and asset sourcing

- Treat the game as a close-range portrait touchscreen experience in the exhibition room.
- Use documentary-quality photographs of Indonesian forests, peatlands, dry vegetation, and field activity as the main visual language. Keep the scene and the educational action legible.
- Reduce flat illustrations, cartoon trees, and generic pictogram icons in the game content. Prefer suitable real photographs; use isolated photographic cutouts with transparent backgrounds where an object needs to sit over a scene.
- Animate meaningful changes gently: each newly placed fire element changes the scene, and visible flame appears only when heat, fuel, and oxygen are all present. Reducing an element makes the flame recede.
- Bundle every visual needed at runtime for offline Android use. Record photographer or creator, source URL, and license in `ASSET_SOURCES.md`; do not introduce paid assets without telling the project owner.
- Fill photo cards edge to edge using uniform zoom and cropping (`BoxFit.cover`), with a suitable focal point for each subject. Preserve native proportions: never stretch width and height independently. The owner prefers cropped, full-bleed photos over contain/letterboxing; do not add empty side bands or a dark mat to preserve the whole source image.
- Present Chapter 1 fire elements as three equally ranked cards in one row, without triangle vertices or connector lines. Retain the term fire triangle in the concept explanation. Keep the shared panel at 190 logical pixels across assembly, explanation, and reduction; reducing an element changes the flame and card state, never the panel dimensions. Element cards and draggable choices keep the same 1.8:1 aspect ratio.
- Chapter 2 karhutla is a reading sequence with a mascot and short speech cards, advanced manually. Do not add hotspots, quizzes, or required object selection to these explanation cards. The separate risk question follows the reading sequence.
- Use a clearly readable air cue for oxygen, and explain that oxygen is present in air. A windsock represents moving air; it is not a visible photograph of oxygen and does not imply wind is required for a fire.
