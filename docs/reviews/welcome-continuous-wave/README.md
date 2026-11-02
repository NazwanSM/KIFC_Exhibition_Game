# Continuous welcome Wave — integration evidence

Source: `mascot_3d_pipeline/Welcome_Wave/Review/Manggala_WELCOME_WAVE_30s_REVIEW.glb`. The supplied report was read before integration and copied to `source-review.md`. Bundled unchanged as `assets/models/manggala_welcome_wave_30s.glb`: 7,025,064 bytes, SHA-256 `cb8e5d8cca8af20aa458442f0c38b5c69b30a23eb9002ecbc04c3ca59e57b46e`. Materials, textures, badge, shape keys, skeleton and all six clips remain in the original file.

## Behavior

Normal web builds now show this mascot on welcome by default. `WELCOME_3D_TEST=false` remains available to disable it, and native builds retain their existing opt-in pending device validation. Wave uses model-viewer's autoplay loop over the full embedded 30 seconds. Existing reduced-motion support disables autoplay. The approved camera metadata is byte-identical to the previous approved camera; the existing position, angle, FOV and source viewport aspect are retained. Transparent side margins of the source landscape viewport are clipped by the portrait mascot slot; the character is not stretched.

An inherited activity signal pauses Wave when navigation begins, including the outgoing AnimatedSwitcher transition. On disposal, a retained reference pauses the actual model-viewer element, removes autoplay, and releases its source. A MutationObserver captures that reference when the platform view is first attached; a document lookup only at disposal was proven too late. App inactivity also requests pause. The native WebView callback requests pause too, but native playback has not been tested.

## Verification

- Fresh normal web release build (no feature flag): PASS. Static analysis: PASS.
- Welcome conversation and game-flow tests: 27/27 PASS.
- Browser regression RED: `lifecycle-before.txt` shows the previous detached element remained unpaused. `lifecycle-after.txt` records an intermediate failed fix; it is retained as diagnostic history, not a passing result.
- `validate_runtime.js` and `runtime-test-output.txt`: browser test of the actual Flutter page. Asserts the served asset hash, all six 30-second clips, Wave arm and mouth variation, loop seam crossing, and face-to-camera direction on 901 timeline samples. The face-center anchor is the source-specified head-local `(0, .12, 0)` and its forward axis is local +Z. Runtime results are in `runtime-result.txt`.
- Navigation assertions: paused immediately after Start Challenge, paused/disconnected/source removed after the transition, and exactly one loaded, playing Wave when Back returns to welcome. This reproduces and fixes the requested stop-on-leave behavior.
- `welcome-411.png`, `welcome-1080.png`, `welcome-2160.png`: actual local browser screenshots at 411x731, 1080x1920 and 2160x3840, frozen at Wave time .267 seconds. These are viewport simulations, not hardware photos. No copy or text layout was changed.

## Limits

Verification covers Flutter Web. Android and Samsung/Tizen hardware playback, performance, physical touch reach and speaker behavior remain unvalidated. Model-viewer lighting differs from Blender studio lighting. Large-screen render sharpness remains a separate issue from preservation of texture data. The sampled and loop-seam checks are not a full artistic inspection of every frame at real-time speed.
