# Tracker revisi KIFC 30 Oktober 2026

Sumber: daftar revisi klien yang disampaikan pemilik proyek dan klarifikasinya dalam percakapan 30 Oktober 2026. Tujuan dokumen ini adalah memetakan pekerjaan, cara penerapan, dependensi, dan bukti penyelesaiannya. Pembuatan tracker tidak berarti revisi game sudah diimplementasikan.

**Status terkini: 16 Belum dikerjakan, 0 Dikerjakan, 0 Siap ditinjau, 4 Selesai secara implementasi.**

ID `KIFC-R30-01` sampai `KIFC-R30-20` khusus untuk putaran ini, bukan nomor halaman atau babak. Riwayat lama tetap disimpan di [tracker 23 Oktober](kifc-screen-revision-tracker-2026-10-23.md). Status pekerjaan lama tidak dipindahkan menjadi status selesai untuk kebutuhan baru.

## Keputusan dan batas cakupan

- Musik pilihan final adalah **Safari oleh syncopika versi penuh**. `a3-0-30s.mp3` adalah cuplikan acuan, bukan berkas loop produksi. Kredit dan lisensi CC BY 3.0 harus dicantumkan. Sumber pilihan ada di [kurasi putaran kedua](../../docs/audio-options/2026-10-29/round-2/sources.json).
- Maskot mengikuti arah **3D yang sudah dirender**, dengan gerakan mulut sederhana saat berbicara. Model 3D real-time bukan target awal. Mutu, konsistensi, transparansi, dan biaya aset tetap perlu dibuktikan melalui contoh sebelum produksi massal.
- Narasi hanya untuk sapaan pembuka, **tiga halaman bacaan Karhutla**, dan salam penutup. Kuis jenis hutan dan seluruh feedback **tidak menggunakan narasi**; maskotnya tetap bergerak.
- Bahasa tetap Indonesia, Inggris, dan Korea, mengikuti pilihan pengguna. Isi narasi Karhutla mengikuti teks penjelasan yang sekarang, tanpa menambah materi baru. Pembuka dan penutup memakai naskah singkat yang sesuai fungsinya.
- Azure AI Speech adalah **usulan sumber TTS**, belum layanan yang sudah dipakai dan belum pilihan voice final. Penyedia, voice/model, izin penggunaan, biaya, dan contoh tiga bahasa perlu dicatat sebelum produksi. Jangan mengklaim TTS sudah dibuat atau gratis tanpa pemeriksaan.
- Pembuka menunggu tombol Mulai meskipun sapaan selesai. Sapaan diulang saat idle; **20 detik setelah sapaan selesai adalah nilai awal usulan**, bukan angka yang ditetapkan klien. Dapat disesuaikan setelah didengarkan dalam konteks pameran.
- Hanya bacaan Karhutla yang berpindah otomatis ketika narasinya selesai. Ketuk untuk melewati harus menghentikan suara dan berpindah satu halaman. Kuis tidak boleh dilewati oleh perilaku ini.
- Penutup tidak berpindah karena audio selesai. Timer khusus penutup menjadi **30 detik**, tetap bisa dilanjutkan lebih cepat lewat ketukan. Feedback dan hasil lain tetap **15 detik**, kecuali direvisi lagi.
- Hapus hanya demo pengurangan unsur. Halaman penjelasan Segitiga Api tetap ada. Skor maksimum tetap **8**, karena demo yang dihapus tidak memiliki poin.
- Video kebakaran berupa rekaman nyata dengan kamera diam, dipakai pada panel setelah 3/3 unsur dan halaman penjelasan Segitiga Api. Tetap ada hutan tanpa kebakaran sebelum lengkap. Kamera diam tidak otomatis menjamin loop mulus.
- Tidak ada perubahan APK, deployment, atau pembelian layanan yang dilakukan hanya untuk membuat tracker ini. Penerapan berikutnya menggunakan komponen yang ada dan menghindari rewrite yang tidak diperlukan.

Keputusan ini menggantikan ketentuan lama tentang demo yang wajib dicoba, seluruh bacaan Babak 2 manual, larangan narasi/TTS lama, serta timer penutup 15 detik. Aturan proyek terkait perlu diselaraskan ketika tiket terkait diterapkan; jangan mengikuti aturan lama yang bertentangan dengan klarifikasi pemilik terbaru.

## Status dan cara memperbarui

- `Belum dikerjakan`: implementasi/aset baru belum tersedia untuk tiket ini.
- `Dikerjakan`: ada pekerjaan nyata, tetapi kriteria selesai belum terpenuhi.
- `Menunggu aset/akses`: catat tepat aset, akun, biaya, atau keputusan yang belum tersedia.
- `Siap ditinjau`: implementasi dan pemeriksaan internal selesai; pemilik dapat menilai buktinya.
- `Selesai`: seluruh kriteria terpenuhi, bukti dan commit tercatat, serta persetujuan subjektif yang memang dibutuhkan sudah diterima.
- Centang hanya hasil yang sudah terbukti. Perbarui tabel ringkas, rincian tiket, dan log sekaligus. Catat siapa yang meninjau dan tanggalnya.
- Commit setiap tiket yang selesai secara terpisah. Isi hash pada kolom Commit; hash tidak perlu dicantumkan sebelum commit tersebut benar-benar ada.
- Urutan berikut adalah perkiraan dari paling mudah sampai paling sulit, bukan estimasi hari kerja. Kesulitan aset eksternal masih memiliki ketidakpastian. Kerjakan tiket hanya setelah dependensi yang dibutuhkan tersedia; jangan menandai integrasi selesai hanya karena aset sudah diunduh.

