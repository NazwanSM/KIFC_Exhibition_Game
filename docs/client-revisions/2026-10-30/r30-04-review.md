# KIFC-R30-04 Penutup 30 detik

Jatah penutup menjadi 30 detik; jatah feedback/hasil lain tetap 15 detik. Ketuk lebih cepat tetap kembali ke pembuka. Timer dihentikan saat navigasi manual dan tidak berkurang ketika dialog terbuka atau aplikasi tidak aktif. Aturan AGENTS terkait diperbarui mengikuti klarifikasi terbaru pemilik.

- Pengujian sebelum perubahan gagal karena penutup masih memiliki jatah 15 detik (red.log).
- Setelah implementasi, 40 tes terkait lulus: 3 regresi penutup, 15 render/kontrol lintas bahasa dan ukuran, serta 22 regresi feedback/reading yang sudah ada.
- flutter analyze --no-pub: No issues found.
- 15 render ID/EN/KO pada 360x640, 411x731, 720x1280, 1080x1920, dan 2160x3840. Seluruh kombinasi pada contact sheet diperiksa: teks 30 detik tampil tanpa overflow, judul, maskot, serta tombol tetap utuh.
- [Contoh render Indonesia](r30-04-closing.png). Bukti lokal: build/review-r30-04-2026-10-30/ berisi screenshots, contact.png, evidence-index.json, tests.log, red.log dan analyze.log.
- Ini render Flutter, bukan foto TV fisik atau playback baru di browser/APK. Narasi belum dibuat; audio selesai kelak tidak boleh mengendalikan navigasi penutup.
