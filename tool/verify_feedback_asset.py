"""Verify the new source, preserved unrelated clips, and prepared runtime."""
import hashlib
import json
import struct
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'docs/client-revisions/2026-11-03/feedback-pose-proportions'
OUT.mkdir(parents=True, exist_ok=True)

def read(path):
    raw = path.read_bytes()
    size = struct.unpack_from('<I', raw, 12)[0]
    return json.loads(raw[20:20 + size]), raw[28 + size:]

def animation_data(doc, binary, name):
    clip = next(a for a in doc['animations'] if a['name'] == name)
    result = []
    for channel in clip['channels']:
        sampler = clip['samplers'][channel['sampler']]
        values = []
        for field in ['input', 'output']:
            accessor = doc['accessors'][sampler[field]]
            view = doc['bufferViews'][accessor['bufferView']]
            start = view.get('byteOffset', 0) + accessor.get('byteOffset', 0)
            components = {'SCALAR': 1, 'VEC3': 3, 'VEC4': 4}[accessor['type']]
            assert accessor['componentType'] == 5126 and 'byteStride' not in view
            values.append(binary[start:start + accessor['count'] * components * 4])
        result.append((channel['target'], sampler.get('interpolation', 'LINEAR'), values))
    return result

old, old_bin = read(ROOT / 'assets/models/manggala_camera_facing_revisions.glb')
new, new_bin = read(ROOT / 'assets/models/manggala_feedback_user_pose.glb')
runtime, runtime_bin = read(ROOT / 'assets/models/manggala_game_states.glb')
preserved = ['Idle', 'Talk', 'Wave', 'Happy', 'PointIdle']
for name in preserved:
    assert animation_data(old, old_bin, name) == animation_data(new, new_bin, name), name
assert animation_data(old, old_bin, 'Feedback') != animation_data(new, new_bin, 'Feedback')
for key in ['materials', 'textures', 'images', 'meshes', 'skins', 'cameras']:
    assert old.get(key) == new.get(key), key
assert runtime['animations'][:6] == new['animations']
assert runtime_bin[:len(new_bin)] == new_bin
poster = Image.open(ROOT / 'build/feedback-poster-wide.png').convert('RGBA')
poster = poster.crop(((2100 - 757) // 2, 0, (2100 - 757) // 2 + 757, 1009))
target = ROOT / 'assets/images/mascot3d/hintSafety.png'
poster.save(target)
manifest_path = ROOT / 'assets/models/mascot_posters.json'
manifest = json.loads(manifest_path.read_text())
manifest['hintSafety'].update(sha256=hashlib.sha256(target.read_bytes()).hexdigest(), bytes=target.stat().st_size)
manifest['hintSafety']['source'] = 'Feedback_User_Pose/Review/Manggala_FEEDBACK_USER_POSE_REVIEW.blend; Feedback frame 1; approved camera; Blender RGBA render, centered crop'
manifest_path.write_text(json.dumps(manifest, indent=2) + '\n')
report = {'preserved_clips': preserved, 'feedback_changed': True,
          'materials_textures_meshes_skins_morphs_cameras_preserved': True,
          'source_six_clips_and_binary_preserved_in_runtime': True,
          'runtime_sha256': hashlib.sha256((ROOT / 'assets/models/manggala_game_states.glb').read_bytes()).hexdigest(),
          'poster': manifest['hintSafety'], 'anatomy_note': 'Owner-authored hand/arm overlap retained per source REVIEW_REPORT.md.'}
(OUT / 'asset-validation.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, indent=2))
