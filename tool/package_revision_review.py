"""Package current review artifacts without owner source footage or credentials."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'build/delivery/KIFC-1.0.10-r30-review'
OUT.mkdir(parents=True, exist_ok=True)
REPORT = ROOT / 'docs/client-revisions/2026-11-03/r30-20'
REPORT.mkdir(parents=True, exist_ok=True)
artifacts = {}
for src, name in [
    ('build/app/outputs/flutter-apk/app-release.apk', 'KIFC-1.0.10-r30-review.apk'),
    ('build/tizen/KIFC-1.0.10-unsigned.wgt', 'KIFC-1.0.10-tizen10-unsigned.wgt'),
]:
    shutil.copy2(ROOT / src, OUT / name)
    artifacts[name] = {'bytes': (OUT / name).stat().st_size,
                       'sha256': hashlib.sha256((OUT / name).read_bytes()).hexdigest()}

with zipfile.ZipFile(OUT / 'KIFC-web-offline-resources.zip', 'w', zipfile.ZIP_DEFLATED) as z:
    for file in sorted((ROOT / 'build/web').rglob('*')):
        if file.is_file():
            z.write(file, file.relative_to(ROOT / 'build/web'))

# Include current tracked files plus the new code/assets required to reproduce
# the pending narrative integration. Never glob owner incoming audio/reports.
paths = set(subprocess.check_output(['git', 'ls-files'], cwd=ROOT).decode().splitlines())
for folder in ['lib', 'test']:
    paths.update(p.relative_to(ROOT).as_posix() for p in (ROOT / folder).rglob('*')
                 if p.is_file() and p.suffix in {'.dart', '.py'})
paths.update(['assets/audio/narration/reading_timing.json',
              'assets/models/manggala_feedback_user_pose.glb',
              'assets/fonts/Roboto-Regular.woff2', 'assets/fonts/Roboto-LICENSE.txt'])
paths.update(p.relative_to(ROOT).as_posix() for p in (ROOT / 'tool').rglob('*')
             if p.is_file() and p.suffix in {'.py', '.mjs', '.js', '.dart', '.ps1', '.md'})
source_index = []
with zipfile.ZipFile(OUT / 'KIFC-current-source-review.zip', 'w', zipfile.ZIP_DEFLATED) as z:
    for name in sorted(paths):
        file = ROOT / name
        if name in {'docs/client-revisions/2026-11-03/r30-20/source-snapshot.json',
                    'docs/client-revisions/2026-11-03/r30-20/package-manifest.json'}:
            continue  # Generated after the archive; avoid recursive manifests.
        if not file.is_file() or name.startswith(('output/', '.playwright-cli/', 'docs/weekly-reports/')):
            continue
        z.write(file, name)
        source_index.append({'file': name, 'sha256': hashlib.sha256(file.read_bytes()).hexdigest()})

for file in OUT.glob('*.zip'):
    artifacts[file.name] = {'bytes': file.stat().st_size, 'sha256': hashlib.sha256(file.read_bytes()).hexdigest()}
with zipfile.ZipFile(OUT / 'KIFC-1.0.10-r30-review.apk') as apk, zipfile.ZipFile(OUT / 'KIFC-1.0.10-tizen10-unsigned.wgt') as wgt:
    for asset in ['assets/models/manggala_game_states.glb', 'assets/audio/narration/reading_timing.json',
                  'assets/images/mascot3d/hintSafety.png', 'assets/fonts/Roboto-Regular.woff2',
                  'assets/animations/forest-burn-loop.mp4', 'assets/audio/forest-music.mp3',
                  'assets/audio/forest-birds.mp3',
                  *[p.relative_to(ROOT).as_posix() for p in (ROOT / 'assets/audio/narration/prepared').glob('*/*.mp3')]]:
        original = (ROOT / asset).read_bytes()
        assert apk.read('assets/flutter_assets/' + asset) == original, 'APK: ' + asset
        assert wgt.read('assets/' + asset) == original, 'WGT: ' + asset
    assert wgt.read('config.xml').find(b'required_version="10.0"') >= 0
    assert b'Roboto' in wgt.read('assets/FontManifest.json')

manifest = {'version': '1.0.10-r30-review', 'versionCode': 2026110331,
            'git_head': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT).decode().strip(),
            'contains_pending_working_tree_integration': True,
            'apk_signing': 'review build signed with existing Android debug key; not store release',
            'tizen_signing': 'unsigned candidate; Samsung certificate required for physical TV installation',
            'minimum_android_api': 24, 'artifacts': artifacts,
            'shared_asset_bytes_verified_in_apk_and_wgt': True,
            'android_runtime_tests': 'postponed by owner', 'physical_tv': 'unavailable',
            'native_tizen_emulator': 'not validated; official TV Web Simulator is a separate test tier'}
(OUT / 'checksums.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
(REPORT / 'package-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
(REPORT / 'source-snapshot.json').write_text(json.dumps(source_index, indent=2) + '\n', encoding='utf-8')
shutil.copy2(ROOT / 'assets/fonts/Roboto-LICENSE.txt', OUT / 'Roboto-LICENSE.txt')
shutil.copy2(REPORT / 'README.md', OUT / 'README.md')
print(json.dumps({'output': str(OUT), 'artifacts': artifacts, 'shared_assets_verified': True}, indent=2))
