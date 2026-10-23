"""Regression check for stale/missing APK media; run with python directly."""
from pathlib import Path
import json
import subprocess
import sys
import tempfile
import unittest
import zipfile


class ApkVerificationTest(unittest.TestCase):
    def test_rejects_old_code_and_missing_or_stale_media(self):
        root = Path(__file__).resolve().parents[1]
        scratch = root / "build/task-temp"
        scratch.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=scratch) as folder:
            apk = Path(folder) / "stale.apk"
            report = Path(folder) / "report.json"
            with zipfile.ZipFile(apk, "w") as bundle:
                bundle.writestr("assets/flutter_assets/assets/images/field/haze-sumatra-nasa.jpg", b"old photo")
                bundle.writestr("assets/flutter_assets/kernel_blob.bin", b"old code")
                bundle.writestr("assets/flutter_assets/assets/animations/237888.mp4", b"raw video")
            result = subprocess.run([sys.executable, str(root / "tool/verify_apk.py"),
                                     str(apk), "--report", str(report)], capture_output=True)
            self.assertEqual(result.returncode, 1, result.stderr)
            data = json.loads(report.read_text(encoding="utf-8"))
            self.assertFalse(data["passed"])
            failures = "\n".join(data["failures"])
            for reason in ["Missing asset:", "Stale asset:", "Stale debug gameplay:", "Unexpected raw video:"]:
                self.assertIn(reason, failures)


if __name__ == "__main__":
    unittest.main()
