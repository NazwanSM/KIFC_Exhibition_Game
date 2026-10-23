# KIFC-02 — rancangan dan pelaksanaan

Acuan: instruksi pemilik untuk mengerjakan KIFC-02 sambil merapikan layout, proporsi pohon, keselarasan foto, dan filter warna. Tiga slot dipertahankan sesuai arah pengerjaan yang diterima pemilik; alternatif drop langsung ke foto tidak diaktifkan.

## Susunan

Judul/instruksi ringkas dan stabil. Panel 190 logical px berisi foto hutan proporsional, progres, api setelah tiga unsur lengkap, serta tiga slot setara dalam satu baris. Di bawahnya enam kartu foto berukuran/rasio seragam 1,8:1, lalu penjelasan maskot pada area baca terpusat. Hindari balon teks di tepi bawah TV. Pertahankan panel sama pada penjelasan dan demo berikutnya.

## Visual

Pakai foto hutan Kalimantan yang sudah berlisensi sebagai adegan utama; cover cropping memakai zoom seragam. Tidak menyimpulkan bahwa file lama mengalami stretch matematis: implementasinya sudah cover, namun subjek pohon melebar dan crop kurang cocok. Pilih percikan akibat gesekan sebagai panas, langit/kanopi sebagai konteks udara dengan label oksigen, dan batu sebagai pengecoh pengganti udara dingin. Kanopi bukan foto molekul oksigen. Semua visual mendapat grading ringan yang sama ketika ditampilkan di kartu Babak 1; objek dan warna aslinya tetap dikenali. Foto asli dipertahankan, filter berjalan lokal tanpa layanan atau aset berbayar.

## Interaksi

Enam kartu dapat diseret. Drop salah tidak mengisi slot dan mendapat alasan sesuai objek/slot. Satu slot hanya terisi unsur yang tepat; api hanya muncul setelah ketiganya lengkap. Naskah benar mengikuti KIFC, dengan waktu baca lebih panjang sebelum lanjut otomatis. Drag feedback menjaga skala yang sama pada preview web dan TV; posisi jari tidak meloncat. Tidak mengubah skor (maksimal tiga unsur) atau keputusan KIFC-04.

## Langkah dan bukti

1. Catat baseline; verifikasi aset, sumber dan crop.
2. Tes fungsi untuk pengecoh, slot salah, duplikasi, penyelesaian dan waktu baca.
3. Implementasi model, teks tiga bahasa, layout dan filter.
4. Periksa render awal/salah/sebagian/lengkap pada 360×640, 411×731, 720×1280, Full HD dan 4K portrait, dalam tiga bahasa. Jalankan analisis serta regresi lengkap.
5. Perbarui tracker, indeks bukti dan preview web. Uji fisik TV, penutur Korea dan penilaian klien tetap dicatat terpisah dari render otomatis.

## Pemetaan implementasi

- `exhibition_game.dart`: enum batu, riwayat drop salah, alasan tiap objek, timer baca 14 detik, susunan assembly dan foto/slot/kartu bersama. Tidak merombak modul atau rute lain.
- `widgets/game_photo.dart`: opsi grading Babak 1, matriks warna ringan dan framing cover; default layar lain tidak berubah.
- `app_locale.dart`: label sumber panas, batu, konteks oksigen, instruksi dan feedback baru dalam Korea, dipetakan dari dua bahasa sumber.
- `test/assembly_review_test.dart`: baseline, lima ukuran × tiga bahasa, keadaan awal/salah/sebagian/lengkap, slot benar/salah, semua pengecoh, api/timer serta geometri.
- `test/game_flow_test.dart`: perbarui ekspektasi feedback sumber dan waktu baca; pertahankan regresi skor/ulang/rute lain.
- `ASSET_SOURCES.md`, tracker, indeks bukti: kredit aset, filter runtime, status tiap checklist dan keterbatasan validasi.

### Siklus pemeriksaan

- [x] Rekam baseline sebelum perubahan dan jalankan tes fungsi yang gagal pada naskah lama.
- [x] Implementasikan perubahan; uji spesifik sampai lulus dan tinjau render sebelum mengunci layout.
- [x] Jalankan `flutter analyze` dan seluruh `flutter test`; simpan log dan 60 screenshot akhir.
- [x] Perbarui dokumentasi berdasarkan hasil, kompilasi ulang web lokal, berikan tautan bukti.

## Perbandingan alternatif D-01

Tiga slot berlabel dipertahankan karena arah tersebut sudah diterima pemilik: pengunjung mengenali hubungan foto dengan kategori panas, bahan bakar, dan oksigen, serta mendapat petunjuk spesifik ketika salah tempat. Alternatif drop langsung ke foto akan memberi target lebih luas, tetapi menghilangkan latihan menghubungkan foto dengan kategori berlabel; format itu memerlukan aturan penerimaan, instruksi, serta respons baru. Alternatif tidak diaktifkan bersamaan. Uji fisik dapat menjadi dasar pembahasan ulang jika tiga target masih sulit disentuh.

## Hasil pelaksanaan

Analisis bersih dan 151 tes lulus. Bukti awal/salah/sebagian/lengkap dalam tiga bahasa dan lima ukuran tersedia pada indeks visual. Foto dan slot bersama pada dua layar berikutnya ikut memakai aset selaras dengan panel tetap 190 px; konten/konsep KIFC-03/04 tidak dianggap selesai. Masalah ukuran preview drag di TV terbukti melalui tes (106 px melawan kartu 170,13 px pada viewport 720×1280) dan diperbaiki dengan transform relatif ke overlay. Kendala penyimpanan encoding dipulihkan dari source cache kompilasi; regresi lengkap memastikan fitur sebelumnya tetap bekerja.

## Koreksi pemilik setelah peninjauan

Ketiga placeholder kini tanpa label kategori. Unsur benar yang belum dipakai dapat masuk ke posisi kosong mana pun; aturan kategori tersembunyi dihapus. Maskot kecil seluruh badan diganti setengah badan besar pada tepi viewport. Judul “Pilih tiga unsur api.” dan instruksi “Seret tiga foto yang tepat ke tempat kosong.” menggantikan wording sebelumnya. Setelah tiga unsur lengkap, tiga foto terpasang tetap tampil sebagai rangkuman dan bank enam pilihan disembunyikan untuk memberi ruang penjelasan.

Pengiriman tiga foto baru ke web sebelumnya belum terverifikasi: source file ada tetapi bundel server yang berjalan belum memasukkannya. Setelah restart penuh, manifest memuat ketiganya, respons HTTP 200 cocok byte-for-byte dengan source, dan screenshot browser menunjukkan semuanya tampil. Tambahan aturan ini dicatat di AGENTS agar peninjauan widget tidak dianggap bukti pengiriman aset web.
