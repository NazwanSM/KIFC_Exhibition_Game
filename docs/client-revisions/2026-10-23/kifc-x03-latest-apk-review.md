# KIFC-X03 — APK terbaru, alur offline dan audio

24 Oktober2026. Pemilik meminta melanjutkan build/pengujian APK terbaru setelah koreksi audio web. Kode aplikasi e8f471f; build berasal dari a7796f7 dengan define KIFC_REVISION=x03-audio-e8f471f. Perubahan pada tiket ini adalah alat uji dan bukti; tidak mengubah urutan layar, skor, timer atau isi permainan.

## APK yang diperiksa

[Unduh APK pengujian](../../../build/review-kifc-x03-latest/KIFC-Challenge-2026-10-24-debug.apk),172309275bytes, SHA-256 `33f9719443910319ff9c6dfb1e2fc6b0b560617c6affbd1774b6761e756f8bf6`. Build **debug untuk pengujian**, bukan paket produksi dengan kunci rilis pemilik. Salinan bernama tetap di folder bukti agar build berikutnya tidak mengganti artefak ini.

[Verifikasi paket](../../../build/review-kifc-x03-latest/apk-verification.json):53 aset offline cocok hash terhadap checkout, marker gameplay/audio ada, tidak membundel MP4 mentah. Satu tes negatif pemeriksa APK lulus. [Build log](../../../build/review-kifc-x03-latest/apk-build.log), [analisis Flutter bersih](../../../build/review-kifc-x03-latest/analysis.log).239 tes Flutter dari koreksi audio tetap menjadi regresi sumber aplikasi; pada tiket ini tidak ada perubahan Dart dan fokus uji diperluas ke APK nyata.

## Perjalanan native

**Tiga perjalanan lengkap ID/EN/KO lulus** pada APK aktual, Android API35,1080×1920,density420. Input melalui ADB/UIAutomator, bukan penggantian state internal atau halaman review. Wi-Fi dimatikan, airplane mode diaktifkan melalui cmd connectivity dan dumpsys menunjukkan **Active default network: none**. Nilai global mobile_data dapat tetap1 pada SIM emulator walaupun tidak ada koneksi; bukti offline memakai jaringan aktif, bukan angka setting saja.

Setiap perjalanan memeriksa:

- Drop Air ditolak dan tetap0/3; tiga unsur berbeda melengkapi3/3. Api tampil setelah lengkap; sentuhan berikutnya menuju penjelasan.
- Tiga pengurangan unsur, narasi berubah dan kelanjutan otomatis ke bacaan Babak2. Tiga bacaan tetap manual dan kuis gambut tetap terpisah.
- Jawaban gambut salah menampilkan hint; jawaban benar membuka kelanjutan sentuh layar. Empat situasi penyebab tetap ada.
- Tiga kartu karakteristik dibuka tanpa skor. Tantangan akhir memakai pilihan netral; satu pengecoh dipilih lalu dibatalkan sebelum memilih empat dampak.
- Setelah waktu habis, ulasan muncul dan skor8/8 sesuai3unsur+4penyebab+1bonus. Penutup terbuka, Main Lagi kembali ke0/3.
- Efek complete sekali, finish sekali, flip3, retry2, correct7, select9; sumber audio disiapkan satu kali sepanjang perjalanan hingga replay. Tidak ada AudioPlayerException, unhandled Flutter exception atau fatal app exception pada log perjalanan yang diuji.

[Hasil tiga bahasa](../../../build/review-kifc-x03-latest/native-journeys.json), perbahasa: [ID](../../../build/review-kifc-x03-latest/id-final/result.json), [EN](../../../build/review-kifc-x03-latest/en-final/result.json), [KO](../../../build/review-kifc-x03-latest/ko-final/result.json). Folder masing-masing berisi input events dan app-logcat.txt.

## Kontrol audio dan lifecycle

Native mute menghentikan kedua loop/gain, unmute memulihkan, Home mem-pause dan kembali ke Activity memulihkan output. Master0 juga mem-pause; dikembalikan ke65%. Mute tetap tersimpan setelah kembali ke pembuka dan berganti bahasa. Sumber tetap disiapkan sekali. [Pemeriksaan lifecycle awal](../../../build/review-kifc-x03-latest/audio-lifecycle-checks.json), [setting lintas bahasa](../../../build/review-kifc-x03-latest/native-settings/result.json), log aktual ada pada folder yang sama. Setting mobile_data dalam snapshot awal tidak dipakai untuk menyimpulkan offline; hasil connectivity sesudahnya menjadi acuan.

## Screenshot

Seluruh gambar berikut adalah **capture APK di emulator**, bukan render widget atau foto TV. Indeks memuat seluruh tahap tiga perjalanan1080×1920; perbandingan tambahan720×1280 memakai density280, dan satu4K memakai density840. Resolusi/density dipilih untuk rasio portrait dan skala logical yang konsisten, bukan klaim ukuran fisik atau jangkauan42inci.

