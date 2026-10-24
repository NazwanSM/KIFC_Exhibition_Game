# KIFC-G01 — gerakan interaksi dan feedback maskot

Pembaruan 24 Oktober 2026, atas permintaan pemilik untuk menambah animasi yang lebih interaktif dan halus. Status **Ditinjau**. Ini penyempurnaan tiket G01, bukan penambahan babak atau perubahan aturan.

Commit implementasi dan bukti: `531a0da` pada `main`. Preview utama memakai `lib/main.dart` di http://localhost:8080/ dan telah dimulai ulang setelah perubahan.

## Hasil implementasi

- Maskot muncul melalui fade, pergeseran naik 16 logical px dan scale .98 → 1 selama 380 ms. Transformasi berada di dalam crop lama; siluet dan logo tidak dibalik.
- Balon percakapan/feedback masuk 55 ms setelah gerakan dimulai, bergeser 8 px selama 320 ms. Pesan baru menggantikan pesan lama tanpa menumpuk. Teks tersedia utuh, tidak diketik huruf demi huruf.
- Diterapkan pada pembuka, penutup, bacaan Babak 2, hint/feedback benar/salah, assembly, penjelasan segitiga api, kartu karakteristik dan ulasan akhir. Penjelasan pengurangan unsur juga berganti lembut.
- Tombol navigasi, lanjut, pilihan penyebab dan demo mendapat respons tekanan .98 → 1. Callback, semantik, keyboard dan audio tetap ditangani tombol asal; pembatalan pointer tidak menjalankan aksi. CTA besar pembuka mempertahankan tekanan lamanya sehingga tidak mengecil dua kali.
- Slot terisi mendapat konfirmasi scale .94 → 1 selama 240 ms; tanda jawaban dan penanda pilihan muncul singkat. Tantangan akhir tetap memakai penanda netral sebelum deadline.
- Panel hasil dan tiga rincian masuk berurutan, dengan jeda 60/110/150/190 ms. Nilai sebenarnya langsung tersedia, tanpa menghitung melalui angka sementara.
- Semua gerakan baru selesai lalu berhenti, tanpa loop atau timer gameplay tambahan. Rebuild idle/countdown/audio tidak mengulang entrance. Reduced motion menampilkan keadaan akhir seketika, termasuk saat preferensi berubah di tengah animasi.
- Pemeriksaan browser pertama menemukan decode pose yang terlambat dari bubble. Empat pose sekarang disiapkan sekali sejak awal melalui cache gambar Flutter yang sama dengan tampilan (lebar decode 320 px). Tidak ada aset/dependensi baru. `gaplessPlayback` mempertahankan gambar lama bila terjadi pergantian sebelum decode siap.

Urutan layar, narasi, skor maksimum 8, waktu permainan, ukuran pilihan, posisi feedback/tombol dan crop akhir dipertahankan.

## Pemeriksaan

- **254 tes Flutter lulus**, dijalankan penuh secara serial pada kode akhir. Log: `build/interaction-motion-regression-final.log`.
- Analisis Flutter bersih: `build/interaction-motion-analysis.log`; `git diff --check` bersih.
- Lima tes komponen memeriksa penyelesaian/replay, layout, reduced motion, state/input anak, dan pembatalan/nonaktifnya tekanan. Sepuluh tes review menambahkan kesiapan decode serta sembilan kombinasi ukuran/bahasa.
- Tes kesiapan pose diamati gagal sebelum perbaikan, kemudian lulus; log RED/GREEN `build/interaction-motion-precache-{red,green}.log`. Pemeriksaan frame menegaskan pilihan tidak menyusut/bergeser, bubble tidak bertabrakan dengan pilihan, crop maskot mencapai dasar dan tap-anywhere tetap maju satu kali.
- Browser nyata: salah → hint → benar, tiga drag valid hingga 3/3/api, penjelasan → demo → ketiga pengurangan → bacaan tetap bekerja. Keempat PNG pose mendapat HTTP 200 sebelum jawaban pertama; tidak ada error console atau request gagal dalam snapshot pemeriksaan. Snapshot/rekaman dicatat pada `browser-checks.json`.

