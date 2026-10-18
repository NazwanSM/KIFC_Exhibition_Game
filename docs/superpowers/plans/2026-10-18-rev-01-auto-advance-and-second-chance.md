# REV-01 — Alur Otomatis dan Kesempatan Kedua: Rencana Implementasi

**Tujuan:** mengganti tombol perantara dengan perpindahan otomatis setelah feedback, menambahkan satu kesempatan tambahan pada soal pilihan banyak, dan merapikan halaman yang tidak lagi dipakai.

**Arsitektur:** `_ExhibitionGameState` tetap pemilik kondisi sesi. Tambahkan satu timer `_autoAdvance` dengan token pembatal (`_advanceToken`) yang dibatalkan oleh `_go`, `_restart`, dan `dispose`. Halaman kuis menerima kondisi percobaan dan menampilkan feedback; perpindahan dijalankan pemilik state.

**Tech Stack:** Flutter, Dart 3, `flutter_test`.

**Spesifikasi:** `docs/superpowers/specs/2026-10-18-rev-01-auto-advance-and-second-chance-design.md`

## Batasan global

- Indonesia dan Inggris harus tetap muat tanpa scroll pada 360×640 dan 411×731.
- Skor tetap berjumlah 9: menyusun unsur 3, penyebab 4, tindakan aman 1, bonus tantangan 1.
- Kesempatan kedua benar bernilai penuh untuk soal berskor.
- Halaman bacaan tetap memakai tombol `Lanjut`.

## Struktur file

| File | Tanggung jawab |
|---|---|
| `lib/features/game/exhibition_game.dart` | Timer otomatis, kondisi percobaan, halaman kuis, penghapusan halaman intro. |
| `test/game_flow_test.dart` | Bukti perpindahan otomatis, kesempatan kedua, dan absennya tombol perantara. |
| `design/quick-specs/client-revision-tracker-2026-10-18.md` | Status dan bukti REV-01. |

## Task 1: Helper perpindahan otomatis dan reset

- [ ] Tambah `Timer? _autoAdvance`, `int _advanceToken`, dan `_scheduleAdvance(VoidCallback, {required bool long})`.
- [ ] `_go` dan `_restart` membatalkan `_autoAdvance` dan menambah token.
- [ ] `_restart` mengosongkan percobaan, kesempatan kedua, dan unsur yang sudah dicoba.
- [ ] `_playAgain` memulai sesi di `_Page.triangleBuild`.

## Task 2: Babak 1 otomatis

- [ ] Susun unsur: saat tiga unsur lengkap, tampilkan feedback sukses dan lanjut otomatis ke penjelasan segitiga.
- [ ] Kurangi unsur: lacak unsur yang sudah dicoba; lanjut otomatis setelah ketiganya dicoba, tanpa tombol.

## Task 3: Soal risiko dengan kesempatan kedua

- [ ] Benar pertama → feedback → lanjut otomatis singkat.
- [ ] Salah pertama → petunjuk maskot → satu percobaan tambahan.
- [ ] Salah kedua → sorot jawaban benar + alasan → lanjut otomatis panjang.

## Task 4: Babak 3 dan 4 otomatis

- [ ] Penyebab: jawaban apa pun menampilkan feedback + alasan, lalu lanjut otomatis tanpa tombol.
- [ ] Ringkasan penyebab digabung ke feedback situasi terakhir; hapus halaman ringkasan.
- [ ] Tindakan aman: kesempatan kedua seperti risiko; benar → lanjut otomatis ke tantangan akhir.

## Task 5: Hapus halaman dan widget mati

- [ ] Hapus `observe`, `triangleIntro`, `causeIntro`, `stopIntro` dari enum dan rute.
- [ ] Hapus `_ObservePage`, `_Hotspot`, `_LandscapePanel`, `_LandCue`, `_TriangleIntro`, `_CauseIntro`, `_StopIntro`, `_PhotoCard` yang tidak lagi dipakai.

## Task 6: Regresi, bukti, dan tracker

- [ ] Perbarui `test/game_flow_test.dart` untuk alur otomatis dan kesempatan kedua.
- [ ] `flutter analyze --no-pub` tanpa masalah dan `flutter test --no-pub` semua lulus.
- [ ] Catat keputusan, bukti, dan tutup REV-01 di tracker.
