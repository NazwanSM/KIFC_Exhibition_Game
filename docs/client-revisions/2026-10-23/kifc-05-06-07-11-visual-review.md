# Bukti Tampilan KIFC-05, KIFC-06, KIFC-07 & KIFC-11

Tanggal: 23 Oktober 2026. Layar: Kartu Bacaan Babak 2 (Definisi, Penyebab, Pencegahan) dan Layar Hasil Akhir (Pesan Penutup). Status: **Ditinjau**. Acuan pekerjaan: [tracker KIFC revisi 23 Oktober](../../../design/quick-specs/kifc-screen-revision-tracker-2026-10-23.md).

## Perubahan yang Diperiksa

1. **KIFC-05 (Kartu 1 - Definisi Karhutla):**
   - Judul baru: *"Tapi, Apa Itu Kebakaran Hutan?"*
   - Narasi maskot baru: *"Kebakaran hutan adalah peristiwa terbakarnya vegetasi dan bahan organik di kawasan hutan, dengan api yang menyebar secara bebas dan tidak terkendali."*
   - Subjudul pengantar menghubungkan materi api dengan kebakaran hutan: *"Tadi kamu melihat api menyala. Bagaimana jika api itu menjalar?"*
   - Selaras dalam 3 bahasa (ID, EN, KO).

2. **KIFC-06 (Kartu 2 - Penyebab Karhutla):**
   - Fungsi kartu kedua diubah sepenuhnya dari pembahasan dampak menjadi pembahasan **penyebab**.
   - Judul baru: *"Mengapa Kebakaran Hutan Bisa Terjadi?"*
   - Subjudul baru: *"Kebakaran hutan dapat terjadi ketika tiga unsur api bertemu."*
   - Narasi maskot baru: *"Kebakaran hutan dapat terjadi ketika panas yang cukup, bahan bakar, dan oksigen bertemu dalam kondisi yang memungkinkan api menyala. Aktivitas manusia dapat mempertemukan ketiga unsur tersebut sehingga meningkatkan risiko kebakaran."*
   - Kunci identifikasi komponen diperbarui dari `karhutla-impact` menjadi `karhutla-cause`.

3. **KIFC-07 (Kartu 3 - Pentingnya Pencegahan Karhutla):**
   - Judul baru: *"Mengapa Kebakaran Hutan Perlu Kita Cegah?"*
   - Narasi maskot baru mencakup 4 pilar dampak secara eksplisit: kerugian **ekologis, ekonomi, sosial budaya, serta politik**, dan hubungannya dengan terganggunya fungsi hutan.
   - Subjudul penjelas: *"Sebagian besar karhutla bisa dicegah sebelum membesar."*

4. **KIFC-11 (Layar Skor Akhir - Pesan Penutup):**
   - Pesan penutup KIFC ditambahkan dalam banner khusus yang menonjol dengan ikon perisai pelindung: *"Mencegah Kebakaran Lebih Baik daripada Memadamkan."*
   - Posisi proporsional di bawah rincian skor, tanpa mengganggu perolehan nilai maupun tombol "Selesai" dan "Main Lagi".
   - Ruang vertikal diselaraskan sehingga tetap muat tanpa overflow pada layar terkecil (360x640) hingga layar 4K (2160x3840).

## Sumber dan Batas Bukti

Semua PNG di bawah adalah **hasil render UI Flutter yang sebenarnya melalui widget test**, menggunakan aset, ikon, dan font aplikasi asli (Archivo, ArchivoBlack, NotoSansKR, MaterialIcons), pada ukuran viewport portrait yang tertulis dengan device pixel ratio 1.

TV sasaran berukuran 42 inci portrait. Ukuran Full HD (1080x1920) dan 4K (2160x3840) merupakan dua simulasi viewport portrait 9:16 untuk peninjauan keterbacaan dan hierarki visual.

---

## Screenshot KIFC-05 (Kartu 1: Definisi)

