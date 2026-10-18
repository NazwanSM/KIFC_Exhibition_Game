# REV-09 — Kajian jangkauan TV portrait

Tanggal: 18 Oktober 2026.

## Konteks dan keputusan

TV dipastikan portrait oleh pemilik proyek. Ukuran fisik dan tinggi tepi bawah dari lantai belum diketahui. Permintaan saat ini: pusatkan interaksi agar pengunjung tidak harus sering meraih ujung atas atau bawah.

Layout ini bersifat sementara. Persentase layar membantu mengelompokkan kontrol, tetapi tidak menentukan kenyamanan dalam sentimeter atau bagi tinggi badan tertentu.

## Temuan dan perubahan

| Bagian | Temuan | Penanganan |
|---|---|---|
| Pembuka | Bahasa dekat atas; tombol mulai berada di kelompok berbeda dari header | Bahasa, judul, percakapan, dan tombol berada dalam kelompok tengah pada layar besar. Hapus baris jumlah babak, durasi, dan tanpa suara. |
| Navigasi | Kembali/Ulangi dekat tepi atas | Ikut berpindah bersama area konten sehingga tidak melekat ke ujung panel. |
| Susun unsur | Sumber kartu dan target perlu dijangkau dalam satu gerakan | Pertahankan kelompok panel dan sumber yang berdekatan; skala seragam mempertahankan proporsi gambar dan pemetaan drag. |
| Penjelasan segitiga api | Tombol lanjut mengikuti footer dekat bawah | Footer beserta materi berada dalam area tengah yang sama. |
| Demo unsur | Pilihan dekat panel; perlu dipertahankan | Kelompok panel, tiga pilihan, dan penjelasan tetap bersama, tanpa penilaian. |
| Kartu karhutla | Membaca lalu menekan lanjut secara berulang | Percakapan dan tombol tetap dikelompokkan; Kembali berada pada area yang sama antarkartu. |
| Risiko dan kuis penyebab | Pilihan dan feedback harus tetap terbaca | Pilihan berada di area tengah. Saat feedback muncul, maskot menempel bawah layar; teks feedback dinaikkan agar tidak ikut terlalu rendah. |
| Keputusan pencegahan | Tiga pilihan harus dapat dijangkau tanpa mengikuti animasi api | Pertahankan posisi pilihan dalam kelompok tengah dan adegan di atasnya. |
| Tantangan akhir | Enam target dalam grid; jangan tersebar ke seluruh panel | Grid diskalakan seragam dalam kelompok tengah; seluruh target tetap dapat disentuh tanpa scroll. |
| Hasil dan penutup | Tombol ulang/selesai dekat bawah | Kelompok konten dan tombol masuk ke area tengah; pesan penutup dan maskot tetap satu komposisi. |

## Aturan layout sementara

- Aktif pada viewport dengan lebar minimal 600 dan tinggi minimal 900 unit layout. Pengujian sasaran: 720×1280 dan 1080×1920 portrait.
- Gunakan referensi 411×731 yang sudah diuji, diskalakan seragam agar tinggi kelompok normal sekitar 70% tinggi viewport; batasi lebar hingga 90% jika ruang lebih sempit.
- Pada dua rasio 9:16 yang diuji, kelompok normal berada pada rentang tinggi 15–85%. Ini zona pemeriksaan geometri, bukan klaim jangkauan fisik.
- Latar foto atau warna memenuhi seluruh layar. Ukuran foto tidak diregangkan pada satu sumbu.
- Pada feedback, bagian dekoratif boleh meluas ke bawah. Seluruh sprite tetap utuh secara horizontal; potongan pinggang berakhir di tepi bawah. Teks dapat tampil lebih tinggi di samping/atas maskot.
- Perangkat kecil mempertahankan layout sebelumnya. Tidak menambahkan kontrol baru, scroll, atau langkah permainan.

## Bukti dan pemeriksaan

- Sesi lengkap Indonesia dan Inggris pada 360×640, 411×731, 720×1280, dan 1080×1920.
- Tes layar besar memeriksa pusat seluruh kontrol aktif pada rentang 15–85% tinggi viewport serta sisi terpendek target minimal 44 unit koordinat viewport. Ini pemeriksaan geometri hasil render, bukan ukuran fisik area sentuh.
- Drag-and-drop, seluruh pilihan demo, kartu bacaan, jawaban risiko, empat penyebab, keputusan, grid akhir, skor, kembali/ulang, dan timeout diperiksa melalui alur tes yang ada.
- Pemeriksaan overflow dan scroll tetap berlaku. Posisi crop feedback di bawah layar juga diperiksa.
- Tangkapan layar serta koordinat target tersedia dalam PNG dan JSON di `build/review-rev09/`.
- Hasil pengukuran rekaman layar besar: pusat kontrol aktif berada pada 23,7–80,9% tinggi layar. Tombol mulai sekitar 73%, tombol lanjut kartu karhutla sekitar 71%, dan target tantangan akhir sekitar 48–59%. Sisi target terpendek yang terukur adalah 44,1 pada 720×1280 dan 66,2 pada 1080×1920, dalam koordinat viewport.
- Seluruh 19 tes lulus; analisis Flutter tanpa masalah dan build web berhasil. Pemeriksaan ini belum mencakup TV Android yang dipasang.
- Snapshot preview browser tidak tersedia pada pemeriksaan ini: dua percobaan berakhir dengan `Preview automation snapshot timed out after 15000ms.` Peninjauan visual memakai PNG hasil render Flutter dari sesi tes, bukan screenshot browser.

## Sebelum tiket ditutup

- Tambahkan pengujian Korea setelah REV-03 tersedia.
- Catat diagonal panel, ukuran area aktif, resolusi/density Android, tinggi bawah layar dari lantai, dan jarak berdiri pengguna.
- Uji pada TV yang dipasang, dengan pengunjung bertinggi badan berbeda. Amati kebutuhan membungkuk, berjinjit, merentangkan tangan, serta pengulangan gerakan naik-turun.
- Periksa keterbacaan huruf dan ukuran fisik tombol; sesuaikan skala dan posisi kelompok jika diperlukan.
- Pastikan seluruh sesi dapat diselesaikan offline pada Android sasaran.

Status REV-09: **Dikerjakan**. Layout dan kajian perangkat lunak tersedia; kenyamanan fisik dan bahasa Korea belum divalidasi.
