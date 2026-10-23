# KIFC-08 — judul tetap dan sentuh untuk lanjut

**Bukti terbaru:** [feedback di kiri maskot, ukuran pilihan tetap](kifc-08-side-feedback-review.md). Catatan di bawah menyimpan pemeriksaan versi sebelumnya.

Tanggal: 23 Oktober 2026. Menggantikan perilaku heading pendek pada pemeriksaan KIFC-08 awal, sesuai koreksi pemilik proyek.

## Perilaku terbaru

- Pertanyaan dan subjudul **tidak berubah** setelah memilih jawaban: sebelum menjawab, hint pertama, salah kedua, dan benar semuanya mempertahankan naskah yang sama.
- Setelah jawaban benar, **sentuhan berikutnya di mana pun dalam layar game** langsung menuju kuis penyebab Babak 3. Termasuk area atas/kembali, kartu yang sudah terkunci, teks, ruang kosong, dan maskot. Area di luar bingkai game pada browser bukan bagian layar game.
- Sentuhan pemilihan jawaban benar tidak langsung melewati penjelasan. Feedback muncul terlebih dahulu; pemain dapat membaca, lalu menyentuh layar untuk melanjutkan.
- Cadangan otomatis 18 detik tetap tersedia. Perpindahan manual membatalkan timer tersebut; callback lama tidak mengulang/reset aktivitas berikutnya.
- Salah pertama tetap memberi satu retry; mengetuk ruang kosong tidak melanjutkan. Salah kedua tetap membuka B, mengunci jawaban, dan berpindah otomatis setelah 12 detik.
- Pada layar pendek, area maskot benar disesuaikan agar pertanyaan panjang dan penjelasan utuh, tanpa scrolling atau overflow. Maskot tetap di kanan bawah dan siluetnya tidak dipotong horizontal. Maskot hint tetap di kiri bawah.

## Verifikasi dan batas bukti

- Tes regresi sebelum perbaikan gagal karena judul berubah menjadi “Api di bawah permukaan tanah” dan tap setelah benar tidak melanjutkan.
- Matriks KIFC-08 terbaru: **16 tes lulus** (15 kombinasi bahasa/ukuran + 1 tes interaksi empat lokasi). Mencakup heading yang sama di semua keadaan, retry, reveal, feedback bertahan, timer cadangan, serta pembatalan timer lama sesudah tap. [Log](../../../build/kifc-08-stable-heading-capture.log).
- Seluruh suite: **136 tes lulus**. [Log](../../../build/kifc-08-stable-heading-tests.log).
- Analisis Flutter bersih. [Log](../../../build/kifc-08-stable-heading-analyze.log).
- **60 PNG dan metadata JSON**: render widget Flutter aktual dengan font/gambar lokal, DPR 1. Bukan foto TV atau screenshot emulator. Sampel benar Indonesia 360/Full HD, hint Indonesia 411, dan benar Korea 4K diperiksa visual: naskah tetap, feedback utuh, maskot mencapai bawah. Layout seluruh kombinasi diperiksa otomatis.
- Full HD/4K portrait adalah simulasi resolusi untuk kebutuhan TV 42 inci; jangkauan dan keterbacaan fisik tetap perlu diuji di perangkat. Belum ada deployment atau APK baru. Server web lokal sudah dikompilasi ulang; refresh browser untuk mencobanya.

## Indeks bukti terbaru

| Viewport portrait | Bahasa | Pertanyaan | Hint | Salah kedua | Benar |
|---|---|---|---|---|---|
| 360x640 | ID | [Lihat](../../../build/review-kifc-08-stable-heading/question-id-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-id-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-id-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-id-360x640.png) |
| 360x640 | EN | [Lihat](../../../build/review-kifc-08-stable-heading/question-en-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-en-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-en-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-en-360x640.png) |
| 360x640 | KO | [Lihat](../../../build/review-kifc-08-stable-heading/question-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-ko-360x640.png) |
| 411x731 | ID | [Lihat](../../../build/review-kifc-08-stable-heading/question-id-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-id-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-id-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-id-411x731.png) |
| 411x731 | EN | [Lihat](../../../build/review-kifc-08-stable-heading/question-en-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-en-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-en-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-en-411x731.png) |
| 411x731 | KO | [Lihat](../../../build/review-kifc-08-stable-heading/question-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-ko-411x731.png) |
| 720x1280 | ID | [Lihat](../../../build/review-kifc-08-stable-heading/question-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-id-720x1280.png) |
| 720x1280 | EN | [Lihat](../../../build/review-kifc-08-stable-heading/question-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-en-720x1280.png) |
| 720x1280 | KO | [Lihat](../../../build/review-kifc-08-stable-heading/question-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-ko-720x1280.png) |
| 1080x1920 | ID | [Lihat](../../../build/review-kifc-08-stable-heading/question-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-id-1080x1920.png) |
| 1080x1920 | EN | [Lihat](../../../build/review-kifc-08-stable-heading/question-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-en-1080x1920.png) |
| 1080x1920 | KO | [Lihat](../../../build/review-kifc-08-stable-heading/question-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-ko-1080x1920.png) |
| 2160x3840 | ID | [Lihat](../../../build/review-kifc-08-stable-heading/question-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-id-2160x3840.png) |
| 2160x3840 | EN | [Lihat](../../../build/review-kifc-08-stable-heading/question-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-en-2160x3840.png) |
| 2160x3840 | KO | [Lihat](../../../build/review-kifc-08-stable-heading/question-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/hint-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/reveal-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-stable-heading/correct-ko-2160x3840.png) |

Regenerasi:

```powershell
$env:KIFC_CAPTURE='1'
$env:KIFC_CAPTURE_DIR='build/review-kifc-08-stable-heading'
flutter test test/peat_quiz_review_test.dart --reporter expanded
```

Artefak `build/` diabaikan Git; bukti versi awal tetap disimpan terpisah.
