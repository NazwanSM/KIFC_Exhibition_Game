"""Build the verified APK handoff ZIP and its Indonesian PDF manuals.

No device operations or Flutter rebuilds. Requires reportlab, PyMuPDF, Pillow.
python tool/build_client_delivery.py
"""
from __future__ import annotations

import hashlib
import json
import shutil
import zipfile
from html import escape
from pathlib import Path

import fitz
from PIL import Image as PILImage
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    BaseDocTemplate, Flowable, Frame, Image, KeepTogether, PageBreak,
    PageTemplate, Paragraph, Spacer, Table, TableStyle,
)

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'docs/client-delivery/2026-10-28'
WORK = ROOT / 'build/client-delivery-2026-10-28'
PDF_OUT = WORK / 'output/pdf'
PACKAGE_NAME = 'KIFC-Game-1.0.5-2026-10-28'
PACKAGE = WORK / PACKAGE_NAME
APK_SOURCE = ROOT / 'build/review-speech-bubble-audit-2026-10-27/KIFC-Review-1.0.5.apk'
APK_NAME = 'KIFC-Fire-Prevention-Challenge-1.0.5.apk'
APK_HASH = '3fb03003f97fb384beec891a51da7b1985e51dbf5100885af3a61e7cb13ee95b'
SHA = '86a00c941ce7739a861b2a172c58b1269ade4fe1'
BASE_CAPTURE = ROOT / 'build/review-speech-bubble-audit-2026-10-27/screenshots'
IMAGES = {
    'welcome': SOURCE / 'screenshots/welcome.png',
    'assembly': SOURCE / 'screenshots/assembly.png',
    'reduction': SOURCE / 'screenshots/reduction.png',
    'cause': SOURCE / 'screenshots/cause.png',
    'peat': SOURCE / 'screenshots/peat.png',
    'impact': SOURCE / 'screenshots/impact.png',
    'score': SOURCE / 'screenshots/score.png',
}
CAPTURE_SOURCES = {
    'welcome': ROOT / 'docs/client-revisions/2026-10-27/welcome-bubble/indonesian.png',
    'assembly': BASE_CAPTURE / 'initial-id-411x731.png',
    'reduction': BASE_CAPTURE / 'demo-id-1080x1920.png',
    'cause': BASE_CAPTURE / 'cause-correct-id-411x731.png',
    'peat': BASE_CAPTURE / 'peat-cards-front-id-411x731.png',
    'impact': BASE_CAPTURE / 'impact-play-id-411x731.png',
    'score': BASE_CAPTURE / 'impact-score-id-411x731.png',
}
GREEN = colors.HexColor('#144232')
INK = colors.HexColor('#17251f')
MUTED = colors.HexColor('#596b62')
LIGHT = colors.HexColor('#f1f5f1')
RULE = colors.HexColor('#d8e1d9')
WIDTH = A4[0] - 84


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def prepare_images():
    """Copy actual QA renders proportionally; never alter UI composition."""
    index_path = SOURCE / 'screenshots/index.json'
    if all(p.exists() for p in IMAGES.values()) and index_path.exists():
        old = json.loads(index_path.read_text(encoding='utf-8'))
        for item in old['images']:
            assert digest(SOURCE / 'screenshots' / item['file']) == item['sha256']
        return
    records = []
    for key, path in CAPTURE_SOURCES.items():
        with PILImage.open(path) as im:
            native = list(im.size)
            im = im.convert('RGB')
            im.thumbnail((540, 960), PILImage.Resampling.LANCZOS)
            IMAGES[key].parent.mkdir(parents=True, exist_ok=True)
            im.save(IMAGES[key], optimize=True)
            size = list(im.size)
        records.append({'file': IMAGES[key].name, 'source':path.relative_to(ROOT).as_posix(),
                        'sourceSha256':digest(path), 'sourcePixels':native,
                        'exportPixels':size, 'sha256':digest(IMAGES[key]),
                        'sourceType':'Flutter widget render', 'language':'id',
                        'capturedOn':'2026-10-27',
                        'processing':'Proportional downscale only, no crop or UI edits'})
    index_path.write_text(json.dumps({'physicalTvPhotographs':False,'images':records},indent=2),encoding='utf-8')


