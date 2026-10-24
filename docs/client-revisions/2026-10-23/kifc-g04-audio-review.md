# KIFC-G04 — musik, suara hutan dan efek interaksi

24 Oktober2026. Pemilik meminta melanjutkan audio, lalu menegaskan agar memakai audio internet yang diunduh. Penundaan sebelumnya digantikan instruksi ini. Cakupan implementasi mengikuti musik+alam+efek pada dokumen KIFC; tidak mencakup voice-over, TTS, pembelian aset atau pembuatan suara mentah.

## Hasil implementasi

- Musik TinyWorlds “Forest Ambience”, rekaman burung Joseph Sardin, dan enam efek Kenney diunduh dari sumber yang menyatakan CC0. [Sumber, lisensi dan konversi](../../../ASSET_SOURCES.md), [hash runtime/original](audio/asset-hashes.json), [lisensi Kenney](audio/kenney-license.txt). Delapan aset runtime total1,213,800bytes; seluruhnya berhasil didekode. Burung merupakan suasana ilustratif, bukan klaim rekaman fauna Indonesia.
- Semua aset dibundel offline. Dua pemutar loop dan satu pemutar efek dipakai ulang, tanpa membuat pemain baru setiap sentuhan. Pembaruan posisi audio per frame dinonaktifkan; tidak ada polling posisi untuk musik.
- Audio mulai setelah interaksi, tidak autoplay sebelum pengunjung menyentuh. Default master45%, musik35%, hutan45%, efek70%; gain keluaran merupakan perkalian dengan master. Setting berlaku selama aplikasi hidup, termasuk pergantian halaman/bahasa dan ulang sesi; aplikasi baru kembali ke default.
- Tombol speaker44×44logical px pada bar navigasi, pembuka dan penutup membuka panel yang mengikuti skala area sentuh terpusat. Empat slider dan mute mengendalikan output. Volume sistem tidak diubah.
- Latar belakang/inactive, mute dan master0 menghentikan keluaran; kembali aktif hanya memulihkan loop yang diizinkan, tanpa mengulang efek lama. Kegagalan output tidak menghalangi game dan tersedia coba lagi.
- Efek tombol/seleksi/kartu/demo netral. Benar/salah hanya berbunyi saat feedback yang memang membuka hasil. Semua pilihan tantangan dampak memakai efek netral yang sama; akhir waktu memakai penanda selesai. Pemutar efek tunggal dan cooldown100ms membatasi spam tanpa mengubah skor, timer atau urutan.
- Bar navigasi bertambah8px untuk target suara44px; dua gap dikurangi4px agar area isi tetap. Jarak header pembuka dikurangi6px agar tombol Mulai tetap dalam batas jangkauan viewport kecil. Ukuran pilihan tidak dikurangi.

## Pemeriksaan otomatis dan sumber bukti

**235 tes Flutter lulus**, termasuk pengujian lifecycle/mute, kondisi memuat ketika mute/dispose, input cepat, kegagalan dan retry, alur lengkap tiga bahasa, serta tidak bocornya jawaban melalui efek. Analisis Flutter bersih. Satu tes negatif pemeriksa APK lulus. Selanjutnya hanya diagnostik debug backend ditambahkan untuk mencatat hasil pemutaran nyata; tidak mengubah logika mixer.

Log dalam `build/review-kifc-g04-audio/`: `audio-suite-verified.log`, `audio-analysis-verified.log`, `audio-visual-verified.log`.17 tes kontrol/visual lulus saat rekaman gambar terakhir. Metadata screenshot menyatakan pemutar tiruan: gambar widget tidak membuktikan keluaran speaker.

## Tampilan lima ukuran × tiga bahasa

60 render widget: pembuka, panel suara, mute, dan panel pada Babak1; Indonesia/Inggris/Korea ×360×640,411×731,720×1280,1080×1920,2160×3840. Penutup juga diuji mempunyai kontrol suara. Ini simulasi TV, bukan foto atau pengukuran jangkauan fisik42inci.