## Antrean dari paling mudah ke paling sulit

| Urut / ID | Pekerjaan | Halaman | Kesulitan | Dependensi | Status | Commit |
|---|---|---|---|---|---|---|
| KIFC-R30-01 | Hapus caption hutan gambut dan aliran air | Pembuka | Sangat mudah | Tidak ada | Selesai | `9e21c95` |
| KIFC-R30-02 | Sederhanakan label babak di atas judul | Semua halaman berlabel babak | Sangat mudah | Tidak ada | Selesai | `9644ce8` |
| KIFC-R30-03 | Perbaiki kapitalisasi judul penutup | Penutup terakhir | Sangat mudah | Tidak ada | Selesai | `0023de3` |
| KIFC-R30-04 | Ubah timer khusus penutup menjadi 30 detik | Penutup terakhir | Mudah | Tidak ada | Selesai | Dicatat setelah commit |
| KIFC-R30-05 | Rapikan susunan judul Karhutla pertama | Bacaan Karhutla 1 | Mudah | Tidak ada | Belum dikerjakan | — |
| KIFC-R30-06 | Tambahkan tombol akhiri tantangan lebih awal | Tantangan akhir | Sedang | Tidak ada | Belum dikerjakan | — |
| KIFC-R30-07 | Hapus demo pengurangan dan sambungkan navigasi | Babak 1 dan transisi ke Babak 2 | Sedang | Tidak ada | Belum dikerjakan | — |
| KIFC-R30-08 | Terima drop di seluruh panel unsur | Penyusunan unsur | Sedang | Tidak ada | Belum dikerjakan | — |
| KIFC-R30-09 | Terapkan Safari versi penuh | Musik lintas game | Sedang | Sumber penuh dan lisensi | Belum dikerjakan | — |
| KIFC-R30-10 | Cari dan siapkan video kebakaran kamera statis | Aset panel hutan | Sedang, bergantung aset | Sumber dan izin penggunaan | Belum dikerjakan | — |
| KIFC-R30-11 | Integrasikan background video kebakaran bersama | Penyusunan lengkap dan penjelasan Segitiga Api | Menengah–sulit | 07, 08, 10 | Belum dikerjakan | — |
| KIFC-R30-12 | Finalisasi naskah dan audisi suara maskot | Pembuka, tiga bacaan, penutup | Menengah–sulit | Akses TTS dan peninjauan suara | Belum dikerjakan | — |
| KIFC-R30-13 | Produksi narasi tiga bahasa dan data timing | Aset narasi | Sulit | 12 | Belum dikerjakan | — |
| KIFC-R30-14 | Buktikan desain maskot 3D prerender | Prototipe aset maskot | Sulit, mutu aset belum terbukti | Referensi dan akses produksi | Belum dikerjakan | — |
| KIFC-R30-15 | Produksi gerakan maskot yang dapat dipakai ulang | Aset animasi maskot | Sulit | 14 | Belum dikerjakan | — |
| KIFC-R30-16 | Integrasikan animasi maskot di seluruh halaman | Semua kemunculan maskot | Sulit | 15 | Belum dikerjakan | — |
| KIFC-R30-17 | Tambahkan salam bersuara pada penutup | Penutup terakhir | Sulit karena dependensi | 03, 04, 09, 13, 16 | Belum dikerjakan | — |
| KIFC-R30-18 | Tambahkan sapaan idle berkala | Pembuka | Sulit | 01, 09, 13, 16 | Belum dikerjakan | — |
| KIFC-R30-19 | Sinkronkan narasi, teks per kata, dan navigasi bacaan | Tiga bacaan Karhutla | Paling sulit secara integrasi | 05, 07, 09, 13, 16 | Belum dikerjakan | — |
| KIFC-R30-20 | Verifikasi terpadu dan kemas hasil revisi | Seluruh alur, web dan APK | Luas, lintas fitur | 01–19 | Belum dikerjakan | — |

Nomor pendek pada dependensi merujuk tiket dengan awalan yang sama. Tiket sumber aset 09, 10, 12, dan 14 dapat dipersiapkan lebih awal bila perlu agar integrasi tidak tertahan; ini tidak mengubah urutan kesulitan.

## Kriteria umum sebelum menutup tiket

