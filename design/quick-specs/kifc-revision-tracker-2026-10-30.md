# Tracker revisi KIFC 30 Oktober 2026

Sumber: daftar revisi klien yang disampaikan pemilik proyek dan klarifikasinya dalam percakapan 30 Oktober 2026. Tujuan dokumen ini adalah memetakan pekerjaan, cara penerapan, dependensi, dan bukti penyelesaiannya. Pembuatan tracker tidak berarti revisi game sudah diimplementasikan.

**Status terkini: 0 Belum dikerjakan, 3 Dikerjakan, 4 Siap ditinjau, 13 Selesai secara implementasi.**

ID `KIFC-R30-01` sampai `KIFC-R30-20` khusus untuk putaran ini, bukan nomor halaman atau babak. Riwayat lama tetap disimpan di [tracker 23 Oktober](kifc-screen-revision-tracker-2026-10-23.md). Status pekerjaan lama tidak dipindahkan menjadi status selesai untuk kebutuhan baru.

## Keputusan dan batas cakupan

- Target yang sebelumnya diberikan pemilik adalah **Samsung QM43B-T, 43 inci 4K, Tizen 6.5**. Model ini terlewat saat persiapan simulator dan dipulihkan dari percakapan 3 November. TV fisik belum tersedia; simulator resmi hanya lapisan uji tambahan. WGT percobaan mensyaratkan Tizen 10 dan **bukan paket target QM43B-T**. Performa FPS/RAM/respons sentuh pada target belum diukur. Pengujian Android tetap ditunda atas instruksi pemilik. [Koreksi target, cakupan dan hasil](../../docs/client-revisions/2026-11-03/r30-20/README.md).

- Musik pilihan final adalah **Safari oleh syncopika versi penuh**. `a3-0-30s.mp3` adalah cuplikan acuan, bukan berkas loop produksi. Kredit dan lisensi CC BY 3.0 harus dicantumkan. Sumber pilihan ada di [kurasi putaran kedua](../../docs/audio-options/2026-10-29/round-2/sources.json).
- Keputusan pemilik 2 November menggantikan rencana prerender: gunakan GLB rigged langsung di Flutter, bersumber dari `Welcome_Wave/Review/Manggala_WELCOME_WAVE_30s_REVIEW.glb` dengan kamera `CAM-UserApprovedView`. Pertahankan enam klip asli, material, tekstur, badge dan morph. Wave welcome terus bergerak dengan mulut aktif; feedback tanpa narasi memakai varian tanpa gerak mulut. Suara tetap diintegrasikan pada R30-17–19.
- Revisi pemilik 3 November: paket sumber diperbarui ke `Camera_Facing_Revisions/Review/Manggala_CAMERA_FACING_REVISIONS_REVIEW.glb` (Talk/Happy/Feedback revisi). Hilangkan label penyiapan pada Karhutla, besarkan maskot terhadap teks, dan kurangi pemuatan ulang. [Bukti tindak lanjut](../../docs/client-revisions/2026-11-03/mascot-review-revisions/README.md): 107 tes, 21 screenshot web, pergantian klip tanpa load tambahan. APK baru terpasang; Talk, Happy, layout dan retensi renderer antarbacaan juga diuji pada Android terhubung setelah perangkat dibuka. Uji TV fisik tetap tertunda.
- Narasi hanya untuk sapaan pembuka, **tiga halaman bacaan Karhutla**, dan salam penutup. Kuis jenis hutan dan seluruh feedback **tidak menggunakan narasi**; maskotnya tetap bergerak.
- Bahasa tetap Indonesia, Inggris, dan Korea, mengikuti pilihan pengguna. Isi narasi Karhutla mengikuti teks penjelasan yang sekarang, tanpa menambah materi baru. Pembuka dan penutup memakai naskah singkat yang sesuai fungsinya.
- Pemilik memilih **ElevenLabs** dengan voice `mw_animated_The Plucky Hero` dan menyatakan peninjauan suara, pengaturan/biaya, serta penggunaan telah selesai. Angka kredit aktual dan pengaturan rinci tidak diberikan dalam percakapan dan tidak diada-adakan.
- Pembuka menunggu tombol Mulai meskipun sapaan selesai. Sapaan diulang saat idle; **20 detik setelah sapaan selesai adalah nilai awal usulan**, bukan angka yang ditetapkan klien. Dapat disesuaikan setelah didengarkan dalam konteks pameran.
- Hanya bacaan Karhutla yang berpindah otomatis ketika narasinya selesai. Ketuk untuk melewati harus menghentikan suara dan berpindah satu halaman. Kuis tidak boleh dilewati oleh perilaku ini.
- Revisi 3 November: ketiga bacaan Babak 2 memberi jeda sekitar 1 detik setelah narasi selesai sebelum maju otomatis, termasuk sebelum kuis. Teks lengkap tetap terlihat; ketukan/tombol Lanjut dapat maju langsung. [Perilaku dan pengujian](../../docs/client-revisions/2026-11-03/reading-completion-delay/README.md).
- Penutup tidak berpindah karena audio selesai. Timer khusus penutup menjadi **30 detik**, tetap bisa dilanjutkan lebih cepat lewat ketukan. Feedback dan hasil lain tetap **15 detik**, kecuali direvisi lagi.
- Hapus hanya demo pengurangan unsur. Halaman penjelasan Segitiga Api tetap ada. Skor maksimum tetap **8**, karena demo yang dihapus tidak memiliki poin.
- Video kebakaran berupa rekaman nyata dengan framing stabil (stabilisasi diperbolehkan), dipakai pada panel setelah 3/3 unsur dan halaman penjelasan Segitiga Api. Tetap ada hutan tanpa kebakaran sebelum lengkap. Framing stabil tidak otomatis menjamin loop mulus.
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
| KIFC-R30-04 | Ubah timer khusus penutup menjadi 30 detik | Penutup terakhir | Mudah | Tidak ada | Selesai | `9630b86` |
| KIFC-R30-05 | Rapikan susunan judul Karhutla pertama | Bacaan Karhutla 1 | Mudah | Tidak ada | Selesai | `618a1ce` (koreksi) |
| KIFC-R30-06 | Tambahkan tombol akhiri tantangan lebih awal | Tantangan akhir | Sedang | Tidak ada | Selesai | `41384fa` |
| KIFC-R30-07 | Hapus demo pengurangan dan sambungkan navigasi | Babak 1 dan transisi ke Babak 2 | Sedang | Tidak ada | Selesai | `d069340` |
| KIFC-R30-08 | Terima drop di seluruh panel unsur | Penyusunan unsur | Sedang | Tidak ada | Selesai | `d62bbae` (koreksi) |
| KIFC-R30-09 | Terapkan Safari versi penuh | Musik lintas game | Sedang | Sumber penuh dan lisensi | Dikerjakan: native belum terverifikasi | `c713309` |
| KIFC-R30-10 | Cari dan siapkan video kebakaran kamera statis | Aset panel hutan | Sedang, bergantung aset | Sumber dan izin penggunaan | Selesai: persetujuan visual pada 11 direkonsiliasi | `0961f1c` |
| KIFC-R30-11 | Integrasikan background video kebakaran bersama | Penyusunan lengkap dan penjelasan Segitiga Api | Menengah–sulit | 07, 08, 10 | Dikerjakan: visual disetujui, uji offline tertunda | `72c8941` |
| KIFC-R30-12 | Finalisasi naskah dan audisi suara maskot | Pembuka, tiga bacaan, penutup | Menengah–sulit | Akses TTS dan peninjauan suara | Selesai: disetujui pemilik | `8aba569` |
| KIFC-R30-13 | Produksi narasi tiga bahasa dan data timing | Aset narasi | Sulit | 12 | Selesai: draf diterima pemilik | `f145844` |
| KIFC-R30-14 | Buktikan desain maskot 3D langsung dari GLB | Prototipe aset maskot | Sulit | Referensi dan akses produksi | Selesai: sumber final dipilih pemilik dan prototipe web teruji | `4203eda` |
| KIFC-R30-15 | Produksi gerakan maskot yang dapat dipakai ulang | Aset animasi maskot | Sulit | 14 | Selesai: paket runtime, poster dan varian silent tersedia | `786ab35` |
| KIFC-R30-16 | Integrasikan animasi maskot di seluruh halaman | Semua kemunculan maskot | Sulit | 15 | Siap ditinjau: web dan Android teruji, review visual pemilik tersisa | `c78f2cc` |
| KIFC-R30-17 | Tambahkan salam bersuara pada penutup | Penutup terakhir | Sulit karena dependensi | 03, 04, 09, 13, 16 | Siap ditinjau: Android tiga bahasa dan regresi teruji | `d1a4278` integrasi bersama |
| KIFC-R30-18 | Tambahkan sapaan idle berkala | Pembuka | Sulit | 01, 09, 13, 16 | Siap ditinjau: playback web/Android teruji, review kenyamanan tersisa | `d1a4278` integrasi bersama |
| KIFC-R30-19 | Sinkronkan narasi, teks per kata, dan navigasi bacaan | Tiga bacaan Karhutla | Paling sulit secara integrasi | 05, 07, 09, 13, 16 | Siap ditinjau: playback dan teks teruji; timing perkiraan perlu didengar | `d1a4278` integrasi bersama |
| KIFC-R30-20 | Verifikasi terpadu dan kemas hasil revisi | Web, APK dan Samsung Tizen | Luas, lintas fitur | 01–19 | Dikerjakan: paket review dan simulator tersedia; Android ditunda pemilik | `ab13abf` checkpoint verifikasi; belum selesai |

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

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** `_KarhutlaCards`, komponen judul stage, dan lokalisasi; `test/chapter2_review_test.dart`.

