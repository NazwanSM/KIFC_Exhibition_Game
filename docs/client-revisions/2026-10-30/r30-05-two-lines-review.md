# KIFC-R30-05 Koreksi judul menjadi dua baris

Koreksi pemilik setelah meninjau hasil awal menggantikan arahan sebelumnya yang meletakkan Tapi, sendirian. Judul Indonesia kini berbunyi:

> Tapi, Apa Itu<br>
> Kebakaran Hutan?

Tidak ada penambahan kata, pengurangan ukuran font, atau perubahan isi penjelasan. Pemisah baris dipindah sebelum Kebakaran dan spasi yang tidak terputus tetap menjaga Kebakaran Hutan? sebagai satu kelompok. Label semantics tetap merupakan kalimat utuh.

- Tes awal pada 360×640 gagal dengan susunan tiga baris lama (red.log).
- Setelah koreksi, 15 tes lintas bahasa/ukuran lulus. Indonesia memeriksa satu selection box untuk baris pertama dan satu box untuk frasa Kebakaran Hutan?, dengan posisi vertikal berbeda. Inggris dan Korea tetap diuji untuk overflow serta kelanjutan ke kartu kedua.
- flutter analyze --no-pub: No issues found.
- 15 screenshot pada 360×640, 411×731, 720×1280, 1080×1920 dan 2160×3840 diperiksa melalui contact sheet. Seluruh judul Indonesia dua baris tanpa kata Hutan? yang terpencil; kontrol, bubble dan maskot tetap utuh. [Contoh 411×731](r30-05-two-lines.png).
- Indeks dan log lokal: build/review-r30-05-two-lines-2026-10-30/ berisi screenshots, evidence-index.json, contact.png, red.log, tests.log dan analyze.log. Bukti lama dipertahankan untuk riwayat.
- Sumber screenshot adalah render widget Flutter, bukan rekaman browser/APK atau foto TV fisik 42 inci. Belum push/deploy.
