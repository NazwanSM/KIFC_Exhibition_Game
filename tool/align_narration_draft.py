"""Align ASR timestamps to the script for review; do not use as final timings."""
import json,re,unicodedata,difflib
from pathlib import Path
f=Path('build/review-r30-13/draft-raw-timings.json');data=json.loads(f.read_text(encoding='utf-8'))
def norm(s):return ''.join(c for c in unicodedata.normalize('NFKC',s).casefold() if c.isalnum())
def align(script,words):
 matches=list(re.finditer(r'\S+',script));exp=[m.group() for m in matches];obs=[w['text'] for w in words];n=len(exp);m=len(obs);dp={(0,0):(0,None)}
 for i in range(n+1):
  for j in range(m+1):
   if (i,j) not in dp:continue
   base=dp[i,j][0]
   def put(ni,nj,c,op):
    if (ni,nj) not in dp or c<dp[ni,nj][0]:dp[ni,nj]=(c,(i,j,op))
   if i<n:put(i+1,j,base+.9,('missing',1,0,0))
   if j<m:put(i,j+1,base+.9,('extra',0,1,0))
   for a in range(1,min(3,n-i)+1):
    for b in range(1,min(3,m-j)+1):
     aa=norm(''.join(exp[i:i+a]));bb=norm(''.join(obs[j:j+b]));sim=difflib.SequenceMatcher(None,aa,bb).ratio() if aa and bb else 0
     put(i+a,j+b,base+2*(1-sim)+.15*(a+b-2),('match',a,b,sim))
 ops=[];pos=(n,m)
 while pos!=(0,0):
  prev=dp[pos][1];ops.append((prev[0],prev[1],prev[2]));pos=(prev[0],prev[1])
 ops.reverse();spans=[];extras=[]
 for i,j,(typ,a,b,sim) in ops:
  if typ=='extra':extras.append(obs[j]);continue
  start,end=matches[i].start(),matches[i+a-1].end()
  x={'text':script[start:end],'char_start':start,'char_end':end,'kind':'word' if a==1 else 'phrase','asr_text':' '.join(obs[j:j+b]),'similarity':round(sim,3)}
  if typ=='missing':x.update({'start':None,'end':None,'review_reason':'ASR tidak menemukan kata'})
  else:
   sub=words[j:j+b];x.update({'start':sub[0]['start'],'end':sub[-1]['end']})
   reasons=[]
   if sim<.8:reasons.append('teks ASR berbeda')
   if a>1:reasons.append('frasa multi-kata belum dipisah')
   if x['end']<=x['start']:reasons.append('durasi nol')
   if min(w['probability'] for w in sub)<.45:reasons.append('kepercayaan ASR rendah')
   if reasons:x['review_reason']=', '.join(reasons)
  spans.append(x)
 return spans,extras
for x in data['items']:
 spans,extra=align(x['script'],x['words']);x['spans']=spans;x['asr_extra']=extra
 x['review_count']=sum('review_reason' in z for z in spans)
 print(x['key'],x['locale'],'tokens',len(spans),'review',x['review_count'],'extras',len(extra),flush=True)
(Path('build/review-r30-13')/'aligned-draft.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
