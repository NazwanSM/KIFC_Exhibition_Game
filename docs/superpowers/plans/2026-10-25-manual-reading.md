# Kelanjutan manual feedback — Implementation Plan

**Goal:** Waktu membaca bebas, sentuh layar untuk lanjut, KIFC-10 tetap 30 detik.
**Architecture:** Hapus timer feedback dan reset hasil. GestureDetector leluhur aktif hanya ketika aktivitas siap dilanjutkan; kontrol anak tetap mendapat prioritas.
**Tech Stack:** Flutter/Dart, komponen dan aset yang ada.
**Spec:** [Rancangan](../specs/2026-10-25-manual-reading-design.md).
**Execution:** Native dalam sesi sesuai instruksi pemilik; tanpa delegasi.

## Batas dan perhatian

- Pertahankan urutan, skor, retry dan durasi tantangan 30 detik.
- Jawaban/drop/flip terakhir tidak boleh sekaligus menutup feedback.
- Kembali/Ulangi/Main Lagi/audio/kredit foto tidak boleh memicu kelanjutan latar.
- Setelah baca 60 detik halaman tetap sama; satu tap hanya maju satu langkah.
- Aktivitas belum lengkap dan tantangan aktif tidak boleh dilewati dengan tap latar.
- Tiga bahasa, reduced motion, ukuran sentuh dan screenshot Full HD/4K tetap diperiksa.

## Langkah

- [x] Tambah tes perilaku membaca/manual/gesture/control; jalankan dan catat kegagalan kode lama.
- [x] Terapkan callback kelanjutan bersama dan hapus timer feedback/reset hasil; ganti notice hasil/penutup.
- [x] Perbarui kontrak perjalanan/visual yang sebelumnya mengandalkan timer; jalankan suite lengkap dan analisis.
- [ ] Capture dan inspeksi tiga bahasa × lima ukuran; uji browser, indeks bukti, perbarui keputusan tracker dan commit terpisah.

Ruling: parent GestureDetector semula menggabungkan semantics setelah feedback dan browser memicu error scheduler. Container semantics stabil dengan explicitChildNodes serta excludeFromSemantics pada gesture menjaga teks terpisah; regresi merah→hijau dan browser nyata diperiksa.
