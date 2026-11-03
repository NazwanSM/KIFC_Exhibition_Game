"""Fetch the official Samsung TV Web Simulator to a separate local SDK folder.

Not a native Tizen OS emulator. The opaque-window workaround is SDK-local.
"""
import argparse
import hashlib
import json
from pathlib import Path
import urllib.request
import zipfile

p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--root', type=Path, default=Path('D:/KIFC-tizen-tools'))
args = p.parse_args()
name = 'tv-samsung-websimulator-core_10.0.6_windows-64.zip'
url = 'https://download.tizen.org/sdk/extensions/tv_extensions/binary/' + name
expected = 'f449e0f9707257b9b6d4004fc8c4caf34369bd3820817fce3016061dd404a1cd'
archive = args.root / 'downloads' / name
archive.parent.mkdir(parents=True, exist_ok=True)
if not archive.exists():
    urllib.request.urlretrieve(url, archive)
assert hashlib.sha256(archive.read_bytes()).hexdigest() == expected, 'SDK archive hash differs'
target = (args.root / 'sdk').resolve()
exe = target / 'data/tools/sec-tv-simulator/simulator.exe'
if not exe.exists():
    with zipfile.ZipFile(archive) as z:
        for item in z.infolist():
            (target / item.filename).resolve().relative_to(target)
        z.extractall(target)
package = exe.parent / 'package.json'
backup = package.with_suffix('.original.json')
if not backup.exists():
    backup.write_bytes(package.read_bytes())
config = json.loads(package.read_text(encoding='utf-8'))
config['window']['transparent'] = False
package.write_text(json.dumps(config, indent=2) + '\n', encoding='utf-8')
report = {'source': url, 'version': '10.0.6', 'sha256': expected, 'bytes': archive.stat().st_size,
          'executable': str(exe), 'sdk_local_workaround': 'window.transparent=false',
          'original_config_backup': str(backup), 'native_tizen_os': False,
          'observed_browser_engine': 'Chromium 137.0.7151.69 (NW.js 0.100.1), not TV Chromium 130'}
(args.root / 'sdk-installation.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report, indent=2))
