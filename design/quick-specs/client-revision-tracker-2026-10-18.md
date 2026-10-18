# Tracker Revisi Klien — KIFC Fire Prevention Challenge

Tanggal: 18 Oktober 2026  
Sumber: catatan pertemuan klien dan klarifikasi pemilik proyek dalam percakapan.  
Cakupan saat ini: pencatatan revisi, implementasi, dan bukti pemeriksaan per tiket.

## Ringkasan progres

- Tiket selesai: **5/10** (REV-01, REV-02, REV-04, REV-06, REV-07).
- Tiket ditinjau: **0**.
- Tiket siap dikerjakan: **4** (REV-03, REV-05, REV-08, REV-09).
- Tiket menunggu prasyarat: **1** (REV-10, verifikasi setelah implementasi).
- Klarifikasi kebutuhan utama: selesai. Keputusan teknis dan desain yang masih terbuka tercatat pada tiket terkait.

Gunakan status: `Siap`, `Dikerjakan`, `Menunggu prasyarat`, `Ditinjau`, atau `Selesai`. Centang pekerjaan hanya setelah ada bukti. Perbarui ringkasan di atas setiap kali status tiket berubah.

| ID | Tiket | Status | Bergantung pada |
|---|---|---|---|
| REV-01 | Alur otomatis dan kesempatan kedua | Selesai | Hasil kajian REV-02; petunjuk dari REV-04 |
| REV-02 | Tukar babak 1–2 dan kaji alur keseluruhan | Selesai | — |
| REV-03 | Tambahkan bahasa Korea | Siap | Struktur konten REV-02; naskah sementara REV-08 |
| REV-04 | Maskot sebagai pendamping dan pemberi petunjuk | Selesai | Empat pose dari pemilik proyek |
| REV-05 | Tambahkan pattern pada latar | Siap | — |
| REV-06 | Ubah tampilan tiga unsur api | Selesai | Kajian REV-02 |
| REV-07 | Jadikan pengenalan karhutla sebagai penjelasan | Selesai | REV-02, REV-04; naskah sementara REV-08 |
| REV-08 | Kelola naskah sementara dan materi klien | Siap | Materi klien untuk finalisasi saja |
| REV-09 | Posisi tombol pembuka dan kenyamanan jangkauan TV besar | Siap | — |
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

- [x] Petakan setiap layar: aktivitas, penjelasan, feedback, dan perpindahan ke layar berikutnya.
- [x] Hapus kebutuhan menekan tombol perantara ketika aktivitas sudah selesai; kartu bacaan tetap memakai kontrol manual.
- [x] Setelah jawaban benar atau aktivitas selesai, tampilkan feedback yang sesuai lalu lanjut otomatis.
- [x] Pada soal lebih dari dua pilihan: salah pertama → maskot memberi petunjuk → satu percobaan tambahan.
- [x] Jika percobaan kedua salah: tampilkan jawaban benar dan alasannya, kemudian lanjut otomatis.
- [x] Pada soal dua pilihan: salah → jelaskan kesalahan dan jawaban sebenarnya → lanjut otomatis tanpa mengulang.
- [x] Cegah ketukan berulang, pengiriman jawaban ganda, dan perpindahan layar ganda saat feedback tampil.
- [x] Tetapkan dan dokumentasikan pengaruh kesempatan kedua terhadap skor sebelum mengubah perhitungan.

**Kriteria selesai:** tidak perlu mengetuk tombol tambahan setelah aktivitas selesai; urutan feedback dan percobaan sesuai keputusan di atas; penjelasan terbaca sebelum layar berpindah; timer perpindahan berhenti ketika pemain keluar dari layar atau sesi diulang.

**Keputusan implementasi:** feedback singkat 2 detik, pembukaan jawaban setelah salah kedua 4,5 detik. Durasi membaca tetap berlaku ketika animasi dimatikan. Halaman bacaan manual; susun unsur lanjut setelah tiga unsur lengkap; demo lanjut setelah ketiga unsur dicoba; tantangan akhir tetap 10 detik tanpa percobaan ulang. Jawaban benar pada percobaan kedua bernilai penuh, tanpa menambah maksimum 9 poin. Kembali membuka aktivitas terkait dalam keadaan dapat dimainkan; timer lama dibatalkan dan skor aktivitas dihitung ulang agar tidak terakumulasi dua kali.