- [x] Koreksi terbaru pemilik: judul Indonesia tepat dua baris, “Tapi, Apa Itu” lalu “Kebakaran Hutan?”. Ini menggantikan susunan “Tapi,” sendirian pada versi awal. Kata “Hutan?” tidak boleh menjadi baris yatim.
- [x] Izinkan kelompok judul membungkus secara wajar pada layar kecil; jangan memaksakan satu baris hingga font terlalu kecil. Inggris/Korea mengikuti struktur bahasa masing-masing.
- [x] Periksa lima viewport tiga bahasa dengan area maskot dan narasi tetap cukup.

**Selesai jika:** hierarki judul terbaca dan tidak ada kata terakhir yang terpencil. Bukti: screenshot bacaan pertama.

**Bukti terbaru:** [Koreksi dua baris tiket 05](../../docs/client-revisions/2026-10-30/r30-05-two-lines-review.md). [Review awal](../../docs/client-revisions/2026-10-30/r30-05-review.md) disimpan sebagai riwayat.

### KIFC-R30-06 — Tombol menyelesaikan tantangan lebih awal

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** `_FinalChallenge` dan timer tantangan; `test/impact_review_test.dart`, `test/feedback_timing_test.dart`.

- [x] Tambahkan tombol berlabel jelas, misalnya “Selesai Memilih”, pada area jangkauan tengah tanpa mengecilkan kartu.
- [x] Satukan penyelesaian lewat tombol dan waktu habis ke satu aksi yang hanya berjalan sekali: kunci pilihan, hentikan timer, buka ulasan menggunakan pilihan saat itu.
- [x] Pertahankan pilihan netral sebelum selesai, rumus bonus, dan 30 detik maksimum. Tidak ada narasi atau efek yang membocorkan jawaban.
- [x] Uji nol/sebagian/semua pilihan, pembatalan pilihan, ketukan cepat berulang, dan tombol ditekan bersamaan dengan deadline. Tombol hanya tampil saat tantangan aktif.

**Selesai jika:** pengunjung dapat menyelesaikan kapan saja tanpa penilaian/navigasi ganda; ulasan dan skor tetap akurat. Bukti: tes interaksi, screenshot, rekaman.

**Bukti:** [Review tiket 06](../../docs/client-revisions/2026-10-30/r30-06-review.md).

### KIFC-R30-07 — Hapus demo pengurangan unsur

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** enum halaman, navigasi, `_BreakTriangle`, state/timer terkait di `exhibition_game.dart`; tes alur, reading, dan feedback.

- [x] Hapus halaman demo, tombol yang mengajak mengurangi unsur, syarat mencoba ketiga unsur, dan state khusus demo yang tidak dipakai lagi.
- [x] Sambungkan halaman Penjelasan Segitiga Api langsung ke bacaan Karhutla pertama; sesuaikan tombol lanjut dan jalur Kembali agar tidak menuju halaman yang dihapus.
- [x] Pertahankan penjelasan Segitiga Api dan skor maksimum 8. Sesuaikan tes/alat journey serta dokumentasi aturan yang sebelumnya mewajibkan demo.
- [x] Uji maju, kembali, ulangi, replay, dan timer yang masih aktif setelah halaman dihapus.

**Selesai jika:** demo tidak lagi dapat dicapai, penjelasan tetap ada, dan tidak ada jalan buntu atau loncatan soal. Bukti: regresi alur dan rekaman perjalanan Babak 1 ke Babak 2.

**Bukti:** [Review tiket 07](../../docs/client-revisions/2026-10-30/r30-07-review.md).

### KIFC-R30-08 — Drop di seluruh panel unsur

**Status:** Selesai secara implementasi; belum merupakan pengesahan klien. **Area kode:** `_TriangleBuild`, `_FireScene`, penerimaan drop dan `_dropPiece`; `test/assembly_review_test.dart`.

- [x] Jadikan seluruh batas panel hutan target drop, bukan hanya tiga kartu tujuan. Hanya kartu unsur yang sudah terisi ditampilkan; sebelum itu tidak ada placeholder, tanda plus atau label kosong. Foto hutan memenuhi seluruh panel sampai bawah.
- [x] Unsur valid yang belum dipakai masuk ke posisi tersedia berikutnya. Foto tidak dibiarkan pada koordinat pelepasan. Decoy, duplikat, dan drop di luar panel tidak menambah poin.
- [x] Pertahankan feedback maskot dan hitungan 0/3 sampai 3/3. Saat lengkap, gesture drop terakhir tidak sekaligus melewati feedback.
- [x] Uji drop pada bagian atas, tengah, tepi, dan area kartu panel pada beberapa resolusi, serta reset dan replay. Panel dan kartu tidak berubah proporsi.

**Selesai jika:** seluruh panel menerima unsur dengan aturan yang sama dan penyimpanan otomatis stabil. Bukti: tes posisi/drop dan rekaman sentuhan.

**Bukti terbaru:** [Koreksi hutan penuh tanpa placeholder](../../docs/client-revisions/2026-10-30/r30-08-full-forest-review.md). [Review awal](../../docs/client-revisions/2026-10-30/r30-08-review.md) disimpan sebagai riwayat.

### KIFC-R30-09 — Safari versi penuh

