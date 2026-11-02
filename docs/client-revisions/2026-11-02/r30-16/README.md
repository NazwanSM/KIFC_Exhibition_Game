# KIFC-R30-16 — integrasi maskot 3D

Status: **siap ditinjau pemilik**. Seluruh konsumen maskot memakai `GameMascot` dan state API bersama. GLB dirender langsung menggunakan model-viewer/WebGL: elemen web pada Flutter web, WebView lokal dengan hybrid composition pada Android. Seluruh GLB, JavaScript renderer dan poster dibundel dalam APK; tidak membutuhkan server internet untuk maskot. Kamera memakai orbit, target, rasio dan FOV dari `CAM-UserApprovedView`. Pencahayaan memakai lingkungan default model-viewer, bukan render studio Blender yang identik piksel.

| Konsumen | Klip | Perilaku |
|---|---|---|
| Welcome | Wave | Loop 30 detik, termasuk morph mulut sesuai permintaan pemilik; berhenti saat keluar |
| Assembly | PointIdle / FeedbackSilent / Happy | Netral / salah / lengkap; crop, sisi feedback dan target drag dipertahankan |
| Penjelasan Segitiga Api | PointIdle | Tanpa ucapan, tombol lanjut tetap manual |
| Tiga bacaan Karhutla | PointIdle | Gerak tanpa ucapan sampai integrasi narasi R30-19 |
| Feedback kuis gambut dan penyebab | Happy / FeedbackSilent | Benar / salah; tanpa TTS atau gerak mulut |
| Tiga kartu gambut | PointIdle | Docking di atas tombol lanjut; seluruh kartu tetap bisa disentuh |
| Ulasan tantangan akhir | Happy / FeedbackSilent | Sesuai hasil; tidak mengubah perhitungan skor |
| Penutup | WaveSilent | Perpisahan tanpa ucapan sampai R30-17; timer penutup tetap 30 detik |

Halaman tantangan aktif dan skor yang sebelumnya tidak menampilkan maskot tetap mengikuti desainnya. API juga menyediakan Idle dan Talking; `narrating` menentukan klip dengan mulut aktif untuk integrasi suara berikutnya. Tidak ada audio narasi baru pada tiket ini.

Renderer berhenti saat halaman keluar, aplikasi tidak aktif, dialog mengambil alih, reduced motion, atau dispose. Pergantian state menutup sesi lama; trigger baru dapat mengulang klip. Poster RGBA yang cocok menutup loading, kegagalan, platform tanpa renderer dan reduced motion. Browser merespons perubahan preferensi reduced motion secara langsung. Resolusi elemen web mengikuti ukuran tampilan setelah FittedBox agar maskot tidak kabur pada simulasi TV. Renderer dekoratif tidak menerima gesture pemain.

## Bukti dan pemeriksaan

- [Indeks screenshot](screenshots.md): 105 screenshot browser aktual, tujuh halaman × tiga bahasa × lima viewport: 360×640, 411×731, 720×1280, 1080×1920, 2160×3840. [Contact sheet](web-contact-sheet.jpg) memperlihatkan tujuh kelompok halaman dalam tiga bahasa.
- [Metadata capture](capture-results.json): klip, durasi 30 detik, bobot morph, ukuran render dan ukuran tampilan. Tidak ada klaim jangkauan fisik TV dari resolusi browser.
- [14 pemeriksaan interaksi web](interaction-results.json): drag salah/benar, navigasi dan penghentian pemutar lama, kuis, kartu, penutup, kembali welcome, reduced motion dan kegagalan sumber yang disengaja. Dua error konsol berasal dari sumber GLB hilang pada uji fallback tersebut.
- [Integritas aset](asset-integrity.json): sumber arsip identik dengan file pemilik; enam klip asli, material, tekstur, badge, mesh, skin, kamera dan binary prefix tetap identik. Tiga varian silent ditambahkan, tujuh poster transparan dan renderer lokal ditemukan dalam APK.
- [Perjalanan Android](android-journey.json): interaksi nyata pada TECNO LG7n Android 12, layar 720×1640, mencakup drag, penjelasan, bacaan, feedback gambut, empat penyebab dan kartu gambut. Pemilihan halaman melalui fixture debug dicatat terpisah dalam [hasil fixture](android-fixtures.json).
- [Penghentian welcome Android](android-start-navigation.json) merekam event pause sebelum PointIdle aktif. [Skeletal/morph dan loop](android-wave-playback.json) merekam perubahan quaternion lengan dan bobot mulut pada tujuh titik, lalu playback melintasi detik 30 kembali ke awal. [Rekaman Android](android-motion.mp4) adalah screen recording welcome pada perangkat 720×1640 selama sekitar 8 detik; bukan rekaman TV fisik.
- `flutter analyze`: tidak ada masalah. `flutter test --no-pub`: **447 tes lulus**. Termasuk regresi baru tiga bahasa pada ukuran Android 360×820 dengan inset atas 36: sebelumnya overflow 23 piksel, sesudah penyesuaian judul sempit lulus tanpa memperkecil kartu jawaban 72 piksel. Build web utama dan APK debug review berhasil.

Pada Android, renderer awal berbasis texture menghalangi beberapa sentuhan Flutter. Perbandingan dengan fallback membuktikan sumber masalah. Native renderer kini memakai WebView hybrid composition tanpa eager gesture recognizer; drag, pilihan jawaban dan navigasi kembali diterima pada perangkat. Judul kuis gambut memakai ukuran compact pada lebar di bawah 380 logical pixels untuk mencegah overflow yang ditemukan pada perangkat.

## Reproduksi dan batas review

`tool/mascot_review_main.dart` hanya memilih halaman game asli melalui query web dan memakai backend audio senyap. `capture_pages.js`, `capture_extra_sizes.js` dan `test_interactions.js` dijalankan melalui Playwright CLI. Pengujian morph/skeletal membaca scene internal hanya dalam alat pemeriksaan; kode produksi memakai API playback publik.

`tool/mascot_review_android_main.dart` membuka inspeksi WebView serta pemilihan fixture melalui VM service **hanya pada build debug review**. Entry point release tetap `lib/main.dart`. Alat `android_mascot_*.mjs` mengoperasikan perangkat yang diizinkan pemilik dan menyimpan bukti. Fixture menggunakan halaman Flutter asli; ini berbeda dari menuntaskan permainan melalui gesture. APK review menggunakan nama versi `1.0.6-mascot-review`, build `2026110216`; APK terpasang sebelumnya dibackup tanpa menghapus data aplikasi.

TV Android 42 inci, Tizen, kenyamanan suara, pengukuran FPS/memori berkepanjangan dan jangkauan fisik belum diuji di tiket ini. Verifikasi terpadu perangkat pameran tetap R30-20. Penilaian visual akhir pemilik masih diperlukan; tiket berikutnya adalah R30-17, salam penutup bersuara.