**Bukti:** 15 tes regresi mencakup kedua bahasa dan dua ukuran portrait, salah pertama/kedua, benar pada kesempatan kedua, ketukan duplikat, reset saat perpindahan tertunda, kunjungan balik, dan mode kurangi animasi. Tangkapan layar di `build/review-rev01/` ditinjau untuk penyelesaian susunan, penyelesaian demo, hint risiko, pembukaan jawaban risiko, dan pembukaan tindakan aman. Pilihan risiko yang belum dijawab memakai warna netral. Uji jangkauan fisik TV dan kecepatan membaca pengunjung tetap memerlukan playtest pada REV-09/REV-10.

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

**Bukti implementasi:** alur baru diuji dalam Bahasa Indonesia dan Inggris pada 360×640 serta 411×731. `flutter analyze --no-pub` dan `flutter test test/game_flow_test.dart --no-pub` lulus pada 18 Oktober 2026. Perpindahan otomatis serta kesempatan kedua dilanjutkan pada REV-01.

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

**Pembuka dan penutup:** maskot diperbesar dan disatukan dengan balon percakapan di area tengah. Pembuka memakai pose welcome di kiri untuk menyapa serta mengajak bermain; tombol mulai tepat di bawah percakapan. Penutup memakai pose success di kanan untuk berterima kasih dan mengingatkan tindakan pencegahan. Paragraf lama diganti agar pesan tidak berulang, seluruh badan dan logo tetap utuh tanpa pencerminan. Bukti visual: `build/review-host-conversation/`.

**Penyempurnaan feedback benar:** pose success tampil besar di kanan bawah, dengan balon percakapan di kiri. Ukuran dan crop mengikuti feedback salah: kedua sisi maskot utuh, potongan pinggang menempel tepi bawah layar. Berlaku pada jawaban benar pemilihan risiko, kuis penyebab, dan keputusan pencegahan. Bukti visual: `build/review-correct-mascot/`.

**Penyempurnaan feedback salah:** maskot hint_safety tampil besar di kiri bawah dengan crop setengah badan, disertai balon percakapan di sebelahnya. Berlaku pada hint pertama, penjelasan salah kedua, dan jawaban salah kuis penyebab. Area jawaban menyesuaikan ruang feedback; teks dan pilihan tidak saling menutupi. Bukti visual: `build/review-mascot-feedback/`. Tes kasus salah pada keempat situasi penyebab mencakup kedua bahasa pada ukuran 360×640.

**Perbaikan crop:** seluruh lebar PNG dipertahankan agar kedua tangan dan sisi tubuh tidak terpotong. Batas potongan pinggang ditempelkan ke tepi bawah viewport pada feedback salah. Bukti lanjutan: `build/review-mascot-edge/`. Tes layout memeriksa posisi bawah crop dan lebar gambar terhadap area crop.

**Tujuan:** memberi penjelasan dan bantuan melalui karakter yang berasal dari identitas Manggala Agni.

- [x] Temukan dan pastikan aset logo Manggala Agni yang akan menjadi acuan.
- [x] Buat konsep maskot melalui generasi gambar berdasarkan logo tersebut; pilih desain yang konsisten dengan identitasnya.
- [x] Siapkan ekspresi atau pose yang diperlukan untuk menjelaskan, memberi petunjuk, dan memberi feedback.
- [x] Integrasikan maskot dengan teks percakapan pada penjelasan dan kondisi salah yang relevan.
- [x] Pastikan maskot tidak menutupi pilihan, foto, teks, atau area sentuh.
- [x] Simpan aset untuk penggunaan offline dan catat asal serta proses pembuatannya sesuai aturan aset proyek.