- Jangan mengubah aturan soal, retry kuis gambut, empat situasi penyebab, kartu gambut tanpa skor, atau rumus skor di luar kebutuhan tiket.
- Kontrol suara, kembali, ulangi, dan dialog tetap memperoleh prioritas. Satu gesture tidak boleh sekaligus menjawab soal dan melewati feedback baru.
- Stop/cancel pemutar, timer, serta callback lama ketika pindah halaman, mengganti bahasa, mengulang, atau dispose. Tidak ada suara atau musik bertumpuk.
- Pertahankan semua aset runtime secara offline pada APK. Cantumkan sumber, lisensi, pengolahan, dan hash di `ASSET_SOURCES.md` atau indeks aset terkait. Jangan menjadikan server TTS kebutuhan saat pengunjung bermain.
- Untuk perubahan visual, sertakan screenshot aktual UI pada 360×640, 411×731, 720×1280, 1080×1920, dan 2160×3840, dalam tiga bahasa. Untuk perubahan gerak, suara, video, dan timing, tambahkan rekaman serta pemeriksaan playback; screenshot saja tidak cukup.
- Catat sumber bukti secara jujur: render widget, browser, emulator, atau TV fisik. Resolusi Full HD/4K bukan bukti jangkauan fisik panel 42 inci. Jika TV belum tersedia, tuliskan belum diuji pada perangkat tujuan.
- Jalankan pemeriksaan yang relevan dengan tiket, bukan tes baru yang hanya menyalin implementasi. Perubahan interaksi, skor, timer, dan lifecycle membutuhkan regresi perilaku. Pemeriksaan aset dan penilaian suara/visual mempunyai bukti tersendiri.

## Rincian tiket

### KIFC-R30-01 — Hapus caption pembuka

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** `_WelcomePage` di `lib/features/game/exhibition_game.dart`, serta padanan lokalisasinya.

- [x] Hapus caption “Hutan gambut dan aliran air” dan padanan Inggris/Korea dari tampilan serta semantics, tanpa menghapus kontrol bahasa atau suara.
- [x] Rapikan ruang yang ditinggalkan agar tidak ada garis/pemisah kosong atau kontrol bergeser ke tepi TV.
- [x] Periksa pembuka dalam tiga bahasa dan ukuran portrait; sertakan bukti sesuai kriteria umum.

**Selesai jika:** caption hilang pada semua bahasa, tata letak seimbang, dan fungsi pembuka tetap berjalan.

**Bukti:** [Review tiket 01](../../docs/client-revisions/2026-10-30/r30-01-review.md).

### KIFC-R30-02 — Sederhanakan label babak

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** label `eyebrow` pada halaman di `exhibition_game.dart` dan `lib/core/localization/app_locale.dart` bila diperlukan.

- [x] Ganti label seperti `BABAK 2 / HUTAN RAWA GAMBUT` menjadi `BABAK 2`, dengan padanan bahasa yang benar pada setiap halaman.
- [x] Terapkan ke penyusunan/penjelasan unsur, bacaan/kuis gambut, penyebab, kartu gambut, tantangan/ulasan, dan skor yang memiliki label tersebut.
- [x] Pertahankan indikator progres `BABAK 2/4` yang terpisah, judul utama, dan informasi urutan soal; jangan menghapus semua teks bertanda slash secara global.

**Selesai jika:** seluruh label babak konsisten, tidak ada deskripsi lama sesudah slash, dan progres tetap benar. Bukti: inventaris halaman dan screenshot tiga bahasa.

**Bukti:** [Review tiket 02](../../docs/client-revisions/2026-10-30/r30-02-review.md).

### KIFC-R30-03 — Kapitalisasi judul penutup

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** `_ClosingPage` dan lokalisasi.

- [x] Ubah judul Indonesia menjadi “Jaga Hutan, Jaga Kehidupan.” dengan awal kata kapital, bukan ALL CAPS.
- [x] Sesuaikan kapitalisasi Inggris secara alami; bahasa Korea tidak memiliki kapitalisasi huruf seperti Latin.
- [x] Pertahankan susunan baris yang nyaman dan identitas halaman penutup, bukan mengganti judul ringkasan skor.

**Selesai jika:** judul benar tanpa clipping/overflow dalam tiga bahasa. Bukti: screenshot penutup.

**Bukti:** [Review tiket 03](../../docs/client-revisions/2026-10-30/r30-03-review.md).

### KIFC-R30-04 — Timer khusus penutup 30 detik

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** pengelolaan feedback timer di `exhibition_game.dart`; pemeriksaan `test/feedback_timing_test.dart`.

- [x] Bedakan jatah penutup 30 detik dari jatah feedback/hasil lain yang tetap 15 detik; hitung ketika penutup ditampilkan.
- [x] Pertahankan ketuk untuk kembali lebih cepat; tombol Main Lagi/Jelajahi Pameran dan kontrol audio tetap menjalankan aksinya sendiri.
- [x] Uji batas sebelum/sesudah 30 detik, pembatalan ketika navigasi manual, serta pause/resume saat dialog atau aplikasi tidak aktif. Jangan mengubah tantangan akhir yang juga 30 detik.

**Selesai jika:** penutup kembali ke pembuka setelah jatahnya habis atau ketukan yang sah, tanpa navigasi ganda. Bukti: hasil regresi timer dan rekaman.

**Bukti:** [Review tiket 04](../../docs/client-revisions/2026-10-30/r30-04-review.md).

