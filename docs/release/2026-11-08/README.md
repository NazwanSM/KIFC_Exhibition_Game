# Panduan serah terima dan pemasangan - 8 November 2026

## Status yang perlu diketahui

Target: Samsung **QM43B-T, 43 inci, 3840 x 2160, Tizen 6.5**, orientasi portrait dan layar sentuh. Build ini memakai source commit `ac88d33dd4d323f2302baa2dffdcc00a1e66f132`, ID `final_20261108`; perubahan sesudah commit itu pada finalisasi hanya menyentuh alat packaging, verifikasi dan dokumentasi.

**Paket untuk TV belum dapat dinyatakan siap produksi.** WGT kandidat sudah dibuat dan diperiksa isinya, tetapi belum ditandatangani dan belum diuji pada QM43B-T fisik. Nomor `required_version=6.5` adalah deklarasi kompatibilitas minimum, bukan bukti game dapat dijalankan di perangkat tersebut. Tidak ada sertifikat/DUID TV di lingkungan ini. Jangan serahkan kandidat unsigned sebagai paket siap instalasi.

Pengujian tambahan Chromium 85.0.4183.0 di Windows, headless + SwiftShader, membuka game tetapi menghasilkan [tampilan rusak](chromium85-software.png), termasuk maskot hitam dan panel transparan, dengan [peringatan WebGL framebuffer](chromium85-console.txt). Chromium 86 dengan software rendering juga menampilkan [maskot hitam](chromium86-software.png). Chromium modern dengan opsi SwiftShader yang sama menampilkan warna maskot, sedangkan pengujian SDK Tizen 10 terdahulu menggunakan mesin berbeda. Temuan ini menunjukkan risiko nyata dan **belum membuktikan hasil pada GPU/firmware TV**. Samsung mencantumkan Chromium 85 untuk Tizen 6.5 secara umum; firmware dan kemampuan GPU pada unit signage harus diperiksa langsung: [spesifikasi web engine Samsung](https://developer.samsung.com/smarttv/develop/specifications/web-engine-specifications.html?device=signage).

## Berkas yang sudah disiapkan

Semua berkas disimpan lokal di `build/final-release-2026-11-08/` (folder `build` tidak ikut Git). Periksa [hash SHA-256](checksums.json) setelah memindahkan file.

| Berkas | Fungsi | Status |
| --- | --- | --- |
| `KIFC-Tizen-6.5-CANDIDATE-UNSIGNED.wgt` | Kandidat Flutter Web yang dikemas sebagai Tizen Web WGT dengan deklarasi 6.5 dan portrait | **Belum ditandatangani; belum diuji di TV; bukan paket siap produksi.** |
| `KIFC-Tizen-10-SIMULATOR-UNSIGNED.wgt` | Paket pembanding untuk simulator SDK Tizen 10 | Hanya alat uji simulator; tidak membuktikan kompatibilitas TV 6.5. |
| `KIFC-Web-LOCAL-EXTERNAL-PC.zip` | Build web untuk dijalankan dari komputer eksternal yang terhubung HDMI dan USB sentuh | Berkas lokal tersedia; perangkat komputer, output display, input sentuh dan audio masih perlu diuji bersama TV. |
| `KIFC-Android-REVIEW-DEBUG-SIGNED.apk` | Alternatif untuk perangkat Android eksternal yang kompatibel | Build review ditandatangani debug (terverifikasi CN Android Debug), Android API minimum 24; **tidak dipasang di Tizen** dan belum diuji pada perangkat terbaru. Kunci rilis produksi belum disiapkan. |
| `checksums.json` | Ukuran dan SHA-256 artefak | Periksa ulang sebelum digunakan. |

WGT adalah aplikasi **Flutter Web yang dibungkus sebagai Web WGT**, bukan konversi APK. Paket menyertakan aset dan CanvasKit lokal; pengujian membuktikan isi dan hash, bukan jaminan penuh offline pada OS TV.

## Langkah yang harus dilakukan saat TV tersedia

1. Catat model, firmware, versi Tizen, DUID dan IP perangkat; sambungkan PC pengembang dan TV ke jaringan yang sama. Atur orientasi fisik dan tampilan portrait sesuai setup signage. Hubungkan dan uji panel sentuh.
2. Siapkan Tizen Studio, Samsung TV Extension dan Samsung Certificate Extension. Ikuti [panduan sertifikat Samsung](https://developer.samsung.com/smarttv/develop/getting-started/setting-up-sdk/creating-certificates.html): buat atau impor profil penandatanganan resmi yang sesuai dan daftarkan DUID TV bila diperlukan. Simpan kunci author milik pemilik dengan aman; jangan bagikan di repository.
3. Buat proyek Tizen Web di Tizen Studio, ekstrak WGT kandidat (arsip ZIP) dan pindahkan isinya ke akar proyek, sehingga `config.xml`, `index.html` dan seluruh aset berada pada akar proyek. Lalu buat paket **signed** dengan profil sertifikat tersebut. Untuk jalur CLI lihat [petunjuk resmi package dan install](https://developer.samsung.com/smarttv/develop/getting-started/using-sdk/command-line-interface.html?device=signage). Periksa nama aplikasi dan checksum paket signed yang sebenarnya dihasilkan. Langkah signing belum diuji di sini.
4. Aktifkan mode developer dan sambungkan menggunakan SDB sesuai [panduan Samsung untuk perangkat](https://developer.samsung.com/smarttv/develop/getting-started/using-sdk/tv-device.html?device=signage). Setelah `sdb devices` menunjukkan unit yang benar, instal paket signed dengan Tizen Studio atau perintah `tizen install` sesuai nama paket dan target dari SDK. Kebijakan certificate/partner signage dapat berbeda; catat pesan error apa adanya.
5. Untuk USB/Custom App Launcher: Samsung menyebut signage mendukung instalasi melalui menu Custom App Launcher, tetapi format distribusi dan izin dapat bergantung pada firmware dan sertifikat. Ikuti [FAQ Samsung untuk signage](https://developer.samsung.com/smarttv/develop/faq/changes-and-news.html?device=signage); **jangan menganggap file WGT unsigned yang sekadar disalin ke USB akan terpasang**. Paket/metadata untuk jalur USB belum diverifikasi pada unit ini.
6. Pada TV sebenarnya, periksa dari welcome hingga penutup untuk Indonesia, Inggris dan Korea: maskot 3D berwarna serta bergerak, sentuh/seret, video, suara dan mute, bacaan Korea bertahap dan jeda satu detik, kuis, skor, restart dan kembali ke awal. Periksa akses lokal/offline, orientasi, batas layar, dan speaker. Uji juga kembali setelah perangkat dimatikan/dinyalakan.
7. Jalankan sesi panjang dan catat frame rate atau frame time, memori bila tersedia, suhu, waktu muat dan respons sentuh. Jika rendering hitam/rusak atau performa tidak stabil, jangan lanjut produksi dengan WGT ini; gunakan jalur komputer eksternal di bawah sambil investigasi dan pengujian target diteruskan.

## Jalur cadangan: komputer eksternal ke TV

1. Ekstrak `KIFC-Web-LOCAL-EXTERNAL-PC.zip` di komputer Windows yang memiliki Python 3 dan Chrome/Edge modern. Sambungkan HDMI untuk gambar dan kabel USB data touch panel ke komputer. Ini memakai komputer sebagai pemutar; instalasi aplikasi di Tizen tidak diperlukan.
2. Di Command Prompt, masuk ke folder `web` hasil ekstrak dan jalankan `py -3 -m http.server 8765 --bind 127.0.0.1`. Biarkan jendela server hidup.
3. Di komputer yang sama, buka `http://127.0.0.1:8765/` pada Chrome/Edge; jadikan full screen (F11) dan pindahkan ke layar TV. Jangan buka `index.html` langsung sebagai `file://`.
4. Atur display portrait, kalibrasi sentuhan Windows ke layar yang benar, dan arahkan audio ke output yang dipakai pameran. Jalankan seluruh uji pada langkah 6-7 di atas, termasuk mulai setelah restart dan sesi panjang. Ini **belum diuji pada perangkat pameran**; aset sudah lokal namun kebutuhan jaringan, autoplay dan pemulihan daya harus dibuktikan dalam setup sebenarnya.

## Petunjuk operator permainan

Pilih bahasa Indonesia, English atau 한국어 dan sentuh **Mulai Tantangan**. Babak 1: seret panas, bahan bakar dan oksigen ke area hutan, baca penjelasan. Babak 2: tiga bacaan berjalan otomatis setelah narasi dan jeda satu detik; layar dapat disentuh untuk lanjut lebih cepat. Jawab pertanyaan gambut dan gunakan kesempatan ulang bila diperlukan. Babak 3: tentukan penyebab empat situasi. Babak 4: buka tiga kartu, lalu pilih dampak yang benar dari enam gambar sebelum 30 detik atau tekan selesai lebih awal. Baca feedback dan hasil; maksimal 8 poin. Layar feedback selesai dapat dilanjutkan dengan sentuhan atau tunggu sekitar 15 detik; penutup kembali ke awal setelah 30 detik. Ikon speaker membuka pengaturan musik, ambience, efek dan mute. Sound baru dimulai setelah interaksi pengunjung.

## Hasil pemeriksaan akhir

- [Flutter analyze](analyze.txt): bersih; [496 tes Flutter](tests.txt): lulus pada Windows host, termasuk alur tiga bahasa, timing dan navigasi.
- [Build web release](web-build.txt): berhasil, resource CanvasKit lokal. [Build APK release](apk-build.txt): berhasil; [pemeriksaan 82 aset APK](apk-verification.json): lulus setelah alat QA mengenali video MP4 runtime yang memang dideklarasikan; [tes negatif](apk-qa-negative-test.txt) membuktikan video yang tidak dideklarasikan tetap ditolak. [Pemeriksaan kode AOT tiga ABI](apk-code-verification.json) menemukan teks Korea revisi pada ketiga binary; ini belum menggantikan uji APK terpasang.
- WGT 6.5 dan 10.0: integritas ZIP, hash seluruh file manifest, GLB, metadata timing dan empat audio Korea baru diperiksa. WGT tidak memiliki tanda tangan. Di simulator SDK 10, WGT 6.5 kandidat terpasang dan membuka welcome serta aktivitas unsur; percobaan otomatis pertama hanya mencatat 2/3 unsur, dan satu ulang seret panas mencapai 3/3. Pengulangan perjalanan penuh berikutnya timeout pada antarmuka debug, sehingga **perjalanan lengkap simulator terbaru belum lulus**. [Ringkasan dan bukti](simulator-result.json).
- Hasil layar Chromium 85/86 di atas adalah desktop software-rendered browser, **bukan Tizen OS emulator atau TV fisik**. SDK simulator Tizen 10 yang lebih baru tidak meniru engine atau hardware perangkat target.
- Pengujian Android pada perangkat, validasi Tizen 6.5, penggunaan speaker fisik, respons touch panel dan uji daya tahan masih terbuka. Batas dua cue kata Korea yang diestimasi ASR masih layak ditinjau dengan pendengaran.

## Membuat ulang artefak

Gunakan Flutter 3.35.5, dari root repository:

```powershell
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
flutter build web --release --no-pub --no-wasm-dry-run --no-web-resources-cdn --dart-define=KIFC_BUILD_ID=final_20261108 --output=build/final-release-2026-11-08/web
python tool/tizen/package_web.py --web-dir build/final-release-2026-11-08/web --output build/final-release-2026-11-08/KIFC-Tizen-6.5-CANDIDATE-UNSIGNED.wgt --required-version 6.5 --orientation portrait --app-version 1.0.11
flutter build apk --release --no-pub --build-name=1.0.11 --build-number=2026110801 --dart-define=KIFC_BUILD_ID=final_20261108
python tool/verify_apk.py build/app/outputs/flutter-apk/app-release.apk
```

APK ini menggunakan debug signing sebagaimana `android/app/build.gradle.kts`; buat signing produksi milik pemilik sebelum distribusi produksi Android. Pembuatan WGT kandidat tidak memerlukan sertifikat tetapi pemasangan pada perangkat memerlukan jalur signing yang sesuai.