**Bukti:** empat PNG dari pemilik proyek terdaftar di pubspec; pose welcome pada pembuka, presenting pada kartu karhutla dan segitiga api, hint_safety pada feedback salah, success pada feedback benar dan penutup. Maskot berada dalam layout, tanpa overlay pada kontrol. Seluruh 12 tes lulus (Indonesia/Inggris, 360×640 dan 411×731); analisis Flutter tanpa masalah. Uji kenyamanan fisik TV besar ada pada REV-09. Petunjuk khusus percobaan kedua mengikuti REV-01; Korea mengikuti REV-03. Penilaian visual langsung pada perangkat tetap bagian REV-10.

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

- [x] Eksplorasi penyajian seperti daftar, kartu, atau susunan lain; tidak wajib memakai tiga titik segitiga.
- [x] Pertahankan aktivitas menyusun atau melengkapi tiga unsur dan demo mengurangi unsur.
- [x] Pastikan pemain memahami bahwa ketiganya merupakan unsur yang diperlukan untuk terjadinya api, bukan sekadar tiga penyebab yang berdiri sendiri.
- [x] Sesuaikan instruksi dan feedback dengan bentuk interaksi yang dipilih; kesempatan kedua tetap dilacak pada REV-01.
- [x] Pertahankan demo pengurangan unsur sebagai eksplorasi tanpa penilaian benar/salah.
- [x] Pertahankan ketepatan materi: oksigen ada di udara; angin bukan syarat terjadinya api; pembatasan oksigen di lahan terbuka memiliki keterbatasan.

**Bukti:** tiga kartu sejajar menggantikan titik dan garis segitiga pada panel bersama. Api ditampilkan di atas deretan kartu, tanpa tertutup target drop. Drag-and-drop, penolakan foto yang salah, penyelesaian susunan, serta tiga pilihan demo tanpa penilaian lulus tes pada kedua bahasa dan ukuran portrait. Aturan tampilan di AGENTS.md sudah diselaraskan.

**Hasil peninjauan visual lanjutan:** selesai. Bukti ada di `build/review-rev06-07/` (tangkapan layar nyata dari perjalanan widget pada dua bahasa dan dua ukuran portrait).

- [x] Seimbangkan ruang pada aktivitas: kartu, area sentuh, dan tombol lanjut kini berada dalam satu kelompok terpusat (`groupFooter`), sehingga tidak ada ruang kosong besar di antara aktivitas dan tombol. Kajian zona jangkauan fisik tetap di REV-09.
- [x] Satukan penjelasan segitiga api dengan maskot dalam komposisi percakapan yang jelas (maskot, ekor balon, dan kartu teks menyatu); istilah serta peran masing-masing unsur dipertahankan.
- [x] Perhalus efek nyala: lingkaran oranye padat diganti gradien radial yang memudar ke transparan, sehingga cahaya menyatu dengan foto di belakang api.
- [x] Pastikan petunjuk panas tetap membedakan pengeringan oleh matahari dari sumber penyulut; kalimat ini kini berada pada layar penjelasan yang dilalui alur aktif, dan intro lama bukan bagian dari alur.

**Kriteria selesai:** aktivitas menyusun dan mengurangi unsur tetap bisa dimainkan, konsep tiga unsur dipahami tanpa bergantung pada bentuk segitiga, dan respons visual mengikuti keadaan unsur.

**Catatan:** instruksi proyek lama mewajibkan bentuk segitiga dan ukuran panel tertentu. Permintaan terbaru menggantikan kewajiban bentuk segitiga; perbarui dokumentasi terkait ketika desain baru diterapkan agar tidak saling bertentangan.

## REV-07 — Jadikan pengenalan karhutla sebagai penjelasan

**Tujuan:** pengunjung mendapat penjelasan karhutla dari maskot tanpa harus menyelesaikan aktivitas pada bagian ini.

- [x] Ganti interaksi mengamati atau memilih objek pada bagian “Apa itu karhutla?” dengan materi penjelasan.
- [x] Sajikan penjelasan melalui maskot dan teks yang runtut serta alami.
- [x] Tentukan pembagian materi: tiga kartu pendek dengan satu gagasan per kartu.
- [x] Tentukan cara melanjutkan yang memberi cukup waktu membaca: tombol manual pada setiap kartu.
- [x] Pastikan definisi, konteks hutan/lahan, serta kaitan dengan aktivitas sebelumnya tersampaikan.