### KIFC-R30-05 — Judul bacaan Karhutla pertama

**Status:** Belum dikerjakan. **Area kode:** `_KarhutlaCards`, komponen judul stage, dan lokalisasi; `test/chapter2_review_test.dart`.

- [ ] Susun “Tapi,” pada baris tersendiri, lalu kelompokkan “Apa Itu Kebakaran Hutan?” di bawahnya. Kata “Hutan?” tidak boleh menjadi baris yatim.
- [ ] Izinkan kelompok judul membungkus secara wajar pada layar kecil; jangan memaksakan satu baris hingga font terlalu kecil. Inggris/Korea mengikuti struktur bahasa masing-masing.
- [ ] Periksa lima viewport tiga bahasa dengan area maskot dan narasi tetap cukup.

**Selesai jika:** hierarki judul terbaca dan tidak ada kata terakhir yang terpencil. Bukti: screenshot bacaan pertama.

### KIFC-R30-06 — Tombol menyelesaikan tantangan lebih awal

**Status:** Belum dikerjakan. **Area kode:** `_FinalChallenge` dan timer tantangan; `test/impact_review_test.dart`, `test/feedback_timing_test.dart`.

- [ ] Tambahkan tombol berlabel jelas, misalnya “Selesai Memilih”, pada area jangkauan tengah tanpa mengecilkan kartu.
- [ ] Satukan penyelesaian lewat tombol dan waktu habis ke satu aksi yang hanya berjalan sekali: kunci pilihan, hentikan timer, buka ulasan menggunakan pilihan saat itu.
- [ ] Pertahankan pilihan netral sebelum selesai, rumus bonus, dan 30 detik maksimum. Tidak ada narasi atau efek yang membocorkan jawaban.
- [ ] Uji nol/sebagian/semua pilihan, pembatalan pilihan, ketukan cepat berulang, dan tombol ditekan bersamaan dengan deadline. Tombol hanya tampil saat tantangan aktif.

**Selesai jika:** pengunjung dapat menyelesaikan kapan saja tanpa penilaian/navigasi ganda; ulasan dan skor tetap akurat. Bukti: tes interaksi, screenshot, rekaman.

### KIFC-R30-07 — Hapus demo pengurangan unsur

**Status:** Belum dikerjakan. **Area kode:** enum halaman, navigasi, `_BreakTriangle`, state/timer terkait di `exhibition_game.dart`; tes alur, reading, dan feedback.

- [ ] Hapus halaman demo, tombol yang mengajak mengurangi unsur, syarat mencoba ketiga unsur, dan state khusus demo yang tidak dipakai lagi.
- [ ] Sambungkan halaman Penjelasan Segitiga Api langsung ke bacaan Karhutla pertama; sesuaikan tombol lanjut dan jalur Kembali agar tidak menuju halaman yang dihapus.
- [ ] Pertahankan penjelasan Segitiga Api dan skor maksimum 8. Sesuaikan tes/alat journey serta dokumentasi aturan yang sebelumnya mewajibkan demo.
- [ ] Uji maju, kembali, ulangi, replay, dan timer yang masih aktif setelah halaman dihapus.

**Selesai jika:** demo tidak lagi dapat dicapai, penjelasan tetap ada, dan tidak ada jalan buntu atau loncatan soal. Bukti: regresi alur dan rekaman perjalanan Babak 1 ke Babak 2.

### KIFC-R30-08 — Drop di seluruh panel unsur

**Status:** Belum dikerjakan. **Area kode:** `_TriangleBuild`, `_FireScene`, penerimaan drop dan `_dropPiece`; `test/assembly_review_test.dart`.

- [ ] Jadikan seluruh batas panel hutan target drop, bukan hanya tiga kartu tujuan. Kartu tujuan tetap menjadi tempat penyimpanan visual otomatis.
- [ ] Unsur valid yang belum dipakai masuk ke posisi tersedia berikutnya. Foto tidak dibiarkan pada koordinat pelepasan. Decoy, duplikat, dan drop di luar panel tidak menambah poin.
- [ ] Pertahankan feedback maskot dan hitungan 0/3 sampai 3/3. Saat lengkap, gesture drop terakhir tidak sekaligus melewati feedback.
- [ ] Uji drop pada bagian atas, tengah, tepi, dan area kartu panel pada beberapa resolusi, serta reset dan replay. Panel dan kartu tidak berubah proporsi.

**Selesai jika:** seluruh panel menerima unsur dengan aturan yang sama dan penyimpanan otomatis stabil. Bukti: tes posisi/drop dan rekaman sentuhan.

### KIFC-R30-09 — Safari versi penuh

**Status:** Belum dikerjakan. **Area kode/aset:** `assets/audio/`, `lib/core/audio/audioplayers_backend.dart`, `game_audio.dart`, kredit dan `ASSET_SOURCES.md`.

