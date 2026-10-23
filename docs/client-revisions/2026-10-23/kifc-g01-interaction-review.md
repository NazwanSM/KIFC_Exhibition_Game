# KIFC-G01 — Variasi interaksi dan respons

24 Oktober 2026. Audit implementasi aktif; tidak menambah jenis interaksi tanpa manfaat materi.

| Tahap | Aksi pemain | Respons dan kelanjutan |
|---|---|---|
| Pembuka | Pilih bahasa, mulai | Label/judul langsung berubah, pilihan bahasa aktif terlihat, CTA memberi respons tekan |
| Susun unsur | Seret foto ke slot mana saja | Drop benar mengisi slot dan kategori; pengecoh/duplikat tidak dihitung.3/3 menyalakan api dan feedback. Sentuhan berikutnya di mana saja melanjutkan; fallback otomatis14detik |
| Segitiga api | Baca, tekan CTA | Panel sama, CTA terpisah dari host; beralih ke demo tanpa mengubah urutan |
| Pengurangan | Pilih/revisi panas, bahan bakar, oksigen | Tidak dinilai benar/salah; cardstate, api dan penjelasan berubah. Perpindahan cepat tidak membuat api flash. Tiga pilihan dicoba → lanjut setelah2.6detik |
| Tiga bacaan | Lanjut/kembali manual | Satu topik tiap kartu, tidak ada hotspot/kuis wajib pada definisi |
| Kuis gambut | Satu dari tiga habitat | Hint pertama tanpa timer, satu retry; benar/reveal mengunci input. Benar dapat disentuh di mana saja untuk lanjut. Timer lama dibatalkan ketika pindah |
| Manusia/alam | Pilihan biner | Salah langsung menjelaskan jawaban sebenarnya, tanpa retry yang membocorkan satu-satunya pilihan tersisa; tidak dapat menambah skor lewat tap berulang |
| Tindakan | Satu dari tiga tindakan | Hint/reveal mengunci sesuai hasil; simulasi rambatan menunggu keputusan dan berubah sesuai tindakan |
| Dampak | Pilih/batalkan beberapa foto | Penanda dipilih netral. Deadline stopwatch mengunci tap, hasil baru terbuka setelah waktu habis. Grid tidak bergeser |
| Hasil/penutup | Selesai/main lagi/jelajahi | Tap menyegarkan idle; ulang sesi membersihkan skor, pilihan, demo dan timer lama |

Transisi aktif berupa fade/slide320ms masuk dan220ms keluar. Reduced motion meniadakan gerakan dekoratif, tetapi tetap menyediakan waktu membaca feedback. Timer/transisi memakai token pembatalan agar callback lama tidak memindahkan layar baru. Pengungkapan hasil akhir memakai halaman yang sama agar pemain dapat membandingkan pilihannya.

## Bukti

- `test/assembly_review_test.dart`:drag ditolak/diterima, duplikat, tap seluruh layar setelah selesai, reset dan timer.
- `test/peat_quiz_review_test.dart`:satu retry, jawaban terkunci, header stabil, tap lanjut dan pembatalan callback18detik.
- `test/game_flow_test.dart`:alur ID/EN, skor/penalti, input deadline, neutral toggle, reduced motion dan idle15detik.
- `test/korean_flow_test.dart`:alur lengkap KO dan sesi baru, termasuk pemeriksaan teks tertinggal.
- `test/forest_fire_simulation_test.dart`:pilihan cepat tidak memunculkan flash dan setiap unsur dapat memadamkan enam titik.
- Screenshot per ukuran/bahasa tertaut pada indeks tiket02/03/04/08/10, serta [audit bahasa](kifc-x02-language-review.md) dan [audit visual](kifc-g03-visual-audit.md). Bukti Android nyata menunjukkan drag tiga unsur dan demo padam secara offline.

Log keseluruhan final dan batas perangkat ada di [verifikasi integrasi](kifc-x03-integration-review.md). Tidak ada urutan produksi yang diubah atau audio yang ditambahkan. KIFC-09 tetap menunggu keputusan.