**Bukti:** definisi, dampak, dan pencegahan tampil sebagai percakapan bersama maskot. Tidak ada hotspot atau soal pada rangkaian bacaan. Setiap kartu memiliki ID tetap untuk penggantian narasi klien. Tes memeriksa ketiga kartu secara berurutan, lalu soal risiko yang terpisah. Seluruh 12 tes lulus; analisis Flutter tanpa masalah. Naskah final klien tetap menunggu di REV-08.

**Hasil peninjauan visual dan alur lanjutan:** selesai.

- [x] Perbaiki tombol Kembali: dari kartu kedua/ketiga kembali ke kartu sebelumnya; dari kartu pertama kembali ke demo. Perpindahan ini dikendalikan indeks kartu dan diuji ulang.
- [x] Hubungkan kartu bacaan dan maskot secara visual (balon dan ekor percakapan), dengan jarak dan skala yang konsisten pada layar kecil dan besar.
- [x] Hindari subjudul generik berulang: setiap kartu kini punya kalimat pengantar sendiri, dan kartu pertama menghubungkan dengan tiga unsur api yang baru dimainkan.
- [x] Periksa ulang tampilan setelah perbaikan; seluruh 12 tes lulus dan tangkapan layar baru sudah ditinjau pada dua bahasa dan dua ukuran portrait.

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

## REV-09 — Posisi tombol pembuka dan kenyamanan jangkauan TV besar

**Kemajuan awal:** tombol mulai sudah dikelompokkan dengan percakapan maskot di pembuka sehingga mengikuti ajakan bermain. Tampilan diperiksa pada 360×640 dan 411×731. Ini belum menutup tiket: kajian seluruh kontrol, bahasa Korea, dan pengujian jangkauan pada TV fisik masih diperlukan.

**Tujuan:** tombol pembuka dan seluruh interaksi utama mudah ditemukan serta dijangkau pengguna TV touchscreen portrait berukuran besar, tanpa harus sering meraih ujung atas atau bawah layar.

- [ ] Tinjau posisi tombol terhadap judul, pemilih bahasa, dan konten pembuka.
- [ ] Pindahkan tombol ke area yang lebih tinggi dan mudah terlihat tanpa perlu menggulir halaman.
- [ ] Pastikan ukuran area sentuh dan jarak antarkontrol nyaman digunakan.
- [ ] Periksa dengan teks Indonesia, Inggris, dan Korea.
- [ ] Validasi keterjangkauan pada perangkat pameran saat tersedia; catat jika pemeriksaan baru dilakukan melalui emulator.
- [ ] Kaji seluruh sesi: posisi pilihan jawaban, tombol kartu penjelasan, navigasi kembali, area drag-and-drop, dan objek tantangan akhir.
- [ ] Catat ukuran fisik TV, orientasi, tinggi pemasangan, dan posisi berdiri pengguna sebelum menentukan zona sentuh yang nyaman; resolusi saja tidak menunjukkan keterjangkauan fisik.
- [ ] Letakkan interaksi yang sering digunakan dalam zona jangkauan nyaman dan kurangi perpindahan tangan berulang antara ujung atas dan bawah.
- [ ] Uji sesi lengkap pada TV besar dengan pengguna yang memiliki tinggi badan berbeda; catat titik yang memerlukan membungkuk, berjinjit, atau merentangkan tangan berlebihan.

**Kriteria selesai:** tombol terlihat utuh pada tampilan awal dan mudah dikenali sebagai langkah memulai. Interaksi utama sepanjang sesi nyaman dijangkau pada ukuran dan tinggi pemasangan TV sasaran. Catat bukti uji, perubahan posisi, serta batas pemeriksaan; pemeriksaan emulator belum membuktikan kenyamanan fisik pada TV.

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
| 2026-10-18 | REV-06 dan REV-07 ditutup: komposisi aktivitas dan maskot diperbaiki, efek nyala diperhalus, petunjuk panas dipindah ke layar aktif, dan navigasi Kembali kartu diperbaiki. Analisis Flutter bersih, seluruh 12 tes lulus, tangkapan layar baru ditinjau pada dua bahasa dan dua ukuran portrait. |