def styles():
    for name, file in [('Body','Archivo-Regular.ttf'), ('Bold','Archivo-Bold.ttf')]:
        pdfmetrics.registerFont(TTFont(name, str(ROOT / 'assets/fonts' / file)))
    pdfmetrics.registerFontFamily('Body',normal='Body',bold='Bold',italic='Body',boldItalic='Bold')
    def s(name, size, leading, **kwargs):
        return ParagraphStyle(name,fontName='Body',fontSize=size,leading=leading,
                              textColor=INK,alignment=TA_LEFT,spaceAfter=7,**kwargs)
    return {
        'title':ParagraphStyle('title',fontName='Bold',fontSize=23,leading=27,textColor=INK,spaceAfter=8),
        'subtitle':ParagraphStyle('subtitle',fontName='Body',fontSize=10,leading=14,textColor=MUTED,spaceAfter=16),
        'body':s('body',10,14.1),
        'lead':s('lead',11.1,15.6,spaceBefore=1),
        'h2':ParagraphStyle('h2',fontName='Bold',fontSize=12,leading=16,textColor=GREEN,spaceBefore=8,spaceAfter=6,keepWithNext=True),
        'small':ParagraphStyle('small',fontName='Body',fontSize=8.5,leading=11.5,textColor=MUTED,spaceAfter=8),
        'cell':s('cell',9.3,12.7),
        'caption':ParagraphStyle('caption',fontName='Body',fontSize=8.5,leading=11.5,textColor=MUTED,alignment=1,spaceBefore=5),
        'code':ParagraphStyle('code',fontName='Courier',fontSize=8,leading=12,textColor=INK,spaceAfter=0),
    }


class Check(Flowable):
    def __init__(self):
        super().__init__()
        self.width=11
        self.height=12
    def draw(self):
        self.canv.setStrokeColor(GREEN)
        self.canv.setLineWidth(.8)
        self.canv.roundRect(0,1,8,8,1,stroke=1,fill=0)


class Manual(BaseDocTemplate):
    def __init__(self,path,label,expected_pages):
        super().__init__(str(path),pagesize=A4,rightMargin=42,leftMargin=42,
                         topMargin=50,bottomMargin=40,title=label,
                         author='KIFC Game Exhibition',pageCompression=1)
        self.label=label
        self.expected_pages=expected_pages
        self.addPageTemplates(PageTemplate(id='manual',frames=Frame(42,40,WIDTH,A4[1]-90,leftPadding=0,rightPadding=0,topPadding=0,bottomPadding=0),onPage=self.decorate))
    def decorate(self,c,doc):
        c.saveState()
        c.setFillColor(GREEN)
        c.setFont('Bold',8)
        c.drawString(42,A4[1]-28,'KIFC  /  FIRE PREVENTION CHALLENGE')
        c.setFont('Body',8)
        c.setFillColor(MUTED)
        c.drawRightString(A4[0]-42,A4[1]-28,'28 Oktober 2026')
        c.setStrokeColor(RULE)
        c.line(42,31,A4[0]-42,31)
        c.setFont('Body',7.5)
        c.drawString(42,20,'APK 1.0.5  |  '+self.label)
        c.drawRightString(A4[0]-42,20,f'{doc.page} / {self.expected_pages}')
        c.restoreState()