- [ ] Ambil sumber penuh dari URL yang sudah dicatat pada kurasi, verifikasi hash/CC BY 3.0, dan simpan kredit syncopika serta keterangan pengolahan.
- [ ] Siapkan versi runtime yang ringan dengan titik loop yang diperiksa; jangan mengulang cuplikan 30 detik yang memiliki fade-out. Cek awal/akhir sambungan tanpa klik atau jeda mencolok.
- [ ] Sesuaikan mix supaya efek interaksi tetap terbaca. Pertahankan musik, suasana alam, dan efek sebagai lapisan berbeda; jangan mengganti efek jawaban.
- [ ] Uji native/web, mute, pengaturan volume, lifecycle, retry error, pergantian halaman, dan replay tanpa loop bertumpuk. Sediakan pengurangan volume sementara untuk narasi di tiket 17–19 tanpa mengubah setelan volume pengguna secara permanen.

**Selesai jika:** Safari penuh menjadi musik game, aset offline dan kredit lengkap, serta loop/mix diperiksa melalui playback. Bukti: sumber/hash, tes audio, rekaman dan catatan perangkat.

### KIFC-R30-10 — Sumber video kebakaran nyata yang statis

**Status:** Belum dikerjakan. **Area:** aset baru di `assets/animations/` atau lokasi media yang konsisten dengan proyek, `ASSET_SOURCES.md`.

- [ ] Cari footage nyata dengan kamera tetap, tanpa gerakan pan/zoom yang mengganggu, watermark, atau konten yang tidak sesuai untuk edukasi pengunjung.
- [ ] Verifikasi izin penggunaan dalam game/pameran dan modifikasi; catat kreator, URL sumber, lisensi, versi asli, dan perubahan. Hindari aset berbayar tanpa menyampaikan biayanya dahulu.
- [ ] Pilih rentang yang bisa diulang dengan wajar; siapkan crop proporsional, encoding runtime, poster/fallback, dan uji sambungan. Kamera statis bukan bukti loop sudah mulus.
- [ ] Tinjau kesesuaian visual dengan panel hutan dan tiga kartu unsur sebelum integrasi. Jangan mengklaim lokasi footage adalah Indonesia jika tidak dibuktikan sumber.

**Selesai jika:** ada aset berizin, dapat didekode, cukup ringan, dan pratinjau loop yang layak. Bukti: metadata lisensi/hash, durasi/resolusi/ukuran, dan contoh playback.

### KIFC-R30-11 — Background video kebakaran bersama

**Status:** Belum dikerjakan. **Dependensi:** 07, 08, 10. **Area kode:** panel `_FireScene`, komponen media bersama, `pubspec.yaml` bila diperlukan; `test/fire_video_review_test.dart` dan assembly.

- [ ] Ganti titik api lama dengan pergantian background panel: foto hutan selama 0/3–2/3, footage kebakaran setelah 3/3. Gunakan komponen yang sama pada penjelasan Segitiga Api.
- [ ] Pertahankan ukuran panel, tiga kartu unsur, proporsi foto/video, dan keterbacaan overlay. Tidak ada video fullscreen atau animasi api lama yang masih menumpuk.
- [ ] Pilih mekanisme playback yang benar-benar mendukung target Android dan web; catat bila membutuhkan dependensi baru. Footage tidak menambah suara sendiri yang bertabrakan dengan musik/narasi.
- [ ] Kelola preload, transisi, loop, pause/resume, stop/dispose, poster saat error, dan fallback reduced motion. Reset/replay mengembalikan foto hutan tanpa api.
- [ ] Uji offline APK, asset delivery web setelah restart penuh, serta batas 2/3 ke 3/3 tanpa flicker atau pemutar ganda.

**Selesai jika:** pergantian foto/video dan kesinambungan kedua halaman benar, media tidak menutupi konten, serta kegagalan decode tidak membuat aktivitas macet. Bukti: tes state/media, rekaman native/web dan screenshot lintas ukuran.

### KIFC-R30-12 — Naskah dan audisi suara tiga bahasa

**Status:** Belum dikerjakan. **Area:** naskah narasi dan manifest sumber audio baru; referensi teks bacaan di `_KarhutlaCards` dan lokalisasi.

- [ ] Inventaris isi tiga bubble Karhutla dalam ID/EN/KO. Buat sapaan pembuka singkat yang mengajak bermain dan salam penutup singkat yang berterima kasih; jangan mengisi kuis/feedback dengan voice-over.
- [ ] Pilih kandidat voice hangat, ramah, percaya diri, dan bersemangat sesuai ranger; lakukan audisi pendek untuk pengucapan karhutla, gambut, dan nama lembaga jika disebut. Identitas suara antarbasa harus diusahakan konsisten, bukan dijamin tanpa audisi.
- [ ] Periksa Azure AI Speech sebagai usulan, dukungan voice/timing tiap bahasa, akses akun, izin distribusi audio hasil, dan biaya. Catat penyedia/engine/voice yang benar-benar digunakan; alternatif penyedia harus disebut bila usulan tidak dapat dipakai.
- [ ] Siapkan contoh yang konkret dan sampaikan kebutuhan biaya/akses sebelum menjalankan produksi berbayar. Minta penilaian pemilik terhadap karakter suara sebelum membuat seluruh narasi.