**Status:** Implementasi dan pengujian widget selesai; pemeriksaan native belum terverifikasi. **Area kode/aset:** `assets/audio/`, `lib/core/audio/audioplayers_backend.dart`, `game_audio.dart`, kredit dan `ASSET_SOURCES.md`.

- [x] Ambil sumber penuh dari URL yang sudah dicatat pada kurasi, verifikasi hash/CC BY 3.0, dan simpan kredit syncopika serta keterangan pengolahan.
- [x] Siapkan versi runtime yang ringan dengan titik loop yang diperiksa; jangan mengulang cuplikan 30 detik yang memiliki fade-out. Cek awal/akhir sambungan tanpa klik atau jeda mencolok.
- [x] Sesuaikan mix supaya efek interaksi tetap terbaca. Pertahankan musik, suasana alam, dan efek sebagai lapisan berbeda; jangan mengganti efek jawaban.
- [ ] Uji native/web, mute, pengaturan volume, lifecycle, retry error, pergantian halaman, dan replay tanpa loop bertumpuk. Sediakan pengurangan volume sementara untuk narasi di tiket 17–19 tanpa mengubah setelan volume pengguna secara permanen.

**Selesai jika:** Safari penuh menjadi musik game, aset offline dan kredit lengkap, serta loop/mix diperiksa melalui playback. Bukti: sumber/hash, tes audio, rekaman dan catatan perangkat.

**Bukti dan batas pengujian:** [Review 09](../../docs/client-revisions/2026-10-30/r30-09-review.md).

### KIFC-R30-10 — Sumber video kebakaran nyata yang statis

**Status:** Selesai secara implementasi. Persetujuan visual footage pada tiket 11 direkonsiliasi dengan tiket sumber 10; hash aset runtime sama dengan commit `0961f1c`. Tidak meminta persetujuan ulang untuk footage yang sama. Stabilisasi diizinkan pemilik; kandidat pembakaran ranting tetap ditolak. **Area:** aset baru di `assets/animations/` atau lokasi media yang konsisten dengan proyek, `ASSET_SOURCES.md`.

- [x] Cari footage nyata dengan framing tetap (stabilisasi diperbolehkan), tanpa gerakan pan/zoom yang mengganggu, watermark, atau konten yang tidak sesuai untuk edukasi pengunjung.
- [x] Verifikasi izin penggunaan dalam game/pameran dan modifikasi; catat kreator, URL sumber, lisensi, versi asli, dan perubahan. Hindari aset berbayar tanpa menyampaikan biayanya dahulu.
- [x] Pilih rentang yang bisa diulang dengan wajar; siapkan crop proporsional, encoding runtime, poster/fallback, dan uji sambungan. Kamera statis bukan bukti loop sudah mulus.
- [x] Tinjau kesesuaian visual melalui simulasi proporsi panel dan tiga kartu unsur sebelum integrasi (belum screenshot Flutter). Jangan mengklaim lokasi footage adalah Indonesia jika tidak dibuktikan sumber.

**Selesai jika:** ada aset berizin, dapat didekode, cukup ringan, dan pratinjau loop yang layak. Bukti: metadata lisensi/hash, durasi/resolusi/ukuran, dan contoh playback.

**Bukti dan batas:** [Review kandidat 10](../../docs/client-revisions/2026-10-30/r30-10-review.md).

### KIFC-R30-11 — Background video kebakaran bersama

**Status:** Sedang dikerjakan. Pemilik menyetujui hasil visual setelah melihat bukti; implementasi dan playback web/ponsel diperiksa. Uji offline terpisah dan pemeriksaan media lain di bawah masih tertunda. **Commit implementasi:** `72c8941`. **Dependensi:** 07, 08, 10. **Area kode:** panel `_FireScene`, komponen media bersama, `pubspec.yaml` bila diperlukan; `test/fire_video_review_test.dart` dan assembly.

- [x] Ganti titik api lama dengan pergantian background panel: foto hutan selama 0/3–2/3, footage kebakaran setelah 3/3. Gunakan komponen yang sama pada penjelasan Segitiga Api.
- [x] Pertahankan ukuran panel, tiga kartu unsur, proporsi foto/video, dan keterbacaan overlay. Tidak ada video fullscreen atau animasi api lama yang masih menumpuk.
- [x] Sesuaikan exposure dan saturasi foto kartu unsur agar selaras dengan footage kebakaran, sambil menjaga label dan gambar tetap mudah dikenali. Hasil visual disetujui pemilik.
- [ ] Tinjau ketajaman video runtime di panel pada simulasi TV portrait dan perangkat aktual bila tersedia; bandingkan dengan sumber sebelum memutuskan apakah encoding perlu ditingkatkan.
- [x] Gunakan `video_player` untuk playback Android dan web; footage dibungkam. Playback diperiksa di browser dan ponsel TECNO.
- [ ] Kelola preload, transisi, loop, pause/resume, stop/dispose, poster saat error, dan fallback reduced motion. Reset/replay mengembalikan foto hutan tanpa api.
- [ ] Uji offline APK, asset delivery web setelah restart penuh, serta batas 2/3 ke 3/3 tanpa flicker atau pemutar ganda.

**Selesai jika:** pergantian foto/video dan kesinambungan kedua halaman benar, media tidak menutupi konten, serta kegagalan decode tidak membuat aktivitas macet. Bukti: tes state/media, rekaman native/web dan screenshot lintas ukuran.

**Progres 30 Oktober:** implementasi awal video dan pewarnaan kartu; 50 tes layout/alur pada salinan verifikasi lulus, 15 render widget tiga bahasa/lima ukuran menampilkan poster, dan video berjalan muted/loop pada build web yang disajikan dari port terverifikasi. Build APK bersih memuat video/poster dan berjalan di ponsel TECNO 720×1640; dua frame menunjukkan video bergerak, rekaman 14 detik dan log init/release tersedia. Pemilik menyetujui hasil visual setelah peninjauan. Pengujian dengan jaringan benar-benar terputus serta pemeriksaan lifecycle, fallback, dan ketajaman pada TV fisik masih tertunda; screenshot widget bukan bukti video bergerak atau uji TV fisik. Bukti lokal: `build/review-r30-11/`; rincian: [catatan verifikasi 11](../../docs/client-revisions/2026-10-30/r30-11-review.md).

### KIFC-R30-12 — Naskah dan audisi suara tiga bahasa

**Status:** Selesai berdasarkan konfirmasi pemilik pada 1 November 2026. **Penyedia:** ElevenLabs; **voice:** `mw_animated_The Plucky Hero` (`QZt6b1wd97jPRMrPdClY`). Pemilik membuat 15 file melalui web dan menyatakan peninjauan suara, pengaturan/biaya, serta penggunaan sudah selesai. Nilai kredit aktual dan pengaturan yang dipakai tidak diberikan sehingga tidak dicatat sebagai angka pasti.

- [x] Inventaris tiga bubble Babak 2 dalam ID/EN/KO dan siapkan sapaan serta penutup; teks Babak 2 mengikuti konten final.
- [x] Pilih voice dan tinjau hasil tiga bahasa berdasarkan konfirmasi pemilik.
- [x] Catat penyedia yang dipilih: ElevenLabs, menggantikan usulan Azure; status biaya dan penggunaan dikonfirmasi pemilik tanpa rincian angka aktual.
- [x] Siapkan dan terima contoh serta seluruh 15 file narasi dari pemilik. Semua file berhasil didekode; dua nama file Inggris yang tertukar sudah dikoreksi.

