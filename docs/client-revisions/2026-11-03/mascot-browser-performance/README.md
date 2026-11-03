# Browser mascot performance — 3 November 2026

The optimized release web build removes duplicate mascot loading and unnecessary CanvasKit paints during narrated reading. Model, textures, camera, animation data and word timestamps are preserved. This is desktop browser evidence, not a QM43B-T performance certificate.

## Observed results

| Active reading measurement | Before | Optimized | Sampling |
|---|---:|---:|---|
| 1080×1920 main-thread task time (ms per second) | 1002.8 | 168.3 | median of 3 journeys each |
| 1080×1920 rAF interval p95 (ms) | 20.8 | 7.1 | median of 3 journeys each |
| 2160×3840 main-thread task time (ms per second) | 1005.5 | 200.2 | 1 journey each; exploratory |
| 2160×3840 rAF interval p95 (ms) | 27.9 | 7.1 | 1 journey each; exploratory |
| GLB requests per journey | 2 | 1 | all 3 Full HD repetitions |
| Viewer JS requests per journey | 2 | 1 | all 3 Full HD repetitions |

Reading main-thread task time decreased **83.2%** at Full HD and **80.1%** in the single 4K comparison. These percentages concern browser main-thread work, not whole-system CPU/GPU utilization. rAF intervals measure callback pacing, not rendered GLB FPS or display-to-touch latency.

Median initial model load event: 1336 → 1258 ms from navigation. This local startup observation includes app initialization and shader/model preparation; it is not an internet download benchmark. [Raw summary](summary.json).

## Causes and changes

1. **Duplicate web warmup:** Flutter rootBundle loaded GLB and viewer JS as bytes that only the native asset server consumes, while the browser renderer loaded its own copies. Web now leaves fetch/decoded-model caching to model-viewer. Native byte warmup is retained.
2. **Identical text updates:** audio positions arrived every frame and rebuilt the reading screen even between word boundaries. Every audio position is still recorded; UI rebuilds only when the visible text changes or reading advances.
3. **Forced Flutter painting:** audioplayers' default FramePositionUpdater schedules Flutter frames continuously. A CPU profile after the first two fixes still showed dominant CanvasKit WASM work. The web narration sampler now uses browser requestAnimationFrame directly, preserving display-frame audio sampling without requesting Flutter paints. Stop, resume and disposal cancel the appropriate callback. Native keeps FramePositionUpdater.

No texture resizing, mesh simplification, FPS cap, camera change, shader replacement or new quality reduction was applied. The [input hashes](visual-input-hashes.json) confirm identical GLB, renderer JS and timing bytes.

## Visual and functional validation

- **466 Flutter tests passed**, analysis clean. [Final regression log](tests-final.log), [analysis](analyze-final.log).
- The new word-boundary regression failed before the fix (an unchanged word scheduled a frame), then passed. Existing audio progression, pause, failure, skip, scoring and timer tests also pass.
- A release-browser sampler harness failed before the fix because audio-only sampling scheduled a Flutter paint, and passed afterward with the same sampled position, stop/resume and disposal behavior. [Red](sampler-red-result.json), [green](sampler-green-result.json).
- Browser loading checks failed on the duplicate GLB and passed for all three optimized journeys. JavaScript errors: none in the accepted benchmark runs.
- **15 before/after welcome pairs**: five sizes × ID/EN/KO, real renderer at fixed Wave time 1.25 seconds. **14 pairs are pixel-identical**. The remaining 2160×3840 English pair differs in only **3 pixels, maximum channel delta 1/255**. [Exact comparison](visual-comparison.json), [capture index](evidence-index.json).
- [Optimized Full HD Indonesian](visual/optimized/1080x1920/0-welcome-id.png), [optimized 4K Korean](visual/optimized/2160x3840/0-welcome-ko.png).

The Flutter debug browser-test compiler stalled and was stopped; it is not counted as a passing test. The sampler contract was instead exercised with a release-mode browser harness, matching the benchmark build mode. Builds emit the existing Cupertino icon-font inventory warning; successful builds and clean analysis are recorded separately.

## Method and limits

Desktop headless Chrome 156 on Windows, NVIDIA RTX 3050 Laptop GPU via ANGLE/D3D11, 16 logical processors, DPR 1. Release builds, fresh contexts, network cache disabled, service workers blocked. Three Full HD journeys each before/after; one optimized PNG control journey; one 4K journey each. Welcome, real pointer drag of three fire elements, looping video with feedback and active narrated reading were exercised. Reading sampling waits for the same visible phrase, so the PNG fallback's initial narration delay is excluded. PNG is a diagnostic control and is not the shipped visual treatment.

The earlier preview browser lost its automation connection (snapshot timeout then unavailable host); controlled Chrome was used for the accepted runs. Initial exploratory results that sampled PNG during its narration startup delay are excluded. Raw accepted data lives in `final-before/`, `optimized-results/`, `png-optimized-results/`, `4k-before/` and `4k-optimized/`.

| Required input / budget | Availability / verdict |
|---|---|
| Source, browser timings, profile, tests, screenshots | FOUND |
| project.yaml / project.local.yaml performance budgets | ABSENT; no agreed FPS, frame, load, draw-call or memory ceiling; headroom NOT ASSESSED |
| Target QM43B-T hardware performance | ABSENT; NOT ASSESSED — NO DATA |
| GPU timing, total process/GPU memory, true touch latency, long soak | ABSENT; NOT ASSESSED — NO DATA |

JS heap samples are observations only and exclude native, GPU and much WASM memory. No total-RAM reduction or leak-free sustained operation is claimed. Model-viewer's existing adaptive-resolution behavior was not changed. QM43B-T is Tizen 6.5; the earlier Tizen 10 WGT experiment is not its deployment package. Android tests remain deferred as requested.

## Review and reproduction

The new web ZIP is `build/delivery/KIFC-web-performance-20261103.zip`; [checksum](package.json). Extract and serve it through HTTP, then open its index page. Do not use file://. The previous APK/WGT/source packages are preserved and do not contain these new optimizations. No push or deployment was performed.

The working tree already contains pending R30-17–19 integration. [optimization.patch](optimization.patch) isolates this follow-up against the prior `KIFC-current-source-review.zip` snapshot, rather than pretending the current source equals clean HEAD. Its application to the three original source files plus new files was checked in an isolated fixture. Source hashes are in [source-files.json](source-files.json).

Rebuild: `flutter build web --no-pub --no-wasm-dry-run --no-web-resources-cdn`. The benchmark uses `tool/browser_mascot_perf.mjs`; set PLAYWRIGHT_MODULE to an installed Playwright module directory, PERF_URL to the HTTP build URL and PERF_OUT to an evidence folder. Use PERF_REPEATS=3 and 1080×1920, then a separate 2160×3840 run. `tool/assert_mascot_perf.mjs` checks observed resource delivery; `tool/summarize_browser_perf.py` summarizes the recorded paths. The browser sampler harness is `tool/narration_sampler_check.dart`, built with Flutter's release web target and checked by `tool/run_narration_sampler_check.mjs`.

Verdict: **COMPLETE — browser profile and quality-preserving optimization verified for the recorded desktop scenarios.** TV hardware performance remains NOT ASSESSED.
