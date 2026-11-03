"""Record finished checks and verify the restarted web server serves current assets."""
import hashlib
import json
from pathlib import Path
from urllib.request import urlopen
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'docs/client-revisions/2026-11-03/feedback-pose-proportions'
assert 'All tests passed!' in (ROOT / 'build/feedback-pose-layout-final.log').read_text()
assert 'No issues found!' in (ROOT / 'build/feedback-pose-analysis-final.log').read_text()
assert 'Built build' in (ROOT / 'build/feedback-pose-web-build.log').read_text(encoding='utf-8')
served = []
for asset in ['assets/models/manggala_game_states.glb', 'assets/images/mascot3d/hintSafety.png']:
    response = urlopen('http://127.0.0.1:8788/assets/' + asset)
    assert response.status == 200
    assert response.read() == (ROOT / asset).read_bytes()
    served.append(asset)
assert urlopen('http://127.0.0.1:8788/assets/AssetManifest.bin').status == 200
index = []
for file in sorted((OUT / 'widget').glob('*.png')):
    with Image.open(file) as im:
        size = list(im.size)
    index.append({'file': file.relative_to(OUT).as_posix(), 'size': size,
                  'source': 'Flutter widget render; static mascot fallback',
                  'sha256': hashlib.sha256(file.read_bytes()).hexdigest()})
(OUT / 'screenshots.json').write_text(json.dumps(index, indent=2) + '\n')
report = {'tests_passed': 127, 'analyze': 'No issues found', 'web_build': 'passed',
          'web_server_restarted': True, 'served_bytes_match_current_assets': served,
          'served_asset_manifest': 'HTTP 200', 'widget_screenshots': len(index),
          'native_latest_feedback_playback_tested': False,
          'physical_tv_tested': False}
(OUT / 'checks.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, indent=2))
