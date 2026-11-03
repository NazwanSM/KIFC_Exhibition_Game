"""Render the owner Feedback pose for loading/reduced-motion fallback."""
from pathlib import Path
import bpy

ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path(r'D:/KIFC Game Exhibition/mascot_3d_pipeline/Feedback_User_Pose/Review')
bpy.ops.wm.open_mainfile(filepath=str(SOURCE / 'Manggala_FEEDBACK_USER_POSE_REVIEW.blend'))
scene = bpy.context.scene
for owner, name in [(bpy.data.objects['RIG-Manggala-Final'], 'Feedback'),
                    (bpy.data.objects['GEO-Manggala-Final'].data.shape_keys, 'Feedback_Mouth')]:
    for track in owner.animation_data.nla_tracks:
        track.mute = True
    action = bpy.data.actions[name]
    owner.animation_data.action = action
    owner.animation_data.action_slot = action.slots[0]
scene.camera = bpy.data.objects['CAM-UserApprovedView']
scene.frame_set(1)
scene.render.resolution_x = 2100
scene.render.resolution_y = 1009
scene.render.resolution_percentage = 100
scene.render.film_transparent = True
scene.render.image_settings.file_format = 'PNG'
scene.render.image_settings.color_mode = 'RGBA'
scene.render.filepath = str(ROOT / 'build/feedback-poster-wide.png')
bpy.ops.render.render(write_still=True)
