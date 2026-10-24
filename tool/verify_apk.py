"""Check offline assets in an APK against this checkout (no third-party modules).

python tool/verify_apk.py build/app/outputs/flutter-apk/app-debug.apk
Use after every build: an exit code of zero from Gradle alone can leave an old
packaged APK. Debug builds also check recognizable current gameplay strings.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import sys
import zipfile

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("apk", nargs="?", type=Path,
                    default=root / "build/app/outputs/flutter-apk/app-debug.apk")
parser.add_argument("--report", type=Path,
                    default=root / "build/review-kifc-integration/apk-verification.json")
args = parser.parse_args()
apk = args.apk
pubspec = (root / "pubspec.yaml").read_text(encoding="utf-8")
asset_section = pubspec.split("  assets:\n", 1)[1].split("  fonts:", 1)[0]
expected = set()
for entry in re.findall(r"^    - (assets/[^\r\n]+)", asset_section, re.M):
    source = root / entry
    if source.is_dir():
        expected.update(p for p in source.iterdir() if p.is_file())
    else:
        expected.add(source)
for font in re.findall(r"asset: (assets/[^\r\n]+)", pubspec):
    expected.add(root / font)

failures = []
with zipfile.ZipFile(apk) as bundle:
    names = set(bundle.namelist())
    for source in sorted(expected):
        asset = source.relative_to(root).as_posix()
        packed = "assets/flutter_assets/" + asset
        if packed not in names:
            failures.append("Missing asset: " + asset)
        elif hashlib.sha256(bundle.read(packed)).digest() != hashlib.sha256(source.read_bytes()).digest():
            failures.append("Stale asset: " + asset)
    raw_video = [name for name in names if name.lower().endswith(".mp4")]
    if raw_video:
        failures.append("Unexpected raw video: " + ", ".join(raw_video))
    kernel = "assets/flutter_assets/kernel_blob.bin"
    if kernel in names:
        data = bundle.read(kernel)
        for marker in ["Impact challenge bonus", "finalChallengeSeconds", "_compactLayout", "PeatCharacteristicCard"]:
            if marker.encode() not in data:
                failures.append("Stale debug gameplay: missing " + marker)

report = {"apk": str(apk.resolve()), "bytes": apk.stat().st_size,
          "sha256": hashlib.sha256(apk.read_bytes()).hexdigest(),
          "offlineAssetsChecked": len(expected), "failures": failures,
          "passed": not failures}
out = args.report
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(json.dumps(report, indent=2), encoding="utf-8")
print(json.dumps(report, indent=2))
sys.exit(1 if failures else 0)
