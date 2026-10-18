# Tracker Revisi Klien — KIFC Fire Prevention Challenge

Tanggal: 18 Oktober 2026  
Sumber: catatan pertemuan klien dan klarifikasi pemilik proyek dalam percakapan.  
Cakupan saat ini: pencatatan revisi dan kriteria selesai. Implementasi belum dimulai.

## Ringkasan progres

- Tiket selesai: **0/10**.
- Tiket ditinjau: **1/10** (REV-02: spesifikasi dan rencana implementasi siap ditinjau).
- Tiket siap dikerjakan: **8**.
- Tiket menunggu prasyarat: **1** (REV-10, verifikasi setelah implementasi).
- Klarifikasi kebutuhan utama: selesai. Keputusan teknis dan desain yang masih terbuka tercatat pada tiket terkait.

Gunakan status: `Siap`, `Dikerjakan`, `Menunggu prasyarat`, `Ditinjau`, atau `Selesai`. Centang pekerjaan hanya setelah ada bukti. Perbarui ringkasan di atas setiap kali status tiket berubah.

| ID | Tiket | Status | Bergantung pada |
|---|---|---|---|
| REV-01 | Alur otomatis dan kesempatan kedua | Siap | Hasil kajian REV-02; petunjuk dari REV-04 |
| REV-02 | Tukar babak 1–2 dan kaji alur keseluruhan | Ditinjau | — |
| REV-03 | Tambahkan bahasa Korea | Siap | Struktur konten REV-02; naskah sementara REV-08 |
| REV-04 | Maskot sebagai pendamping dan pemberi petunjuk | Siap | Aset logo Manggala Agni yang sesuai |
| REV-05 | Tambahkan pattern pada latar | Siap | — |
| REV-06 | Ubah tampilan tiga unsur api | Siap | Kajian REV-02 |
| REV-07 | Jadikan pengenalan karhutla sebagai penjelasan | Siap | REV-02, REV-04, REV-08 |
| REV-08 | Kelola naskah sementara dan materi klien | Siap | Materi klien untuk finalisasi saja |
| REV-09 | Naikkan tombol utama halaman pembuka | Siap | — |
| REV-10 | Verifikasi seluruh revisi | Menunggu prasyarat | REV-01 sampai REV-09 |

## Keputusan yang sudah dikonfirmasi

1. Aktivitas selesai atau jawaban benar diikuti feedback singkat dan kelanjutan otomatis, tanpa tombol perantara yang tidak diperlukan.
2. Untuk soal dengan lebih dari dua pilihan, kesalahan pertama mendapat petunjuk dari maskot dan satu kesempatan tambahan. Jika percobaan kedua juga salah, tampilkan jawaban serta penjelasannya, lalu lanjut otomatis.
3. Untuk soal dua pilihan, jawaban salah langsung diberi feedback dan penjelasan jawaban yang benar, lalu lanjut otomatis. Tidak ada kesempatan kedua.
4. Babak 2 menjadi babak 1 dan sebaliknya. Alur perlu dikaji menyeluruh agar permainan dan penjelasannya saling menyambung.
5. Aktivitas menyusun dan mengurangi unsur api tetap ada. Bentuk segitiga tidak wajib; bentuk penyajian boleh dieksplorasi.
6. Maskot memakai teks untuk tahap ini. Suara ditunda ke pengembangan berikutnya karena menambah pekerjaan dan biaya.
7. Tim menyiapkan naskah dan terjemahan sementara. Bahasa dan bentuk materi yang akan dikirim klien belum diketahui.
8. Halaman pengenalan karhutla menjadi penjelasan tanpa aktivitas menjawab atau memilih objek.

## REV-01 — Alur otomatis dan kesempatan kedua

**Tujuan:** mengurangi ketukan yang hanya berfungsi memindahkan layar, sambil memberi waktu untuk memahami feedback.

- [ ] Petakan setiap layar: aktivitas, penjelasan, feedback, dan perpindahan ke layar berikutnya.
- [ ] Hapus kebutuhan menekan tombol perantara seperti “Lihat Risikonya” ketika aktivitas sudah selesai.
- [ ] Setelah jawaban benar atau aktivitas selesai, tampilkan feedback yang sesuai lalu lanjut otomatis.
- [ ] Pada soal lebih dari dua pilihan: salah pertama → maskot memberi petunjuk → satu percobaan tambahan.
- [ ] Jika percobaan kedua salah: tampilkan jawaban benar dan alasannya, kemudian lanjut otomatis.
- [ ] Pada soal dua pilihan: salah → jelaskan kesalahan dan jawaban sebenarnya → lanjut otomatis tanpa mengulang.
- [ ] Cegah ketukan berulang, pengiriman jawaban ganda, dan perpindahan layar ganda saat feedback tampil.
- [ ] Tetapkan dan dokumentasikan pengaruh kesempatan kedua terhadap skor sebelum mengubah perhitungan.

