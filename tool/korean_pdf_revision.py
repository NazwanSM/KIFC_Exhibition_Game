"""Inventory the owner's 26-page Korean PDF before applying its approved copy."""
from pathlib import Path
import json, re, hashlib, argparse

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'design/quick-specs/korean-full-pdf-2026-11-05.json'
TRACKER = ROOT / 'design/quick-specs/korean-full-pdf-tracker-2026-11-05.md'
PDF = ROOT / 'docs/client-revisions/2026-11-05/korean-full-pdf/source.pdf'
source = ROOT / 'lib/core/localization/app_locale.dart'
specs = [
 ('welcome',[1],['안녕하세요!','산불의 원인을 알아보고','숲을 지키는 방법을','함께 배워봐요.'],'안녕하세요!'),
 ('assembly-partial',[2],['잘 맞혔어요.','나머지 요소도 찾아보세요.'],'잘 맞혔어요.'),
 ('assembly-complete',[3],['맞아요! 충분한 열과 연료, 산소가 만나면 불이 붙을 수 있어요.','이 세 가지를 불의 3 요소라고 해요. 그 중 하나를 줄이면','불을 통제하는 데 도움이 돼요.'],'맞아요! 충분한 열과'),
 ('triangle-explanation',[4],['충분한 열, 연료, 산소가 만나면 불이 날 수 있어요.','사람의 활동으로 이 세 가지 요소가 한 곳에 모일 수 있어요.','그래서 불이 나지 않도록 미리 예방하는 것이 중요해요.'],'충분한 열, 연료, 산소가 만나면 불이 날 수 있어요. 사람의 활동으로'),
 ('reading-1-subtitle',[5],['불이 어떻게 시작되는지 살펴봤어요.','불길이 번지면 어떤 일이 생길까요?'],'불이 어떻게 시작되는지 살펴봤어요.'),
 ('reading-2-subtitle',[6],['산불의 세 가지 요소가 만나면 불이 발생할 수 있어요.'],'불의 세 요소가 만나면 산불이 발생'),
 ('reading-2-body',[6],['산불은 불이 붙기 위한 세 가지 요소인',"'열, 연료, 산소'가 서로 만날 때 발생해요.",'사람들의 행동이 이 요소들을 결합하게 만들어','산불 위험을 높이곤 합니다.'],'산불은 충분한 열,'),
 ('reading-3-body',[7],['산불은 환경을 파괴하고 생태적,','경제적, 사회문화적, 정치적 피해를','일으켜요. 이러한 피해는 숲이','제 기능을 제대로 수행하지 못 하게 해요.'],'산불은 환경을 파괴하고'),
 ('risk-correct',[9],['맞아요! 메마른 이탄습지 숲의','화재는 불씨가 지표면 아래에서','타들어 갈 수 있어 진압하기','어려워요. 땅속의 불씨는','발견하기 어렵고, 지표면의 불이','꺼진 뒤에도 다시 불길을','일으킬 수 있어요.'],'맞아요! 메마른 이탄습지'),
 ('risk-hint',[10],['아직 아니에요. 유기물 토양층이','두껍게 쌓인 숲 유형을 떠올려보세요.','불길이 그 층 안에서 타 들어가','진압하기 어려워져요.'],'아직 아니에요. 유기물 토양층이'),
 ('cause-title',[11],['무엇이 산불 위험을 일으켰을까요?'],'무엇이 산불 위험을'),
 ('cause-1-situation',[11],['건조한 날씨에 땅을 개간하려고','풀과 나무를 태워요.'],'건조한 날씨에 땅을 개간하려고'),
 ('cause-1-correct',[12],['땅을 개간하려고 식물을 태우면','주변으로 불이 번질 수 있어요.'],'땅을 개간하려고 식물을'),
 ('cause-2-correct',[14],['담배꽁초의 불씨가 주변의','마른 풀에 옮겨 붙을 수 있어요.'],'담배꽁초의 불씨가 주변의'),
 ('cause-3-correct',[17],['번개는 마른 식물에 불을 붙일 수','있는 자연 발화 원인이에요.'],'번개는 마른 식물에'),
 ('cause-4-situation',[18],['작은 불을 마른 땅 근처에 피워두고','자리를 비웠어요.'],'작은 불을 마른 땅 근처에'),
 ('cause-4-reason',[18,19],['불을 지켜보지 않고 두면 주변의','마른 연료로 번질 수 있어요.'],'불을 지켜보지 않고 두면 주변의'),
 ('cause-4-summary',[18,19],['산불은 사람의 행동이나','자연 현상으로 시작될 수 있어요.','불이 나기 전에 예방하는 것이','가장 좋아요.'],'산불은 사람의 행동이나 자연 현상으로'),
 ('peat-complete',[20],['이탄지 화재에는 이 세 가지','특징이 있어요.','이제 그 영향도 알아볼까요?'],'이탄지 화재에는 이 세 가지 특징이 있어요.'),
 ('safety',[21],['실제 화재에 가까이 가지 마세요. 신고하고 담당자의 안내를 따르세요.'],'실제 화재에 가까이 가지 마세요.'),
 ('closing',[22],['함께 해줘서 고마워요!','불씨를 마른 식물에서 멀리 하세요.','불을 발견하면 담당자에게 알려 주세요.'],'함께해 줘서 고마워요!'),
 ('final-F01',[23],['선택한 영향이 없어요. 네 가지 영향은','연무, 생태계 훼손, 많은 탄소 배출,','지반 침하예요.'],'선택한 영향이 없어요.'),
 ('final-F02',[23],['네 가지 영향을 모두 찾았어요.','화재는 생태계를 훼손하고 이탄에','저장된 탄소를 방출해요.'],'네 가지 영향을 모두 찾았어요.'),
 ('final-F03',[23,24],['화재는 대기 질을 악화시키고','이탄의 탄소 저장량을 줄여요.','두 가지 증가나 개선은 화재의 영향이','아니에요.'],'화재는 대기 질을 악화시키고'),
 ('final-F04',[24],['연기는 대기 질을 악화시켜요. 더 깨끗한 공기는','화재의 영향이 아니에요.','놓친 영향도 확인해 보세요.'],'연기는 대기 질을 악화시켜요.'),
 ('final-F05',[24],['화재로 저장된 탄소가 방출되면','이탄의 탄소 저장량이 줄어들어요.','놓친 영향도 확인해 보세요.'],'화재로 저장된 탄소가 방출되면'),
 ('final-F06',[25],['이탄 화재의 연기는 연무를','만들고 대기 질을 악화시켜요.','이 영향을 놓쳤어요.'],'이탄 화재의 연기는 연무를'),
 ('final-F07',[25],['화재는 이탄지 생태계의 식물과','서식지를 훼손해요.','이 영향을 놓쳤어요.'],'화재는 이탄지 생태계의 식물과'),
 ('final-F08',[25,26],['이탄이 타면 저장된 탄소가','대기로 방출돼요.','이 영향을 놓쳤어요.'],'이탄이 타면 저장된 탄소가'),
 ('final-F09',[26],['이탄층이 사라지면 지표면이','낮아질 수 있어요.','이것을 지반 침하라고 해요.'],'이탄층이 사라지면 지표면이'),
]

