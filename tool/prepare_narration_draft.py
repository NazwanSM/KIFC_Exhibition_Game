"""Prepare a non-production narration draft. Requires ffmpeg and faster-whisper.

Run from repo root with KIFC_ASR_MODEL set to a local multilingual model.
Outputs are written under build/review-r30-13, never overwriting input audio.
"""
from pathlib import Path
import json,subprocess,hashlib,re,os,sys
from faster_whisper import WhisperModel
root=Path('.');source=root/'assets/audio/narration/incoming';out=root/'build/review-r30-13';out.mkdir(parents=True,exist_ok=True)
scripts=json.loads((root/'docs/client-revisions/2026-10-30/narration/scripts.json').read_text(encoding='utf-8'))['scripts']
model=os.environ.get('KIFC_ASR_MODEL')
if not model: raise SystemExit('Set KIFC_ASR_MODEL to a local faster-whisper model directory.')
asr=WhisperModel(model,device='cpu',compute_type='int8',cpu_threads=4,local_files_only=True)
ff='ffmpeg';probe='ffprobe'
items=[]
for key in ('welcome','karhutla-definition','karhutla-cause','karhutla-prevention','closing'):
 for lang in ('id','en','ko'):
  inp=source/f'{key}-{lang}.mp3';dst=out/'audio'/lang/f'{key}.mp3';dst.parent.mkdir(parents=True,exist_ok=True)
  cmd=[ff,'-hide_banner','-i',str(inp),'-af','loudnorm=I=-18:TP=-1.5:LRA=11:print_format=json','-f','null',os.devnull]
  p=subprocess.run(cmd,capture_output=True,text=True,check=True);matches=re.findall(r'\{\s*"input_i".*?\}',p.stderr,re.S);assert matches,inp
  measure=json.loads(matches[-1]); filt='loudnorm=I=-18:TP=-1.5:LRA=11:linear=true:measured_I={input_i}:measured_TP={input_tp}:measured_LRA={input_lra}:measured_thresh={input_thresh}:offset={target_offset}'.format(**measure)
  subprocess.run([ff,'-y','-v','error','-i',str(inp),'-af',filt,'-ar','44100','-c:a','libmp3lame','-b:a','192k',str(dst)],check=True)
  subprocess.run([ff,'-v','error','-i',str(dst),'-f','null','-'],check=True)
  info=json.loads(subprocess.check_output([probe,'-v','error','-show_entries','format=duration','-of','json',str(dst)]));duration=float(info['format']['duration'])
  segments,_=asr.transcribe(str(dst),language=lang,beam_size=5,condition_on_previous_text=False,vad_filter=False,word_timestamps=True)
  words=[]
  for seg in segments:
   for w in seg.words or []:words.append({'text':w.word.strip(),'start':round(float(w.start),3),'end':round(float(w.end),3),'probability':round(float(w.probability),3)})
  assert words and all(0<=w['start']<=w['end']<=duration+0.05 for w in words)
  items.append({'key':key,'locale':lang,'script':scripts[key][lang],'source_file':str(inp).replace('\\','/'),'source_sha256':hashlib.sha256(inp.read_bytes()).hexdigest(),'output_file':str(dst).replace('\\','/'),'output_sha256':hashlib.sha256(dst.read_bytes()).hexdigest(),'duration_seconds':round(duration,3),'voice':'mw_animated_The Plucky Hero','provider':'ElevenLabs','model':'not supplied by owner','settings':'not supplied by owner','source_loudness':measure,'timing_source':'faster-whisper-base word timestamps, automatic unreviewed','words':words})
  print(key,lang,'secs',round(duration,2),'words',len(words),flush=True)
(out/'draft-raw-timings.json').write_text(json.dumps({'status':'automatic_unreviewed','items':items},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Completed',len(items),'audio files and timestamp extraction.',flush=True)
