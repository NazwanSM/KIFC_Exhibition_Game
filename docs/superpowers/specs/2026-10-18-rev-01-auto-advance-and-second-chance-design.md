# REV-01 — Alur Otomatis dan Kesempatan Kedua: Spesifikasi Desain

**Tanggal:** 18 Oktober 2026  
**Status:** Disetujui untuk implementasi  
**Melaksanakan tiket:** REV-01 pada [tracker revisi klien](../../../design/quick-specs/client-revision-tracker-2026-10-18.md)

## Tujuan

Mengurangi ketukan yang hanya memindahkan layar, memberi waktu membaca feedback, dan menambahkan satu kesempatan tambahan pada soal pilihan banyak. Penjelasan yang perlu dibaca tetap memakai kontrol eksplisit.

## Keputusan yang dikonfirmasi

1. **Skor kesempatan kedua: poin penuh.** Jawaban benar pada percobaan kedua bernilai sama dengan percobaan pertama. Jika pemain tidak pernah menjawab benar, nilainya 0.
2. **Demo kurangi unsur lanjut setelah ketiga unsur dicoba.** Tidak ada tombol lanjut di layar demo.
3. **Durasi feedback otomatis:** ±2 detik untuk feedback singkat, ±4,5 detik saat menampilkan jawaban benar beserta alasannya.
4. Halaman bacaan (penjelasan segitiga api, tiga kartu karhutla) tetap memakai tombol `Lanjut` sebagai kontrol membaca.
5. Tantangan akhir bertimer tetap berjalan sendiri sampai waktu habis; ia bukan soal pilihan ganda biasa dan tidak diberi kesempatan kedua.

## Peta layar

| Layar | Jenis | Aksi pemain | Perpindahan |
|---|---|---|---|
| Pembuka | pilih bahasa | `Mulai Tantangan` | Babak 1 — susun unsur |
| Susun unsur (B1) | aktivitas drag | 3 unsur lengkap | feedback singkat → **otomatis** ke penjelasan segitiga |
| Penjelasan segitiga api (B1) | bacaan | `Coba Kurangi Satu Unsur` | demo kurangi unsur |
| Kurangi satu unsur (B1) | demo tanpa skor | mencoba ketiga unsur | feedback → **otomatis** ke kartu karhutla |
| Kartu karhutla (B2) | bacaan 3 kartu | `Lanjut` tiap kartu | soal risiko |
| Soal risiko (B2) | pilihan 3 opsi | benar / salah-1 / salah-2 | feedback → **otomatis** ke penyebab |
| Penyebab (B3) | 4 soal 2 opsi | pilih manusia/alam | feedback + alasan → **otomatis** ke situasi berikutnya |
| Tindakan aman (B4) | pilihan 3 opsi | benar / salah-1 / salah-2 | feedback → **otomatis** ke tantangan akhir |
| Tantangan akhir (B4) | bertimer, banyak objek | menyentuh objek | waktu habis → skor |
| Skor & penutup | hasil | kontrol eksplisit | main lagi / beranda |

## Aturan feedback dan kesempatan kedua

### Soal lebih dari dua pilihan (risiko, tindakan aman)

1. **Benar pada percobaan pertama:** feedback sukses → lanjut otomatis setelah ±2 detik.
2. **Salah pertama:** maskot memberi petunjuk, pilihan tetap aktif untuk **satu** percobaan tambahan.
3. **Salah kedua:** tampilkan jawaban benar (opsi benar disorot) dan alasannya, kunci pilihan, lalu lanjut otomatis setelah ±4,5 detik.
4. Pada soal berskor (tindakan aman), benar pada percobaan kedua tetap bernilai penuh 1 poin.

### Soal dua pilihan (penyebab)

1. Jawaban benar maupun salah langsung menampilkan feedback dan alasan jawaban yang benar.
2. Tidak ada kesempatan kedua dan tidak ada pengulangan; alur lanjut otomatis setelah ±2 detik.
3. Feedback situasi terakhir merangkum hubungan penyebab dengan pencegahan, lalu berpindah ke Babak 4 tanpa halaman ringkasan terpisah.

### Drag-and-drop dan tantangan akhir

- Susun unsur: penolakan foto yang salah tetap tidak berpindah layar dan tidak diberi skor; perpindahan otomatis hanya setelah ketiga unsur lengkap.
- Kurangi unsur: tetap tanpa benar/salah; perpindahan otomatis hanya setelah ketiga unsur dicoba.
- Tantangan akhir: tetap dijalankan timer 10 detik; tidak memakai aturan kesempatan kedua.

## Kontrol teknis

- Satu helper `_scheduleAdvance(action, long:)` mengatur timer perpindahan. Setiap perpindahan halaman, tombol Kembali, dan reset sesi membatalkan timer aktif (token bertambah) sehingga perpindahan tidak pernah terjadi dua kali.
- Selama feedback tampil, pilihan dan area sentuh pada aktivitas terkait dikunci untuk mencegah jawaban ganda.
- Waktu baca feedback tidak dipengaruhi pengaturan kurangi animasi. Ketukan berulang pada jawaban salah yang sama tidak menghabiskan kesempatan kedua.
- Mengunjungi ulang aktivitas melalui Kembali membuka ulang aktivitas tersebut, mengosongkan jawaban/percobaan serta skor milik aktivitas itu. Bacaan karhutla tetap kembali satu kartu per ketukan; dari kuis penyebab, Kembali menuju soal risiko.
- Halaman intro yang tidak lagi dipakai (`observe`, `triangleIntro`, `causeIntro`, `stopIntro`) dan halaman ringkasan penyebab dihapus agar tidak ada tombol perantara.
- `_playAgain` memulai sesi baru di Babak 1.

## Kriteria penerimaan

- Tidak ada tombol perantara setelah aktivitas selesai atau jawaban benar.
- Urutan feedback, kesempatan kedua, dan jawaban benar mengikuti aturan di atas pada kedua bahasa.
- Penjelasan terbaca sebelum layar berpindah; durasi mengikuti keputusan.
- Timer perpindahan berhenti saat pemain menekan Kembali, berpindah layar, atau mengulang sesi.
- Indonesia dan Inggris tetap muat tanpa scroll pada 360×640 dan 411×731.

## Di luar cakupan

Naskah final klien (REV-08), bahasa Korea (REV-03), pattern latar (REV-05), dan posisi tombol pembuka (REV-09).
