# KIFC-02 — visual, alur dan bukti pemeriksaan

**Koreksi terbaru:** [aset web terverifikasi, placeholder tanpa label dan maskot setengah badan](kifc-02-empty-slots-review.md). Bukti di bawah menyimpan implementasi sebelum koreksi pemilik.

Tanggal: 23 Oktober 2026. Status: **Ditinjau**, implementasi lokal siap dicoba. Mengacu pada DOCX KIFC serta tambahan pemilik mengenai layout, keselarasan foto dan proporsi pohon.

## Hasil

- Judul dan instruksi stabil. Tiga slot setara, kartu pilihan dalam grid 3 × 2, label lebih besar, sudut kartu seragam, dan feedback maskot pada area baca terpusat.
- Foto latar Baluran diganti hutan Kalimantan yang sudah dibundel. `BoxFit.cover` memakai pembesaran seragam dan crop; tidak mengubah rasio piksel sumber. Implementasi lama juga sudah cover, sehingga pemeriksaan tidak menyimpulkan bahwa file lama secara matematis di-stretch. Subjek/crop lama tampak melebar dan kurang sesuai komposisi baru.
- Foto utama dan kartu Babak 1 mendapat **filter warna ringan yang sama** (sedikit mengurangi saturasi, bayangan netral hangat). Filter merupakan `ColorFilter.matrix` lokal, tanpa mengedit file asli atau memakai layanan berbayar. Warna air, kayu, daun dan percikan tetap dapat dibedakan.
- Panas: percikan akibat gesekan, menggantikan matahari. Oksigen: konteks udara/kanopi dengan label dan cue O₂; bukan foto molekul oksigen. Batu menggantikan udara dingin. Tiga foto baru sekitar **0,96 MiB**, dibundel lokal. [Kredit, sumber dan lisensi](../../../ASSET_SOURCES.md).
- Semua enam kartu awal dapat diseret; air, hujan dan batu tidak mengisi slot. Kesalahan mendapat alasan spesifik. Kartu yang benar tetapi salah tempat mengarahkan ke kategori yang sesuai. Kartu terpasang ditandai centang tanpa memutihkan foto.
- Preview drag mempertahankan ukuran kartu asal dan berada di atas jari, sehingga area drop tetap terlihat. Test regresi awal membuktikan preview lama menjadi 106 px ketika kartu tampil 170,13 px pada TV 720 × 1280.
- Api muncul pada foto utama **hanya setelah tiga unsur benar terpasang**. Naskah penuh KIFC tampil selama 14 detik sebelum lanjut otomatis, memberi ruang baca lebih panjang dari 2 detik lama. Durasi ini pilihan implementasi vendor; uji baca dengan pengunjung belum dilakukan.
- Semua teks baru tersedia dalam Indonesia, Inggris dan Korea. Hangul lokal digunakan; terjemahan Korea masih menunggu tinjauan penutur.
- Tiga slot dipertahankan sesuai arah yang diterima pemilik. Alternatif drop langsung ke foto dibandingkan dalam [rancangan](kifc-02-layout-plan.md), tidak diaktifkan. Foto/slot bersama di halaman penjelasan dan demo juga konsisten; narasi KIFC-03 dan keputusan KIFC-04 tetap terbuka.

## Pemeriksaan

- `flutter analyze`: **No issues found**. [Log](../../../build/kifc-02-analyze.log).
- Seluruh `flutter test`: **151 tes lulus**. [Log](../../../build/kifc-02-suite.log). Meliputi alur, skor, pembatalan timer saat mengulang, feedback sebelumnya, serta matriks assembly terbaru.
- Matriks KIFC-02: **15 tes lulus**. [Log](../../../build/kifc-02-capture.log). Semua pengecoh diuji melalui drag; unsur salah tempat ditolak; api absen pada 0/1/2 unsur dan muncul setelah 3; feedback bertahan lebih dari 5 detik lalu lanjut otomatis. Panel tiga slot tetap satu baris, rasio 1,8:1, tidak ada overflow atau scroll. Ukuran preview drag sesuai kartu pada semua ukuran.
- Penyiapan gambar pada tes alur akhir disesuaikan: menunggu decoding aset yang benar-benar dibutuhkan, bukan bergantung pada urutan semua file dalam cache. Tidak mengubah perilaku tantangan akhir di aplikasi.
- Sampel visual ditinjau: awal Indonesia 411/Full HD; lengkap Indonesia 360/411 dan Inggris 4K; salah Inggris/Korea 411; awal Korea 720; sebagian Indonesia 360. Label/feedback utuh, foto proporsional, status terpasang terlihat. Kombinasi lain diperiksa otomatis dan tersedia di indeks.

## Sumber dan batas screenshot

**Render widget Flutter aktual**, `RenderRepaintBoundary.toImage`, DPR 1, font/foto lokal. Bukan screenshot browser/emulator atau foto TV. Full HD 1080 × 1920 dan 4K 2160 × 3840 mensimulasikan resolusi TV portrait 42 inci, tidak membuktikan jangkauan sentuh, tinggi pemasangan, atau performa perangkat fisik. Web lokal sudah dikompilasi ulang; belum ada deployment atau APK baru.

[Baseline sebelum perubahan, Indonesia 411 × 731](../../../build/review-kifc-02-baseline/assembly-baseline-id-411x731.png) dipertahankan terpisah.

## Indeks 60 render terbaru