**Selesai jika:** naskah tiga bahasa dan voice terpilih dapat ditinjau, pengucapan layak, serta sumber dan biaya jelas. Bukti: naskah, contoh audisi, identitas voice dan catatan pilihan pemilik. Akses belum tersedia berarti Menunggu aset/akses, bukan selesai.

### KIFC-R30-13 — Produksi audio narasi dan timing

**Status:** Belum dikerjakan. **Dependensi:** 12. **Area:** aset audio narasi offline, manifest per halaman/bahasa, indeks timing kata/frasa.

- [ ] Buat set narasi pembuka, tiga bacaan, dan penutup untuk tiga bahasa. Gunakan naskah yang sudah dipilih; penutup harus cukup singkat agar tidak terpotong timer 30 detik.
- [ ] Simpan penyedia, model/voice ID, locale, pengaturan, naskah, durasi, sumber timing, serta hash tiap berkas. Normalisasi secara konsisten tanpa clipping dan periksa kejelasan di atas musik.
- [ ] Peroleh atau siapkan timestamp yang mengikuti ucapan nyata. Jangan memakai kecepatan ketik konstan sebagai pengganti sinkronisasi; penanganan kata/eojel Korea perlu memperhatikan struktur bahasanya.
- [ ] Uji semua berkas dapat didekode offline dan timing tidak melebihi durasi. Cek audio-teks cocok, tidak ada kata hilang atau tertukar locale; catat batas peninjauan penutur bahasa bila belum tersedia.

**Selesai jika:** seluruh halaman bersuara memiliki audio dan timing tiga bahasa yang cocok. Bukti: manifest, berkas, hasil pemeriksaan durasi/decode dan peninjauan naskah-suara.

### KIFC-R30-14 — Prototipe maskot 3D prerender

**Status:** Belum dikerjakan. **Area:** referensi karakter dan aset prototipe; `game_mascot.dart` hanya untuk uji integrasi bila diperlukan.

- [ ] Pertahankan wajah orangutan, topi, seragam, warna, serta logo dada kiri sesuai referensi yang sudah disetujui. Jangan mengganti identitas maskot atau membuat variasi antarhalaman.
- [ ] Buat contoh pendek idle/menyapa dan berbicara dengan kamera tetap. Gerakan mulut sederhana cukup; lip-sync fonem presisi tidak diwajibkan.
- [ ] Buktikan metode produksi dapat menghasilkan latar transparan/hasil compositing yang bersih, loop yang layak, dan logo yang tidak berubah bentuk.
- [ ] Catat alat/model, sumber referensi, izin aset, biaya, ukuran, serta batas kualitasnya. Periksa hasil bersama UI sebelum memproduksi seluruh gerakan; jangan menyamakan image-to-video bergaya 3D dengan model 3D rigged yang dapat diputar bebas.

**Selesai jika:** pemilik menyetujui contoh visual dan jalur produksi yang teruji. Bukti: contoh loop, contoh di atas UI, metadata, serta keputusan visual. Tidak ada komitmen real-time 3D dalam tiket ini.

### KIFC-R30-15 — Paket gerakan maskot yang dapat dipakai ulang

**Status:** Belum dikerjakan. **Dependensi:** 14. **Area:** aset animasi maskot, poster dan manifest state.

- [ ] Produksi state seperlunya: idle ramah, menyapa/mengajak, berbicara/menjelaskan, respons benar/merayakan, respons belum tepat/memberi petunjuk, dan salam perpisahan. Gabungkan gerakan dengan fungsi serupa jika hasilnya tetap jelas.
- [ ] Pakai loop berbicara yang sama untuk tiga bahasa; mulut bergerak hanya selama state berbicara. Tidak perlu satu video baru untuk setiap kalimat.
- [ ] Samakan skala, titik tumpu, pencahayaan, arah hadap, margin aman, crop, serta ketajaman logo. Hindari tangan/kepala terpotong di sisi kiri/kanan.
- [ ] Optimalkan format/resolusi/frame rate berdasarkan uji nyata dan siapkan poster/fallback statis serta reduced motion. Validasi kemampuan decoder/transparansi sebelum menetapkan format seluruh paket.

**Selesai jika:** seluruh state yang dibutuhkan tersedia, konsisten, dan cukup ringan. Bukti: manifest/hash, preview setiap state dan catatan ukuran/playback.

### KIFC-R30-16 — Maskot bergerak lintas halaman

**Status:** Belum dikerjakan. **Dependensi:** 15. **Area kode:** `lib/features/game/widgets/game_mascot.dart`, konsumen maskot di `exhibition_game.dart`, registrasi aset.

- [ ] Petakan seluruh konsumen: pembuka, assembly, penjelasan, bacaan, feedback kuis/penyebab, kartu gambut, ulasan hasil, dan penutup. Konsumen yang dihapus bersama demo tidak dipertahankan.
- [ ] Gunakan satu komponen/state API bersama untuk idle, berbicara, respons benar, petunjuk, dan perpisahan; jangan membuat pemutar terpisah per bubble.
- [ ] Pertahankan penempatan yang sudah disetujui: arah benar/salah, crop setengah badan, kedekatan bubble, dan docking maskot di atas tombol kartu gambut. Animasi tidak boleh mengurangi ukuran jawaban atau menghalangi sentuhan.
- [ ] Feedback hanya bergerak, tidak otomatis diberi TTS atau gerakan mulut yang menyiratkan narasi. Hentikan media di halaman tersembunyi; kelola reset, lifecycle, dispose dan reduced motion.

