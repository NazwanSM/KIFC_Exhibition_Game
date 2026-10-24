# KIFC-G04 — koreksi bunyi interaksi dan pemulihan web

24 Oktober 2026. Pemilik melaporkan efek kurang terdengar, sejumlah tombol belum berbunyi, dan audio sesekali berhenti/error. Pemilik mengonfirmasi kasus berhenti terjadi di website.

## Temuan dan perubahan

- Klik lama hanya7.12ms. Diganti rekaman Kenney click_001 menjadi97.12ms; semua efek dinaikkan levelnya dengan limiter, tanpa membuat suara mentah. Efek kartu yang lebih pelan mendapat penguatan tersendiri. Musik dan ambience tetap dari sumber CC0 yang sama.
- Default master65%, musik25%, hutan30%, efek100%. Gain output efek0.65, sebelumnya0.315; gain musik0.1625 dan hutan0.195, mendekati latar sebelumnya0.1575/0.2025. Volume sistem tidak diubah. Seluruh lapisan tetap dapat diatur/mute.
- Aktivasi sebelumnya hanya melalui PointerDown. Dapat direproduksi pada browser: aksi tombol melalui semantics berpindah halaman tanpa membuat pemutar. Kini callback interaksi juga mengaktifkan audio; timer tidak membuka autoplay.
- Bunyi mencakup Mulai, bahasa, Kembali/Ulangi, CTA, lanjut dengan sentuhan layar, ulang dari penutup, buka/tutup pengaturan dan kredit foto, unmute serta pelepasan slider. Tombol nonaktif tidak berbunyi. Mute/volume nol tetap senyap. Tooltip pengaturan langsung mengikuti bahasa.
- Dua loop dan tujuh efek menggunakan sumber tetap yang dimuat sekali, maksimum9 pemutar aktif. Sebelumnya satu kanal efek mengganti sumber setiap klik. Kini satu efek yang gagal dibuang dan dibuat ulang pada pemakaian berikutnya; musik/alam tidak ikut dimatikan. Lane mixer terpisah dari efek agar kontrol suara tidak menunggu antrean efek. Penanganan output latar yang gagal tetap menyediakan tombol coba lagi dan percobaan berikutnya setelah backoff2detik, tanpa mengubah pilihan mute/volume.
- Efek finish.wav khusus akhir kuis merupakan dua frasa rekaman Kenney yang disambung,0.780s. Diputar tepat sekali pada batas waktu, dapat selesai tanpa terpotong efek navigasi. Tidak memberi petunjuk benar/salah sebelum ulasan. Semua pilihan kuis terakhir tetap netral.
- Urutan layar, skor8, timer30detik, aturan jawaban, dan alur kartu tetap.

[Sumber/konversi/lisensi](../../../ASSET_SOURCES.md), [hash9 aset](audio/asset-hashes.json). Aset offline sekitar1.29MB; tidak ada VO/TTS atau pembelian.

## Verifikasi

**239 tes Flutter lulus**, analisis tanpa temuan. Dua regresi diperiksa gagal sebelum perbaikan: semantics tanpa PointerDown tidak menyiapkan audio, dan kegagalan satu efek membuat unavailable=true. Tes kini lulus. Tes tambahan meliputi pemulihan setelah backoff dengan mute tetap tersimpan, akhir kuis tepat sekali, kredit foto buka/tutup, navigasi hasil dan tombol ulang khusus penutup. Penutupan dialog memakai controller yang ditangkap dari game karena konteks dialog berada di luar audio scope.

17 tes kontrol/visual diulang dengan60 screenshot: lima ukuran×tiga bahasa×empat keadaan. Pemeriksaan alur lengkap menjaga pilihan final netral dan tidak menumpuk pemutar saat ulang.

Bukti lokal di [folder koreksi](../../../build/review-kifc-g04-audio-feedback/):

- [Suite239tes](../../../build/review-kifc-g04-audio-feedback/full-suite.log), [analisis](../../../build/review-kifc-g04-audio-feedback/analysis.log), [17tes visual](../../../build/review-kifc-g04-audio-feedback/visual-suite.log).
- [Decode penuh/durasi/level9aset](../../../build/review-kifc-g04-audio-feedback/asset-decode-levels.json), [9respons HTTP/hash dan manifest terbaru](../../../build/review-kifc-g04-audio-feedback/web-assets.json).
- [Pemutaran nyata dan pemulihan browser](../../../build/review-kifc-g04-audio-feedback/browser-stress-recovery.json): dua loop playing, efek berhasil; satu penolakan play sengaja disuntikkan pada tap. Klik berikutnya membuat ulang cue dan playing berhasil, tanpa menghentikan loop. Delapan putaran Kembali/Mulai menghasilkan16aksi navigasi;9context tetap aktif. Total10context dibuat karena satu yang rusak ditutup. Tidak ada unhandled rejection/window error. Event Empty src pada pemutar yang dibuang tercatat sebagai akibat disposal, bukan error pemutar aktif.
- [Mute/unmute browser](../../../build/review-kifc-g04-audio-feedback/browser-mixer.json): seluruh gain aktif0 dan loop paused saat mute; unmute memulihkan gain tanpa menambah pemutar.
- [Akhir kuis browser](../../../build/review-kifc-g04-audio-feedback/browser-final-deadline.json): finish playing sekali dan ended sekali,9context, tanpa error tak tertangani. Browser memasuki kartu09 melalui entry review pengembangan lalu menuju tantangan; deadline diuji tanpa pilihan. Penilaian suara pilihan benar/salah dan tombol penutup diperiksa pada tes perjalanan otomatis. Upaya klik pilihan yang sudah kedaluwarsa tidak dihitung sebagai bukti pilihan browser.

Browser memakai preview T3 Chromium dan komponen Flutter aktual. Instrumentasi hanya di halaman pengujian untuk mencatat HTMLMediaElement, gain dan AudioContext; tidak masuk kode produksi. Screenshot tidak membuktikan kenyamanan akustik speaker. APK lama dari review awal belum dibangun ulang untuk koreksi ini; fokus laporan pemilik adalah web.

## Screenshot

Widget render, bukan foto perangkat fisik. Simulasi1080×1920 dan2160×3840 mencakup rasio TV portrait42inci, tetapi tidak mengukur tinggi pemasangan/jangkauan atau speaker.

- [Panel Indonesia FullHD](../../../build/review-kifc-g04-audio-feedback/audio-panel-id-1080x1920.png)
- [Panel Inggris4K](../../../build/review-kifc-g04-audio-feedback/audio-panel-en-2160x3840.png)
- [Panel Korea360×640](../../../build/review-kifc-g04-audio-feedback/audio-panel-ko-360x640.png)
- [Indeks60render](../../../build/review-kifc-g04-audio-feedback/screenshot-index.json)
- [Panel browser1080×1920](../../../build/review-kifc-g04-audio-feedback/browser-panel-1080x1920.png)
- [Ulasan setelah bunyi akhir — browser1280×800 dengan shellportrait](../../../build/review-kifc-g04-audio-feedback/browser-final-review.png)

Status Ditinjau secara lokal. Volume ruangan/TV fisik dan pengesahan pemilik tetap terbuka. Tidak ada push/deploy.
