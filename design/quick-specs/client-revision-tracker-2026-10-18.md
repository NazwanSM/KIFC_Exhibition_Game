# Tracker Revisi Klien — KIFC Fire Prevention Challenge

Tanggal: 18 Oktober 2026  
Sumber: catatan pertemuan klien dan klarifikasi pemilik proyek dalam percakapan.  
Cakupan saat ini: pencatatan revisi, implementasi, dan bukti pemeriksaan per tiket.

## Pembaruan status — 21 Oktober 2026

- REV-03 sudah diimplementasikan dengan font Hangul offline. Teks feedback gabungan, label situasi, dan bonus yang tertinggal telah diperbaiki. Pergantian bahasa kini langsung memperbarui judul dan widget teks konstan. Empat tes di `test/app_locale_test.dart` lulus setelah perbaikan; analisis Flutter bersih. Masih perlu pemeriksaan satu sesi lengkap dalam tiga bahasa, pemenggalan teks, serta pemeriksaan naskah Korea oleh penutur yang sesuai. Status tetap Dikerjakan.
- REV-05 sudah disetujui secara visual oleh pemilik proyek. Yang terbuka adalah pemeriksaan motif dan keterbacaan pada TV sasaran; status Ditinjau tidak berarti desain masih belum diterapkan.
- REV-08 masih menunggu materi final klien. Naskah sementara sudah digunakan dalam tiga bahasa, tetapi inventaris naskah, sumber, versi, dan status persetujuan belum dirapikan dalam tiket ini.
- REV-09 sudah menerapkan area interaksi tengah dan penyesuaian tombol pembuka. Ukuran TV dan tinggi pemasangan belum diketahui; pemeriksaan tiga bahasa dan uji jangkauan fisik tetap terbuka.
- REV-10 belum menjalani pemeriksaan terpadu terbaru dalam tiga bahasa. Tes serta bukti per fitur yang tercatat sebelumnya bukan pengganti uji seluruh revisi secara bersamaan. Pemeriksaan digital dapat dimulai tanpa menunggu TV; uji fisik dan pemeriksaan setelah materi klien masuk tetap dicatat terpisah.
- APK debug dan web lokal telah diperbarui setelah perbaikan Korea dan gradasi tombol. Gradasi tombol aksi kini dominan hijau dengan transisi lebih tipis; hasil diperiksa di web dan emulator. Bukti emulator: `build/review-soft-green-buttons.png`. Pernyataan historis di bawah tentang belum diperbaruinya APK/web tidak lagi menggambarkan kondisi terakhir. Server web lokal kemudian dihentikan oleh restart T3; menjalankannya kembali bukan pekerjaan implementasi yang belum selesai.
- Pada audit awal 21 Oktober, perubahan terbaru masih lokal pada branch `main`. Sesuai permintaan pemilik proyek, paket perubahan kemudian disiapkan untuk commit, push, dan deployment ke site Pages utama. Hasil deployment harus dikonfirmasi dari workflow GitHub dan site, bukan dari keberhasilan push saja.
- Pemeriksaan sebelum deployment: `flutter analyze --no-pub` bersih; seluruh 27 tes lulus. Empat tes regresi lama disesuaikan untuk membaca `Text` yang dirender di dalam `LocalizedText`, dengan pemeriksaan pesan feedback dan nilai skor tetap dipertahankan. Pemeriksaan ini belum menutup kebutuhan uji manual Korea atau TV fisik.

## Ringkasan progres

- Tiket selesai: **5/10** (REV-01, REV-02, REV-04, REV-06, REV-07).
- Tiket ditinjau: **1** (REV-05; implementasi dan bukti visual siap ditinjau pemilik proyek).
- Tiket sedang dikerjakan: **2** (REV-03 dan REV-09; pemeriksaan tampilan Korea serta validasi perangkat masih terbuka).
- Tiket siap dikerjakan: **1** (REV-08).
- Tiket menunggu prasyarat: **1** (REV-10, verifikasi setelah implementasi).
- Klarifikasi kebutuhan utama: selesai. Keputusan teknis dan desain yang masih terbuka tercatat pada tiket terkait.