- [ID: api dan feedback](../../../build/review-kifc-x03-latest/id-final/assembly-complete.png)
- [ID: pilihan akhir netral](../../../build/review-kifc-x03-latest/id-final/final-neutral-mixed.png)
- [ID: hasil8/8](../../../build/review-kifc-x03-latest/id-final/score.png)
- [EN: penutup](../../../build/review-kifc-x03-latest/en-final/closing.png)
- [KO: tiga kartu](../../../build/review-kifc-x03-latest/ko-final/characteristics-closed.png)
- [KO: hasil8/8](../../../build/review-kifc-x03-latest/ko-final/score.png)
- [720p: panel Indonesia](../../../build/review-kifc-x03-latest/viewport-comparison/audio-panel-id-720x1280.png)
- [4K: pembuka Indonesia](../../../build/review-kifc-x03-latest/viewport-comparison/welcome-id-2160x3840.png)
- [Indeks perjalanan](../../../build/review-kifc-x03-latest/screenshot-index.json), [indeks perbandingan resolusi dan batasnya](../../../build/review-kifc-x03-latest/viewport-comparison/index.json).

Enam capture720p mencakup pembuka/panel ketiga bahasa. Tambahan panel4K tidak dinyatakan lulus karena alat host kehabisan alokasi memori; PID aplikasi tetap sama. [Render widget4K tiga bahasa dari koreksi audio](kifc-g04-audio-feedback.md) tetap tersedia dan sumbernya dibedakan dengan jelas.

## Performa dan lingkungan

[Observasi performa serta bagian NOT ASSESSED](../../../production/polish/android-emulator-report-2026-10-24.md). Snapshot PSS260.1MiB bukan puncak atau bukti bebas kebocoran. SurfaceFlinger hanya memberi timestamp0 sehingga FPS tidak dihitung. Hasil debug/emulator tidak dipakai untuk mengesahkan performa produksi/TV.

- Renderer SwiftShader awal mengeluarkan error glWaitSync0x501 dan emulator berhenti. Proses uji diulang dengan GPU host NVIDIA; tiga perjalanan lengkap kemudian lulus. Tidak mengubah manifest/renderer aplikasi.
- Stock UIAutomator menunggu idle saat countdown sehingga melewatkan waktu memilih. Helper shell khusus meniadakan idle wait, memastikan XML baru, dan memakai UI native aktual. [Panduan alat](../../../tool/android/README.md). Timer permainan tetap30detik.
- C tersisa sekitar290MB pada awal.13 direktori sementara kompilasi yang berisi referensi proyek, total1.44GB, diarsipkan secara reversible ke D:/KIFC-review-temp/archived-flutter-tools. Profil browser dan file pemilik tidak dipindahkan. TEMP/TMP build hanya diatur untuk proses ini, keD. AVD uji merupakan salinan di build; AVD asli tetap.
- APK lama dipertahankan sebagai build/review-kifc-g04-audio/app-debug-g04-initial.apk. Emulator ditutup sesudah pengujian untuk menghemat memori; override tampilan dipulihkan1080×1920/density420.

Status: verifikasi fungsional APK terbaru **Ditinjau**. KIFC-X03 keseluruhan tetap **Ditinjau sebagian** sampai uji TV fisik selesai; publikasi prarilis pengujian sudah diverifikasi di bawah. Kenyamanan speaker, jangkauan, waktu baca, durasi final dan persetujuan naskah Korea/KIFC masih terbuka. Status publikasi sudah diperiksa di bawah.


## Publikasi yang telah diverifikasi

Commit verifikasi **57f0467** sudah di-push ke main. [Workflow Pages](https://github.com/NazwanSM/KIFC_Exhibition_Game/actions/runs/40075079187) sukses: analisis bersih, **239 tes lulus**, build web release dan deploy berhasil. [Site pertama](https://nazwansm.github.io/KIFC_Exhibition_Game/) memuat hasil commit57f04675ebad162168569825246d9fe41646b137. Base href benar,53 aset ada pada manifest dan9 audio yang dilayani cocok hash. Pemutaran musik/alam/tap serta mute seluruh9 pemutar diperiksa langsung pada site publik tanpa error audio tak tertangani. [Hasil HTTP/hash](../../../build/review-kifc-x03-latest/published-web-checks.json), [pemutaran browser publik](../../../build/review-kifc-x03-latest/public-browser-audio.json), [panel browser publik](../../../build/review-kifc-x03-latest/public-browser-audio-panel.png).

[Prarilis APK pengujian](https://github.com/NazwanSM/KIFC_Exhibition_Game/releases/tag/review-2026-10-24-audio) menunjuk commit57f0467. Tiga unggahan selesai dan digest server/ukuran cocok lokal: APK172309275bytes, ZIP20 screenshot terpilih27061830bytes, dan SHA256SUMS.txt. [Metadata unggahan](../../../build/review-kifc-x03-latest/published-apk-release.json). APK tetap debug untuk review; tidak dinyatakan sebagai paket produksi.

- [APK](https://github.com/NazwanSM/KIFC_Exhibition_Game/releases/download/review-2026-10-24-audio/KIFC-Challenge-2026-10-24-debug.apk)
- [ZIP screenshot dan hasil](https://github.com/NazwanSM/KIFC_Exhibition_Game/releases/download/review-2026-10-24-audio/KIFC-testing-evidence-2026-10-24.zip)
- [Checksum](https://github.com/NazwanSM/KIFC_Exhibition_Game/releases/download/review-2026-10-24-audio/SHA256SUMS.txt)

Emulator sudah ditutup; preview lokal http://localhost:8080/ dijalankan kembali. Uji TV fisik, akustik, waktu baca, validasi bahasa dan kunci penandatanganan produksi tetap terbuka. Commit dokumentasi setelah57f0467 hanya merekam hasil ini, tanpa mengganti aplikasi yang terdeploy atau mengulang build.
