import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class ReadingTimingIntegrityTest(unittest.TestCase):
    def test_each_approved_reading_has_ordered_cues_and_matching_audio(self):
        data = json.loads((ROOT / 'assets/audio/narration/reading_timing.json').read_text(encoding='utf-8'))
        self.assertEqual(len(data['items']), 9)
        self.assertEqual({x['locale'] for x in data['items']}, {'id', 'en', 'ko'})
        for item in data['items']:
            with self.subTest(key=item['key'], locale=item['locale']):
                path = ROOT / 'assets/audio/narration/prepared' / item['locale'] / (item['key'] + '.mp3')
                self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), item['audio_sha256'])
                cues = item['cues']
                self.assertEqual(cues[-1]['end'], len(item['text']))
                self.assertTrue(all(a['time'] <= b['time'] for a, b in zip(cues, cues[1:])))
                self.assertTrue(all(0 <= c['time'] <= item['duration'] for c in cues))


if __name__ == '__main__':
    unittest.main()
