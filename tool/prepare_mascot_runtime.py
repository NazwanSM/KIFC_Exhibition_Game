"""Keep the approved GLB intact; append silent runtime clips for unvoiced UI."""
import copy
import hashlib
import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'assets/models/manggala_welcome_wave_30s.glb'
TARGET = ROOT / 'assets/models/manggala_game_states.glb'


def prepare():
    source = SOURCE.read_bytes()
    json_size = struct.unpack_from('<I', source, 12)[0]
    document = json.loads(source[20:20 + json_size])
    original_animations = copy.deepcopy(document['animations'])
    binary = bytearray(source[28 + json_size:][:document['buffers'][0]['byteLength']])
    original_binary = bytes(binary)
    cache = {}
    for name in ['Wave', 'Talk', 'Feedback']:
        clip = copy.deepcopy(next(a for a in original_animations if a['name'] == name))
        clip['name'] += 'Silent'
        for channel in clip['channels']:
            if channel['target']['path'] != 'weights':
                continue
            sampler = clip['samplers'][channel['sampler']]
            assert sampler.get('interpolation', 'LINEAR') == 'LINEAR'
            old = document['accessors'][sampler['output']]
            assert old['type'] == 'SCALAR' and old['componentType'] == 5126
            count = old['count']
            assert count % 3 == 0
            if count not in cache:
                binary.extend(b'\0' * (-len(binary) % 4))
                offset = len(binary)
                binary.extend(struct.pack('<' + 'f' * count, *([1., 0., 0.] * (count // 3))))
                view = len(document['bufferViews'])
                document['bufferViews'].append({'buffer': 0, 'byteOffset': offset, 'byteLength': count * 4})
                index = len(document['accessors'])
                document['accessors'].append({'bufferView': view, 'componentType': 5126, 'count': count, 'type': 'SCALAR'})
                cache[count] = index
            sampler['output'] = cache[count]
        document['animations'].append(clip)
    assert document['animations'][:6] == original_animations
    assert binary[:len(original_binary)] == original_binary
    document['buffers'][0]['byteLength'] = len(binary)
    metadata = json.dumps(document, separators=(',', ':')).encode('utf-8')
    metadata += b' ' * (-len(metadata) % 4)
    binary.extend(b'\0' * (-len(binary) % 4))
    output = (struct.pack('<III', 0x46546C67, 2, 28 + len(metadata) + len(binary))
              + struct.pack('<I4s', len(metadata), b'JSON') + metadata
              + struct.pack('<I4s', len(binary), b'BIN\0') + binary)
    TARGET.write_bytes(output)
    manifest = {
        'source': SOURCE.relative_to(ROOT).as_posix(),
        'source_sha256': hashlib.sha256(source).hexdigest(),
        'runtime': TARGET.relative_to(ROOT).as_posix(),
        'runtime_sha256': hashlib.sha256(output).hexdigest(),
        'runtime_bytes': len(output),
        'original_six_clips_and_binary_payload_preserved': True,
        'added_clips': ['WaveSilent', 'TalkSilent', 'FeedbackSilent'],
        'closed_mouth_weights': [1, 0, 0],
        'camera': 'CAM-UserApprovedView',
        'posters_manifest': 'assets/models/mascot_posters.json',
        'unvoiced_talking_clip': 'TalkSilent',
        'state_clips': {'idle': 'Idle', 'welcome': 'Wave', 'presenting': 'PointIdle',
                        'talking': 'Talk', 'success': 'Happy', 'hintSafety': 'FeedbackSilent',
                        'farewell': 'WaveSilent'},
    }
    (ROOT / 'assets/models/mascot_manifest.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(manifest, indent=2))


if __name__ == '__main__':
    prepare()
