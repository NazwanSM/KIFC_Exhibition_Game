# KIFC-R30-13 — Persiapan narasi dan timing

Status: persiapan diterima pemilik; integrasi subtitle final dikerjakan pada KIFC-R30-19. Pemilik mengonfirmasi peninjauan dan pilihan voice ElevenLabs pada tiket 12. Pengaturan dan nama model yang benar-benar dipakai saat unduh tidak tercatat; metadata menandainya tidak diketahui, bukan mengasumsikan estimasi `eleven_v4` yang tidak sempat dijalankan.

## Audio

- Lima belas file sumber milik pemilik tetap berada di `assets/audio/narration/incoming/`. Salinan hasil normalisasi berada di `assets/audio/narration/prepared/{id,en,ko}/`; 15 file diturunkan dari sumber yang sesuai setelah koreksi dua nama Inggris. MP3 192 kbps, 44,1 kHz, loudnorm dua tahap dengan target -18 LUFS dan true peak -1,5 dBTP.
- Semua salinan terdekode, cocok dengan SHA-256 pada manifest dan durasi penutup tiap bahasa di bawah 30 detik. Pemeriksaan ulang mengukur -18,50 sampai -18,24 LUFS dan puncak tertinggi -1,74 dBTP. Pemeriksaan keterdengaran di atas musik belum dilakukan.
- Kelima belas file telah dideklarasikan di `pubspec.yaml` dan diverifikasi di bundle Flutter melalui pemeriksaan hash. Pemutaran narasi belum diintegrasikan ke game. Simpan sumber asli; jangan menimpa berkas milik pemilik.

## Timing

- [timings-draft.json](timings-draft.json) berisi teks asli, hash sumber dan salinan, durasi, hasil pengenalan kata, dan perkiraan start/end yang diturunkan dari timestamps `faster-whisper-base` pada rekaman yang telah dinormalisasi. Bukan pembagian dengan kecepatan ketik tetap.
- Pemetaan otomatis menandai **18 bagian untuk diperiksa**, termasuk 11 frasa yang masih menggabungkan beberapa kata. ASR memiliki perbedaan teks/kepercayaan rendah terutama di Korea. Tidak ada segmen yang otomatis dinyatakan sebagai timing final; jangan gunakan draf untuk animasi per kata sebelum diperiksa dan diperbaiki. `review_reason` menandakan dugaan masalah, bukan vonis audio salah.
- [Buka alat peninjauan lokal](timing-review.html): putar 15 klip dan tekan kata/frasa untuk melompat ke waktunya. Oranye menunjukkan bagian yang ditandai. Ini alat tinjauan, bukan tampilan game. Informasi waktu dapat diperiksa tanpa jaringan saat direktori proyek tersedia di komputer.
- Pemetaan string, urutan waktu, rentang durasi dan hash semua file diverifikasi secara otomatis. Ketepatan waktu dengan pendengaran, segmentasi per kata Korea, dan penggunaan dalam aplikasi masih perlu diverifikasi.

## Reproduksi

`tool/prepare_narration_draft.py` memerlukan FFmpeg pada PATH, `faster-whisper`, dan variabel `KIFC_ASR_MODEL` yang menunjuk ke model lokal `faster-whisper-base`. Jalankan dari root proyek; keluaran ada di `build/review-r30-13/`. `tool/align_narration_draft.py` memetakan hasil ASR ke naskah dan menandai bagian kurang pasti. Kedua skrip menghasilkan draf, bukan data timing final.

## Sampel campuran untuk pemeriksaan pendengaran

Tiga sampel definisi Karhutla: [Indonesia](mix-preview/id-definition-mix.mp3), [Inggris](mix-preview/en-definition-mix.mp3), [Korea](mix-preview/ko-definition-mix.mp3). Campuran dibuat secara offline menggunakan narasi 0,65, musik 0,091 dan ambience 0,0715 serta limiter 0,95. Nilai musik dan ambience meniru nilai default mixer saat `narrating`; level narasi 0,65 merupakan asumsi uji karena pemutar narasi belum diintegrasikan. Semua sampel berhasil didekode. Ini bukan hasil rekaman dari aplikasi, dan belum ada penilaian pendengaran pada perangkat target.


Pemilik mengonfirmasi bahwa campuran suara dan musik sudah aman. Pemeriksaan timing terpisah dari konfirmasi tersebut; 18 bagian tetap ditandai sampai dapat diverifikasi terhadap audio.


Pemilik telah meninjau alat timing dan menyetujui hasil yang ditampilkan. Sebelas span masih berupa gabungan beberapa kata; persetujuan atas tampilan draf tidak dengan sendirinya menyediakan batas waktu masing-masing kata. Pemisahan dan uji tampilan per kata tetap diperlukan pada integrasi.

Klarifikasi pemilik: subtitle narasi hanya untuk tiga bacaan Babak 2, bertambah per kata dan menetap sampai menjadi paragraf utuh. Pembuka dan penutup tanpa subtitle narasi. Dari 11 span gabungan dalam draf, tujuh berada pada bacaan Babak 2 (semuanya Korea) dan membutuhkan pemisahan per kata.

Pemilik menerima draf yang ditinjau dan meminta melanjutkan. Persiapan KIFC-R30-13 ditutup; penanganan tujuh span gabungan dan verifikasi tampilan subtitle yang bertambah tetap menjadi bagian integrasi KIFC-R30-19.
