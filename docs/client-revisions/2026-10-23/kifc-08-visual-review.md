# KIFC-08 — kuis hutan rawa gambut

**Bukti terbaru:** [feedback di kiri maskot, ukuran pilihan tetap](kifc-08-side-feedback-review.md). Catatan di bawah menyimpan pemeriksaan versi sebelumnya.

**Pembaruan terbaru:** judul/subjudul kini tetap setelah menjawab dan layar dapat disentuh untuk melanjutkan setelah benar. [Lihat bukti pengganti dan 60 render terbaru](kifc-08-stable-heading-review.md). Isi berikut menyimpan catatan pemeriksaan versi awal.

Tanggal pemeriksaan: 23 Oktober 2026. Status: **Ditinjau**, implementasi lokal siap dicoba; belum dirilis.

## Perubahan

- Pertanyaan dan subjudul mengikuti naskah Indonesia KIFC. Tiga foto pilihan: A mangrove, B hutan rawa gambut, C hutan pada tanah mineral. Hanya B benar; tidak ada penambahan poin atau perubahan skor.
- Salah pertama mendapat hint sumber KIFC dan satu retry. Tidak ada perpindahan selama pemain membaca hint. Sentuhan ulang pilihan salah yang sama tidak menghabiskan kesempatan.
- Salah kedua mengungkap B; jawaban terkunci. Naskah tambahan vendor: “Jawaban yang tepat adalah hutan rawa gambut. Api dapat membara di dalam lapisan tanah organik tebal di bawah permukaan sehingga sulit dipadamkan.”
- Benar menampilkan naskah lengkap KIFC, hijau dan centang; maskot di kanan bawah. Salah memakai merah dan silang; maskot di kiri bawah. Tepi kiri/kanan maskot tidak dipotong.
- Setelah pilihan, pertanyaan panjang diganti heading netral “Api di bawah permukaan tanah” agar penjelasan tidak overflow pada viewport kecil. Feedback benar memakai balon selebar konten di atas maskot.
- Inggris dan Korea tersedia. Hangul menggunakan NotoSansKR lokal. Terjemahan belum ditinjau penutur Korea.
- Foto mangrove Nusa Lembongan oleh Lesya Soboleva dan hutan Kalimantan oleh Ken Shono dibundel offline. Kredit/lisensi dicatat pada [ASSET_SOURCES.md](../../../ASSET_SOURCES.md). Foto C mewakili hutan daratan; jenis tanah tidak dapat dibuktikan dari foto saja.

## D-05: perilaku dan waktu baca sementara

Benar: **18 detik**. Salah kedua: **12 detik**, lalu otomatis ke kuis penyebab Babak 3. Salah pertama: menunggu retry tanpa timer lanjut. Ini pilihan implementasi vendor untuk ditinjau, bukan angka yang ditentukan dokumen KIFC atau persetujuan klien. Naskah benar cukup panjang sehingga 4,5 detik sebelumnya terlalu singkat; durasi baru memberi waktu membaca dan melihat pilihan. Uji keterbacaan dengan pengunjung/TV fisik belum dilakukan.

## Verifikasi

- `flutter analyze`: **No issues found**. [Log](../../../build/kifc-08-analyze.log).
- `flutter test --reporter expanded`: **119 tes lulus**, termasuk alur lengkap Indonesia/Inggris, 15 kombinasi viewport/bahasa KIFC-08, retry, sentuhan ulang pilihan salah yang sama, penguncian pilihan, dan kelanjutan otomatis sesudah feedback. [Log](../../../build/kifc-08-tests.log).
- Capture khusus: **15 tes lulus**, menghasilkan **60 PNG** beserta metadata JSON. [Log](../../../build/kifc-08-capture.log).
- Semua kombinasi menguji tidak ada exception layout, tiga pilihan netral sebelum menjawab, target sentuh minimal 48 logical px, serta penguncian/reveal sesuai jawaban.
- Pemeriksaan gambar manual meliputi pertanyaan Indonesia Full HD, Inggris 360, Korea 720; benar Indonesia 360/Full HD, Inggris 411, Korea 4K; hint Korea 360, Inggris 720, Indonesia 4K; pengungkapan Inggris 411 dan Korea Full HD. Tidak terlihat teks terpotong, foto terdistorsi, atau potongan horizontal maskot pada sampel tersebut. Kombinasi lain tercakup tes layout otomatis dan tersedia di indeks.

## Sumber dan batas screenshot

**Render aktual widget Flutter**, melalui `RenderRepaintBoundary.toImage`, DPR 1 dan font lokal. Bukan screenshot emulator/browser atau foto TV. Folder: `build/review-kifc-08/`. Full HD portrait dan 4K portrait merupakan simulasi resolusi calon TV 42 inci; tidak membuktikan kenyamanan jangkauan fisik, tinggi pemasangan, atau performa perangkat. Gambar dalam `build/` diabaikan Git; regenerasi dengan PowerShell:

```powershell
$env:KIFC_CAPTURE='1'
$env:KIFC_CAPTURE_DIR='build/review-kifc-08'
flutter test test/peat_quiz_review_test.dart --reporter expanded
```

## Indeks 60 screenshot

Setiap baris berisi empat keadaan dari ukuran dan bahasa yang sama. ID = Indonesia, EN = Inggris, KO = Korea.

| Viewport portrait | Bahasa | Pertanyaan | Hint pertama | Salah kedua | Benar |
|---|---|---|---|---|---|
| 360x640 | ID | [Lihat](../../../build/review-kifc-08/question-id-360x640.png) | [Lihat](../../../build/review-kifc-08/hint-id-360x640.png) | [Lihat](../../../build/review-kifc-08/reveal-id-360x640.png) | [Lihat](../../../build/review-kifc-08/correct-id-360x640.png) |
| 360x640 | EN | [Lihat](../../../build/review-kifc-08/question-en-360x640.png) | [Lihat](../../../build/review-kifc-08/hint-en-360x640.png) | [Lihat](../../../build/review-kifc-08/reveal-en-360x640.png) | [Lihat](../../../build/review-kifc-08/correct-en-360x640.png) |
| 360x640 | KO | [Lihat](../../../build/review-kifc-08/question-ko-360x640.png) | [Lihat](../../../build/review-kifc-08/hint-ko-360x640.png) | [Lihat](../../../build/review-kifc-08/reveal-ko-360x640.png) | [Lihat](../../../build/review-kifc-08/correct-ko-360x640.png) |
| 411x731 | ID | [Lihat](../../../build/review-kifc-08/question-id-411x731.png) | [Lihat](../../../build/review-kifc-08/hint-id-411x731.png) | [Lihat](../../../build/review-kifc-08/reveal-id-411x731.png) | [Lihat](../../../build/review-kifc-08/correct-id-411x731.png) |
| 411x731 | EN | [Lihat](../../../build/review-kifc-08/question-en-411x731.png) | [Lihat](../../../build/review-kifc-08/hint-en-411x731.png) | [Lihat](../../../build/review-kifc-08/reveal-en-411x731.png) | [Lihat](../../../build/review-kifc-08/correct-en-411x731.png) |
| 411x731 | KO | [Lihat](../../../build/review-kifc-08/question-ko-411x731.png) | [Lihat](../../../build/review-kifc-08/hint-ko-411x731.png) | [Lihat](../../../build/review-kifc-08/reveal-ko-411x731.png) | [Lihat](../../../build/review-kifc-08/correct-ko-411x731.png) |
| 720x1280 | ID | [Lihat](../../../build/review-kifc-08/question-id-720x1280.png) | [Lihat](../../../build/review-kifc-08/hint-id-720x1280.png) | [Lihat](../../../build/review-kifc-08/reveal-id-720x1280.png) | [Lihat](../../../build/review-kifc-08/correct-id-720x1280.png) |
| 720x1280 | EN | [Lihat](../../../build/review-kifc-08/question-en-720x1280.png) | [Lihat](../../../build/review-kifc-08/hint-en-720x1280.png) | [Lihat](../../../build/review-kifc-08/reveal-en-720x1280.png) | [Lihat](../../../build/review-kifc-08/correct-en-720x1280.png) |
| 720x1280 | KO | [Lihat](../../../build/review-kifc-08/question-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08/hint-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08/reveal-ko-720x1280.png) | [Lihat](../../../build/review-kifc-08/correct-ko-720x1280.png) |
| 1080x1920 | ID | [Lihat](../../../build/review-kifc-08/question-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08/hint-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08/reveal-id-1080x1920.png) | [Lihat](../../../build/review-kifc-08/correct-id-1080x1920.png) |
| 1080x1920 | EN | [Lihat](../../../build/review-kifc-08/question-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08/hint-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08/reveal-en-1080x1920.png) | [Lihat](../../../build/review-kifc-08/correct-en-1080x1920.png) |
| 1080x1920 | KO | [Lihat](../../../build/review-kifc-08/question-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08/hint-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08/reveal-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-08/correct-ko-1080x1920.png) |
| 2160x3840 | ID | [Lihat](../../../build/review-kifc-08/question-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08/hint-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08/reveal-id-2160x3840.png) | [Lihat](../../../build/review-kifc-08/correct-id-2160x3840.png) |
| 2160x3840 | EN | [Lihat](../../../build/review-kifc-08/question-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08/hint-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08/reveal-en-2160x3840.png) | [Lihat](../../../build/review-kifc-08/correct-en-2160x3840.png) |
| 2160x3840 | KO | [Lihat](../../../build/review-kifc-08/question-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08/hint-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08/reveal-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-08/correct-ko-2160x3840.png) |