| Viewport portrait | Bahasa Indonesia | English | 한국어 |
|---|---|---|---|
| 360x640 | [Lihat](../../../build/review-chapter2-score/kifc05-definition-id-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-en-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-ko-360x640.png) |
| 411x731 | [Lihat](../../../build/review-chapter2-score/kifc05-definition-id-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-en-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-ko-411x731.png) |
| 720x1280 | [Lihat](../../../build/review-chapter2-score/kifc05-definition-id-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-en-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-ko-720x1280.png) |
| 1080x1920 (Full HD TV) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-id-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-en-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-ko-1080x1920.png) |
| 2160x3840 (4K TV) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-id-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-en-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc05-definition-ko-2160x3840.png) |

---

## Screenshot KIFC-06 (Kartu 2: Penyebab)

| Viewport portrait | Bahasa Indonesia | English | 한국어 |
|---|---|---|---|
| 360x640 | [Lihat](../../../build/review-chapter2-score/kifc06-cause-id-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-en-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-ko-360x640.png) |
| 411x731 | [Lihat](../../../build/review-chapter2-score/kifc06-cause-id-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-en-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-ko-411x731.png) |
| 720x1280 | [Lihat](../../../build/review-chapter2-score/kifc06-cause-id-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-en-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-ko-720x1280.png) |
| 1080x1920 (Full HD TV) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-id-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-en-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-ko-1080x1920.png) |
| 2160x3840 (4K TV) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-id-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-en-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc06-cause-ko-2160x3840.png) |

---

## Screenshot KIFC-07 (Kartu 3: Pencegahan)

| Viewport portrait | Bahasa Indonesia | English | 한국어 |
|---|---|---|---|
| 360x640 | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-id-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-en-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-ko-360x640.png) |
| 411x731 | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-id-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-en-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-ko-411x731.png) |
| 720x1280 | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-id-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-en-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-ko-720x1280.png) |
| 1080x1920 (Full HD TV) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-id-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-en-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-ko-1080x1920.png) |
| 2160x3840 (4K TV) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-id-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-en-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc07-prevention-ko-2160x3840.png) |

---

## Screenshot KIFC-11 (Layar Skor Akhir dengan Pesan Penutup)

| Viewport portrait | Bahasa Indonesia | English | 한국어 |
|---|---|---|---|
| 360x640 | [Lihat](../../../build/review-chapter2-score/kifc11-score-id-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-en-360x640.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-ko-360x640.png) |
| 411x731 | [Lihat](../../../build/review-chapter2-score/kifc11-score-id-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-en-411x731.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-ko-411x731.png) |
| 720x1280 | [Lihat](../../../build/review-chapter2-score/kifc11-score-id-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-en-720x1280.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-ko-720x1280.png) |
| 1080x1920 (Full HD TV) | [Lihat](../../../build/review-chapter2-score/kifc11-score-id-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-en-1080x1920.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-ko-1080x1920.png) |
| 2160x3840 (4K TV) | [Lihat](../../../build/review-chapter2-score/kifc11-score-id-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-en-2160x3840.png) | [Lihat](../../../build/review-chapter2-score/kifc11-score-ko-2160x3840.png) |

---

## Pemeriksaan dan Pengujian

- `flutter analyze --no-pub`: **No issues found!**
- `flutter test --no-pub`: **104 tes lulus** (44 tes suite penuh + 60 tes penangkapan matriks visual Babak 2 dan Skor).
- Seluruh teks naskah Indonesia, Inggris, dan Korea tampil utuh tanpa overflow atau karakter hilang.
- Transisi kembali dan lanjut antar-kartu Babak 2 terverifikasi aman.
- Banner pesan penutup KIFC-11 terbaca jelas di atas tombol aksi pada seluruh simulasi resolusi.

## Cara Membuat Ulang Bukti

```powershell
$env:KIFC_CAPTURE = '1'
flutter test --no-pub test/chapter2_review_test.dart
Remove-Item Env:KIFC_CAPTURE
```
Folder `build/review-chapter2-score/` berisi 60 screenshot PNG dan 60 berkas metadata JSON.