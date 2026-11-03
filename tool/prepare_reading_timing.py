"""Prepare reviewable word cues from the owner's accepted timing draft.

Where a draft span contains several words, divide its interval by character
length. These boundaries are estimates and require listening review.
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'docs/client-revisions/2026-10-30/narration/timings-draft.json'
TARGET = ROOT / 'assets/audio/narration/reading_timing.json'
draft = json.loads(SOURCE.read_text(encoding='utf-8'))
items = []
for item in draft['items']:
    if not item['key'].startswith('karhutla-'):
        continue
    script = item['script']
    cues = []
    for span in item['spans']:
        start, end = span['char_start'], span['char_end']
        assert script[start:end] == span['text'], (item['key'], item['locale'], span)
        pieces = list(re.finditer(r'\S+', span['text']))
        total = sum(len(m.group()) for m in pieces)
        prior = 0
        for word in pieces:
            offset = prior / total
            prior += len(word.group())
            cues.append({
                'end': start + word.end(),
                'time': round(span['start'] + (span['end'] - span['start']) * offset, 4),
                'estimated_split': len(pieces) > 1,
            })
    assert cues and cues[-1]['end'] == len(script)
    assert all(a['time'] <= b['time'] and a['end'] < b['end'] for a, b in zip(cues, cues[1:]))
    assert all(0 <= c['time'] <= item['duration_seconds'] for c in cues)
    items.append({'key': item['key'], 'locale': item['locale'], 'text': script,
                  'duration': item['duration_seconds'], 'cues': cues,
                  'audio_sha256': item['output_sha256']})
assert len(items) == 9
TARGET.write_text(json.dumps({'status': 'estimated_splits_require_listening_review', 'items': items}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(f'Prepared {len(items)} readings with {sum(c["estimated_split"] for i in items for c in i["cues"])} estimated word cues.')