**Bukti:** [naskah](../../docs/client-revisions/2026-10-30/narration/naskah.md), [catatan suara dan file](../../docs/client-revisions/2026-10-30/narration/voice-research.md). Peninjauan rincian audio/timing dan penyelarasan teks pembuka/penutup dikerjakan pada tiket berikutnya.

### KIFC-R30-13 — Produksi audio narasi dan timing

**Status:** Selesai untuk persiapan aset dan draf timing sesuai penerimaan pemilik. Integrasi subtitle bertahap dan penanganan span gabungan dilakukan pada KIFC-R30-19. **Dependensi:** 12. **Area:** aset audio narasi offline, manifest per halaman/bahasa, indeks timing kata/frasa.

- [ ] Buat set narasi pembuka, tiga bacaan, dan penutup untuk tiga bahasa. Gunakan naskah yang sudah dipilih; penutup harus cukup singkat agar tidak terpotong timer 30 detik.
- [ ] Simpan penyedia, model/voice ID, locale, pengaturan, naskah, durasi, sumber timing, serta hash tiap berkas. Normalisasi secara konsisten tanpa clipping dan periksa kejelasan di atas musik.
- [ ] Peroleh atau siapkan timestamp yang mengikuti ucapan nyata. Jangan memakai kecepatan ketik konstan sebagai pengganti sinkronisasi; penanganan kata/eojel Korea perlu memperhatikan struktur bahasanya.
- [ ] Uji semua berkas dapat didekode offline dan timing tidak melebihi durasi. Cek audio-teks cocok, tidak ada kata hilang atau tertukar locale; catat batas peninjauan penutur bahasa bila belum tersedia.

**Selesai jika:** seluruh halaman bersuara memiliki audio tiga bahasa yang cocok; timing per kata dibutuhkan khusus untuk tiga bacaan Babak 2. Bukti: manifest, berkas, hasil pemeriksaan durasi/decode dan peninjauan naskah-suara.

**Progres 1 November:** 15 salinan dinormalisasi dan terdekode; timing ASR disiapkan sebagai draf dengan 18 bagian ditandai untuk tinjauan, 11 berupa frasa multi-kata. Kelima belas file sudah masuk bundle Flutter dan hash cocok. Campuran musik dan draf timing yang ditampilkan diterima oleh pemilik; sinkronisasi bertahap diuji saat integrasi KIFC-R30-19. [Bukti dan alat tinjau](../../docs/client-revisions/2026-10-30/narration/r30-13-preparation.md).

### KIFC-R30-14 — Prototipe maskot 3D langsung dari GLB

**Status:** Selesai sebagai pembuktian konsep dan pilihan jalur produksi, sesuai sumber final dan arahan integrasi pemilik pada 2 November. GLB menggantikan rencana prerender. **Commit:** `4203eda`. **Area:** aset, kamera dan prototipe welcome web.

- [x] Aset final dipilih/diberikan pemilik; salinan dan respons HTTP memiliki hash sama. Identitas, material, tekstur, badge dan morph tidak diedit.
- [x] Idle, Talk, Wave, Happy, Feedback dan PointIdle tersedia, masing-masing 30 detik. Gerak tulang dan mulut diuji di Flutter Web.
- [x] Kamera approved, latar transparan dan loop Wave diuji di UI; arah wajah diperiksa pada 901 sampel, galat maksimum sekitar 0,0000282 derajat.
- [x] Sumber adalah aset proyek yang diberikan pemilik; integrasi tidak memakai layanan berbayar baru. GLB 7.025.064 bytes. Pipeline sumber mencatat Blender 5.2.3; renderer aplikasi memakai model-viewer. Biaya dan rincian produksi awal yang tidak tercatat tidak diasumsikan.

**Bukti:** [laporan welcome](../../docs/reviews/welcome-continuous-wave/README.md), [hasil runtime](../../docs/reviews/welcome-continuous-wave/runtime-result.txt) dan screenshot portrait 411/1080/2160. Peninjau teknis: agen. Pemilik menentukan sumber, kamera dan Wave, kemudian meminta lanjut ke R30-16. Status ini bukan sertifikasi Android/TV fisik; fallback dan ketajaman ditangani pada paket/integrasi berikutnya.

### KIFC-R30-15 — Paket gerakan maskot yang dapat dipakai ulang

**Status:** Selesai untuk paket aset yang diuji di renderer web. Enam klip sumber dipertahankan; varian tanpa ucapan dan tujuh poster transparan tersedia. **Dependensi:** 14. **Area:** aset animasi maskot, poster dan manifest state.

- [x] Produksi state seperlunya: idle ramah, menyapa/mengajak, berbicara/menjelaskan, respons benar/merayakan, respons belum tepat/memberi petunjuk, dan salam perpisahan. Gabungkan gerakan dengan fungsi serupa jika hasilnya tetap jelas.
- [x] Pakai loop berbicara yang sama untuk tiga bahasa; mulut bergerak hanya selama state berbicara. Tidak perlu satu video baru untuk setiap kalimat.
- [x] Samakan skala, titik tumpu, pencahayaan, arah hadap, margin aman, crop, serta ketajaman logo. Hindari tangan/kepala terpotong di sisi kiri/kanan.
- [x] Optimalkan format/resolusi/frame rate berdasarkan uji nyata dan siapkan poster/fallback statis serta reduced motion. Validasi kemampuan decoder/transparansi sebelum menetapkan format seluruh paket.

**Selesai jika:** seluruh state yang dibutuhkan tersedia, konsisten, dan cukup ringan. Bukti: manifest/hash, preview setiap state dan catatan ukuran/playback.


**Bukti 2 November:** [paket runtime](../../docs/client-revisions/2026-11-02/r30-15/README.md), manifest/hash, tujuh poster RGBA, enam klip asli ditambah tiga varian silent. Tidak ada pembelian baru. Perpisahan memakai WaveSilent; Talk/Feedback/Wave asli tetap menyimpan mulut untuk konteks bersuara dan welcome. Varian hanya mengganti track bobot morph; seluruh payload binary asli menjadi prefix yang identik. Pemilik memilih model/kamera/gerakan sumber dan meminta lanjut; peninjau teknis: agen. Uji native/hardware dan kenyamanan performa perangkat target tetap pada R30-20.

### KIFC-R30-16 — Maskot bergerak lintas halaman

**Status:** Siap ditinjau pemilik; komponen lintas halaman diuji pada web dan Android terhubung. **Dependensi:** 15. **Area kode:** `lib/features/game/widgets/game_mascot.dart`, renderer/lifecycle bersama, konsumen di `exhibition_game.dart`, registrasi aset.

- [x] Petakan seluruh konsumen: pembuka, assembly, penjelasan, bacaan, feedback kuis/penyebab, kartu gambut, ulasan hasil, dan penutup. Konsumen yang dihapus bersama demo tidak dipertahankan.
- [x] Gunakan satu komponen/state API bersama untuk idle, berbicara, respons benar, petunjuk, dan perpisahan; jangan membuat pemutar terpisah per bubble.
- [x] Pertahankan penempatan yang sudah disetujui: arah benar/salah, crop setengah badan, kedekatan bubble, dan docking maskot di atas tombol kartu gambut. Animasi tidak boleh mengurangi ukuran jawaban atau menghalangi sentuhan.
- [x] Feedback hanya bergerak, tidak otomatis diberi TTS atau gerakan mulut yang menyiratkan narasi. Hentikan media di halaman tersembunyi; kelola reset, lifecycle, dispose dan reduced motion.

