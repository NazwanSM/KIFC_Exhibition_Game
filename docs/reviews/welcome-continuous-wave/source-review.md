# Welcome — continuous Wave, 30 seconds

Source: `User_Pose_Match/Review/Manggala_USER_POSE_CAMERA_REVIEW.blend`.
This is an independent version. The source and prior deliverables are not overwritten.

## Change

Only the skeletal `Wave` action is replaced. The previous Wave is archived inside Blender as `ARCHIVE_PreContinuous_Wave`. Its original imported Mixamo waving cycle is retimed to one second and repeated for the full 30 seconds, with no stationary hold sections and no repeated lowering of the arm. The former 1.35-second hold after each three-wave group is removed. Shoulder, forearm, elbow, wrist, and fingers retain their imported animation; this is not a wrist-only procedural replacement.

The head is aimed toward `CAM-UserApprovedView` on every baked frame. Its anatomical local +Z face direction points from a face-center anchor toward the camera, with an upright local +Y axis. The camera itself is unchanged. This facing is baked for that fixed camera, not a runtime camera-tracking constraint. Choosing a different camera in the game requires a different head aim or runtime look-at control.

The Wave mouth animation remains unchanged and continues speaking. Idle, Talk, Happy, Feedback and the user's customized PointIdle are unchanged, including all mouth action data. No mesh coordinates, rest bones, skin weights, shape keys, UVs, textures, materials, or original logo assets are edited.

## Review

`Welcome_Wave_CONTINUOUS_30s.mp4` shows the complete 30-second animation at normal speed from the approved camera. Preview encoding is 12 fps; skeletal and morph animation data in Blender/GLB remain 30 fps. `Welcome_Wave_CLOSEUP_30s.mp4` is a crop of the same render, with no perspective change. The render uses the existing studio lighting. `Welcome_Wave_contact.jpg` samples the motion at different phases and throughout the timeline.

## Validation artifacts

- `actual_motion_validation.json`: all 901 frames, camera-facing error, continuous hand motion over one-second windows, framing and elbow range.
- `loop_motion_validation.json`: exact pose/mouth endpoint match, wrap-step comparison, breathing and inherited foot drift.
- `preservation_validation.json`: geometry, UVs, normals, weights, morph coordinates, packed image bytes, material nodes, skeleton and object transforms against the approved source.
- `geometry_animation_validation.json`: badge attachment and bone-length/scale checks over the actual Wave timeline.
- `wave_build_validation.json`: protected action fingerprints, source hash and modification scope.
- `glb_export_validation.json`: six named 30-second clips, skeleton, morph targets, embedded textures, exact badge image and approved camera.
- `roundtrip_validation.json`: clean-scene import comparisons of bone matrices, surfaces, mouth values and camera across all clips.

The intended runtime remains offline. Set the `Wave` clip to repeat in the application to continue beyond 30 seconds. Camera framing requires the same aspect ratio or letterboxing. Flutter/Android renderer playback is not tested here.

## Deliverables

- `Manggala_WELCOME_WAVE_30s_REVIEW.blend`
- `Manggala_WELCOME_WAVE_30s_REVIEW.glb`
- `Welcome_Wave_CONTINUOUS_30s.mp4`
- `Welcome_Wave_CLOSEUP_30s.mp4`

The GLB keeps the names `Idle`, `Talk`, `Wave`, `Happy`, `Feedback`, `PointIdle`. It exports only the character, skinned badge, armature, and approved camera. Debug objects and archived actions are excluded.