**Kriteria selesai:** tidak perlu mengetuk tombol tambahan setelah aktivitas selesai; urutan feedback dan percobaan sesuai keputusan di atas; penjelasan terbaca sebelum layar berpindah; timer perpindahan berhenti ketika pemain keluar dari layar atau sesi diulang.

**Masih perlu diputuskan saat kajian:** durasi feedback; perpindahan pada halaman penjelasan panjang; penerapan aturan pada drag-and-drop; perlakuan tantangan akhir bertimer yang memiliki banyak objek. Tantangan akhir tidak otomatis dianggap soal pilihan ganda biasa.

## REV-02 — Tukar babak 1–2 dan kaji alur keseluruhan

**Tujuan:** pemain mencoba lebih dahulu, lalu mendapat penjelasan yang berkaitan dengan pengalaman bermainnya.

- [x] Petakan alur lama beserta isi setiap layar dan keterkaitan antarbabak.
- [x] Pindahkan babak 2 saat ini menjadi babak 1 dan babak 1 saat ini menjadi babak 2 dalam rancangan alur.
- [x] Susun usulan alur lengkap dari pembuka sampai penutup; jelaskan alasan setiap perpindahan.
- [x] Tinjau penjelasan yang dibutuhkan sebelum bermain agar pemain tidak harus menebak cara berinteraksi.
- [x] Tinjau posisi penjelasan karhutla, aktivitas tiga unsur, demo pengurangan unsur, dan pengenalan risiko agar tidak terasa terputus atau berulang.
- [x] Sesuaikan nomor babak, indikator progres, instruksi, kalimat penghubung, serta rujukan ke materi sebelumnya dalam spesifikasi.
- [x] Catat keputusan alur akhir sebelum menerapkan perubahan layar.

**Kriteria selesai:** pertukaran babak tercapai, instruksi awal cukup untuk bermain, dan setiap aktivitas memiliki pengantar serta penjelasan yang relevan. Babak 3–4 tetap tersambung dengan susunan baru.

**Keputusan alur:** aktivitas tiga unsur api menjadi pembuka Babak 1, kemudian diikuti kartu penjelasan segitiga api dan demo pengurangan unsur. Babak 2 menjelaskan karhutla lewat 2–3 kartu pendek yang dikendalikan pemain, lalu berlanjut ke soal risiko. Layar pengantar yang hanya meminta pemain menekan tombol untuk masuk ke aktivitas berikutnya digabungkan atau dihapus. Naskah setiap kartu bersifat sementara sampai narasi klien tersedia. Lihat [spesifikasi alur](../../docs/superpowers/specs/2026-10-18-revised-exhibition-flow-design.md) dan [rencana implementasi](../../docs/superpowers/plans/2026-10-18-revised-exhibition-flow.md).

## REV-03 — Tambahkan bahasa Korea

**Tujuan:** seluruh pengalaman dapat digunakan dalam bahasa Indonesia, Inggris, dan Korea.

- [ ] Tambahkan pilihan `한국어` pada pemilih bahasa.
- [ ] Siapkan struktur lokalisasi yang mendukung tiga bahasa; periksa penggunaan kondisi Indonesia/Inggris yang masih tertanam dalam UI.
- [ ] Terjemahkan seluruh tombol, instruksi, feedback, petunjuk maskot, penjelasan, skor, dan penutup.
- [ ] Pastikan font mendukung Hangul dan tersedia untuk penggunaan Android tanpa internet.
- [ ] Periksa pemenggalan teks, ukuran komponen, serta konsistensi istilah pada ketiga bahasa.
- [ ] Catat sumber naskah dan status pemeriksaan terjemahan. Perbarui terjemahan ketika materi klien masuk.

**Kriteria selesai:** satu sesi lengkap bisa dimainkan dalam bahasa Korea tanpa teks yang tertinggal dalam bahasa lain, karakter hilang, atau konten terpotong. Indonesia dan Inggris tetap berfungsi.

**Ketergantungan:** terjemahan sementara dapat dikerjakan oleh tim; pemeriksaan akhir oleh klien atau penutur yang sesuai belum ditentukan.

## REV-04 — Maskot sebagai pendamping dan pemberi petunjuk

**Tujuan:** memberi penjelasan dan bantuan melalui karakter yang berasal dari identitas Manggala Agni.