**Selesai jika:** seluruh kemunculan maskot yang aktif memakai state yang tepat tanpa regresi layout/performa. Bukti: inventaris konsumen, screenshot, rekaman gerakan dan fallback.

**Bukti 2 November:** [indeks R30-16](../../docs/client-revisions/2026-11-02/r30-16/README.md), 105 capture browser pada lima viewport dan tiga bahasa, 14 pemeriksaan interaksi web, perjalanan Android nyata dan 10 capture fixture halaman asli pada TECNO LG7n Android 12. Skeletal, morph, loop 30 detik dan penghentian welcome teruji. Input WebView Android diperbaiki dengan hybrid composition; overflow judul kuis pada layar sempit diperbaiki tanpa mengecilkan jawaban. Analisis bersih, 447 tes lulus, build web/APK debug berhasil. Peninjau teknis: agen; persetujuan visual akhir pemilik dan uji TV fisik/performa berkepanjangan masih tersisa. Narasi R30-17–19 telah diintegrasikan pada 3 November dan menunggu review akhir sebagaimana tiket terkait.

### KIFC-R30-17 — Salam penutup bersuara

**Status:** Siap ditinjau: playback Android tiga bahasa, state mulut, mixer dan regresi dasar teruji. Penutup tidak memiliki subtitle narasi. **Dependensi:** 03, 04, 09, 13, 16. **Area kode:** `_ClosingPage`, pengelola narasi, mixer audio dan timer penutup.

- [x] Putar salam/terima kasih sekali ketika masuk penutup, sesuai bahasa pengguna; tampilkan gerakan berbicara lalu kembali idle/perpisahan ketika audio selesai.
- [x] Selesai audio tidak memicu perpindahan. Penutup tetap menunggu timer 30 detik atau tindakan pengguna; jika timer/hak suara belum tersedia, tampilkan fallback teks yang tetap bisa dilanjutkan.
- [x] Turunkan musik sementara selama narasi, pulihkan sesuai setelan pengguna sesudahnya. Mute tetap berlaku dan tidak mengubah volume sistem.
- [x] Uji replay, ketuk cepat, navigasi saat berbicara, lifecycle dan audio gagal; tidak ada suara penutup yang tertinggal di sesi baru.

**Selesai jika:** audio penutup dan gerakan benar tanpa mengambil alih aturan timer/manual. Bukti: rekaman tiga bahasa serta regresi timer/lifecycle/audio.

**Bukti 3 November:** [laporan integrasi](../../docs/client-revisions/2026-11-03/r30-17-18/README.md). Android: tiga bahasa, Wave/morph lalu WaveSilent, mixer turun dan pulih; renderer ditunggu maksimum empat detik agar suara selaras dengan munculnya maskot. Sembilan tes narasi dan regresi alur lulus. Perlu review pendengaran pemilik dan uji speaker TV. Commit per tiket belum dicatat karena perubahan bersama kedua tiket masih dalam working tree.

### KIFC-R30-18 — Sapaan pembuka berkala

**Status:** Siap ditinjau: sapaan berkala terhubung dan diuji pada web/Android setelah interaksi; review kenyamanan masih diperlukan. Pembuka tidak memiliki subtitle narasi. **Dependensi:** 01, 09, 13, 16. **Area kode:** `_WelcomePage`, lifecycle, pengelola narasi dan kontrol bahasa.

- [x] Putar sapaan singkat sesuai bahasa yang aktif saat pembuka idle. Gunakan jeda awal yang dapat dikonfigurasi, usulan 20 detik setelah sapaan selesai; kenyamanan pengulangan menunggu review pemilik.
- [x] Selesai sapaan tidak memulai tantangan. Mulai, pergantian bahasa, dialog, mute, keluar halaman, background, serta replay harus membatalkan/menyesuaikan jadwal lama; tidak ada panggilan bertumpuk atau dua bahasa berbunyi bersamaan.
- [x] Uji sapaan APK saat foreground setelah interaksi. Cold start tanpa sentuhan tidak memulai audio sesuai aturan aplikasi; kemampuan autoplay sistem Android sendiri tidak disimpulkan. Web juga menunggu interaksi dan teruji memainkan suara setelahnya.
- [x] Selama mute sapaan tidak berbunyi; animasi idle tetap hidup. Setelah unmute tidak memutar antrean sapaan yang terlewat. Penilaian interval dan volume dalam suasana pameran menunggu review pemilik/perangkat tujuan.

**Selesai jika:** sapaan berkala menarik perhatian tanpa mengganggu atau memulai game sendiri. Bukti: rekaman idle beberapa siklus, tes lifecycle/locale dan catatan perbedaan web/APK.

**Bukti 3 November:** [laporan integrasi](../../docs/client-revisions/2026-11-03/r30-17-18/README.md). Browser: tidak autoplay sebelum interaksi, sapaan Inggris diputar dan berhenti saat mulai. Android: beberapa siklus mixer setelah interaksi, serta cold start tanpa audio sebelum interaksi; tes mute, background dan pergantian bahasa lulus. Kenyamanan suara di lokasi dan commit terpisah masih tertunda.

### KIFC-R30-19 — Bacaan dengan narasi dan teks per kata

**Status:** Siap ditinjau: playback, teks bertahap, navigasi, fallback dan regresi dasar terintegrasi; timing perkiraan menunggu review pendengaran pemilik. **Dependensi:** 05, 07, 09, 13, 16. **Area kode:** `_KarhutlaCards`, `_MascotDialogue`, pengelola narasi, lokalisasi dan navigasi bacaan; `test/reading_interaction_test.dart`, `test/chapter2_review_test.dart`.

**Bukti 3 November:** [laporan dan screenshot](../../docs/client-revisions/2026-11-03/r30-19/README.md). Sembilan data timing terdaftar di bundle; 15 cue hasil pemisahan tujuh frasa Korea masih perkiraan dan perlu didengar. Android tiga bahasa menampilkan teks bertahap; bacaan Korea berjalan otomatis hingga kuis tanpa jawaban. Web dengan audio produksi menguji auto-lanjut, skip dan penghentian suara pada kuis. Analisis bersih, 106 tes regresi dan empat tes integrasi terbaru lulus. Perubahan tiket 17–19 belum di-commit; review pendengaran dan uji TV fisik masih tertunda.

- [x] Terapkan hanya pada tiga bacaan definisi, penyebab, dan pencegahan Karhutla. Teks bubble bertambah per kata mengikuti timestamp narasi; kata yang sudah muncul tetap terlihat hingga membentuk paragraf utuh. Jaga tinggi/lebar bubble agar tidak meloncat tiap kata.
- [x] Mulai timeline setelah aset narasi siap dan halaman aktif. Selama pemuatan, tampilkan keadaan yang bisa dipahami serta akses lanjut manual; pemuatan gagal tidak boleh melewati penjelasan tanpa kesempatan membaca.
- [x] Gerakkan mulut maskot selama narasi, turunkan musik, dan selaraskan kemunculan teks dengan posisi audio. Saat pause/lifecycle, teks dan audio berhenti bersama; reduced motion tetap dapat membaca informasi lengkap melalui alternatif yang layak.
- [x] Selesai narasi pertama/kedua membuka bacaan berikutnya; bacaan ketiga menuju kuis jenis hutan. Ketuk layar saat bacaan aktif langsung melewati satu halaman dan menghentikan audio lama, bukan sekadar menampilkan seluruh teks dahulu.
- [x] Pertahankan prioritas tombol Kembali, suara, dialog, dan kontrol manual. Tangani ketuk berulang serta ketuk bersamaan event audio selesai dengan satu transisi saja. Callback lama tidak boleh melewati halaman baru atau pertanyaan.
- [x] Saat mute, gunakan timeline teks dengan durasi rekaman sebagai dasar kelanjutan otomatis; jangan membuat game menunggu audio yang sengaja dimatikan. Saat audio gagal, sediakan teks lengkap dan kelanjutan manual tanpa deadlock; catat fallback kepada pengguna secara wajar.
- [x] Uji tiga bahasa, jeda/resume, kembali lalu masuk lagi, audio decode gagal, subtitle panjang, batas akhir timestamp, dan perpindahan menuju kuis yang belum dijawab.

