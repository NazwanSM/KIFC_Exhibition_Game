# Paket APK dan panduan untuk TV

Disiapkan pada 28 Oktober 2026 sesuai permintaan pemilik proyek: satu ZIP berisi APK terbaru, panduan bermain, serta instalasi TV beserta penanganan error.

## Isi paket

- `00_MULAI_DI_SINI.txt` memberi urutan penggunaan dan kebutuhan perangkat.
- `01_APK/KIFC-Fire-Prevention-Challenge-1.0.5.apk` merupakan salinan tanpa modifikasi dari APK review terakhir.
- `02_Panduan/01_Panduan_Bermain.pdf` memuat empat halaman bergambar: mulai bermain, menyusun dan mengurangi unsur, penjelasan/kuis/kartu informasi, tantangan akhir dan perhitungan skor.
- `02_Panduan/02_Instalasi_TV_dan_Penanganan_Error.pdf` memuat enam halaman: kompatibilitas, USB dan pengaturan portrait/touch, uji penerimaan/operasi/pembaruan, error instalasi, masalah runtime, serta ADB dan pelaporan opsional.
- `03_Info_Paket/INFO_VERSI.txt` mencatat identitas APK, basis kode, signing review, dan batas bukti QA.
- `SHA256SUMS.txt` berisi hash kelima berkas lain dalam paket.

ZIP berada di `build/client-delivery-2026-10-28/KIFC-Game-1.0.5-2026-10-28.zip`. Artifact besar, PDF, serta render pemeriksaan disimpan di `build/` yang diabaikan Git. Tidak ada perubahan kode aplikasi, pembaruan APK, pemasangan pada perangkat, atau deployment dalam pekerjaan ini.

## Sumber dan pembuatan ulang

Naskah terstruktur berada di [delivery-content.json](delivery-content.json). Generator [build_client_delivery.py](../../../tool/build_client_delivery.py) menggunakan ReportLab, PyMuPDF, dan Pillow. Tujuh gambar berasal dari render UI Flutter aktual pada 27 Oktober, dengan asal, resolusi, dan hash dicatat dalam [indeks gambar](screenshots/index.json). Gambar hanya diperkecil proporsional, bukan diubah komposisinya; bukan foto TV fisik.

```powershell
python tool/verify_apk.py build/review-speech-bubble-audit-2026-10-27/KIFC-Review-1.0.5.apk --report build/client-delivery-2026-10-28/apk-verification.json
python tool/build_client_delivery.py
```

Generator memerlukan APK sumber yang disimpan lokal. Hash APK dikunci agar paket tidak diam-diam mengambil APK lain. Skrip memeriksa jumlah halaman PDF, CRC ZIP, daftar berkas, serta kesamaan hash semua berkas ZIP dengan sumbernya. Render sepuluh halaman harus ditinjau secara visual sebelum hasil baru dikirim.

## Pemeriksaan pada paket ini

- APK: versi `1.0.5`, versionCode `20261029`, package `id.kifc.fire_prevention_challenge`, minimum API 24 (Android 7.0), target API 36. Kode build bukan tanggal pengemasan.
- ABI: `armeabi-v7a`, `arm64-v8a`, dan `x86_64`, dibaca melalui `aapt dump badging`.
- Tanda tangan v2 APK lolos `apksigner verify`; sertifikat Android Debug. Bukan signing produksi pemilik.
- SHA-256 APK `3fb03003f97fb384beec891a51da7b1985e51dbf5100885af3a61e7cb13ee95b`; 53 aset runtime cocok dengan checkout.
- Basis kode game `5b3fb42`, baseline repo `86a00c9` dengan pipeline 325 tes lulus. Paket tidak mengklaim native run baru atau uji TV fisik.
- Sepuluh halaman PDF dirender dan semuanya diperiksa secara visual: tidak ada teks terpotong, tabrakan, halaman kosong, atau gambar yang ditarik tidak proporsional. Tautan referensi teknis ditanam sebagai anotasi PDF.
- Laporan final lokal: `build/client-delivery-2026-10-28/package-verification.json`; hasil APK: `apk-verification.json`; render: `qa/`.
- Pemeriksaan ZIP independen membaca ulang lima checksum, tujuh gambar PDF, empat tautan referensi, batas teks sepuluh halaman, dan komponen bubble terbaru pada ketiga ABI APK. Hasil: `independent-verification.json`.
- ZIP final berukuran 51.563.143 byte (sekitar 51,6 MB); SHA-256 `6f978afcb0d86a5dc552c9c212a9e9dcbcef4ef4b18d2b722ed165bd9c20aeac`.

Panduan menjelaskan keterbatasan peluncur biasa tanpa `LEANBACK_LAUNCHER`, kebutuhan touchscreen/gesture seret, pemetaan touch terpisah dari HDMI, dan ketergantungan orientasi pada vendor. Tidak mengarahkan operator untuk menghapus aplikasi, menonaktifkan perlindungan global, atau reset pabrik sebagai langkah pertama. ADB hanya berupa instruksi; tidak ada skrip instalasi otomatis.

## Rujukan Android

Rujukan primer diperiksa 28 Oktober 2026 dan dicantumkan di PDF:

- [Android Debug Bridge](https://developer.android.com/tools/adb)
- [Create and run a TV app](https://developer.android.com/training/tv/get-started/create)
- [Signing considerations](https://developer.android.com/studio/publish/app-signing#considerations)
- [Play Protect pada Android TV](https://support.google.com/androidtv/answer/12188351?hl=en)

Aturan permainan dibandingkan dengan kode `exhibition_game.dart` dan catatan QA proyek, termasuk durasi akhir 30 detik, kelanjutan hasil 15 detik, percobaan pengurangan kumulatif, serta skor maksimum delapan.
