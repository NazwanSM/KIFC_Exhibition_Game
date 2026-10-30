# KIFC-R30-08 Drop di seluruh panel hutan

Catatan riwayat: placeholder dan batas bawah foto pada versi awal ini sudah digantikan oleh [koreksi hutan penuh tanpa placeholder](r30-08-full-forest-review.md), mengikuti klarifikasi pemilik.

Seluruh area panel hutan menerima pelepasan foto, termasuk area atas, tepi, tengah, dan tempat unsur yang sudah terisi. Unsur valid yang belum digunakan mengisi tempat kosong berikutnya dari kiri ke kanan. Posisi pelepasan tidak menentukan kategori atau koordinat penyimpanan. Foto pengecoh, duplikat, dan drop di luar panel tidak menambah poin.

Panel mendapat garis amber dan tint tipis ketika foto berada di atasnya. Tampilan hover sama untuk semua foto agar tidak membocorkan jawaban. Instruksi Indonesia/Inggris/Korea mengarahkan pengunjung ke area hutan; placeholder bertuliskan Terisi otomatis / Auto-filled / 자동 배치. Ukuran panel, rasio kartu, dan posisi penyimpanannya tetap sama. Api muncul setelah 3/3, dan gesture drop terakhir tidak sekaligus melewati feedback.

- Pengujian awal gagal ketika unsur dilepas di bagian atas hutan sebelum implementasi (red.log).
- 15 tes lintas bahasa/lima ukuran memeriksa 135 titik di dalam panel dan 60 titik di luarnya, foto pengecoh, kartu terpakai, penempatan di atas tempat terisi, ukuran/posisi panel dan kartu, reset, highlight, serta feedback setelah 3/3.
- Satu tes tambahan memakai dua gesture bersamaan untuk foto yang sama, lalu mencoba callback setelah lengkap, setelah berpindah halaman, dan setelah dispose. Tidak ada poin tambahan maupun error.
- 47 tes gabungan alur revisi 07, revisi 08, dan regresi penyusunan lulus. Suite seluruh game: 437 tes lulus. Satu tes capture aplikasi penuh dijalankan tersendiri dan lulus; analisis final bersih. Script perjalanan Android lolos kompilasi Python.
- 60 screenshot aktual widget diperiksa melalui empat contact sheet: kosong, sebagian, hover, lengkap; 360×640, 411×731, 720×1280, 1080×1920 dan 2160×3840; ID/EN/KO. [Kosong](r30-08-empty.png), [hover panel](r30-08-dragging.png), [3/3 unsur](r30-08-complete.png).
- [Rangkaian interaksi GIF](r30-08-gesture-journey.gif) berisi 24 frame render widget aktual 411×731 dengan overlay foto yang diseret, lalu penjelasan dan bacaan Karhutla langsung. Waktu playback berasal dari skrip uji; ini bukan rekaman browser/emulator dan tidak menyertakan audio. Contact sheet frame diperiksa; avatar mempertahankan proporsi dan unsur masuk otomatis.
- Bukti lokal: build/review-r30-08-2026-10-30/ memuat screenshots, evidence-index.json dengan hash PNG, empat contact sheet, gesture-frames/index.json, gesture-contact.png, gesture-journey.gif, red.log, tests.log, interaction-regression.log, full-suite.log, recording.log dan analyze.log.
- Belum menjalankan APK/browser baru, menguji TV fisik 42 inci, atau melakukan push/deploy. Resolusi TV adalah simulasi viewport; bukan bukti jangkauan fisik atau kualitas speaker. Footage kebakaran nyata dan penggantian musik tetap tiket terpisah.