**Selesai jika:** ucapan, gerakan mulut, teks, serta perpindahan selaras dan seluruh isi penjelasan dapat diakses saat suara gagal/mute. Bukti: regresi event/timing dan rekaman ketiga bacaan dalam tiga bahasa.

### KIFC-R30-20 — Verifikasi terpadu dan paket hasil revisi

**Status:** Dikerjakan. Regresi 465 tes lulus, paket web/APK/WGT review tersedia dan Samsung TV Web Simulator resmi diuji. Pengujian Android ditunda atas permintaan pemilik; runtime Tizen OS asli dan TV fisik belum divalidasi. **Dependensi:** 01–19. **Area:** tes, alat journey, indeks bukti, build web/APK, dan panduan paket klien.

- [x] Jalankan analisis dan suite regresi yang relevan, lalu perbarui perjalanan E2E agar tidak lagi mengunjungi demo. Pastikan skor maksimum 8, retry gambut, dan informasi tanpa skor tetap benar.
- [ ] Mainkan alur tiga bahasa pada web dan APK: idle/sapaan, drop/3 unsur/video, penjelasan, tiga bacaan bersuara/skip, kuis, penyebab, kartu gambut, tantangan selesai lebih awal/deadline, ulasan/skor, penutup 30 detik dan replay.
- [ ] Uji audio/mute/unmute, musik diturunkan saat narasi, gagal decode, lifecycle, pemutar/timer tidak bocor, serta seluruh aset offline. Verifikasi hash aset dan kode APK agar tidak mengirim build lama.
- [ ] Lengkapi screenshot lima ukuran, rekaman animasi/audio, dan pengujian pada TV fisik jika tersedia. Catat batas bukti performa, jangkauan dan kenyamanan speaker; pisahkan yang belum dapat dibuktikan dari yang lulus.
- [x] Perbarui panduan bermain/instalasi, kredit, informasi versi dan checksum. Buat APK/ZIP review yang baru; jangan menimpa paket 1.0.5 lama atau menyebutnya sudah berisi revisi ini.
- [ ] Tandai per tiket yang telah ditinjau. Push/deploy/distribusi mengikuti instruksi pemilik pada tahap rilis; paket review tidak otomatis berarti semua hasil visual/suara disahkan klien.

**Progres 3 November:** [Laporan verifikasi dan paket review](../../docs/client-revisions/2026-11-03/r30-20/README.md). Uji tambahan: WGT terpasang pada Samsung TV Web Simulator 10.0.6; alur produksi Indonesia, video, skeletal/morph, narasi/skip/kuis, skor dan penutup 30 detik; sapaan Inggris/Korea. Mode jendela opaque diperlukan pada SDK Windows untuk mengatasi gambar lama tertinggal. Simulator memakai Chromium 137, bukan engine TV Tizen 10 yang tercatat Chromium 130; hasil ini bukan sertifikasi native Tizen OS. Remote key diterima, tetapi drag-and-drop membutuhkan sentuhan/pointer. APK build lulus dan aset byte-identical; tidak dipasang/diuji ulang di Android sesuai instruksi pemilik. WGT unsigned dan dibatasi kandidat Tizen 10; uji model TV nyata, signing dan review pendengaran tetap terbuka.

**Follow-up performa browser 3 November:** [Laporan dan bukti](../../docs/client-revisions/2026-11-03/mascot-browser-performance/README.md). Pengukuran Chrome desktop menemukan pemuatan GLB ganda dan frame CanvasKit yang dipaksa pemantau audio. Optimasi mempertahankan data visual/timing; kerja main thread bacaan turun 83,2% pada median tiga perjalanan Full HD, dan 80,1% pada satu perbandingan 4K. Regresi 466 tes dan harness browser lulus. Lima ukuran × tiga bahasa: 14 pasangan screenshot identik; satu pasangan berbeda tiga piksel dengan selisih maksimum 1/255. Paket web baru terpisah tersedia; APK/WGT lama tidak diperbarui. Status tiket tetap Dikerjakan: hasil desktop tidak menggantikan kompatibilitas/performa QM43B-T Tizen 6.5 atau pengujian Android yang ditunda.

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
| 30 Oktober 2026 | KIFC-R30-04 | Belum dikerjakan → Selesai implementasi | `9630b86` | 40 tes lulus; analisis bersih; 15 render diperiksa; red/green timer | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-05 | Belum dikerjakan → Selesai implementasi | `9c829f0` | 60 tes lulus; analisis bersih; 15 render diperiksa; grouping judul teruji | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-06 | Belum dikerjakan → Selesai implementasi | `41384fa` | 65 tes terkait lulus; analisis bersih; 45 render diperiksa; deadline/submit dan cue tunggal teruji | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-05 lanjutan | Koreksi visual setelah masukan pemilik | `618a1ce` | Judul Indonesia dua baris tanpa mengecilkan font; 15 tes/15 render tiga bahasa dan lima viewport lulus; analisis bersih | Pemeriksaan internal; menggantikan susunan Tapi, sendiri |
| 30 Oktober 2026 | KIFC-R30-07 | Belum dikerjakan → Selesai implementasi | `d069340` | 16 tes baru + 83 regresi lulus; 45 pemeriksaan alur diulang setelah cleanup; analisis bersih; 30 render diperiksa | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-08 | Belum dikerjakan → Selesai implementasi | `f74d33b` | 47 tes interaksi gabungan lulus; suite lengkap 437 lulus; 1 tes capture tambahan lulus; analisis bersih; 60 render dan GIF frame widget diperiksa | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-08 lanjutan | Koreksi tampilan setelah klarifikasi pemilik | `d62bbae` | Hutan penuh sampai dasar; tanpa placeholder kosong; 79 pemeriksaan terkait lulus, analisis bersih; 75 render dan GIF terbaru | Pemeriksaan internal; TV fisik belum diuji |
| 30 Oktober 2026 | KIFC-R30-09 | Implementasi; native masih terbuka | `c713309` | 30 tes lulus, analisis bersih; browser final-encode/mute/loop lulus; source/hash, kredit dan ducking tersedia | UIAutomator emulator gagal memberi root; tidak mengklaim uji native lulus |
| 30 Oktober 2026 | KIFC-R30-10 | Kandidat dan derivatif siap; belum selesai | `e4cf559` | Pexels berizin; H.264 5.5s/960×640, tanpa audio, poster/hash; decode lulus | Alternatif stabilisasi, bukan kamera asli statis; belum diintegrasikan (11) |
| 30 Oktober 2026 | KIFC-R30-10 lanjutan | Stabilisasi diizinkan; kandidat ranting ditolak → wildfire baru siap ditinjau | `0961f1c` | H.264 11s/960×540 tanpa audio; 1.86 MB, poster/hash, decode dan inspeksi empat waktu lulus | Belum dipasang (11), belum disahkan visual oleh pemilik |
| 30 Oktober 2026 | KIFC-R30-11 | Hasil visual disetujui pemilik; tetap dikerjakan | `72c8941` | Playback web dan ponsel diperiksa, rekaman dan screenshot tersedia | Uji offline dan pemeriksaan media tersisa belum selesai |

