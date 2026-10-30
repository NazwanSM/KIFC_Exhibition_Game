# KIFC-R30-06 Selesai memilih lebih awal

Tantangan akhir tetap memiliki batas maksimum 30 detik. Tombol Selesai Memilih / Finish Selecting / 선택 완료 menggunakan ruang kosong di bawah hitungan pilihan; ukuran dan posisi grid jawaban tidak berubah. Tombol membuka ulasan dari pilihan saat ditekan. Waktu habis menggunakan aksi penyelesaian yang sama, mempertahankan frame nol selama 420 ms sebelum ulasan.

- Pengujian awal gagal sebelum tombol diimplementasikan (red.log).
- Delapan tes interaksi lulus: tanpa pilihan, sebagian, campuran, empat benar, keenam pilihan, pembatalan pilihan, callback berulang, serta kedua urutan tombol/deadline. Rumus bonus tetap max(0, benar - salah) / 4.
- Penyelesaian menghentikan stopwatch/timer, mengunci pilihan, dan memicu GameSound.finish satu kali. RecordingAudioBackend membuktikan pemanggilan cue; ini bukan pemeriksaan speaker atau playback browser.
- 15 tes visual tiga bahasa/lima viewport lulus; 45 render mencakup kosong, dua pilihan netral, dan ulasan. Tes memeriksa grid tetap sama, posisi tombol di bawah grid dan sebelum 85% tinggi viewport, serta tidak ada overflow. Contact sheet ketiga kondisi diperiksa.
- 40 regresi impact review, audio gameplay, feedback timing, dan reading interaction lulus. Dua regresi ring countdown normal/reduced motion juga lulus. Total terkait tiket: 65 tes lulus. flutter analyze --no-pub bersih.
- Screenshot ulasan awal tertangkap sebelum reveal dimulai. Harness kini memompa frame kedua hingga animasi selesai dan memastikan opacity bubble bernilai 1. Tidak ada perubahan animasi produksi untuk mengatasi masalah capture ini.
- [Tombol selesai setelah memilih](r30-06-challenge.png) dan [ulasan setelah selesai](r30-06-review.png), keduanya render Indonesia 411×731.
- Bukti lokal: build/review-r30-06-2026-10-30/ berisi screenshots, tiga contact sheet, evidence-index.json, red.log, interaction.log, visual.log, regression.log, countdown-ring.log dan analyze.log. interaction-first.log menyimpan kegagalan awal locator tes ElevatedButton.icon yang kemudian diperbaiki.
- Screenshot berasal dari render widget Flutter pada 360×640, 411×731, 720×1280, 1080×1920, dan 2160×3840. Ini simulasi viewport portrait, bukan foto TV 42 inci. Belum ada rekaman playback, uji browser/APK baru, atau uji fisik jangkauan/speaker. Verifikasi lintas perangkat dan paket berada pada tiket 20; belum push/deploy.
