# KIFC-R30-01 Menghapus caption pembuka

Caption hutan gambut/aliran air, ikon tetesan air, serta pemisah barisnya dihapus. Kontrol suara dipindah ke baris pilihan bahasa, tanpa mengubah bubble, maskot, tombol mulai, atau perilaku permainan.

- 23 tes lulus: 15 pemeriksaan layout/kontrol lintas ukuran dan bahasa serta 8 regresi gerakan percakapan pembuka/penutup. Dialog suara tetap dapat dibuka/ditutup dan tombol Mulai masuk ke aktivitas unsur.
- `flutter analyze --no-pub`: No issues found.
- 15 render pembuka: ID/EN/KO pada 360x640, 411x731, 720x1280, 1080x1920, 2160x3840; contact sheet seluruh kombinasi diperiksa secara visual. Tidak terlihat overflow, caption/pemisah sisa, atau tabrakan kontrol.
- [Contoh render Indonesia 411x731](r30-01-welcome.png).
- Bukti lengkap lokal: `build/review-r30-01-2026-10-30/`, termasuk `screenshots/`, `evidence-index.json`, `contact.png`, `tests.log`, dan `analyze.log`.
- Sumber bukti adalah render UI Flutter, bukan foto TV. Belum ada browser/native run baru, pengujian speaker, APK baru, atau deployment pada tiket ini.
