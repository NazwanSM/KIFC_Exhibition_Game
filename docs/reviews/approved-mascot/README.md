# Final mascot — Flutter Web integration review

Source: `mascot_3d_pipeline/User_Pose_Match/Review/Manggala_USER_POSE_CAMERA_REVIEW.glb`. Read the accompanying review report before integration; a copy is retained here with the camera metadata. Bundled as `assets/models/manggala_user_approved.glb` with identical SHA-256 `58a6ef5974fd64720c84b93898013f9e096cad94c2682f8bba3dde2c834b4356`. No export, mesh, material, texture, badge or morph edit was applied to the source.

## Integration

Welcome remains opt-in with `--dart-define=WELCOME_3D_TEST=true`. It plays the final 30-second Wave on repeat; reduced-motion preference disables autoplay. Other pages still use their existing assets. `model_viewer_plus` 1.9.3 replaces the previous controller wrapper so camera target, orbit, metric distance and FOV can be configured before loading. This pinned version supports the project's Dart 3.9 SDK. The bundled model-viewer JS is served locally.

The approved camera is converted from Blender Z-up to glTF Y-up and applied explicitly; model-viewer does not automatically select the embedded camera. Source roll is negligible (below 0.00003 degrees). Its 2100:1009 viewport ratio is preserved by the renderer. The portrait mascot slot clips transparent side margins from that landscape viewport; it does not stretch the character or alter the projection to fit the slot. Lighting is model-viewer's default environment, so this is not a pixel-identical Blender lighting match. Render sharpness on the scaled Flutter canvas still needs improvement.

## Evidence

- Web release build: PASS; `flutter analyze`: PASS.
- Asset delivery: browser HTTP 200, 7,026,968 bytes; SHA-256 of the served body matches the original GLB. Capture script asserts this after clearing the old local service-worker cache.
- Existing welcome tests: 8/8 PASS. These check the normal UI and do not themselves validate WebGL.
- `runtime-track-validation.json`: actual model instance inside Flutter Web. Six 30-second clips; 13 nonperiodic samples per clip. Loaded bone position/rotation/scale and morph weights compared against the loaded clip's interpolated tracks. Maximum difference below 3e-8. Internal scene access is test-only and is not used by application code.
- Talk/Wave/Feedback show changing mouth weights. Idle/Happy/PointIdle keep the closed mouth from their source tracks. PointIdle's arm local rotation is constant as intended; its breathing tracks are included in the comparison. Static arm/mouth values are not counted as playback failure.
- `runtime-playback-validation.txt`: real playback advanced from 29.8 seconds across the loop seam for each clip; all wrapped to roughly 0.5 seconds. This is a loop-seam test plus sampled track validation, not a full real-time artistic review of every frame of six clips.
- Active camera vs embedded `CAM-UserApprovedView`: world matrix max difference about 4.02e-7; six landmark projections differ by at most 0.0027 px when mapped to 2100x1009. Vertical FOV matches within about 1.3e-6 degrees. Minor aspect rounding occurs at CSS pixel boundaries. Renderer optimizes near/far to 0.007/7 rather than the source 0.01/1000; visible landmark XY projection is preserved.
- Nine `welcome-{id,en,ko}-{411,1080,2160}.png` files: actual local browser screenshots at 411x731, 1080x1920, 2160x3840, frozen at Wave time 1.213 s. Six `clip-*.png` screenshots show individual clip samples at 1080x1920. These are not hardware photographs.

## Limits

Android playback is not validated: `adb devices` found no connected device. Android WebView loopback HTTP configuration is prepared (localhost/127.0.0.1 only), but has not been exercised on Android. No APK or Tizen compatibility claim is made. There is no narration sync or phoneme lip-sync. No performance/FPS budget or physical touchscreen reach was validated. The earlier full test suite had two audio-volume failures; this integration ran the focused welcome tests, not a new full-suite run.