def unescape(s): return s.replace('\\n','\n').replace("\\'", "'").replace('\\\\','\\')
def quote(s): return "'"+s.replace('\\','\\\\').replace("'","\\'").replace('\n','\\n')+"'"
pattern = re.compile(r"'((?:\\.|[^'\\])*)':\s*'((?:\\.|[^'\\])*)'")

if __name__ == '__main__':
 parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
 if not args.apply:
  if OUT.exists():
   parser.error('Initial inventory already exists; preserved as the pre-implementation record. Use --apply to reapply it.')
  current=source.read_text(encoding='utf8').split('const Map<String, String> _korean =')[1]
  entries=[(unescape(m[1]),unescape(m[2])) for m in pattern.finditer(current)]
  items=[]
  for name,pages,lines,prefix in specs:
   keys=[k for k,v in entries if v.startswith(prefix)]
   assert keys,(name,prefix)
   items.append({'id':name,'pages':pages,'lines':lines,'keys':keys,'text':'\n'.join(lines)})
  data={'source':'revisi game korean version.pdf','sha256':hashlib.sha256(PDF.read_bytes()).hexdigest(),'pageCount':26,'items':items,
   'composed':[{'id':'cause-1-wrong','pages':[13],'lines':['사람의 행동으로 시작된 불이에요.']+items[12]['lines']},
    {'id':'cause-2-wrong','pages':[15],'lines':['사람의 행동으로 시작된 불이에요.']+items[13]['lines']},
    {'id':'cause-4-correct','pages':[19],'lines':items[16]['lines']+items[17]['lines']},
    {'id':'cause-4-wrong','pages':[18],'lines':['사람의 행동으로 시작된 불이에요.']+items[16]['lines']+items[17]['lines']}],
   'referenceOnlyPages':[8,16],'pendingAudio':'Owner: record now, regenerate Korean voices later; existing MP3 files retained.'}
  OUT.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
  rows=['# Tracker revisi Korea lengkap dari PDF — 5 November 2026','','Sumber: `revisi game korean version.pdf`, 26 halaman. SHA-256: `'+data['sha256']+'`.','','Status awal dicatat sebelum implementasi: **34 item teks/layout belum diterapkan; 2 halaman acuan visual sudah diperiksa; regenerasi audio Korea belum dikerjakan.**','','Kolom revisi bertulisan Korea menjadi acuan. Keterangan Indonesia dalam tanda kurung tidak dimasukkan ke game. Susunan baris dikunci mengikuti baris Korea pada PDF; judul Babak 3 satu baris. PDF hlm. 6 memberi revisi pada subjudul yang berada di atas bubble bacaan kedua sesuai screenshot.','','| ID | Halaman PDF | Status |','| --- | --- | --- |']
  for x in data['items']+data['composed']:rows.append(f"| {x['id']} | {', '.join(map(str,x['pages']))} | Belum diterapkan |")
  rows+=['| reference-8 | 8 | Diperiksa; tidak ada teks pengganti |','| reference-16 | 16 | Diperiksa; tidak ada teks pengganti |','| audio-ko-regenerate | 1, 6–7, 22 | Belum dikerjakan — pemilik meminta dicatat; regenerasi nanti |','','## Catatan audio','','PDF mengubah naskah Korea, terutama bacaan kedua dan ketiga serta salam pembuka/penutup. MP3 yang tersedia masih naskah lama. Rekaman dan alignment baru perlu dibuat kemudian sesuai instruksi pemilik. Validasi teks/layout tidak menandakan narasi baru sudah selesai.','']
  TRACKER.write_text('\n'.join(rows),encoding='utf8')
  print(f'Inventoried {len(items)} direct and {len(data["composed"])} composed copy revisions before implementation.')
 else:
  data=json.loads(OUT.read_text(encoding='utf8')); replacements={k:x['text'] for x in data['items'] for k in x['keys']}
  text=source.read_text(encoding='utf8'); head,body=text.split('const Map<String, String> _korean =',1)
  body=pattern.sub(lambda m:quote(unescape(m[1]))+':\n      '+quote(replacements[unescape(m[1])]) if unescape(m[1]) in replacements else m[0],body)
  source.write_text(head+'const Map<String, String> _korean ='+body,encoding='utf8')
  blocks=[x['text'] for x in data['items']]+['\n'.join(x['lines']) for x in data['composed']]
  generated="// Approved display lines from the owner's Korean PDF, 5 November 2026.\nconst koreanPdfBlocks = <String>{\n"+''.join('  '+quote(x)+',\n' for x in blocks)+'};\n'
  (ROOT/'lib/core/localization/korean_pdf_copy.dart').write_text(generated,encoding='utf8')
  timing_path=ROOT/'assets/audio/narration/reading_timing.json'
  timings=json.loads(timing_path.read_text(encoding='utf8'))
  approved={x['id']:x for x in data['items']}
  for item in timings['items']:
   entry={'karhutla-cause':'reading-2-body','karhutla-prevention':'reading-3-body'}.get(item['key'])
   if item['locale']!='ko' or not entry: continue
   item.setdefault('audio_script_text',item['text'])
   item['text']=approved[entry]['text']
   item['pending_audio_regeneration']=True
   item['display_revision']='Korean PDF 2026-11-05; provisional display cues, old audio retained by owner instruction'
   words=list(re.finditer(r'\S+',item['text']));total=sum(len(w[0]) for w in words);prior=0
   item['cues']=[]
   for word in words:
    item['cues'].append({'end':word.end(),'time':round(prior/total*item['duration']*.95,4),'estimated_split':True})
    prior+=len(word[0])
  timing_path.write_text(json.dumps(timings,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
  voices=[{'key':key,'locale':'ko','script':approved[entry]['text'].replace('\n',' '),'status':'pending_regeneration'}
    for key,entry in [('welcome','welcome'),('karhutla-cause','reading-2-body'),('karhutla-prevention','reading-3-body'),('closing','closing')]]
  (ROOT/'docs/client-revisions/2026-11-05/korean-full-pdf/pending-voice-scripts.json').write_text(json.dumps(voices,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
  print(f'Applied approved copy to {len(replacements)} localization keys.')
