# KIFC-08 — pilihan tetap besar, feedback di kiri maskot

**Pembaruan terbaru:** [balon feedback dinaikkan agar jauh dari tepi bawah](kifc-08-raised-feedback-review.md). Catatan berikut menyimpan pemeriksaan versi sebelumnya.

Tanggal: 23 Oktober 2026. Mengikuti koreksi pemilik pada screenshot: jangan mengecilkan pilihan demi feedback.

## Perubahan

- Semua kartu jawaban memiliki tinggi tetap **72 logical pixel** pada semua keadaan dan ukuran uji. Pemilihan hanya memberi warna, centang/silang, dan animasi penekanan; feedback tidak mengecilkan kartu, foto, atau font label.
- Feedback benar ditempatkan **di kiri maskot**, dengan balon dan maskot sejajar ke bawah. Tidak lagi berupa balon di atas maskot.
- Maskot tetap di kanan bawah, siluet utuh secara horizontal. Pada layar pendek lebarnya disesuaikan agar penjelasan panjang bisa ditampilkan di sampingnya. Maskot hint tetap di kiri bawah.
- Judul dan subjudul tidak berubah. Naskah KIFC tidak diringkas. Setelah benar, sentuhan berikutnya di seluruh layar game tetap melanjutkan, dengan timer 18 detik sebagai cadangan. Retry dan reveal salah kedua tetap berlaku.

## Pemeriksaan

- Tes regresi awal gagal karena tinggi kartu berubah setelah feedback, contoh 68,33 px pada hint 360 × 640; implementasi lama juga memakai 52 px pada keadaan benar.
- Pemeriksaan terbaru memastikan tinggi setiap kartu 72 px setelah hint/reveal/benar, heading tetap, dan sisi kanan balon benar tidak melewati sisi kiri area maskot. Balon dan maskot memiliki rentang vertikal yang bertumpang tindih sehingga tampil berdampingan.
- **16 tes KIFC-08 lulus**; 15 kombinasi ukuran/bahasa serta satu tes tap dan pembatalan timer. Pemeriksaan gambar memastikan semua `RawImage` selesai decode sebelum capture. [Log capture](../../../build/kifc-08-side-capture.log).
- Seluruh suite: **136 tes lulus**. [Log](../../../build/kifc-08-side-suite.log). Analisis Flutter: bersih. [Log](../../../build/kifc-08-side-analyze.log).
- Bukti: **60 render widget Flutter aktual**, DPR 1, font dan foto lokal. Bukan foto TV atau screenshot emulator/browser. Full HD/4K adalah simulasi resolusi untuk kebutuhan TV 42 inci, bukan bukti jangkauan fisik. Belum ada deployment atau APK baru.
- Sampel visual ditinjau: benar Indonesia 360/411/Full HD, Inggris 360, Korea 4K, serta hint Korea 411. Seluruh kombinasi memiliki pemeriksaan layout otomatis.

## Indeks render terbaru

| Viewport portrait | Bahasa | Pertanyaan | Hint | Salah kedua | Benar |
|---|---|---|---|---|---|
| 360x640 | ID | [Lihat](../../../build/review-kifc-08-side-feedback/question-id-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-id-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-id-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-id-360x640.png) |
| 360x640 | EN | [Lihat](../../../build/review-kifc-08-side-feedback/question-en-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-en-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-en-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-en-360x640.png) |
| 360x640 | KO | [Lihat](../../../build/review-kifc-08-side-feedback/question-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-ko-360x640.png) |
| 411x731 | ID | [Lihat](../../../build/review-kifc-08-side-feedback/question-id-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-id-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-id-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-id-411x731.png) |
| 411x731 | EN | [Lihat](../../../build/review-kifc-08-side-feedback/question-en-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-en-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-en-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-en-411x731.png) |
| 411x731 | KO | [Lihat](../../../build/review-kifc-08-side-feedback/question-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-ko-411x731.png) |
| 720x1280 | ID | [Lihat](../../../build/review-kifc-08-side-feedback/question-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-id-720x1280.png) |
| 720x1280 | EN | [Lihat](../../../build/review-kifc-08-side-feedback/question-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-en-720x1280.png) |
| 720x1280 | KO | [Lihat](../../../build/review-kifc-08-side-feedback/question-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-ko-720x1280.png) |
| 1080x1920 | ID | [Lihat](../../../build/review-kifc-08-side-feedback/question-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-id-1080x1920.png) |
| 1080x1920 | EN | [Lihat](../../../build/review-kifc-08-side-feedback/question-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-en-1080x1920.png) |
| 1080x1920 | KO | [Lihat](../../../build/review-kifc-08-side-feedback/question-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-ko-1080x1920.png) |
| 2160x3840 | ID | [Lihat](../../../build/review-kifc-08-side-feedback/question-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-id-2160x3840.png) |
| 2160x3840 | EN | [Lihat](../../../build/review-kifc-08-side-feedback/question-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-en-2160x3840.png) |
| 2160x3840 | KO | [Lihat](../../../build/review-kifc-08-side-feedback/question-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/hint-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/reveal-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-side-feedback/correct-ko-2160x3840.png) |

Regenerasi artefak lokal:

```powershell
$env:KIFC_CAPTURE='1'
$env:KIFC_CAPTURE_DIR='build/review-kifc-08-side-feedback'
flutter test test/peat_quiz_review_test.dart --reporter expanded
```

Folder build diabaikan Git. Bukti versi sebelumnya tetap disimpan terpisah.
