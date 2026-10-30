"""Reproduce the selected wildfire loop from the licensed source MP4.

Usage: python tool/prepare_wildfire_video.py SOURCE_MP4
Requires FFmpeg/FFprobe; no downloads or generated imagery.
"""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def prepare(source):
    source = Path(source).resolve()
    manifest = json.loads((ROOT / 'docs/client-revisions/2026-10-30/video/source.json').read_text(encoding='utf-8'))
    if hashlib.sha256(source.read_bytes()).hexdigest() != manifest['sourceSha256']:
        raise ValueError('Source does not match the licensed wildfire selection')
    work = ROOT / 'build/review-r30-10-wildfire-2026-10-30'
    work.mkdir(parents=True, exist_ok=True)
    cropped = work / 'cropped.mp4'
    output = ROOT / 'assets/animations/forest-burn-loop.mp4'
    subprocess.run(['ffmpeg', '-y', '-v', 'error', '-ss', '1', '-t', '12', '-i', str(source),
        '-vf', 'crop=1088:612:416:468,scale=960:540,fps=24', '-an', '-c:v', 'libx264',
        '-crf', '21', '-preset', 'fast', '-pix_fmt', 'yuv420p', str(cropped)], check=True)
    graph = ('[0:v]fps=24,split=3[h][m][t];'
        '[h]trim=0:1,setpts=PTS-STARTPTS,fps=24,settb=1/24[head];'
        '[m]trim=1:11,setpts=PTS-STARTPTS[mid];'
        '[t]trim=11:12,setpts=PTS-STARTPTS,fps=24,settb=1/24[tail];'
        '[tail][head]xfade=duration=1:offset=0[seam];'
        '[mid][seam]concat=n=2:v=1:a=0[out]')
    subprocess.run(['ffmpeg', '-y', '-v', 'error', '-i', str(cropped), '-filter_complex', graph,
        '-map', '[out]', '-an', '-c:v', 'libx264', '-profile:v', 'main', '-level', '3.1',
        '-crf', '23', '-preset', 'fast', '-r', '24', '-pix_fmt', 'yuv420p',
        '-movflags', '+faststart', str(output)], check=True)
    subprocess.run(['ffmpeg', '-y', '-v', 'error', '-i', str(output), '-frames:v', '1',
        '-q:v', '2', str(ROOT / manifest['poster'])], check=True)
    subprocess.run(['ffmpeg', '-v', 'error', '-i', str(output), '-f', 'null', '-'], check=True)
    if hashlib.sha256(output.read_bytes()).hexdigest() != manifest['runtimeSha256']:
        raise ValueError('Output differs from reviewed encoding; review FFmpeg version/settings')
    print('Wildfire loop reproduced, hash matched, complete decode passed.')


if __name__ == '__main__':
    prepare(sys.argv[1])
