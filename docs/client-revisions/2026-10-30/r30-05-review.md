# KIFC-R30-05 Judul Karhutla pertama

Judul Indonesia menempatkan Tapi, pada baris tersendiri. Kebakaran Hutan? menjadi satu kelompok yang tidak dipisahkan saat wrapping. Bahasa Inggris mempertahankan naskahnya dengan Forest Fire? sebagai satu kelompok; Korea mempertahankan terjemahan alami yang ada. Ukuran font tidak diperkecil, dan semantics menormalkan whitespace agar pembaca layar serta pencari judul tetap memperoleh kalimat asli.

- Pengujian awal gagal pada judul Indonesia 360x640 sebelum perbaikan (red.log).
- 15 tes baru memeriksa posisi baris Tapi, dan selection box frasa agar Hutan?/Fire? tidak menjadi baris yatim; sekaligus memeriksa overflow dan kelanjutan ke bacaan kedua.
- 45 regresi tiga kartu Karhutla, tiga bahasa, lima viewport lulus. Total terkait tiket: 60 tes lulus; analisis bersih.
- 15 render definisi pada lima ukuran portrait dan tiga bahasa diperiksa melalui contact sheet: susunan judul, bubble, maskot dan CTA utuh. [Contoh Indonesia](r30-05-definition.png).
- Bukti lokal: build/review-r30-05-2026-10-30/ memuat screenshots, contact.png, evidence-index.json, red.log, tests.log, reading-cards.log dan analyze.log.
- Belum menambahkan TTS, subtitle per kata, atau maskot 3D; itu tiket selanjutnya. Render Flutter bukan foto TV fisik; belum ada browser/APK run baru atau deployment.
