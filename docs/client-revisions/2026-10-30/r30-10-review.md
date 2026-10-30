# KIFC-R30-10 — pengganti berupa kebakaran hutan yang jelas

Pemilik mengizinkan hasil stabilisasi, tetapi menolak kandidat 29961571 karena terlihat seperti pembakaran ranting lokal. Kandidat tersebut diganti dengan Wildfire in a Forest oleh Arnav Kainthola, Pexels 7448357. Cuplikan menunjukkan garis api meluas di lereng berhutan, pohon di antara nyala, serta asap pada malam hari. Tidak ada gambar/api hasil generasi.

Sumber: https://www.pexels.com/video/wildfire-in-a-forest-7448357/ . Lisensi: https://www.pexels.com/license/ . Keduanya diperiksa 30 Oktober 2026. Pexels mengizinkan unduhan, penggunaan dalam aplikasi dan modifikasi; kredit tetap disimpan. Lokasi pengambilan tidak diverifikasi dan tidak diklaim sebagai Indonesia. Tripod tidak diklaim; framing bagian terpilih diperiksa pada beberapa waktu dan tidak diberi pan/zoom tambahan.

Aset yang disiapkan:

- assets/animations/forest-burn-loop.mp4: 11 detik, 960×540, H.264 Main 3.1, yuv420p, 24fps, faststart, tanpa audio; 1.863.442 byte.
- assets/animations/forest-burn-poster.jpg: poster/fallback dari frame pertama.
- Sumber detik 1–13, crop tetap proporsional 1088×612 di x416/y468, resize ke 960×540. Tail/head memakai dissolve melingkar 1 detik. Sambungan dan empat waktu 0/4/8/10.95 detik diperiksa melalui contact sheet. Tidak men-stretch gambar.
- Metadata, ukuran, codec, jumlah stream dan durasi lulus pemeriksaan; decoding seluruh klip FFmpeg selesai tanpa error. Manifest dengan hash sumber/derivatif ada di video/source.json. Reproduksi: tool/prepare_wildfire_video.py.

[Poster terbaru](r30-10-wildfire-poster.jpg). Bukti lokal build/review-r30-10-wildfire-2026-10-30/ memuat source/night.mp4, contact sheet sumber, loop-contact.jpg dan validation.json. Kandidat hutan pegunungan 12075744 juga diperiksa, tetapi nyala terlalu samar; cuplikan malam dipilih agar kebakarannya jelas. Catatan kandidat ranting yang ditolak dipertahankan di video/rejected-brush-review.md dan rejected-29961571.json; stabilize.py/stabilization.json di direktori yang sama hanya berlaku untuk kandidat lama, bukan aset saat ini.

Status: siap ditinjau visual, belum persetujuan pemilik terhadap cuplikan pengganti. Belum dipasang ke game; integrasi adalah tiket 11. Pratinjau bukan screenshot hasil integrasi, bukan uji TV fisik, dan tidak membuktikan playback APK. Tidak ada perubahan alur/penilaian, push atau deployment pada koreksi ini.

Pemeriksaan komposisi aset memakai simulasi HTML panel rasio 411:248 dengan tiga foto unsur. Crop awal diperketat agar kartu tidak menutupi mayoritas nyala; ini tetap simulasi aset, bukan screenshot game yang sudah terintegrasi.