**Selesai jika:** seluruh kemunculan maskot yang aktif memakai state yang tepat tanpa regresi layout/performa. Bukti: inventaris konsumen, screenshot, rekaman gerakan dan fallback.

### KIFC-R30-17 — Salam penutup bersuara

**Status:** Belum dikerjakan. **Dependensi:** 03, 04, 09, 13, 16. **Area kode:** `_ClosingPage`, pengelola narasi, mixer audio dan timer penutup.

- [ ] Putar salam/terima kasih sekali ketika masuk penutup, sesuai bahasa pengguna; tampilkan gerakan berbicara lalu kembali idle/perpisahan ketika audio selesai.
- [ ] Selesai audio tidak memicu perpindahan. Penutup tetap menunggu timer 30 detik atau tindakan pengguna; jika timer/hak suara belum tersedia, tampilkan fallback teks yang tetap bisa dilanjutkan.
- [ ] Turunkan musik sementara selama narasi, pulihkan sesuai setelan pengguna sesudahnya. Mute tetap berlaku dan tidak mengubah volume sistem.
- [ ] Uji replay, ketuk cepat, navigasi saat berbicara, lifecycle dan audio gagal; tidak ada suara penutup yang tertinggal di sesi baru.

**Selesai jika:** audio penutup dan gerakan benar tanpa mengambil alih aturan timer/manual. Bukti: rekaman tiga bahasa serta regresi timer/lifecycle/audio.

### KIFC-R30-18 — Sapaan pembuka berkala

**Status:** Belum dikerjakan. **Dependensi:** 01, 09, 13, 16. **Area kode:** `_WelcomePage`, lifecycle, pengelola narasi dan kontrol bahasa.

- [ ] Putar sapaan singkat sesuai bahasa yang aktif saat pembuka idle. Gunakan jeda awal yang dapat dikonfigurasi, usulan 20 detik setelah sapaan selesai, lalu nilai kenyamanan pengulangannya.
- [ ] Selesai sapaan tidak memulai tantangan. Mulai, pergantian bahasa, dialog, mute, keluar halaman, background, serta replay harus membatalkan/menyesuaikan jadwal lama; tidak ada panggilan bertumpuk atau dua bahasa berbunyi bersamaan.
- [ ] Pada APK, uji apakah sapaan bisa dimulai saat foreground. Pada web, tangani pembatasan autoplay: bila ditolak, tunggu interaksi pengguna dan lanjutkan secara benar tanpa spam error. Jangan menjanjikan sapaan sebelum interaksi pada semua browser.
- [ ] Selama mute sapaan tidak berbunyi; animasi idle tetap hidup. Setelah unmute tidak memutar antrean sapaan yang terlewat. Nilai interval dan volume dengan musik serta suasana pameran.

**Selesai jika:** sapaan berkala menarik perhatian tanpa mengganggu atau memulai game sendiri. Bukti: rekaman idle beberapa siklus, tes lifecycle/locale dan catatan perbedaan web/APK.

### KIFC-R30-19 — Bacaan dengan narasi dan teks per kata

**Status:** Belum dikerjakan. **Dependensi:** 05, 07, 09, 13, 16. **Area kode:** `_KarhutlaCards`, `_MascotDialogue`, pengelola narasi, lokalisasi dan navigasi bacaan; `test/reading_interaction_test.dart`, `test/chapter2_review_test.dart`.

- [ ] Terapkan hanya pada tiga bacaan definisi, penyebab, dan pencegahan Karhutla. Teks bubble bertambah per kata mengikuti timestamp narasi, bukan langsung penuh; jaga tinggi/lebar bubble agar tidak meloncat tiap kata.
- [ ] Mulai timeline setelah aset narasi siap dan halaman aktif. Selama pemuatan, tampilkan keadaan yang bisa dipahami serta akses lanjut manual; pemuatan gagal tidak boleh melewati penjelasan tanpa kesempatan membaca.
- [ ] Gerakkan mulut maskot selama narasi, turunkan musik, dan selaraskan kemunculan teks dengan posisi audio. Saat pause/lifecycle, teks dan audio berhenti bersama; reduced motion tetap dapat membaca informasi lengkap melalui alternatif yang layak.
- [ ] Selesai narasi pertama/kedua membuka bacaan berikutnya; bacaan ketiga menuju kuis jenis hutan. Ketuk layar saat bacaan aktif langsung melewati satu halaman dan menghentikan audio lama, bukan sekadar menampilkan seluruh teks dahulu.
- [ ] Pertahankan prioritas tombol Kembali, suara, dialog, dan kontrol manual. Tangani ketuk berulang serta ketuk bersamaan event audio selesai dengan satu transisi saja. Callback lama tidak boleh melewati halaman baru atau pertanyaan.
- [ ] Saat mute, gunakan timeline teks dengan durasi rekaman sebagai dasar kelanjutan otomatis; jangan membuat game menunggu audio yang sengaja dimatikan. Saat audio gagal, sediakan teks lengkap dan kelanjutan manual tanpa deadlock; catat fallback kepada pengguna secara wajar.
- [ ] Uji tiga bahasa, jeda/resume, kembali lalu masuk lagi, audio decode gagal, subtitle panjang, batas akhir timestamp, dan perpindahan menuju kuis yang belum dijawab.

