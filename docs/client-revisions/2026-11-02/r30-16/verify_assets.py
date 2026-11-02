"""Read-only integrity checks against the owner source and built Android APK."""
import hashlib
import json
import struct
import zipfile
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[4]
EVIDENCE = Path(__file__).resolve().parent
SOURCE = Path(r'D:\KIFC Game Exhibition\mascot_3d_pipeline\Welcome_Wave\Review\Manggala_WELCOME_WAVE_30s_REVIEW.glb')

def glb(data):
    size = struct.unpack_from('<I', data, 12)[0]
    document = json.loads(data[20:20 + size])
    binary = data[28 + size:][:document['buffers'][0]['byteLength']]
    return document, binary

source = SOURCE.read_bytes()
archival = (ROOT / 'assets/models/manggala_welcome_wave_30s.glb').read_bytes()
runtime = (ROOT / 'assets/models/manggala_game_states.glb').read_bytes()
a, ab = glb(source)
b, bb = glb(runtime)
assert archival == source
assert b['animations'][:6] == a['animations']
assert bb[:len(ab)] == ab
for field in ['materials', 'textures', 'images', 'meshes', 'nodes', 'skins', 'cameras']:
    assert b.get(field) == a.get(field), field
posters = []
for path in sorted((ROOT / 'assets/images/mascot3d').glob('*.png')):
    with Image.open(path) as im:
        assert im.mode == 'RGBA'
        assert im.getpixel((0, 0))[3] == 0
        posters.append({'file': path.name, 'dimensions': list(im.size), 'transparent_corner': True})
assert len(posters) == 7
apk = ROOT / 'build/app/outputs/flutter-apk/app-debug.apk'
with zipfile.ZipFile(apk) as bundle:
    assert bundle.read('assets/flutter_assets/assets/models/manggala_game_states.glb') == runtime
    assert bundle.read('assets/flutter_assets/packages/model_viewer_plus/assets/model-viewer.min.js')
    for poster in posters:
        assert bundle.read('assets/flutter_assets/assets/images/mascot3d/' + poster['file'])
result = {
    'owner_source_sha256': hashlib.sha256(source).hexdigest(),
    'archival_source_identical': True,
    'runtime_sha256': hashlib.sha256(runtime).hexdigest(),
    'runtime_bytes': len(runtime),
    'original_six_clips_identical': True,
    'original_binary_prefix_identical': True,
    'materials_textures_images_meshes_nodes_skins_cameras_identical': True,
    'runtime_clips': [clip['name'] for clip in b['animations']],
    'posters': posters,
    'apk_contains_runtime_posters_and_local_renderer': True,
}
(EVIDENCE / 'asset-integrity.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps(result, indent=2))