Gunakan status: `Siap`, `Dikerjakan`, `Menunggu prasyarat`, `Ditinjau`, atau `Selesai`. Centang pekerjaan hanya setelah ada bukti. Perbarui ringkasan di atas setiap kali status tiket berubah.

| ID | Tiket | Status | Bergantung pada |
|---|---|---|---|
| REV-01 | Alur otomatis dan kesempatan kedua | Selesai | Hasil kajian REV-02; petunjuk dari REV-04 |
| REV-02 | Tukar babak 1–2 dan kaji alur keseluruhan | Selesai | — |
| REV-03 | Tambahkan bahasa Korea | Dikerjakan | Pemeriksaan tampilan dan pemeriksa bahasa Korea; materi akhir klien pada REV-08 |
| REV-04 | Maskot sebagai pendamping dan pemberi petunjuk | Selesai | Empat pose dari pemilik proyek |
| REV-05 | Tambahkan pattern pada latar | Ditinjau | Pemeriksaan TV fisik pada REV-09/REV-10 |
| REV-06 | Ubah tampilan tiga unsur api | Selesai | Kajian REV-02 |
| REV-07 | Jadikan pengenalan karhutla sebagai penjelasan | Selesai | REV-02, REV-04; naskah sementara REV-08 |
| REV-08 | Kelola naskah sementara dan materi klien | Siap | Materi klien untuk finalisasi saja |
| REV-09 | Posisi tombol pembuka dan kenyamanan jangkauan TV besar | Dikerjakan | Validasi TV fisik; Korea pada REV-03 |
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

**Keputusan implementasi:** feedback singkat 2 detik, pembukaan jawaban setelah salah kedua 4,5 detik. Durasi membaca tetap berlaku ketika animasi dimatikan. Halaman bacaan manual; susun unsur lanjut setelah tiga unsur lengkap; demo lanjut setelah ketiga unsur dicoba; tantangan akhir tetap 10 detik tanpa percobaan ulang. Sesuai perubahan yang disetujui pada 19 Oktober, pilihan tantangan akhir dapat dibatalkan sebelum waktu habis, feedback ditunda sampai waktunya habis, dan ulasan dilanjutkan secara manual ke hasil keseluruhan. Jawaban benar pada percobaan kedua bernilai penuh, tanpa menambah maksimum 9 poin. Kembali membuka aktivitas terkait dalam keadaan dapat dimainkan; timer lama dibatalkan dan skor aktivitas dihitung ulang agar tidak terakumulasi dua kali.

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

- [x] Tambahkan pilihan `한국어` pada pemilih bahasa.
- [x] Siapkan dukungan tiga bahasa pada teks yang tampil, termasuk pilihan jawaban dan teks dinamis.
- [x] Terjemahkan tombol, instruksi, feedback, petunjuk maskot, penjelasan, skor, dan penutup dengan naskah sementara.
- [x] Bundel font Noto Sans KR agar Hangul tersedia di Android tanpa internet.
- [ ] Periksa pemenggalan teks, ukuran komponen, serta konsistensi istilah pada ketiga bahasa.
- [x] Catat sumber font dan status naskah Korea sementara; perbarui terjemahan ketika materi klien masuk.

**Kriteria selesai:** satu sesi lengkap bisa dimainkan dalam bahasa Korea tanpa teks yang tertinggal dalam bahasa lain, karakter hilang, atau konten terpotong. Indonesia dan Inggris tetap berfungsi.

**Ketergantungan:** terjemahan sementara dapat dikerjakan oleh tim; pemeriksaan akhir oleh klien atau penutur yang sesuai belum ditentukan.