**Selesai jika:** ucapan, gerakan mulut, teks, serta perpindahan selaras dan seluruh isi penjelasan dapat diakses saat suara gagal/mute. Bukti: regresi event/timing dan rekaman ketiga bacaan dalam tiga bahasa.

### KIFC-R30-20 — Verifikasi terpadu dan paket hasil revisi

**Status:** Belum dikerjakan. **Dependensi:** 01–19. **Area:** tes, alat journey, indeks bukti, build web/APK, dan panduan paket klien.

- [ ] Jalankan analisis dan suite regresi yang relevan, lalu perbarui perjalanan E2E agar tidak lagi mengunjungi demo. Pastikan skor maksimum 8, retry gambut, dan informasi tanpa skor tetap benar.
- [ ] Mainkan alur tiga bahasa pada web dan APK: idle/sapaan, drop/3 unsur/video, penjelasan, tiga bacaan bersuara/skip, kuis, penyebab, kartu gambut, tantangan selesai lebih awal/deadline, ulasan/skor, penutup 30 detik dan replay.
- [ ] Uji audio/mute/unmute, musik diturunkan saat narasi, gagal decode, lifecycle, pemutar/timer tidak bocor, serta seluruh aset offline. Verifikasi hash aset dan kode APK agar tidak mengirim build lama.
- [ ] Lengkapi screenshot lima ukuran, rekaman animasi/audio, dan pengujian pada TV fisik jika tersedia. Catat batas bukti performa, jangkauan dan kenyamanan speaker; pisahkan yang belum dapat dibuktikan dari yang lulus.
- [ ] Perbarui panduan bermain/instalasi, kredit, informasi versi dan checksum. Buat APK/ZIP review yang baru; jangan menimpa paket 1.0.5 lama atau menyebutnya sudah berisi revisi ini.
- [ ] Tandai per tiket yang telah ditinjau. Push/deploy/distribusi mengikuti instruksi pemilik pada tahap rilis; paket review tidak otomatis berarti semua hasil visual/suara disahkan klien.

**Selesai jika:** perubahan diuji sebagai satu pengalaman yang utuh, artifact dan panduan cocok dengan versi baru, serta laporan mencatat hasil dan batas pemeriksaannya secara jujur.

## Pemetaan daftar klien ke tiket

| Permintaan klien | Tiket |
|---|---|
| Hilangkan caption pembuka | 01 |
| Ganti musik ke A3/Safari penuh | 09 |
| Maskot 3D bergerak di seluruh game | 14, 15, 16 |
| Maskot berbicara tiga bahasa pada area tertentu | 12, 13, 17, 18, 19 |
| Drop di mana saja pada panel dan simpan otomatis | 08 |
| Ganti animasi api dengan video nyata setelah lengkap dan halaman berikutnya | 10, 11 |
| Hapus Demo Interaktif | 07 |
| Bacaan Babak 2: suara, teks per kata, auto/ketuk lanjut | 12, 13, 19 |
| Susunan judul “Tapi,” | 05 |
| Hilangkan keterangan sesudah slash pada label babak | 02 |
| Tantangan 30 detik dengan penyelesaian lebih awal | 06 |
| Penutup bersuara, kapitalisasi judul, timer 30 detik | 03, 04, 17 |
| Bukti hasil, tes terpadu, dan paket versi terbaru | 20, ditambah kriteria bukti tiap tiket |

## Log pelaksanaan

Status diperbarui setelah implementasi dan pemeriksaan nyata. Selesai secara implementasi tidak menyatakan uji TV fisik atau persetujuan visual klien.

| Tanggal | Tiket | Perubahan status | Commit implementasi | Bukti dan hasil pemeriksaan | Peninjau / catatan |
|---|---|---|---|---|---|
| 30 Oktober 2026 | KIFC-R30-01 | Belum dikerjakan → Selesai implementasi | `9e21c95` | 23 tes lulus; analisis bersih; 15 render tiga bahasa/lima viewport diperiksa | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-02 | Belum dikerjakan → Selesai implementasi | `9644ce8` | 57 tes lulus; analisis bersih; 180 render dan contact sheet tiga bahasa | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-03 | Belum dikerjakan → Selesai implementasi | `0023de3` | 15 pemeriksaan visual + 24 regresi lulus; analisis bersih; 15 render diperiksa | Pemeriksaan internal; timer masih 15 detik sesuai batas tiket |
| 30 Oktober 2026 | KIFC-R30-04 | Belum dikerjakan → Selesai implementasi | Dicatat setelah commit | 40 tes lulus; analisis bersih; 15 render diperiksa; red/green timer | Pemeriksaan internal; TV fisik belum diuji |