- [ ] Temukan dan pastikan aset logo Manggala Agni yang akan menjadi acuan.
- [ ] Buat konsep maskot melalui generasi gambar berdasarkan logo tersebut; pilih desain yang konsisten dengan identitasnya.
- [ ] Siapkan ekspresi atau pose yang diperlukan untuk menjelaskan, memberi petunjuk, dan memberi feedback.
- [ ] Integrasikan maskot dengan teks percakapan pada penjelasan dan kondisi salah yang relevan.
- [ ] Pastikan maskot tidak menutupi pilihan, foto, teks, atau area sentuh.
- [ ] Simpan aset untuk penggunaan offline dan catat asal serta proses pembuatannya sesuai aturan aset proyek.

**Kriteria selesai:** maskot tampil konsisten dan membantu pemain memahami materi atau langkah berikutnya; teks dapat dibaca dalam tiga bahasa.

**Di luar tahap ini:** suara, rekaman narasi, dan integrasi text-to-speech. Tidak perlu menyediakan kontrol audio pada tahap teks ini.

## REV-05 — Tambahkan pattern pada latar

**Tujuan:** membuat latar terasa lebih hidup tanpa mengganggu materi.

- [ ] Eksplorasi motif yang sesuai dengan tema dan identitas acara; motif final belum ditentukan.
- [ ] Terapkan motif secara konsisten pada layar yang sesuai.
- [ ] Atur skala, kepadatan, dan kontras supaya teks, foto, serta pilihan tetap jelas.
- [ ] Periksa tampilan pada perangkat sasaran dan pastikan aset tersedia offline.

**Kriteria selesai:** latar memiliki motif yang terasa menyatu dengan desain, dengan keterbacaan dan kejelasan feedback tetap terjaga.

## REV-06 — Ubah tampilan tiga unsur api

**Tujuan:** mengajarkan panas, bahan bakar, dan oksigen dengan bentuk yang lebih bebas, sambil mempertahankan aktivitasnya.

- [ ] Eksplorasi penyajian seperti daftar, kartu, atau susunan lain; tidak wajib memakai tiga titik segitiga.
- [ ] Pertahankan aktivitas menyusun atau melengkapi tiga unsur dan demo mengurangi unsur.
- [ ] Pastikan pemain memahami bahwa ketiganya merupakan unsur yang diperlukan untuk terjadinya api, bukan sekadar tiga penyebab yang berdiri sendiri.
- [ ] Sesuaikan instruksi dan feedback dengan bentuk interaksi yang dipilih serta aturan REV-01.
- [ ] Pertahankan demo pengurangan unsur sebagai eksplorasi tanpa penilaian benar/salah.
- [ ] Pertahankan ketepatan materi: oksigen ada di udara; angin bukan syarat terjadinya api; pembatasan oksigen di lahan terbuka memiliki keterbatasan.

**Kriteria selesai:** aktivitas menyusun dan mengurangi unsur tetap bisa dimainkan, konsep tiga unsur dipahami tanpa bergantung pada bentuk segitiga, dan respons visual mengikuti keadaan unsur.

**Catatan:** instruksi proyek lama mewajibkan bentuk segitiga dan ukuran panel tertentu. Permintaan terbaru menggantikan kewajiban bentuk segitiga; perbarui dokumentasi terkait ketika desain baru diterapkan agar tidak saling bertentangan.

## REV-07 — Jadikan pengenalan karhutla sebagai penjelasan

**Tujuan:** pengunjung mendapat penjelasan karhutla dari maskot tanpa harus menyelesaikan aktivitas pada bagian ini.

- [ ] Ganti interaksi mengamati atau memilih objek pada bagian “Apa itu karhutla?” dengan materi penjelasan.
- [ ] Sajikan penjelasan melalui maskot dan teks yang runtut serta alami.
- [ ] Tentukan pembagian materi: satu halaman atau beberapa bagian pendek, sesuai panjang naskah dan hasil kajian alur.
- [ ] Tentukan cara melanjutkan yang memberi cukup waktu membaca dan tetap sesuai tujuan alur yang lebih lancar.
- [ ] Pastikan definisi, konteks hutan/lahan, serta kaitan dengan aktivitas sebelumnya tersampaikan.

**Kriteria selesai:** tidak ada kuis atau aktivitas memilih pada bagian pengenalan ini; penjelasan terbaca dengan nyaman dan terhubung ke babak berikutnya.

**Keputusan bentuk:** gunakan 2–3 kartu pendek, masing-masing dengan satu gagasan dan tombol `Lanjut`. Naskah final tetap menunggu narasi klien. Penundaan suara sudah disepakati; halaman ini menggunakan teks.

## REV-08 — Kelola naskah sementara dan materi klien