| 31 Oktober 2026 | KIFC-R30-12 | Mulai dikerjakan; akses Azure belum tersedia | `8c48e32` | Draf 5 momen × 3 bahasa; sumber dan kandidat awal Azure dicatat | Suara, pelafalan, akses, lisensi akun, dan biaya aktual belum dibuktikan |

| 31 Oktober 2026 | KIFC-R30-12 lanjutan | Dua kandidat gratis siap didengar | `28aa077` | Supertonic 3 M1/M2; enam sampel ID/EN/KO dibuat lokal, decode dan sinyal diperiksa | Belum dinilai pemilik, belum produksi, timing dan izin proyek perlu ditinjau |

| 31 Oktober 2026 | KIFC-R30-12 lanjutan | Audisi karakter lebih lembut disiapkan | `f3de85b` | Supertonic 3 M3/M4/M5 dalam tiga bahasa; 12 MP3 terdekode | Kandidat belum dinilai subjektif atau dipilih pemilik |

| 31 Oktober 2026 | KIFC-R30-12 lanjutan | Sampel VoxCPM2 gratis siap didengar | `e92ebc9` | 1 sampel Indonesia; model Apache 2.0; sumber layanan dan batas kuota dicatat | Belum dinilai pemilik; EN/KO belum dibuat, ketentuan host dan kualitas perlu ditinjau |

| 31 Oktober 2026 | KIFC-R30-12 ElevenLabs | Percobaan ditunda layanan | `aa962f5` | 1 sampel ID, `eleven_v4`; estimasi 64 kredit | Layanan sibuk: tidak dimulai, 0 kredit ditagihkan; belum ada audio |

| 31 Oktober 2026 | KIFC-R30-12 ElevenLabs lanjutan | Lima file Indonesia diterima | `d0b3bde` | Lima MP3 terdekode; transkripsi otomatis awal tiga bacaan dibandingkan teks bubble | Perlu dengar manusia; sapaan/penutup berbeda dari tampilan; EN/KO dan kredit aktual belum diketahui |

| 1 November 2026 | KIFC-R30-12 lanjutan | 15 file tiga bahasa diterima | `5def511` | 15 MP3 terdekode; definition/cause Inggris diperbaiki dengan menukar nama, hash terjaga | ASR hanya pemeriksaan awal; perlu peninjauan pendengaran, timing dan penyelarasan pembuka/penutup |

| 1 November 2026 | KIFC-R30-12 | Selesai sesuai konfirmasi pemilik | `8aba569` | Voice ElevenLabs dan 15 file diterima; pemilik mengonfirmasi tiga poin peninjauan | Rincian kredit/model konkret tidak diberikan; timing berada pada 13 |

| 1 November 2026 | KIFC-R30-13 | Draf audio/timing disiapkan | commit persiapan | 15 salinan dinormalisasi; hash/decode/durasi lulus; 18 bagian timing ditandai | Bundle dan hash lulus; perlu review, pemisahan frasa, serta cek campuran musik |

| 1 November 2026 | KIFC-R30-13 lanjutan | Sampel campuran disiapkan | commit sampel | Sampel definisi ID/EN/KO mengikuti nilai mixer default saat narasi; decode lulus | Perlu dengar dan uji perangkat; timing masih 18 bagian perlu tinjauan |

| 1 November 2026 | KIFC-R30-13 | Audio dan timing draf disetujui pemilik | commit dokumentasi | Pemilik meninjau alat timing dan menyetujui hasil yang ditampilkan | 11 span masih gabungan kata; batas tiap kata dan integrasi masih diperlukan |

| 1 November 2026 | KIFC-R30-13/17/18/19 | Klarifikasi subtitle pemilik | commit dokumentasi | Subtitle bertambah dan menetap menjadi paragraf hanya pada bacaan Babak 2; pembuka dan penutup tanpa subtitle narasi | Tujuh span gabungan tersisa pada bacaan Babak 2 berbahasa Korea; perlu timing per kata |

| 1 November 2026 | KIFC-R30-13 | Persiapan diterima dan ditutup | `f145844` | Pemilik menerima audio dan timing draf serta meminta lanjut | KIFC-R30-19 menangani subtitle bertahap dan tujuh span gabungan Korea saat integrasi |

| 2 November 2026 | KIFC-R30-14 | Sumber GLB dan prototipe disetujui sebagai jalur integrasi | `4203eda` | Pilihan pemilik dan bukti welcome telah direkonsiliasi | Rencana prerender diganti GLB real-time; perangkat target belum diuji |
| 2 November 2026 | KIFC-R30-15 | Paket runtime dan poster selesai | `786ab35` | Enam klip asli, tiga varian tanpa ucapan, tujuh poster RGBA dengan hash | Dilanjutkan ke komponen lintas halaman R30-16 |
| 2 November 2026 | KIFC-R30-16 | Siap ditinjau pemilik | `c78f2cc` | 447 tes, 105 screenshot browser, interaksi dan playback Android; hybrid composition memperbaiki sentuhan | Review visual pemilik; TV fisik pada R30-20. Berikutnya R30-17 |

| 3 November 2026 | KIFC-R30-10 | Persetujuan visual direkonsiliasi; selesai | `0961f1c` | Video sama persis dengan aset yang telah diterima pada R30-11; SHA-256 dibandingkan | Tidak meminta persetujuan ulang untuk footage yang sama |
| 3 November 2026 | KIFC-R30-20 | Checkpoint verifikasi dan paket review; masih dikerjakan | `ab13abf` | 465 tes + 30 tes visual lulus, analisis bersih; APK/web/WGT dan checksum; alur Indonesia pada simulator resmi | Peninjau teknis: agen. Android ditunda pemilik; TV fisik belum tersedia, native Tizen OS/signing/review pemilik masih terbuka |

| 3 November 2026 | KIFC-R30-20 koreksi target | QM43B-T dipulihkan dari informasi pemilik sebelumnya; belum lulus performa | — | Samsung mencantumkan Tizen 6.5; WGT percobaan meminta 10.0. Audit GLB 6.77 MB/17.333 segitiga; renderer membutuhkan WebGL2 | Peninjau teknis: agen. Tidak ada data FPS/RAM/latensi target; hasil simulator tidak mengesahkan QM43B-T. Android tetap ditunda |

### Follow-up pemilik — Feedback_User_Pose dan proporsi maskot (3 November)

- Persiapan push GitHub atas instruksi pemilik: aset terbaru dicommit `9a1c510`, source integrasi bersama R30-17–19/optimasi/layout dicommit `d1a4278`. Regresi ulang 475 tes lulus, analisis bersih, integritas sembilan bacaan lulus. Ini snapshot integrasi bersama, bukan penutupan tiga tiket secara terpisah; status review dan uji perangkat tetap terbuka. [Cakupan checkpoint](../../docs/client-revisions/2026-11-03/github-integration-checkpoint.md).

- Welcome diperbesar dari tinggi komponen 180/216 menjadi 230/275 logical pixels, agar setidaknya sebesar Babak 2. Perbandingan geometri layar kecil/Full HD/4K dan matriks welcome lima ukuran × tiga bahasa lulus. Model, kamera dan Wave tetap. [Bukti dan batas validasi](../../docs/client-revisions/2026-11-03/welcome-mascot-enlarged/README.md).

