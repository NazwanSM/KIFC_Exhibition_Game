# Feedback pose and mascot proportions — 3 November 2026

Owner follow-up: use `Feedback_User_Pose/Review/Manggala_FEEDBACK_USER_POSE_REVIEW.glb`; enlarge and horizontally center the mascot after assembling all three fire elements, retaining its bottom anchor; enlarge other feedback mascots relative to speech bubbles.

## Changes

- Runtime rebuilt from the exact new source copy `assets/models/manggala_feedback_user_pose.glb`. Approved camera, materials, textures, badge, mesh/morph definitions and skin preserved. The five unrelated animation channels and sample bytes match the previous camera-facing source. Original Feedback mouth animation remains in Feedback; unvoiced feedback uses the regenerated FeedbackSilent clip.
- Updated Feedback loading/reduced-motion poster from the accompanying Blender scene, approved camera, Feedback frame 1; no source scene saved or overwritten. Blender lighting differs from model-viewer; the poster is a static fallback.
- Assembly completion uses a wider mascot container centered on X, still anchored to the same bottom edge. Its content is enlarged and offset to compensate for the source image's transparent side margin. The following explanation also has a larger mascot with the Continue button beside it.
- Correct/incorrect quiz and assembly feedback use larger containers and an enlarged upper-body view, preserving the bottom anchor. Compact long feedback uses 12px text to keep complete explanations within available space. Information-card feedback remains vertically centered beside its mascot. Impact feedback grows within its existing available height.

## Evidence

[Asset validation](asset-validation.json) compares decoded animation channel payloads and source/runtime structure. The source report explicitly records owner-authored arm/hand overlap; this is retained rather than repaired.

The `widget/` directory contains actual Flutter **widget renders with static mascot fallbacks**, not browser or Android captures. Five portrait viewports: 360×640, 411×731, 720×1280, 1080×1920 and 2160×3840; Indonesian, English and Korean. These simulate pixel dimensions, not physical reach or playback on a 42-inch TV.

- [Assembly complete, 1080×1920](widget/complete-id-1080x1920.png)
- [Assembly complete, 2160×3840](widget/complete-id-2160x3840.png)
- [Correct quiz feedback, 1080×1920](widget/correct-id-1080x1920.png)
- [Incorrect quiz feedback, 1080×1920](widget/hint-id-1080x1920.png)
- [Korean correct feedback, 2160×3840](widget/correct-ko-2160x3840.png)

Checks: `python tool/verify_feedback_asset.py`; `flutter analyze --no-pub`; assembly, peat quiz, impact, reading integration, chapter 2 and peat information-card test suites. The assembly suite explicitly asserts centered X and the unchanged physical bottom anchor. Final counts and build results are recorded in `checks.json`.

Status: ready for owner visual review. This follow-up remains in the existing working tree alongside prior uncommitted revisions; no unrelated owner files were staged. Native playback of this latest Feedback source has not been tested on the Android device in this follow-up.
