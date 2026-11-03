"""Create an unsigned offline Samsung TV Web widget from a Flutter web build.

This is a Web WGT, not flutter-tizen's native TPK. Signing/device approval remain
separate steps. No SDK, developer credentials or source project changes needed.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import zipfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--web-dir', type=Path, default=Path('build/web'))
parser.add_argument('--output', type=Path, default=Path('build/tizen/KIFC-1.0.10-unsigned.wgt'))
args = parser.parse_args()
root = args.web_dir.resolve()
for name in ['index.html', 'flutter_bootstrap.js', 'main.dart.js', 'canvaskit/canvaskit.wasm']:
    if not (root / name).is_file():
        raise SystemExit(f'Missing build resource: {name}')
index = (root / 'index.html').read_text(encoding='utf-8')
index, count = re.subn(r'<base href="[^"]*">', '<base href="./">', index)
if count != 1:
    raise SystemExit('Expected one Flutter base href')
bootstrap = (root / 'flutter_bootstrap.js').read_text(encoding='utf-8')
if not re.search(r'"useLocalCanvasKit"\s*:\s*true', bootstrap):
    raise SystemExit('Rebuild with --no-web-resources-cdn before packaging')
config = '''<?xml version="1.0" encoding="UTF-8"?>
<widget xmlns="http://www.w3.org/ns/widgets" xmlns:tizen="http://tizen.org/ns/widgets"
 id="https://kifc.local/fire-prevention" version="1.0.10" viewmodes="maximized">
 <tizen:application id="KIFCGameTV.FirePrevention" package="KIFCGameTV" required_version="10.0"/>
 <content src="index.html"/>
 <name>KIFC Fire Prevention</name>
 <icon src="icons/Icon-192.png"/>
 <tizen:profile name="tv-samsung"/>
 <tizen:setting screen-orientation="landscape" context-menu="disable"
  background-support="disable" encryption="disable" install-location="auto" hwkey-event="enable"/>
 <tizen:content-security-policy>default-src 'self' data: blob:; script-src 'self' 'unsafe-eval' 'wasm-unsafe-eval' blob:; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; connect-src 'self' data: blob:; media-src 'self' data: blob:; font-src 'self' data:; worker-src 'self' blob:</tizen:content-security-policy>
</widget>
'''
args.output.parent.mkdir(parents=True, exist_ok=True)
entries = []
with zipfile.ZipFile(args.output, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
    for file in sorted(root.rglob('*')):
        if not file.is_file():
            continue
        name = file.relative_to(root).as_posix()
        # WRT runs an installed widget, not a service-worker-controlled website.
        if name == 'flutter_service_worker.js' or name.endswith('.map'):
            continue
        data = index.encode() if name == 'index.html' else file.read_bytes()
        if name == 'flutter_bootstrap.js':
            data = data.replace(b'serviceWorkerSettings:', b'_unusedServiceWorkerSettings:')
        archive.writestr(name, data)
        entries.append({'file': name, 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()})
    archive.writestr('config.xml', config)
manifest = {'package': str(args.output), 'signed': False,
            'target': 'Samsung TV Web application; compatibility candidate',
            'build_requires': '--no-web-resources-cdn',
            'sha256': hashlib.sha256(args.output.read_bytes()).hexdigest(),
            'bytes': args.output.stat().st_size, 'files': entries}
args.output.with_suffix('.manifest.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: v for k, v in manifest.items() if k != 'files'}, indent=2))