- Revisi proporsi lanjutan: ulasan dampak Babak 4 memakai maskot besar setengah badan untuk hasil sempurna maupun belum sempurna, mengikuti komponen pada kartu karakteristik. Bubble dibatasi pada ruang di bawah hitungan jawaban; maskot berakhir tepat di atas tombol. Jawaban benar Babak 3 digeser 40 logical pixels lebih ke kanan, tanpa mengubah feedback salah atau kuis Babak 2. [Bukti dan pemeriksaan](../../docs/client-revisions/2026-11-03/mascot-layout-followup/README.md). Status tetap siap ditinjau; Android ditunda.

- Follow-up performa browser: pengukuran dan optimasi selesai untuk skenario desktop yang dicatat, tanpa mengurangi mesh/tekstur/kualitas render. [Bukti, batas metrik dan paket web](../../docs/client-revisions/2026-11-03/mascot-browser-performance/README.md). Tidak mengubah jumlah tiket selesai; validasi QM43B-T dan review pemilik tetap terbuka.

- Perbaikan terbaru: maskot completion/penjelasan menjadi overlay bawah dengan `Stack/Positioned`, tanpa mengambil tinggi panel unsur/teks. Scroll panel dihapus; panel utuh dan ukuran tetap. Subtitle dan bubble 13px dipertahankan, completion tengah, penjelasan kiri, Lanjut kanan. [Bukti terbaru yang menggantikan pendekatan scroll sebelumnya](../../docs/client-revisions/2026-11-03/assembly-mascot-overlay/README.md).

- Koreksi copy terbaru: subtitle penjelasan kembali pada semua ukuran layar; bubble completion/penjelasan kembali 13px dan padding 12px. Tinggi serta posisi maskot dipertahankan. Pada layar pendek, panel hutan dapat digulir jika ruang tidak cukup; teks tidak dihilangkan/diperkecil. [Bukti yang menggantikan catatan subtitle/teks kecil sebelumnya](../../docs/client-revisions/2026-11-03/restore-assembly-copy/README.md).

- Permintaan terbaru: tinggi maskot penjelasan disamakan dengan completion, tetap kiri-bawah. Width/scale/crop kini sama tanpa pengecilan berdasar sisa footer; layout pendek menyediakan ruang lewat padding/jarak dan menghindari subtitle berulang, isi bubble utuh. [Bukti terbaru dan batas validasi](../../docs/client-revisions/2026-11-03/explanation-matching-height/README.md).

- Koreksi terbaru pemilik membatalkan posisi tengah pada layar penjelasan bertombol Lanjut: maskot kembali kiri-bawah, subtitle dan susunan teks dipulihkan, pembesaran tetap; tombol tetap kanan dengan lebar yang aman. Completion tetap tengah. [Bukti yang menggantikan revisi posisi penjelasan sebelumnya](../../docs/client-revisions/2026-11-03/explanation-original-position/README.md).

- Layar penjelasan sesudah completion kini memakai ukuran/scale/crop bersama dan posisi tengah-bawah; Lanjut dipindahkan ke ruang kanan dengan gap 8px. Subtitle pengantar berulang disembunyikan pada viewport pendek; isi bubble utuh dan panel hutan tetap. [Bukti dan pemeriksaan](../../docs/client-revisions/2026-11-03/explanation-matches-assembly/README.md). Review melalui hot reload; server build tidak dijalankan.

- Koreksi lanjutan pemilik: ukuran completion disamakan dengan maskot saat pemilihan tiga unsur (lebar, scale, crop bersama), dipusatkan X dan tetap di bawah; trial geser naik dihapus. 15 tes assembly lulus, termasuk kesamaan ukuran sebelum/sesudah, tiga bahasa × lima viewport; analisis bersih. [Bukti terbaru](../../docs/client-revisions/2026-11-03/completion-matches-assembly/README.md). Server web build tetap dimatikan; review melalui sesi Flutter development pemilik.

- Sumber Feedback diganti dengan `Feedback_User_Pose/Review/Manggala_FEEDBACK_USER_POSE_REVIEW.glb`; laporan sumber dibaca, lima klip lain dan kamera/material/morph dipertahankan. Pose tumpang tindih tangan pada sumber tetap dipertahankan.
- Maskot setelah tiga unsur api diperbesar dan dipusatkan pada X, dengan anchor bawah tetap. Maskot feedback benar/salah, penjelasan segitiga api, kartu informasi dan review dampak diperbesar; teks lengkap dan ukuran pilihan jawaban tetap dipertahankan.
- Status: **siap ditinjau pemilik**, belum menjadi tiket selesai/commit baru. [Indeks bukti dan batas validasi](../../docs/client-revisions/2026-11-03/feedback-pose-proportions/README.md): widget render lima viewport dan tiga bahasa, validasi data GLB; playback sumber terbaru di Android belum diuji dalam follow-up ini. Jumlah status tiket utama tidak berubah.

- Follow-up feedback 3 November: hilangkan gap maskot–tombol pada review dampak, dan perbaiki ukuran renderer web yang tertahan setelah jawaban salah dikoreksi. ResizeObserver memperbarui ukuran tanpa reload GLB. 475 tes lulus, analisis bersih, build web sukses; bukti browser serta lima viewport × tiga bahasa tersedia di [indeks docking/resize](../../docs/client-revisions/2026-11-03/feedback-docking-resize/README.md). Siap ditinjau pemilik; jumlah status tiket tidak berubah.

- Follow-up penutup 3 November: ukuran maskot halaman paling akhir disamakan dengan welcome (tinggi 230/275, faktor lebar .62), posisi kanan dan animasi farewell tetap. Jarak elemen dirapikan agar muat pada layar kecil. 15 pemeriksaan layout (5 ukuran × 3 bahasa) lulus; [bukti](../../docs/client-revisions/2026-11-03/closing-welcome-size/README.md). Jumlah status tiket tidak berubah.

- Follow-up narasi Babak 2: pemutar tiap rekaman dipisahkan dan event posisi/selesai lama dilepas sebelum pergantian halaman agar narasi berikutnya tidak langsung dianggap selesai. Jeda 1 detik tetap. 476 tes lulus; pemeriksaan browser menjalankan tiga narasi otomatis dengan teks bertahap dan animasi Talk. [Bukti isolasi sesi](../../docs/client-revisions/2026-11-03/reading-session-isolation/README.md). Jumlah status tiket tidak berubah.

- Follow-up klien 4 November, commit `0a64243`: judul Korea Babak 1 menjadi “산불의 세 가지 요소를 고르세요.”; sapaan welcome membungkus per kata agar “원인을” tidak terpisah sebelum “을”. 36 tes terkait lulus, analisis bersih dan build web sukses; [bukti tiga bahasa × lima ukuran](../../docs/client-revisions/2026-11-04/korean-copy-wrapping/README.md). Siap ditinjau klien; jumlah status tiket utama tidak berubah.

- Follow-up klien 5 November: kata Korea dijaga tetap utuh pada semua teks terlokalisasi dan subtitle bertahap, dengan label aksesibilitas serta timing narasi memakai teks asli. Audit 240 tampilan/5 ukuran mencakup 9 feedback akhir: tidak ada kata terbelah atau keluar horizontal; 477 tes lulus, analisis dan build web sukses. [Bukti dan batas pengujian](../../docs/client-revisions/2026-11-05/korean-word-wrapping/README.md). Siap ditinjau; jumlah status tiket utama tidak berubah.