def build_manual(pages,path,label):
    st=styles()
    def p(text,kind='body'):
        return Paragraph(escape(text),st[kind])
    def grid(rows,col_widths,bg=None):
        t=Table(rows,colWidths=col_widths,hAlign='LEFT')
        cmds=[('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),0),('RIGHTPADDING',(0,0),(-1,-1),10),('TOPPADDING',(0,0),(-1,-1),0),('BOTTOMPADDING',(0,0),(-1,-1),6)]
        if bg: cmds.append(('BACKGROUND',(0,0),(-1,-1),bg))
        t.setStyle(TableStyle(cmds))
        return t
    def photo(key,max_w,max_h):
        with PILImage.open(IMAGES[key]) as im: w,h=im.size
        scale=min(max_w/w,max_h/h)
        return Image(str(IMAGES[key]),w*scale,h*scale)
    story=[]
    for page_index,page in enumerate(pages):
        if page_index: story.append(PageBreak())
        story.extend([p(page['title'],'title'),p(page['subtitle'],'subtitle')])
        for block in page['blocks']:
            kind=block['type']
            if kind in ['lead','paragraph','h2','small']:
                story.append(p(block['text'],'body' if kind=='paragraph' else kind))
            elif kind=='callout':
                table=Table([[p(block['text'],'cell')]],colWidths=[WIDTH])
                table.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),LIGHT),('BOX',(0,0),(-1,-1),.5,RULE),('LEFTPADDING',(0,0),(-1,-1),12),('RIGHTPADDING',(0,0),(-1,-1),12),('TOPPADDING',(0,0),(-1,-1),10),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
                story.extend([table,Spacer(1,9)])
            elif kind in ['steps','bullets','checks']:
                for i,item in enumerate(block['items']):
                    marker=Check() if kind=='checks' else p(str(i+1)+'.' if kind=='steps' else '-', 'body')
                    story.append(grid([[marker,p(item)]],[21,WIDTH-21]))
            elif kind=='welcome':
                right=[]
                for i,item in enumerate(block['items']):
                    right.append(p(f'{i+1}. '+item))
                story.append(grid([[photo(block['image'],168,300),right]],[184,WIDTH-184]))
                story.append(Spacer(1,7))
            elif kind=='images':
                cell_width=WIDTH/len(block['images'])
                cells=[]
                for im in block['images']:
                    cells.append([photo(im['image'],cell_width-20,block['height']),p(im['caption'],'caption')])
                story.extend([grid([cells],[cell_width]*len(cells)),Spacer(1,8)])
            elif kind=='table':
                rows=[[Paragraph(escape(x),ParagraphStyle('th',parent=st['cell'],fontName='Bold',textColor=colors.white)) for x in block['headers']]]
                rows += [[p(x,'cell') for x in row] for row in block['rows']]
                t=Table(rows,colWidths=block['widths'],repeatRows=1,hAlign='LEFT')
                t.setStyle(TableStyle([('VALIGN',(0,0),(-1,-1),'TOP'),('BACKGROUND',(0,0),(-1,0),GREEN),('ROWBACKGROUNDS',(0,1),(-1,-1),[LIGHT,colors.white]),('LINEBELOW',(0,0),(-1,-1),.35,RULE),('LEFTPADDING',(0,0),(-1,-1),9),('RIGHTPADDING',(0,0),(-1,-1),9),('TOPPADDING',(0,0),(-1,-1),8),('BOTTOMPADDING',(0,0),(-1,-1),5)]))
                story.extend([t,Spacer(1,10)])
            elif kind=='issues':
                for title,body in block['items']:
                    story.append(KeepTogether([p(title,'h2'),p(body)]))
            elif kind=='code':
                text=escape(block['text']).replace('\n','<br/>')
                # Break only at safe command whitespace; source text stays exact in PDF extraction.
                t=Table([[Paragraph(text,st['code'])]],colWidths=[WIDTH])
                t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),LIGHT),('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),('TOPPADDING',(0,0),(-1,-1),9),('BOTTOMPADDING',(0,0),(-1,-1),9)]))
                story.extend([t,Spacer(1,8)])
            elif kind=='references':
                for n,title,url in block['items']:
                    story.append(Paragraph(f'[{n}] <link href="{escape(url,quote=True)}" color="#144232">{escape(title)}</link>',st['small']))
            else: raise ValueError(kind)
    Manual(path,label,len(pages)).build(story)
    with fitz.open(path) as pdf:
        if len(pdf)!=len(pages):
            raise AssertionError(f'{path.name}: expected {len(pages)} pages, got {len(pdf)}; fix overflow')
        for i,page in enumerate(pdf):
            assert pages[i]['title'] in page.get_text().replace('\n',' '),f'Wrong page content {i+1}'
        render=WORK/'qa'/path.stem
        render.mkdir(parents=True,exist_ok=True)
        for i,page in enumerate(pdf):
            page.get_pixmap(matrix=fitz.Matrix(1.6,1.6),alpha=False).save(render/f'page-{i+1:02}.png')


def main():
    assert APK_SOURCE.exists(), APK_SOURCE
    assert digest(APK_SOURCE)==APK_HASH,'Unexpected APK; do not package'
    report=json.loads((WORK/'apk-verification.json').read_text(encoding='utf-8'))
    assert report['passed'] and report['sha256']==APK_HASH and report['offlineAssetsChecked']==53
    prepare_images()
    content=json.loads((SOURCE/'delivery-content.json').read_text(encoding='utf-8'))
    PDF_OUT.mkdir(parents=True,exist_ok=True)
    filenames=['01_Panduan_Bermain.pdf','02_Instalasi_TV_dan_Penanganan_Error.pdf']
    for key,filename,label in [('playing',filenames[0],'Panduan bermain'),('installation',filenames[1],'Instalasi dan penanganan error TV')]:
        build_manual(content[key],PDF_OUT/filename,label)
    for folder in ['01_APK','02_Panduan','03_Info_Paket']:
        (PACKAGE/folder).mkdir(parents=True,exist_ok=True)
    shutil.copy2(APK_SOURCE,PACKAGE/'01_APK'/APK_NAME)
    for filename in filenames:
        shutil.copy2(PDF_OUT/filename,PACKAGE/'02_Panduan'/filename)
    intro='''KIFC FIRE PREVENTION CHALLENGE
Paket game dan panduan - 28 Oktober 2026

MULAI DI SINI
1. Baca 02_Panduan/02_Instalasi_TV_dan_Penanganan_Error.pdf.
2. Ekstrak paket lalu pasang APK di 01_APK pada panel atau player Android.
3. Uji orientasi portrait, sentuhan, suara, dan satu putaran penuh pada TV tujuan.
4. Gunakan 02_Panduan/01_Panduan_Bermain.pdf untuk pendamping dan pengunjung.

APK: 1.0.5 (kode 20261029), minimum Android 7.0 / API 24.
Game menggunakan input sentuh dan seret. Remote arah saja belum mencukupi.
TV non-Android perlu player Android yang cocok; HDMI saja tidak membawa touch.
Setelah APK terpasang, game dan seluruh asetnya dapat berjalan tanpa internet.

Ini APK review dengan signing Android Debug, bukan signing produksi pemilik.
Versi 1.0.5 belum diuji pada TV fisik tujuan. Ikuti daftar uji penerimaan pada PDF.
Ikon mungkin tidak muncul di beranda Android TV; cara membukanya ada di panduan.
Game tidak memiliki autostart saat listrik menyala atau penguncian kiosk bawaan.

INFO VERSI
Lihat 03_Info_Paket/INFO_VERSI.txt untuk identitas dan hash APK.
SHA256SUMS.txt memuat checksum semua berkas paket selain dirinya sendiri.
Pastikan paket berasal dari tim proyek; checksum bukan pengganti verifikasi asal.

CADANGAN WEB
https://nazwansm.github.io/KIFC_Exhibition_Game/?revision=86a00c9
Versi web membutuhkan internet serta browser yang kompatibel; bukan pengganti
jaminan dukungan perangkat TV, touch, atau operasi offline pada APK.
'''
    (PACKAGE/'00_MULAI_DI_SINI.txt').write_text(intro,encoding='utf-8')
    info=f'''KIFC FIRE PREVENTION CHALLENGE - IDENTITAS PAKET
Disiapkan: 28 Oktober 2026
Nama aplikasi: Fire Prevention Challenge
Package ID: id.kifc.fire_prevention_challenge
Versi APK: 1.0.5
Version code: 20261029 (nomor build, bukan tanggal paket)
Minimum Android: 7.0 / API 24
Target SDK: 36
ABI: armeabi-v7a, arm64-v8a, x86_64
Orientasi: portrait
Activity: id.kifc.fire_prevention_challenge/.MainActivity
Signing: Android Debug, skema v2 terverifikasi
Sertifikat SHA-256:
8be018ae3d90482b0352f6b220a68099aeec27d071203d166af7bcf16c1f56a6
APK bytes: {APK_SOURCE.stat().st_size}
APK SHA-256:
{APK_HASH}

Basis repository: {SHA}
Perubahan kode game terakhir: 5b3fb42 (bubble bersama lintas halaman)
APK dibangun 27 Oktober 2026, dikemas tanpa membangun ulang atau memodifikasi APK.

PEMERIKSAAN
- SHA-256 APK cocok dengan artifact 1.0.5.
- Tanda tangan APK diverifikasi dengan Android apksigner.
- Minimum SDK, versi, package ID, activity, serta ABI dibaca dari APK.
- 53 aset runtime cocok dengan checkout proyek dan tersedia offline.
- Pipeline GitHub commit 86a00c9: 325 tes lulus, analisis dan build web berhasil.
- Pemeriksaan dokumen: 4 halaman bermain dan 6 halaman instalasi dirender ke PNG.
- Tidak ada klaim uji native baru atau uji TV fisik untuk paket ini.

SUMBER GAMBAR PANDUAN
Render UI Flutter aktual, bahasa Indonesia, dari pemeriksaan 27 Oktober 2026.
Sumber 411 x 731 atau 1080 x 1920; penyesuaian ukuran proporsional saja.
Bukan foto hardware TV atau bukti jangkauan fisik pada panel 42 inci.

MATERI DAN LISENSI
Kredit foto, musik, dan efek tersedia melalui kontrol kredit dalam game.
Rincian sumber aset proyek: https://github.com/NazwanSM/KIFC_Exhibition_Game/blob/main/ASSET_SOURCES.md
'''
    (PACKAGE/'03_Info_Paket/INFO_VERSI.txt').write_text(info,encoding='utf-8')
    files=sorted(p for p in PACKAGE.rglob('*') if p.is_file() and p.name!='SHA256SUMS.txt')
    assert len(files)==5,[str(p) for p in files]
    lines=[digest(p)+'  '+p.relative_to(PACKAGE).as_posix() for p in files]
    (PACKAGE/'SHA256SUMS.txt').write_text('\n'.join(lines)+'\n',encoding='ascii')
    zip_path=WORK/(PACKAGE_NAME+'.zip')
    with zipfile.ZipFile(zip_path,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=6) as archive:
        for path in sorted(p for p in PACKAGE.rglob('*') if p.is_file()):
            archive.write(path,path.relative_to(WORK).as_posix())
    with zipfile.ZipFile(zip_path) as archive:
        assert archive.testzip() is None
        assert len(archive.namelist())==6
        for path in files+[PACKAGE/'SHA256SUMS.txt']:
            assert hashlib.sha256(archive.read(path.relative_to(WORK).as_posix())).hexdigest()==digest(path)
    result={'zip':str(zip_path),'zipBytes':zip_path.stat().st_size,'zipSha256':digest(zip_path),
            'apkSha256':APK_HASH,'files':[p.relative_to(PACKAGE).as_posix() for p in files]+['SHA256SUMS.txt'],
            'pdfPages':{'playing':4,'installation':6},'crcAndHashesPassed':True}
    (WORK/'package-verification.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result,indent=2))


if __name__=='__main__':
    main()
