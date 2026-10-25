# Pengujian menyeluruh KIFC — 25 Oktober 2026

**Hasil: siap disampaikan sebagai update/review klien berdasarkan skenario lokal yang diperiksa. Tidak ditemukan penghambat pada perjalanan akhir.** Ini bukan pengesahan KIFC atau sertifikasi pemasangan TV fisik.

Sumber gameplay awal `8b1cbdd`, branch `main`. Koreksi nama launcher Android dikomit terpisah sebagai `5d101d6`. Tidak ada perubahan Dart, naskah, aturan skor atau urutan layar selama QA ini. [Hasil rinci mesin](../../../production/qa/e2e-results-2026-10-25.json), [rencana pengujian](../../../production/qa/e2e-plan-2026-10-25.md).

## Bukti hasil

| Pemeriksaan | Hasil aktual |
|---|---|
| Suite Flutter | 313 tes lulus; analisis tanpa isu |
| Pemeriksa APK Python | 1 tes lulus; binary final diverifikasi terpisah |
| Web release | Build berhasil; browser bersih ID/EN/KO sampai 8/8, penutup dan replay 0/3 |
| APK debug offline | ID/EN/KO sampai 8/8 dan replay 0/3; cue akhir/assembly masing-masing sekali, sumber disiapkan sekali per perjalanan |
| APK release final | ID/EN/KO sampai 8/8, penutup dan replay 0/3, memakai input Android nyata; log perjalanan tanpa exception Flutter/audio yang tidak tertangani |
| Aset Android offline | 53 hash cocok, termasuk foto, maskot, animasi dan font; tanpa MP4 mentah |
| Audio | 9 sumber berhasil decode; 10 pemeriksaan kontrol web dan 10 native, termasuk mute/master 0, layer, lifecycle native dan replay |
| Audio gagal sementara | Server QA mengembalikan 503 khusus retry.wav. Dua error media yang disengaja tercatat; musik/alam tetap playing. Sumber dipulihkan ke 200 dan cue retry kembali playing pada interaksi berikutnya |
| Feedback/dialog | Dialog browser ditahan 16 detik; feedback tetap ada sesudah ditutup dan lanjut setelah sisa waktu. Total teramati 31,045 detik termasuk jeda; 9 sumber tanpa error pada kasus ini |
| Visual/caption | 951 render berdimensi PNG tervalidasi. Seluruh tahap utama APK dan pembanding bahasa/ukuran diperiksa secara representatif, bukan klaim 951 gambar dibaca manual satu per satu |

Suite dijalankan dengan sumber Dart yang sama dengan APK final. Perubahan berikutnya hanya label manifest Android dan alat/dokumentasi QA. APK final dibangun dan dipasang ulang setelah koreksi label; hasil native-final merupakan bukti untuk binary yang dibagikan.

## Cakupan 18 kelompok revisi

| Tiket | Yang diperiksa |
|---|---|
| 01 | Pembuka, pergantian bahasa/judul, CTA, maskot dan kontrol suara |
| 02–04 | Decoy/duplikat/slot bebas/drag, penyelesaian 3/3, penjelasan, CTA, urutan, pasangan api kiri/tengah/kanan, 6→4→2→0, pilihan ulang dan Ulangi |
| 05–07 | Tiga kartu bacaan/caption, navigasi manual dan konsistensi istilah |
| 08 | Hint salah pertama, retry, benar/salah kedua; judul tetap dan kelanjutan feedback |
| 09 | Tiga sampul berbeda, flip/reopen, syarat semua dibaca, tanpa skor |
| 10 | Enam pilihan, pilihan netral/cancel, countdown 30 detik/ring/warna, deadline dan grading tertunda |
| 11 | Hasil benar/salah/terlewat, skor parsial/kategori dalam suite, maksimum 8, penutup dan reset |
| G01–G03 | Respons sentuhan, transisi, feedback maskot, reduced motion, inset, proporsi foto dan animasi api |
| G04 | Musik/alam/7 cue, kontrol terpisah, aktivasi setelah interaksi, lifecycle dan pemulihan sumber |
| X01–X03 | Urutan lengkap, pembatalan timer, navigasi/replay/skor, tiga bahasa/Hangul/teks dinamis, APK/versi/hash/tanda tangan/offline |

Feedback/hasil tetap 15 detik atau sentuh konten/latar untuk lanjut lebih cepat. Bacaan dan kartu informasi manual; hint pertama tidak bisa dilewati. Tes memeriksa batas 14999→15000 ms, dialog/lifecycle dan pembatalan timer. Tiga browser mengamati pergantian tantangan sekitar 30,7–31,0 detik termasuk transisi/polling; kontrak deadline 30 detik diperiksa dengan jam tes. Kartu 09 tanpa poin; maksimum 8 = unsur 3 + penyebab 4 + bonus dampak ≤1.

## Temuan dan koreksi

