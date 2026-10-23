# KIFC-08 — feedback dinaikkan untuk kenyamanan membaca

Tanggal: 23 Oktober 2026. Koreksi pemilik: feedback terlalu dekat tepi bawah pada TV.

## Perubahan

- Balon feedback benar, hint, dan pengungkapan jawaban dinaikkan. Hanya balon yang dijauhkan dari tepi bawah; maskot tetap mencapai bawah agar potongan pinggang tidak tampak menggantung.
- Jarak bawah balon pada kanvas 411 × 731 adalah **48 logical px**, sebelumnya 8 px. Pada 360 × 640 dipakai 20 px untuk mempertahankan seluruh isi dan kartu. Pada layout TV dengan `TouchscreenArea`, jarak bawah 72 logical px dalam kanvas terskala, diverifikasi minimal **7,5% tinggi viewport**.
- Feedback benar tetap di kiri maskot; hint/salah tetap di kanan maskot kiri. Judul dan subjudul tidak berubah, semua kartu tetap 72 logical px, naskah tidak dipotong, dan sentuhan setelah benar tetap melanjutkan.
- Gap sebelum footer pada kanvas pendek disesuaikan 9 menjadi 4 px untuk menjaga ruang bagi balon yang dinaikkan. Ukuran foto, label, dan kartu jawaban dipertahankan.

## Verifikasi

- Regresi awal membuktikan jarak lama hanya 8 px pada kanvas 411 × 731, gagal terhadap minimum baru 48 px.
- Matriks KIFC-08: **16 tes lulus**. Semua keadaan feedback diperiksa jaraknya dari bawah, tidak bertabrakan dengan kartu terakhir, heading tetap, kartu 72 px, serta mekanisme retry/tap/timer. [Log capture](../../../build/kifc-08-raised-capture.log).
- Seluruh suite **136 tes lulus**. [Log](../../../build/kifc-08-raised-suite.log). Analisis Flutter bersih. [Log](../../../build/kifc-08-raised-analyze.log).
- 60 render widget Flutter aktual (empat keadaan × tiga bahasa × lima ukuran), DPR 1, font dan gambar lokal. Bukan foto TV, screenshot emulator, atau screenshot browser. Sampel hint Indonesia 411, benar Indonesia 360/Full HD, Inggris 411, dan hint Korea 4K diperiksa visual.
- Resolusi Full HD/4K portrait mensimulasikan kebutuhan TV 42 inci. Tinggi pemasangan, jangkauan dan kenyamanan baca pengunjung tetap memerlukan uji pada perangkat fisik. Belum ada APK/deployment baru.

## Screenshot terbaru

| Viewport portrait | Bahasa | Pertanyaan | Hint | Salah kedua | Benar |
|---|---|---|---|---|---|
| 360x640 | ID | [Lihat](../../../build/review-kifc-08-raised-feedback/question-id-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-id-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-id-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-id-360x640.png) |
| 360x640 | EN | [Lihat](../../../build/review-kifc-08-raised-feedback/question-en-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-en-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-en-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-en-360x640.png) |
| 360x640 | KO | [Lihat](../../../build/review-kifc-08-raised-feedback/question-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-ko-360x640.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-ko-360x640.png) |
| 411x731 | ID | [Lihat](../../../build/review-kifc-08-raised-feedback/question-id-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-id-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-id-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-id-411x731.png) |
| 411x731 | EN | [Lihat](../../../build/review-kifc-08-raised-feedback/question-en-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-en-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-en-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-en-411x731.png) |
| 411x731 | KO | [Lihat](../../../build/review-kifc-08-raised-feedback/question-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-ko-411x731.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-ko-411x731.png) |
| 720x1280 | ID | [Lihat](../../../build/review-kifc-08-raised-feedback/question-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-id-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-id-720x1280.png) |
| 720x1280 | EN | [Lihat](../../../build/review-kifc-08-raised-feedback/question-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-en-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-en-720x1280.png) |
| 720x1280 | KO | [Lihat](../../../build/review-kifc-08-raised-feedback/question-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-ko-720x1280.png) |
| 1080x1920 | ID | [Lihat](../../../build/review-kifc-08-raised-feedback/question-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-id-1080x1920.png) |
| 1080x1920 | EN | [Lihat](../../../build/review-kifc-08-raised-feedback/question-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-en-1080x1920.png) |
| 1080x1920 | KO | [Lihat](../../../build/review-kifc-08-raised-feedback/question-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-ko-1080x1920.png) |
| 2160x3840 | ID | [Lihat](../../../build/review-kifc-08-raised-feedback/question-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-id-2160x3840.png) |
| 2160x3840 | EN | [Lihat](../../../build/review-kifc-08-raised-feedback/question-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-en-2160x3840.png) |
| 2160x3840 | KO | [Lihat](../../../build/review-kifc-08-raised-feedback/question-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/hint-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/reveal-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08-raised-feedback/correct-ko-2160x3840.png) |

Regenerasi artefak lokal:

```powershell
$env:KIFC_CAPTURE='1'
$env:KIFC_CAPTURE_DIR='build/review-kifc-08-raised-feedback'
flutter test test/peat_quiz_review_test.dart --reporter expanded
```

Artefak build diabaikan Git. Bukti versi sebelumnya dipertahankan terpisah.