**Implementasi sementara, 20 Oktober 2026:** pemilih bahasa kini menawarkan Indonesia, Inggris, dan `한국어`. Seluruh teks yang tampil di layar diarahkan melalui kamus Korea; cakupan literal diperiksa terhadap layar game dan layar demo lama, termasuk dialog maskot, pilihan, instruksi, tombol, skor, semantik timer, dan kalimat dinamis. Noto Sans KR variabel disertakan bersama lisensi SIL OFL dan didaftarkan di `ASSET_SOURCES.md`. `flutter analyze --no-pub` bersih dan build APK debug berhasil. Pemeriksaan tampilan belum dilakukan karena tidak ada emulator/perangkat Android tersambung; panjang teks pada layar perlu ditinjau sebelum REV-03 ditutup. Terjemahan ini masih naskah sementara dan memerlukan pemeriksaan penutur Korea serta pembaruan saat materi klien masuk.

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

- [x] Eksplorasi motif yang sesuai dengan tema dan identitas acara; pemilik proyek menyetujui arah garis kontur lahan pada 19 Oktober 2026.
- [x] Terapkan motif secara konsisten pada layar berlatar krem dan hijau gelap.
- [x] Atur skala, kepadatan, dan kontras supaya teks, foto, serta pilihan tetap jelas.
- [ ] Periksa tampilan pada perangkat sasaran dan pastikan aset tersedia offline.

**Kriteria selesai:** latar memiliki motif yang terasa menyatu dengan desain, dengan keterbacaan dan kejelasan feedback tetap terjaga.

**Implementasi dan bukti, 19 Oktober 2026:** kontur statis berwarna hijau lembut pada latar krem dan hijau pucat pada latar gelap, lebih samar di tengah. Pola digambar lokal tanpa unduhan, timer, atau pengendali animasi; berada di belakang konten dan tidak menangkap sentuhan. Foto pembuka, penutup, dan panel aktivitas tetap menjadi fokus. Analisis Flutter bersih; tiga uji alur lengkap lulus pada Indonesia 411×731 dan 1080×1920 serta Inggris 360×640. Screenshot render Flutter di `build/review-rev05/` sudah ditinjau untuk halaman terang, gelap, feedback, dan alur akhir. Ini bukti render viewport, bukan screenshot APK atau validasi TV fisik. Sifat offline sudah terpenuhi; pemeriksaan pada perangkat TV menunggu perangkat sasaran. Status Ditinjau menunggu tanggapan pemilik proyek atas hasil visual.

**Penyesuaian visual kedua, 19 Oktober 2026:** setelah pemilik proyek menilai pola awal masih terlalu sepi, jumlah kontur ditambah dari 12 menjadi 18 per kelompok, jarak garis diperkecil, kelompok digeser mendekati area isi, dan kontras dinaikkan dengan bagian tengah tetap lebih tenang. Efek tetap statis. Analisis Flutter dan ketiga uji alur pada ukuran/bahasa yang sama kembali lulus. Bukti terbaru di `build/review-rev05-v2/`; halaman terang, gelap, dan feedback ditinjau ulang. Status tetap Ditinjau.

**Penyesuaian visual ketiga, 19 Oktober 2026:** pemilik proyek meminta pola lebih renggang dan kedua kelompok tidak saling overlap. Jumlah kontur dikurangi menjadi 12 per kelompok, posisi dipisahkan ke kanan atas dan kiri bawah, serta radius dibatasi berdasarkan jarak antarpusat agar kedua kelompok selalu memiliki celah saat ukuran viewport berubah. Kontras versi kedua dipertahankan. Analisis Flutter dan tiga uji alur kembali lulus; screenshot terbaru di `build/review-rev05-v3/` ditinjau pada halaman terang/gelap, termasuk viewport 1080×1920. Versi ketiga menggantikan versi kedua sebagai hasil yang siap ditinjau.

**Tanggapan pemilik proyek:** versi ketiga disetujui secara visual. Pemeriksaan TV fisik tetap mengikuti REV-09/REV-10.

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

