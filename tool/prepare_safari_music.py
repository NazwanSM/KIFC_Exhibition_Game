"""Prepare the chosen full Safari composition; requires FFmpeg/FFprobe on PATH.

python tool/prepare_safari_music.py SOURCE_OGG
The source hash is pinned to the owner's A3 selection. No download or generation.
"""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
WORK = ROOT / 'build/review-r30-09-2026-10-30'
EXPECTED = 'ce9f72c736617849fb16ce78f03c5b148b4d97ad7b422ac809f274315792f878'


def run(*args):
    result = subprocess.run(args, capture_output=True, text=True, check=True)
    return result


def prepare(source):
    source = Path(source)
    assert hashlib.sha256(source.read_bytes()).hexdigest() == EXPECTED, 'Wrong Safari source'
    WORK.mkdir(parents=True, exist_ok=True)
    probe = json.loads(run('ffprobe', '-v', 'quiet', '-show_format', '-of', 'json', str(source)).stdout)
    duration = float(probe['format']['duration'])
    overlap = 5.0  # Join the source's natural fade-out to its introduction.
    import wave, array, math
    decoded = WORK / 'safari-decoded.wav'
    run('ffmpeg', '-y', '-v', 'error', '-i', str(source), '-af', 'volume=-6dB',
        '-ar', '44100', '-ac', '2', '-c:a', 'pcm_s16le', str(decoded))
    with wave.open(str(decoded), 'rb') as w:
        frames, rate, channels = w.getnframes(), w.getframerate(), w.getnchannels()
        raw = w.readframes(frames)
    count = round(overlap * rate)
    head, tail, seam = array.array('h'), array.array('h'), array.array('h')
    head.frombytes(raw[:count*channels*2]); tail.frombytes(raw[-count*channels*2:])
    for frame in range(count):
        phase = frame / (count - 1) * math.pi / 2
        for channel in range(channels):
            i = frame * channels + channel
            seam.append(max(-32768, min(32767, round(tail[i]*math.cos(phase)+head[i]*math.sin(phase)))))
    intermediate = WORK / 'safari-loop-unmastered.wav'
    with wave.open(str(intermediate), 'wb') as w:
        w.setparams((channels, 2, rate, 0, 'NONE', 'not compressed'))
        w.writeframes(raw[count*channels*2:-count*channels*2] + seam.tobytes())
    assert abs((frames-count)/rate - (duration-overlap)) < .01
    measured = run('ffmpeg', '-hide_banner', '-i', str(intermediate), '-af',
                   'loudnorm=I=-18:TP=-2:LRA=12:print_format=json', '-f', 'null', '-')
    (WORK / 'loudness-pass1.log').write_text(measured.stderr, encoding='utf-8')
    stats = json.loads(measured.stderr[measured.stderr.rfind('{'):measured.stderr.rfind('}')+1])
    filt = ('loudnorm=I=-18:TP=-2:LRA=12:linear=true:'
            f'measured_I={stats["input_i"]}:measured_TP={stats["input_tp"]}:'
            f'measured_LRA={stats["input_lra"]}:measured_thresh={stats["input_thresh"]}:'
            f'offset={stats["target_offset"]}')
    output = WORK / 'forest-music.mp3'
    run('ffmpeg', '-y', '-v', 'error', '-i', str(intermediate), '-af', filt,
        '-ar', '44100', '-ac', '2', '-c:a', 'libmp3lame', '-b:a', '96k',
        '-metadata', 'title=Safari', '-metadata', 'artist=syncopika',
        '-metadata', 'copyright=CC BY 3.0; https://creativecommons.org/licenses/by/3.0/', str(output))
    final = run('ffmpeg', '-hide_banner', '-i', str(output), '-af',
                'loudnorm=I=-18:TP=-2:LRA=12:print_format=json', '-f', 'null', '-')
    (WORK / 'loudness-runtime.log').write_text(final.stderr, encoding='utf-8')
    final_stats = json.loads(final.stderr[final.stderr.rfind('{'):final.stderr.rfind('}')+1])
    manifest = {
        'title': 'Safari', 'creator': 'syncopika',
        'sourcePage': 'https://opengameart.org/content/safari',
        'sourceUrl': 'https://opengameart.org/sites/default/files/safari.ogg',
        'license': 'CC BY 3.0', 'licenseUrl': 'https://creativecommons.org/licenses/by/3.0/',
        'sourceSha256': EXPECTED, 'sourceDurationSeconds': duration,
        'runtime': 'assets/audio/forest-music.mp3', 'loopDurationSeconds': duration-overlap,
        'processing': 'Full composition, rotated by 5 seconds; 5-second equal-power circular outro/intro crossfade; two-pass -18 LUFS/-2 dBTP; stereo 44.1kHz MP3 96kbps. No 30-second excerpt or new fade-out.',
        'bytes': output.stat().st_size, 'sha256': hashlib.sha256(output.read_bytes()).hexdigest(),
        'measuredLUFS': float(final_stats['input_i']), 'measuredTruePeakDb': float(final_stats['input_tp']),
    }
    assert output.stat().st_size < 3_000_000
    assert -19 < manifest['measuredLUFS'] < -17
    assert manifest['measuredTruePeakDb'] <= -2
    shutil.copyfile(output, ROOT / manifest['runtime'])
    docs = ROOT / 'docs/client-revisions/2026-10-30/audio'
    docs.mkdir(parents=True, exist_ok=True)
    (docs / 'safari-source.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
    print(json.dumps(manifest, indent=2))


if __name__ == '__main__':
    prepare(sys.argv[1])
