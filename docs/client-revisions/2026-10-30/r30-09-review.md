# KIFC-R30-09 Safari full composition

Full source hash matches the selected A3 recording: 226.725 seconds by syncopika, CC BY 3.0. The runtime is 221.725 seconds after a 5-second circular equal-power overlap of the original fade-out and introduction. No 30-second excerpt is used. Size 2,661,505 bytes, measured -18.44 LUFS / -3.70 dBTP. Source and runtime hashes are in audio/safari-source.json; tool/prepare_safari_music.py reproduces processing from the pinned source.

Defaults are music .50, nature .22, effects 1 under master .65. Future narration ducking changes effective gains only, preserving user sliders, mute and lifecycle. Music, ambience and effects retain their existing fixed player lanes. Safari source/license/modifications and the unchanged bird/effect credits are reachable through Sound → Audio credits.

30 unit/widget tests passed, including ducking, error recovery, lifecycle, page changes, replay and three-language/five-size sound panels/credits. Analysis clean. Screenshot source is widget rendering with fake audio; it does not prove speaker playback. Contact sheet inspected: build/review-r30-09-2026-10-30/contact-credits.png. [Credit panel](r30-09-audio-credits.png).

Web release and debug APK builds succeeded. Browser playback/mute/loop tests initially passed on the preliminary encode; final-encode browser evidence is recorded separately in browser-final.log. Native validation remains OPEN: the emulator repeatedly returned no UIAutomator root, so no native mixer success is claimed. Do not distribute the diagnostic APK as a final verified delivery. Human listening could not be evaluated by this model: audio input was unsupported. The runtime MP3 is provided for audition.

Build artifacts/logs: build/review-r30-09-2026-10-30/. Source OGG and archived source HTML are under source/. Tests, raw loudness measurements and failed attempts are retained. No push/deploy. Ticket remains in progress until native verification is completed; client sound preference and physical TV speaker comfort require listening.

Final encode browser check: PASS, 221.725442s, nine fixed media elements, mute/unmute and actual end-to-start playback, no media errors. The final test supplied the exact runtime MP3 through a Playwright route to bypass an older cached encode. This verifies decoding/playback of the final file; it is not proof that a deployed service worker has updated. No deployment was made.