**Kajian lanjutan:** pemilik proyek memastikan TV portrait dan meminta interaksi lebih terpusat; ukuran panel serta tinggi pemasangan belum diketahui. Layout layar besar memakai kelompok konten yang diskalakan proporsional ke area tengah. Tinggi acuan diperbesar dari 70% menjadi 84% viewport setelah pengujian APK memperlihatkan konten terlalu kecil; bagian bawah kelompok diberi ruang tambahan agar kontrol tetap terjangkau. Latar tetap penuh. Maskot feedback tetap menempel tepi bawah, sementara teks petunjuk dinaikkan. Keterangan jumlah babak, perkiraan durasi, dan tanpa suara di pembuka dihapus dalam kedua bahasa. Audit dan batas validasi: [kajian REV-09](rev09-portrait-touch-reach-review.md). Bukti terbaru di `build/review-tv-expanded/`.

**Tujuan:** tombol pembuka dan seluruh interaksi utama mudah ditemukan serta dijangkau pengguna TV touchscreen portrait berukuran besar, tanpa harus sering meraih ujung atas atau bawah layar.

- [x] Tinjau posisi tombol terhadap judul, pemilih bahasa, dan konten pembuka.
- [x] Pindahkan tombol ke area yang lebih tinggi dan mudah terlihat tanpa perlu menggulir halaman.
- [ ] Pastikan ukuran area sentuh dan jarak antarkontrol nyaman digunakan.
- [ ] Periksa dengan teks Indonesia, Inggris, dan Korea.
- [ ] Validasi keterjangkauan pada perangkat pameran saat tersedia; catat jika pemeriksaan baru dilakukan melalui emulator.
- [x] Kaji seluruh sesi: posisi pilihan jawaban, tombol kartu penjelasan, navigasi kembali, area drag-and-drop, dan objek tantangan akhir.
- [ ] Catat ukuran fisik TV, orientasi, tinggi pemasangan, dan posisi berdiri pengguna sebelum menentukan zona sentuh yang nyaman; resolusi saja tidak menunjukkan keterjangkauan fisik.
- [x] Terapkan zona interaksi tengah sementara untuk mengurangi perpindahan tangan antara ujung atas dan bawah; kenyamanan fisiknya belum dikonfirmasi.
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

**Penyempurnaan countdown, 19 Oktober 2026:** sesuai permintaan pemilik proyek, lingkaran timer tantangan akhir kini berkurang dari penuh ke kosong selama 10 detik, mengikuti stopwatch yang sama dengan angka dan akhir tantangan. Pembaruan pecahan waktu hanya menggambar ulang indikator; animasi berhenti saat countdown selesai. Mode kurangi animasi tetap memperlihatkan proporsi waktu tanpa interpolasi. Dua tes baru memeriksa penuh, setengah, seperempat, 20%, nol, dan perpindahan ke skor pada kedua mode animasi. Seluruh 21 tes dan analisis Flutter lulus. Screenshot render pada sisa 5 dan 2 detik ditinjau di `build/review-countdown-ring/`. Belum ada pembaruan APK atau deployment web untuk perubahan ini.

**Warna countdown, 19 Oktober 2026:** lingkaran hijau pada 10–6 detik, kuning pada 5–4 detik, dan merah pada 3–0 detik. Track lingkaran memakai warna senada yang lebih samar. Dua tes countdown diperluas untuk memeriksa batas warna pada angka 10, 6, 5, 4, 3, dan 0; keduanya lulus pada mode animasi normal maupun dikurangi. Analisis Flutter bersih. Screenshot render pada 10, 5, dan 3 detik ditinjau di `build/review-countdown-color/`.