1. **Nama launcher internal — diperbaiki.** APK sebelumnya menampilkan fire_prevention_challenge. Kini Fire Prevention Challenge. Verifikasi memakai aapt terhadap APK hasil build, tanda tangan dan instalasi pembaruan. [Review koreksi](apk-display-name-review.md), commit `5d101d6`.
2. **Alat perjalanan perlu mengikuti timer/transisi — diperbaiki.** Tunggu lama 2,4 detik diganti tap terpisah sesuai feedback 15 detik. Skrip menunggu label 3/3, jendela cold-start menerima input serta transisi score→closing agar Play Again tidak diambil dari frame keluar. Tidak memperpendek timer atau memanggil state privat game. Mode release tidak memalsukan counter debug: field audio diberi null/audioCueLogAssessed:false.
3. **README menyebut dua bahasa — diperbarui** menjadi Indonesia, Inggris dan Korea.

Percobaan skrip tidak valid dipertahankan di build, tetapi dikeluarkan dari hasil lulus: locator ganda saat transisi, hierarchy tertinggal satu frame, input cold-start terlalu awal, koordinat Play Again frame keluar, batas command line Windows, serta injeksi route yang tidak menghasilkan kegagalan. Uji 503 dari server terpisah akhirnya memastikan kegagalan nyata dan pemulihan. Hasil primer memakai browser-*-passed dan native-final-* yang tercantum dalam JSON hasil.

## Visual dan caption

Dimensi utama: 360×640, 411×731, 720×1280, 1080×1920, 2160×3840. Tes shell web menambah 390×844, 800×600 dan 1440×900. Sumber dibedakan antara render widget Flutter, browser 720×1280 CSS dan screenshot APK emulator 1080×1920/density 420. Full HD/4K merupakan simulasi viewport, bukan foto TV 42 inci.

Inspeksi representatif 23 keadaan native Indonesia dan enam pembanding bahasa/ukuran tidak memperlihatkan aset gagal, stretch, overlap penghalang atau caption terpotong. [Catatan visual dan batasnya](../../../build/review-e2e-2026-10-25/visual-inspection/notes.md), [indeks 951 render](../../../build/review-e2e-2026-10-25/widget-evidence-index.json). Korea diuji coverage/layout dan alur; pengesahan penutur/KIFC tetap diperlukan.

## Paket klien

- [ZIP update klien](../../../build/review-e2e-2026-10-25/KIFC-Client-Update-2026-10-25.zip): APK final, PDF, 37 PNG asli, indeks sumber/ukuran, atribusi aset dan checksum.
- ZIP final: 95.469.426 byte, SHA256 `a7b89a5d782b4fa675cc1849086488fe01ab1fa18f7a837beab2277b1c2f8753`. Seluruh hash manifest, salinan di dalam ZIP, CRC ZIP dan dua halaman PDF diperiksa.
- [Laporan ringkas PDF](../../../build/review-e2e-2026-10-25/client/Laporan-Update-KIFC-2026-10-25.pdf).
- [APK review](../../../build/review-e2e-2026-10-25/client/KIFC-Review-2026-10-25.apk), versi 1.0.1 (20261025), minSdk 24, targetSdk 36; 75.532.455 byte.
- SHA256 APK: `e01e1367d5ec3e47fecddf870361ec764c6dc3ef440611087049130ac4ba4fba`.

APK memakai mode release dengan sertifikat Android Debug yang diverifikasi, bukan kunci produksi pemilik. Manifest/perangkat terpasang mencatat versi yang sama. “Active default network: none” pada emulator mendukung pengujian offline. Detail cue berasal dari debug/browser; release tidak memuat log counter debug. Snapshot release terpisah memperlihatkan 9 media-player clients, termasuk 2 loop playing. Ini bukan pengukuran kenyamanan/latensi speaker fisik.

## Lingkungan dan batas hasil

T3 preview snapshot gagal dua kali dengan “Preview automation snapshot timed out after 15000ms.” Pengujian beralih ke Playwright CLI/Edge isolated tanpa ekstensi, memakai API browser/media dan input nyata. Sembilan sumber normal mendapat 200, tanpa error media pada tiga perjalanan. Ini mendukung dugaan intersepsi IDM pada pemeriksaan sebelumnya; pengaturan ekstensi pengguna tidak diubah.

Build release pertama berhenti saat drive C penuh dan JVM tidak dapat mengalokasikan memori. Delapan direktori transform cache yang baru dibuat build gagal diparkir di build/review, tanpa menghapus file pemilik. Cache Gradle terisolasi dan TEMP berikutnya berada di D; emulator review dimatikan saat build berat. Build berikutnya berhasil. Warning Kotlin/cache lintas drive memakai fallback dan build berakhir sukses; log disimpan. Ini masalah host/build, bukan crash game yang disimpulkan tanpa bukti.

Tetap terbuka: jangkauan dan waktu baca pada tinggi pemasangan TV 42 inci aktual, performa/FPS/sesi panjang pada perangkat target, level/latensi/kenyamanan speaker ruangan, pengesahan naskah/terjemahan KIFC, dan kunci signing produksi. Tidak ada push/deployment pada sesi QA. Paket lokal tidak otomatis memperbarui Pages atau APK publik sebelumnya.

Commit QA/alat/hasil: `98b6e79` pada `main`. Koreksi launcher: `5d101d6`.