| Viewport portrait | Bahasa | Awal | Salah | Dua unsur | Lengkap |
|---|---|---|---|---|---|
| 360x640 | ID | [Lihat](../../../build/review-kifc-02/initial-id-360x640.png) | [Lihat](../../../build/review-kifc-02/incorrect-id-360x640.png) | [Lihat](../../../build/review-kifc-02/partial-id-360x640.png) | [Lihat](../../../build/review-kifc-02/complete-id-360x640.png) |
| 360x640 | EN | [Lihat](../../../build/review-kifc-02/initial-en-360x640.png) | [Lihat](../../../build/review-kifc-02/incorrect-en-360x640.png) | [Lihat](../../../build/review-kifc-02/partial-en-360x640.png) | [Lihat](../../../build/review-kifc-02/complete-en-360x640.png) |
| 360x640 | KO | [Lihat](../../../build/review-kifc-02/initial-ko-360x640.png) | [Lihat](../../../build/review-kifc-02/incorrect-ko-360x640.png) | [Lihat](../../../build/review-kifc-02/partial-ko-360x640.png) | [Lihat](../../../build/review-kifc-02/complete-ko-360x640.png) |
| 411x731 | ID | [Lihat](../../../build/review-kifc-02/initial-id-411x731.png) | [Lihat](../../../build/review-kifc-02/incorrect-id-411x731.png) | [Lihat](../../../build/review-kifc-02/partial-id-411x731.png) | [Lihat](../../../build/review-kifc-02/complete-id-411x731.png) |
| 411x731 | EN | [Lihat](../../../build/review-kifc-02/initial-en-411x731.png) | [Lihat](../../../build/review-kifc-02/incorrect-en-411x731.png) | [Lihat](../../../build/review-kifc-02/partial-en-411x731.png) | [Lihat](../../../build/review-kifc-02/complete-en-411x731.png) |
| 411x731 | KO | [Lihat](../../../build/review-kifc-02/initial-ko-411x731.png) | [Lihat](../../../build/review-kifc-02/incorrect-ko-411x731.png) | [Lihat](../../../build/review-kifc-02/partial-ko-411x731.png) | [Lihat](../../../build/review-kifc-02/complete-ko-411x731.png) |
| 720x1280 | ID | [Lihat](../../../build/review-kifc-02/initial-id-720x1280.png) | [Lihat](../../../build/review-kifc-02/incorrect-id-720x1280.png) | [Lihat](../../../build/review-kifc-02/partial-id-720x1280.png) | [Lihat](../../../build/review-kifc-02/complete-id-720x1280.png) |
| 720x1280 | EN | [Lihat](../../../build/review-kifc-02/initial-en-720x1280.png) | [Lihat](../../../build/review-kifc-02/incorrect-en-720x1280.png) | [Lihat](../../../build/review-kifc-02/partial-en-720x1280.png) | [Lihat](../../../build/review-kifc-02/complete-en-720x1280.png) |
| 720x1280 | KO | [Lihat](../../../build/review-kifc-02/initial-ko-720x1280.png) | [Lihat](../../../build/review-kifc-02/incorrect-ko-720x1280.png) | [Lihat](../../../build/review-kifc-02/partial-ko-720x1280.png) | [Lihat](../../../build/review-kifc-02/complete-ko-720x1280.png) |
| 1080x1920 | ID | [Lihat](../../../build/review-kifc-02/initial-id-1080x1920.png) | [Lihat](../../../build/review-kifc-02/incorrect-id-1080x1920.png) | [Lihat](../../../build/review-kifc-02/partial-id-1080x1920.png) | [Lihat](../../../build/review-kifc-02/complete-id-1080x1920.png) |
| 1080x1920 | EN | [Lihat](../../../build/review-kifc-02/initial-en-1080x1920.png) | [Lihat](../../../build/review-kifc-02/incorrect-en-1080x1920.png) | [Lihat](../../../build/review-kifc-02/partial-en-1080x1920.png) | [Lihat](../../../build/review-kifc-02/complete-en-1080x1920.png) |
| 1080x1920 | KO | [Lihat](../../../build/review-kifc-02/initial-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-02/incorrect-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-02/partial-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-02/complete-ko-1080x1920.png) |
| 2160x3840 | ID | [Lihat](../../../build/review-kifc-02/initial-id-2160x3840.png) | [Lihat](../../../build/review-kifc-02/incorrect-id-2160x3840.png) | [Lihat](../../../build/review-kifc-02/partial-id-2160x3840.png) | [Lihat](../../../build/review-kifc-02/complete-id-2160x3840.png) |
| 2160x3840 | EN | [Lihat](../../../build/review-kifc-02/initial-en-2160x3840.png) | [Lihat](../../../build/review-kifc-02/incorrect-en-2160x3840.png) | [Lihat](../../../build/review-kifc-02/partial-en-2160x3840.png) | [Lihat](../../../build/review-kifc-02/complete-en-2160x3840.png) |
| 2160x3840 | KO | [Lihat](../../../build/review-kifc-02/initial-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-02/incorrect-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-02/partial-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-02/complete-ko-2160x3840.png) |

Regenerasi artefak lokal:

```powershell
$env:KIFC_CAPTURE='1'
$env:KIFC_CAPTURE_DIR='build/review-kifc-02'
flutter test test/assembly_review_test.dart --reporter expanded
```

Folder build diabaikan Git. Baseline tidak ditimpa saat regenerasi.
