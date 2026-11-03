# KIFC-R30-19 — narasi dan teks bacaan Karhutla

Catatan historis: laporan ini menggambarkan integrasi awal. Source terbaru telah dicommit pada `d1a4278`; label persiapan telah dihapus, optimasi browser dan jeda satu detik setelah narasi telah diterapkan. Lihat [checkpoint integrasi](../github-integration-checkpoint.md), [optimasi](../mascot-browser-performance/README.md) dan [jeda terbaru](../reading-completion-delay/README.md). Batas review pendengaran/perangkat di bawah tetap berlaku.

Tiga bacaan menggunakan sembilan rekaman yang disetujui. Teks muncul bertahap berdasarkan posisi aktual pemutar audio dan tetap membentuk paragraf lengkap; tata letak menyediakan ruang untuk seluruh paragraf sejak awal. Selama persiapan muncul pesan penyiapan. Maskot memakai Talk selama suara dan mixer menurunkan musik/ambience. Animasi mulut adalah klip generik, bukan lip sync fonem.

Ketika narasi selesai, bacaan pertama dan kedua berpindah ke bacaan berikutnya; bacaan ketiga membuka kuis tanpa memilih jawaban. Lanjut atau ketukan latar melewati satu bacaan serta menghentikan audio lama. Timer peralihan dan nomor sesi mencegah event lama atau ketukan beruntun melewati bacaan berikutnya. Saat mute, teks memakai timeline sepanjang rekaman; saat aplikasi/dialog dijeda, timeline dan audio berhenti bersama. Jika audio gagal, teks ditampilkan utuh dengan pesan dan tombol manual. Reduced motion menampilkan paragraf lengkap langsung.

## Batas timing yang perlu ditinjau

Data runtime dihasilkan oleh `tool/prepare_reading_timing.py` dari draf yang diterima pemilik. Tujuh rentang Korea yang berisi frasa dipecah menjadi 15 cue kata berdasarkan proporsi jumlah karakter; waktu hasil pemisahan adalah **perkiraan**, belum diverifikasi satu per satu dengan pendengaran. Waktu yang ada tetap berasal dari draf, bukan penyelarasan fonem baru. Semua teks, urutan waktu, durasi dan SHA-256 sembilan audio diperiksa oleh `test/reading_timing_integrity_test.py`.

## Bukti

- [Indeks screenshot](screenshots.md): 21 capture Flutter web pada 360×640, 411×731, 720×1280, 1080×1920 dan 2160×3840 dalam tiga bahasa; bacaan 2 dan 3 juga dicapture dalam tiga bahasa pada 1080×1920. Fixture web screenshot memakai timeline senyap. Resolusi simulasi bukan bukti jangkauan fisik TV.
- Android TECNO LG7n Android 12, 720×1640: [Indonesia awal](id-5.png), [Indonesia tengah](id-13.png), [Indonesia bacaan berikutnya](id-22.png), [Inggris](en-13.png), [Korea](ko-13.png). Capture menggunakan APK debug review sebelum penambahan pesan persiapan; APK terbaru dengan pesan tersebut telah dibangun dan dipasang, tetapi belum dicapture ulang karena perangkat terkunci.
- [Sampel renderer Indonesia](id-samples.json), [Inggris](en-samples.json), dan [Korea](ko-samples.json) menunjukkan PointIdle/Talk dan playback aktif. Pada Android, bacaan Korea berlangsung otomatis hingga [kuis](ko-risk-android.png); [semantics](ko-risk-semantics.json) menunjukkan ketiga jawaban masih tersedia tanpa jawaban dipilih.
- [Dialog Android](android-dialog-lifecycle.json): Talk berhenti saat dialog pengaturan terbuka, lalu berjalan kembali setelah ditutup. Posisi dan pause/resume audio diuji pula melalui pemain palsu pada tes integrasi.
- [Web dengan audio produksi](web-audio-summary.json): audio tiga bacaan dimulai, bacaan pertama lanjut otomatis, dua berikutnya dilewati, suara berhenti dan kuis yang belum dijawab tampil. [Screenshot playback](web-id-audio-active.png). Capture mentah merekam sebagian event ganda karena instrumentasi browser dipasang dua kali; ringkasan tidak menganggapnya dua pemutar.
- Analisis Flutter bersih. Regresi 106 tes lulus setelah integrasi; empat tes integrasi terbaru juga lulus untuk reduced motion, gagal audio/manual, mute/background, posisi audio, skip cepat, callback lama, kembali dan masuk lagi, serta transisi ke kuis. Build web utama dan APK debug berhasil. Kode dan data timing terbaru diperiksa di dalam APK.

Belum ada rekaman audio permainan dari speaker dan belum ada uji pada TV pameran/Tizen. Review pendengaran pemilik diperlukan untuk 15 cue perkiraan, kenyamanan dan campuran suara. Perubahan tiket 17–19 masih berada di working tree dan commit per tiket masih perlu dirapikan.
