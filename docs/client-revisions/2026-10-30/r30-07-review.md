# KIFC-R30-07 Hapus demo pengurangan unsur

Demo pengurangan dihapus dari enum halaman, navigasi, widget, state pilihan, syarat mencoba tiga unsur, dan feedback timer. Penjelasan Segitiga Api tetap ada. Tombolnya menjadi Lanjut / Continue / 계속 dan membuka bacaan Karhutla pertama. Kembali dari bacaan pertama menuju penjelasan; kembali sekali lagi membuka penyusunan kosong. Skor maksimum tetap 8.

- 16 tes baru lulus: alur maju/ketuk latar/kembali dalam tiga bahasa × lima ukuran, serta pembatalan timer penyusunan, reset dan replay. Pengujian awal gagal sebelum perubahan (red.log).
- 83 regresi terkait lulus: penyusunan, panel api, reading/feedback timer, alur lengkap/skor, inset Android, dan motion. Setelah membersihkan parameter layout khusus demo yang tidak dipakai lagi, 45 tes alur/reading terkait dijalankan ulang dan lulus. Analisis bersih.
- Tes halaman demo yang dihapus digantikan oleh pengujian alur langsung. Komponen simulasi api bersama dan tes komponen tersebut tetap dipertahankan. Api lama belum diganti footage nyata; itu tiket 10–11.
- Perjalanan Android (tool/android_journey.py), README dan aturan proyek diselaraskan. Script Android lolos kompilasi Python; belum dijalankan terhadap APK baru. Generator paket tanggal 28 Oktober dipertahankan karena secara eksplisit terikat APK 1.0.5 lama.
- 30 screenshot aktual widget diperiksa pada 360×640, 411×731, 720×1280, 1080×1920 dan 2160×3840, ID/EN/KO: [penjelasan](r30-07-explanation.png) dan [bacaan berikutnya](r30-07-reading.png). Tidak ada CTA demo, clipping, atau halaman perantara. Ukuran panel tidak berubah.
- Bukti lokal: build/review-r30-07-2026-10-30/ berisi screenshots, evidence-index.json, contact-explanation.png, contact-reading.png, red.log, tests.log, regression.log, final-tests.log dan analyze.log.
- Bukti adalah render widget dan pengujian interaksi terotomasi; belum ada rekaman browser/APK baru atau foto TV fisik 42 inci. Tidak menyatakan jangkauan fisik maupun playback audio sudah diuji. Belum push/deploy; paket lama tidak berisi revisi ini.
