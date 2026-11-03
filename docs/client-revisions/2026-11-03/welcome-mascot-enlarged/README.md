# Welcome mascot enlarged — 3 November 2026

Welcome's mascot slot grows from 180/216 to 230/275 logical pixels (compact/regular), around 27%. The full-body Wave treatment, approved camera, GLB, textures and clips remain unchanged. The speech bubble retains its font and content, reflowing into the available width. Closing and Chapter 2 sizes are unchanged.

A new rendered-geometry regression compares welcome with Chapter 2 at 360×640, 411×731, 1080×1920 and 2160×3840. All four cases failed before enlargement and pass afterward: welcome is at least as tall as Chapter 2 in physical widget bounds. The existing welcome matrix covers all five portrait sizes and ID/EN/KO, verifying title, conversation and Start remain separated and usable. Targeted tests: 28 passed.

- [Full HD Indonesian](widget/id-1080x1920.png)
- [Small portrait Korean](widget/ko-360x640.png)
- [4K English](widget/en-2160x3840.png)
- [Evidence index](evidence-index.json)

These are Flutter widget screenshots using static GLB-derived posters, not TV photographs or animation recordings. Runtime Wave remains a real-time GLB. Review source patch is relative to the working tree after the one-second narration delay follow-up, not clean HEAD containing the older integration checkpoint. Android remains deferred. The live web build uses build ID welcome_mascot_enlarged_20261103 and is served on port 8791 after build completion.

Final regression: **475 tests passed**, analysis clean. The welcome size change is a separate source hunk; unrelated pending narrative/layout integration remains in the working tree.