**Tujuan:** pekerjaan dapat berjalan dengan materi sementara, lalu diperbarui secara terarah setelah klien mengirim konten.

- [ ] Inventarisasi naskah yang dibutuhkan per layar, termasuk feedback benar/salah dan petunjuk percobaan kedua.
- [ ] Siapkan naskah Indonesia yang alami dan akurat, lalu versi Inggris dan Korea.
- [ ] Tandai materi sementara dan catat sumber, versi, serta status pemeriksaannya.
- [ ] Catat kebutuhan materi dari klien dan status penerimaannya; bahasa kiriman saat ini belum diketahui.
- [ ] Setelah materi diterima, bandingkan dengan naskah sementara dan identifikasi dampaknya terhadap alur, tampilan, serta terjemahan.
- [ ] Integrasikan materi yang disepakati dan selaraskan ketiga bahasa.

**Kriteria selesai:** materi klien yang disepakati sudah dipasang, ketiga bahasa selaras, dan status pemeriksaan tiap naskah tercatat.

**Status materi klien:** menunggu; tidak menghalangi penyusunan naskah sementara. Tiket ini belum boleh ditutup hanya karena naskah sementara selesai.

## REV-09 — Naikkan tombol utama halaman pembuka

**Tujuan:** tombol utama mudah ditemukan dan dijangkau pengguna TV touchscreen portrait.

- [ ] Tinjau posisi tombol terhadap judul, pemilih bahasa, dan konten pembuka.
- [ ] Pindahkan tombol ke area yang lebih tinggi dan mudah terlihat tanpa perlu menggulir halaman.
- [ ] Pastikan ukuran area sentuh dan jarak antarkontrol nyaman digunakan.
- [ ] Periksa dengan teks Indonesia, Inggris, dan Korea.
- [ ] Validasi keterjangkauan pada perangkat pameran saat tersedia; catat jika pemeriksaan baru dilakukan melalui emulator.

**Kriteria selesai:** tombol terlihat utuh pada tampilan awal dan mudah dikenali sebagai langkah memulai. Posisi akhirnya ditentukan berdasarkan komposisi layar serta jangkauan pengguna, bukan angka posisi yang diasumsikan sekarang.

## REV-10 — Verifikasi seluruh revisi

**Tujuan:** memastikan seluruh perubahan bekerja bersama dalam satu pengalaman pameran.

- [ ] Jalankan satu sesi lengkap dalam ketiga bahasa.
- [ ] Periksa jawaban benar, salah pertama, salah kedua, dan salah pada soal dua pilihan.
- [ ] Periksa perpindahan otomatis, reset sesi, serta timer saat layar ditinggalkan.
- [ ] Verifikasi aturan skor yang diputuskan, termasuk dampak percobaan kedua dan tantangan akhir.
- [ ] Pastikan demo pengurangan unsur tetap tanpa penilaian.
- [ ] Periksa teks panjang, maskot, motif latar, dukungan Hangul, serta keterlihatan tombol pembuka.
- [ ] Jalankan pemeriksaan Flutter dan tes regresi yang relevan dengan perilaku yang berubah.
- [ ] Periksa Android offline dan tampilan web; catat keterbatasan pemeriksaan pada TV fisik jika belum tersedia.
- [ ] Catat bukti pemeriksaan, masalah yang ditemukan, dan hasil perbaikannya.

**Kriteria selesai:** tidak ada masalah yang menghalangi sesi lengkap; hasil pemeriksaan dan batas validasinya terdokumentasi. Materi sementara yang belum disetujui tetap ditandai jelas.

## Urutan pengerjaan yang disarankan

1. REV-02: putuskan alur rinci dan daftar layar.
2. REV-08: susun naskah sementara; mulai persiapan aset REV-04.
3. REV-06 dan REV-07: terapkan aktivitas serta penjelasan sesuai alur.
4. REV-01: terapkan feedback, kesempatan kedua, dan perpindahan otomatis.
5. REV-03: lengkapi bahasa Korea untuk seluruh alur dan feedback.
6. REV-05 dan REV-09: rapikan latar serta halaman pembuka.
7. REV-10: verifikasi pengalaman lengkap. Ulangi pemeriksaan yang terdampak saat materi klien masuk.

Urutan ini merupakan saran pengerjaan, bukan penetapan tanggal atau estimasi durasi.

## Catatan perubahan tracker

| Tanggal | Perubahan |
|---|---|
| 2026-10-18 | Tracker dibuat dari sembilan revisi klien dan klarifikasi pemilik proyek; ditambahkan tiket verifikasi. Belum ada perubahan kode aplikasi. |