## Screenshot dan rekaman

Direktori bukti: `build/review-kifc-g01-motion/`; [indeks JSON](../../../build/review-kifc-g01-motion/evidence-index.json).

**81 widget render Flutter**: tiga bahasa × tiga ukuran (360×640, 1080×1920, 2160×3840) × sembilan keadaan. Keadaan: pembuka; hint pada 80/180/420 ms; benar pada 180 ms/selesai; demo; preview hasil 0 poin; penutup. Preview hasil 0 merupakan entry pengujian langsung, bukan bukti skor perjalanan; aturan skor dan perjalanan penuh diperiksa oleh suite regresi.

| Contoh | Full HD portrait | 4K portrait |
|---|---|---|
| Feedback salah, di tengah gerakan | [180 ms Indonesia](../../../build/review-kifc-g01-motion/hint-180ms-id-1080x1920.png) | [180 ms Indonesia](../../../build/review-kifc-g01-motion/hint-180ms-id-2160x3840.png) |
| Feedback benar, selesai | [Indonesia](../../../build/review-kifc-g01-motion/correct-settled-id-1080x1920.png) | [Korea](../../../build/review-kifc-g01-motion/correct-settled-ko-2160x3840.png) |
| Pembuka | [Indonesia](../../../build/review-kifc-g01-motion/welcome-id-1080x1920.png) | [Inggris](../../../build/review-kifc-g01-motion/welcome-en-2160x3840.png) |
| Penutup | [Indonesia](../../../build/review-kifc-g01-motion/closing-id-1080x1920.png) | [Korea](../../../build/review-kifc-g01-motion/closing-ko-2160x3840.png) |

Browser Chromium, viewport **720×1280 CSS px**, raster rekaman **1440×2560** karena DPR 2; memakai shell portrait web 411×730,67 logical px yang sudah ada. Ini berbeda dari widget render native di atas.

- [Feedback setelah koreksi decode](../../../build/review-kifc-g01-motion/feedback-browser-warmed.mp4).
- [Penyusunan tiga unsur dan penyelesaian](../../../build/review-kifc-g01-motion/assembly-browser.mp4), [screenshot 3/3](../../../build/review-kifc-g01-motion/assembly-browser.png).
- [Demo pengurangan, respons kontrol dan perpindahan ke bacaan](../../../build/review-kifc-g01-motion/demo-browser.mp4).
- `feedback-browser-720x1280.mp4` adalah percobaan pertama sebelum koreksi decode, dipertahankan sebagai pembanding. Contact sheet video adalah alat inspeksi internal; tidak dihitung dalam 81 screenshot widget.

Gambar Full HD hint, benar Korea 4K, browser 3/3 dan contact sheet sebelum/sesudah warmup diperiksa langsung. Bukti frame tersedia untuk seluruh kombinasi; tidak mengklaim setiap file diperiksa satu per satu pada resolusi penuh.

## Batas dan publikasi

Resolusi viewport bukan foto TV 42 inci atau validasi jangkauan fisik. Rekaman browser bersifat dokumentasi interaksi dengan sampling capture adaptif; angka FPS file rekaman tidak mengukur FPS aplikasi. Performa pada perangkat TV, speaker dan tinggi pemasangan tetap terbuka melalui D-09/X03.

Perubahan ini tersedia pada kode/preview lokal. APK prarilis dan GitHub Pages `57f0467` dari pengujian sebelumnya belum memuat penyempurnaan gerakan ini; belum membuat APK atau deployment baru untuk revisi ini.

Rancangan: [motion design](../../superpowers/specs/2026-10-24-interaction-motion-design.md). Implementasi memakai komponen bersama, tanpa rewrite alur game.
