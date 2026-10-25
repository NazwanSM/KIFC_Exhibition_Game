# KIFC-03 — maskot kiri dan tombol kanan

Permintaan pemilik 25 Oktober: maskot presenting mengarah ke kanan, sehingga ditempatkan di kiri dan tombol Coba Kurangi Satu Unsur / Try Reducing an Element di kanan. Lebar tombol diperbesar menjadi 66% area; label tiga bahasa ditampilkan satu baris dengan penyesuaian skala hanya bila perlu. Pose/logo tidak dicerminkan dan tetap memakai aset yang sama.

Pada layout kecil tombol mengikuti tinggi maskot. Pada simulasi TV dengan TouchscreenArea, posisi vertikal CTA tetap berada di area jangkauan tengah. Percobaan awal menempatkan tombol terlalu rendah dan gagal 5 pemeriksaan jangkauan; posisinya dikoreksi tanpa melonggarkan tes. Susunan unsur, caption, api dan urutan layar tetap.

Verifikasi akhir: 64 tes terarah lulus (kartu, visual api, alur lengkap Indonesia/Inggris/Korea serta timer feedback). 15 kasus penjelasan memastikan maskot di kiri, CTA di kanan, teks benar-benar satu baris dan seluruh label berada dalam kotak tombol. Build web release berhasil; analisis awal bersih dan diulang pada kode akhir. 75 screenshot fokus revisi tersedia: 60 keadaan kartu 09 dan 15 penjelasan 03, tiga bahasa × lima ukuran portrait. [Indeks sumber/dimensi](../../../build/review-mascot-alignment-2026-10-25/evidence-index.json).

Bukti: [Inggris 411×731](../../../build/review-mascot-alignment-2026-10-25/explanation-en-411x731.png), [Inggris 360×640](../../../build/review-mascot-alignment-2026-10-25/explanation-en-360x640.png), [Inggris 4K](../../../build/review-mascot-alignment-2026-10-25/explanation-en-2160x3840.png). Ini render Flutter, bukan foto TV fisik. Uji fisik/performa/akustik tetap terpisah.

APK review baru: release 1.0.2 (20261026), 53 hash aset offline cocok, 75.532.455 byte, SHA256 `2947c0d671e023ac328ebbcffe6ecd7886797b0b02fbe5e62145333a5e737b6f`. Sertifikat tetap Android Debug untuk review. Paket ZIP E2E sebelumnya memuat 1.0.1 sebelum minor revision ini; tidak ditimpa atau diklaim sudah mencakup perubahan baru. Tidak push/deploy.