**Pilihan netral dan ulasan tantangan akhir, 19 Oktober 2026:** selama 10 detik, semua pilihan memakai penanda netral yang sama, tanpa skor atau petunjuk benar/salah. Mengetuk ulang membatalkan pilihan. Pada tenggat waktu, input dikunci termasuk ketukan sebelum pembaruan timer berikutnya. Setelah angka 0, halaman ulasan menampilkan jumlah benar, salah, dan risiko terlewat, penanda pada tiap foto, skor babak, serta penjelasan singkat. Tombol “Lihat Hasil Akhir” membuka skor keseluruhan setelah pemain selesai membaca. Aturan skor tetap benar +1, salah −1, minimum 0; bonus tetap skor babak dibagi 4. Dua tes baru mencakup pembatalan, tidak adanya feedback saat memilih, ketukan di tenggat waktu, hasil campuran, dan ulasan yang tidak berpindah otomatis. Tes countdown kini memeriksa ulasan tanpa pilihan (0 benar, 0 salah, 4 terlewat). Seluruh 23 tes dan analisis Flutter lulus. Screenshot render Flutter untuk kedua bahasa dan empat viewport portrait (360×640, 411×731, 720×1280, 1080×1920) di `build/review-final-neutral/`; pilihan netral, ulasan campuran, serta ulasan pada layar besar sudah ditinjau. Belum ada build APK atau deployment web baru untuk perubahan ini.

**Penyederhanaan ulasan, 19 Oktober 2026:** pemilik proyek menilai ulasan awal terlalu terasa seperti template dan menyetujui penggantian kartu statistik serta paragraf umum dengan satu baris hasil dan percakapan maskot. Fase memilih dan ulasan kini memakai susunan layar yang sama; posisi serta ukuran grid tetap saat waktu habis, tanpa transisi ke dashboard baru. Skor rinci dan aturan perhitungan hanya ditampilkan pada hasil keseluruhan. Maskot memberi pesan berdasarkan gambar yang dipilih, kesalahan, risiko terlewat, atau belum adanya pilihan; pose sukses berada di kanan untuk hasil sempurna, pose petunjuk di kiri untuk hasil lain. Foto dan logo maskot tetap proporsional. Tes diperluas untuk memeriksa kestabilan posisi grid, pesan spesifik terhadap pilihan, dan pose maskot pada kedua bahasa serta empat ukuran portrait. Seluruh 23 tes lulus; analisis Flutter bersih. Screenshot terbaru di `build/review-final-host/` ditinjau pada hasil campuran dan sempurna, termasuk viewport 1080×1920. Ini merupakan hasil render Flutter; APK dan web belum diperbarui.

## Urutan pengerjaan yang disarankan

1. REV-02: putuskan alur rinci dan daftar layar.
2. REV-08: susun naskah sementara; mulai persiapan aset REV-04.
3. REV-06 dan REV-07: terapkan aktivitas serta penjelasan sesuai alur.
4. REV-01: terapkan feedback, kesempatan kedua, dan perpindahan otomatis.
5. REV-03: tinjau pemenggalan naskah Korea dan minta pemeriksaan penutur sebelum menutup tiket.
6. REV-05 dan REV-09: rapikan latar serta halaman pembuka.
7. REV-10: verifikasi pengalaman lengkap. Ulangi pemeriksaan yang terdampak saat materi klien masuk.

Urutan ini merupakan saran pengerjaan, bukan penetapan tanggal atau estimasi durasi.

## Catatan perubahan tracker

| Tanggal | Perubahan |
|---|---|
| 2026-10-19 | REV-05 masuk Ditinjau: motif kontur statis diterapkan pada latar polos, tiga uji alur dan analisis Flutter lulus, screenshot viewport tersedia. Validasi TV fisik masih terbuka. |
| 2026-10-18 | Tracker dibuat dari sembilan revisi klien dan klarifikasi pemilik proyek; ditambahkan tiket verifikasi. Belum ada perubahan kode aplikasi. |
| 2026-10-18 | REV-06 dan REV-07 ditutup: komposisi aktivitas dan maskot diperbaiki, efek nyala diperhalus, petunjuk panas dipindah ke layar aktif, dan navigasi Kembali kartu diperbaiki. Analisis Flutter bersih, seluruh 12 tes lulus, tangkapan layar baru ditinjau pada dua bahasa dan dua ukuran portrait. |
