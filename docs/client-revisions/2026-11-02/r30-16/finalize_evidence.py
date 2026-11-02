"""Build the evidence index and record verified local command outcomes."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[4]
HERE = Path(__file__).resolve().parent
lines = ['# Screenshot R30-16', '', 'Browser aktual, viewport portrait; simulasi resolusi TV, bukan foto panel fisik. Semua tautan memakai hasil capture game Flutter yang sebenarnya.', '', '| Halaman / bahasa | 360×640 | 411×731 | 720×1280 | 1080×1920 | 2160×3840 |', '|---|---|---|---|---|---|']
for screen in ['welcome', 'triangleBuild', 'triangleExplanation', 'karhutlaCards', 'peatCharacteristics', 'finalReview', 'closing']:
    for lang in ['id', 'en', 'ko']:
        files = [f'{screen}-{lang}-{w}.jpg' for w in [360, 411, 720, 1080, 2160]]
        assert all((HERE / name).exists() for name in files)
        lines.append('| ' + screen + ' / ' + lang + ' | ' + ' | '.join(f'[Lihat]({name})' for name in files) + ' |')
lines += ['', '## Android aktual', '', 'TECNO LG7n Android 12, 720×1640. Fixture memilih halaman Flutter asli melalui entry point debug; perjalanan gesture dicatat terpisah.', '', '| Halaman fixture | Indonesia | Inggris | Korea |', '|---|---|---|---|']
for screen in ['risk-correct', 'final-review', 'closing']:
    lines.append('| ' + screen + ' | ' + ' | '.join(f'[Lihat](android-{screen}-{lang}.png)' for lang in ['id', 'en', 'ko']) + ' |')
lines += ['', '[Welcome Android](android-welcome-final.png) · [Drag salah](android-assembly-wrong.png) · [Drag lengkap](android-assembly-complete.png) · [Penyebab salah](android-cause-wrong.png) · [Penyebab benar](android-cause-correct.png) · [Kartu gambut](android-peat-cards.png) · [Rekaman gerakan](android-motion.mp4)', '', '## Fallback dan interaksi browser', '', '[Reduced motion](reduced-motion.jpg) · [Renderer gagal](renderer-failure-fallback.jpg) · [Kuis benar](risk-correct.jpg) · [Kuis salah](risk-wrong.jpg) · [Kartu dibuka](peat-cards-open.jpg)', '']
(HERE / 'screenshots.md').write_text('\n'.join(lines), encoding='utf-8')
tests = (ROOT / 'build/r30-16-final-tests.log').read_text(encoding='utf-8')
analysis = (ROOT / 'build/r30-16-final-analysis.log').read_text(encoding='utf-8')
assert '+447: All tests passed!' in tests
assert 'No issues found!' in analysis
for name in ['r30-16-main-final.log', 'r30-16-review-final.log']:
    assert 'Built build' in (ROOT / 'build' / name).read_text(encoding='utf-8')
assert len(json.loads((HERE / 'android-fixtures.json').read_text())) == 10
apk = ROOT / 'build/app/outputs/flutter-apk/app-debug.apk'
result = {'date': '2026-11-02', 'analysis': 'No issues found', 'flutter_tests_passed': 447, 'web_capture_count': 105, 'web_interaction_checks': 14, 'native_fixture_captures': 10, 'main_web_build': 'passed', 'review_web_build': 'passed', 'android_review_apk_build': 'passed', 'apk_version': '1.0.6-mascot-review+2026110216', 'apk_sha256': hashlib.sha256(apk.read_bytes()).hexdigest(), 'physical_exhibition_TV_tested': False}
(HERE / 'verification.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps(result))