- [Pembuka FullHD Indonesia](../../../build/review-kifc-g04-audio/audio-welcome-id-1080x1920.png)
- [Panel FullHD Indonesia](../../../build/review-kifc-g04-audio/audio-panel-id-1080x1920.png)
- [Panel4K Inggris](../../../build/review-kifc-g04-audio/audio-panel-en-2160x3840.png)
- [Panel Korea360×640](../../../build/review-kifc-g04-audio/audio-stage-panel-ko-360x640.png)

## Browser nyata

Preview bawaan gagal dua kali: `Preview automation snapshot timed out after 15000ms.` Pengujian dialihkan ke Edge pada aplikasi normal localhost8080, bukan halaman tiruan.

[Panel browser](../../../build/review-kifc-g04-audio/browser-panel.png), [mute](../../../build/review-kifc-g04-audio/browser-muted.png), [Babak1 setelah Mulai](../../../build/review-kifc-g04-audio/browser-stage.png). [Log hasil pemutar](../../../build/review-kifc-g04-audio/browser-playback.json) mencatat sumber siap, musik/nature `playing` dengan gain0.1575/0.2025, berubah `paused:0` saat mute/master0, kembali playing setelah dipulihkan, serta efek tap `playing` pada gain0.315. Ini hasil setelah `resume`/`pause` backend berhasil, bukan pengukuran akustik speaker. Tidak ada duplikasi pemutar pada perpindahan ke Babak1. Console juga memuat error dari ekstensi browser lain; itu bukan error pemutar KIFC.

[Delapan respons HTTP/hash](../../../build/review-kifc-g04-audio/web-assets.json) membuktikan bundel web terbaru menyajikan aset yang sama. [Decode delapan aset](../../../build/review-kifc-g04-audio/audio-decode.json) memeriksa durasi/codec dan decode penuh.

## Batas penilaian

Kenyamanan volume, keseimbangan di ruangan, kemampuan speaker dan performa pada TV42inci fisik tetap menunggu perangkat pemasangan. Bukti viewport, log pemutar dan emulator tidak menggantikannya. Tidak ada push/deployment pada pekerjaan ini.


## APK dan Android offline

APK debug [app-debug.apk](../../../build/app/outputs/flutter-apk/app-debug.apk):172,301,355bytes, SHA-256 `73e4bf3b340ef09754bd14c7c7ebe2eeea689cfb8d25a7638e3e33fb15580e16`, build define `KIFC_REVISION=g04-audio-offline`. [Pemeriksaan paket](../../../build/review-kifc-g04-audio/apk-verification.json):52 aset offline cocok hash, marker `GameAudioController` ada, tidak membundel MP4 mentah. Diagnostik debug tambahan hanya untuk verifikasi; pengubahan kurung kurawal lint sesudah build tidak mengubah perilaku yang diuji.

Emulator API35,1080×1920,density420. Airplane mode1, Wi-Fi0. APK dipasang dan dijalankan; musik/hutan mulai setelah tombol speaker, mute mengubah dua loop menjadi paused/gain0, unmute memulihkan gain, Home menghentikan output dan kembali ke Activity memulihkannya. Sumber siap hanya sekali (tiga pemutar), lalu efek tombol Mulai berhasil dimainkan. [Metadata pemeriksaan](../../../build/review-kifc-g04-audio/android-checks.json), [log aktual](../../../build/review-kifc-g04-audio/android-playback.log).

- [Pembuka Android](../../../build/review-kifc-g04-audio/android-welcome.png)
- [Panel Android](../../../build/review-kifc-g04-audio/android-panel.png)
- [Mute Android](../../../build/review-kifc-g04-audio/android-muted.png)
- [Babak1 Android](../../../build/review-kifc-g04-audio/android-stage.png)

Build awal memasang Android SDK Platform35 yang dibutuhkan plugin dan melaporkan kegagalan cache incremental Kotlin karena Pub Cache berada diC dan checkout diD. Compiler fallback tetap menghasilkan APK dengan exit0; paket dan pemutaran native kemudian diverifikasi. [Log build](../../../build/review-kifc-g04-audio/apk-build.log). Pengujian dijalankan berurutan dan emulator dimatikan setelah selesai untuk menghemat memori. Tidak ada perpindahan cache/AVD asli atau perubahan volume sistem.
