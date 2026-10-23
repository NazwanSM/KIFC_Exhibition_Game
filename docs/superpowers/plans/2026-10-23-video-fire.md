# Replace fire motion with the supplied recording

Goal: use the owner's 33072-395456627.mp4 throughout animated fire surfaces, preserving gameplay, offline support and portrait readability.

Design: derive a 480×180 transparent 15fps animated WebP from the full ~20s recording; crop only the empty upper background and key dark pixels. Native Flutter image decoding avoids a platform video dependency and opaque black mat. Store a matching static poster for reduced motion. Preserve source attachment unchanged. No audio.

1. Generate and inspect alpha, dimensions, duration and frame changes; record source and reproducible conversion command.
2. Replace single-fire and spreading-fire renderers with the shared loop. Preserve pause for hidden/lifecycle states, reduced motion, anchored shrinking, progress boundaries and fuel-break stopping. Remove the old mesh-fire rendering path.
3. Keep the Chapter 1 panel 190px and card ratio1.8. Put the wider recording in the upper region and three cards below with a clear gap; no flame over labels, no aspect distortion. Leave all scores, narratives and progression unchanged.
4. Verify actual frame decoding/movement/transparency, reduced-motion poster, lifecycle and stopped boundary; full suite/analyze, multi-size/three-language UI evidence, restart web server and verify served assets and browser motion. Record limits of emulator/physical-TV verification honestly.
