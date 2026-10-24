# KIFC-X03 — Verifikasi integrasi 24 Oktober 2026

> Pembaruan24Oktober: dokumen ini mempertahankan snapshot integrasi sebelumnya. KIFC-09 kini berupa kartu tanpa skor; maksimum8 dan212 tes lulus. Bukti/build terbaru: [kartu09](kifc-09-flip-review.md) dan [hasil11](kifc-11-score8-review.md). APK terbaru dibangun dan diverifikasi paketnya; replay emulator09/11 serta uji TV fisik tetap terbuka.

**Kode aplikasi yang diuji: `01f2693`** (commit sesudahnya hanya tes/dokumentasi/peralatan verifikasi). Tidak ada push/deployment. Aplikasi normal tetap dimulai dari pembuka, dengan urutan lama.

## Matriks cakupan

| Materi/tiket | Otomatis dan visual | Browser/Android | Batas tersisa |
|---|---|---|---|
| 01 Pembuka | 3 bahasa, lima ukuran, pergantian judul langsung, tekan/batal CTA | Browser utama dan APK offline | Jangkauan TV fisik |
| 02 Susun unsur | Pengecoh, duplikat, drop, feedback, tap lanjut/reset; lima ukuran × tiga bahasa | APK: drag tiga unsur, tidak ada api sebelum lengkap | TV fisik |
| 03 Penjelasan | Narasi lengkap, panel sama, CTA/maskot tidak tabrakan | APK: enam api tampil offline | Penilaian visual pemilik |
| 04 Pengurangan | Tiga faktor, transisi padam/replay, rapid input | APK: Panas → padam | FPS/GPU perangkat fisik |
| 05–07 Bacaan | Naskah tiga bahasa, urutan/lanjut/kembali, empat aspek kerugian | Bukti widget dan perjalanan penuh | Penilaian bahasa klien |
| 08 Gambut | Tiga habitat, hint/reveal, satu retry, ukuran kartu tetap, feedback terangkat | Perjalanan penuh widget | Durasi/naskah tambahan D-05 |
| Babak 3 | Empat situasi, biner, feedback/skor, dipertahankan sesuai instruksi | Perjalanan ID/EN/KO | Penilaian pemilik |
| 09 Karakteristik | Usulan dua format siap | Layar tindakan lama tetap aktif | D-04/D-07; belum ada pengganti09 |
| 10 Dampak | 60 render, netral/toggle/deadline, hitungan/penalti/ulasan, timer30 | Browser aktual bermain → ulasan | Durasi final D-06 dan skor D-07 |
| 11 Hasil | Pesan KIFC, label bonus dampak, skor/ulang sesi/idle15 detik | Perjalanan tiga bahasa | Aturan/kategori final setelah09; waktu baca TV |
| Penutup | Dialog host, main lagi/beranda, reset bersih | Perjalanan tiga bahasa | TV fisik |
| Animasi/G02 | Alpha/fase/lifecycle/reduced motion/fallback; codec dan ukuran aset | Api dan padam offline Android | Profil performa TV |
| Audio/G04 | Tidak diaktifkan; cakupan paket tersedia | Tidak ada klaim uji audio | D-08/D-09 |
| Web preview | Rasio portrait tetap pada berbagai browser viewport | Edge aktual, localhost8080 | Tidak ada deployment baru |

## Hasil pemeriksaan final

- **191 tes Flutter lulus**, satu proses pengujian pada satu waktu, temporary directory di driveD: `build/review-kifc-integration/suite-d-drive.log`.
- **Analisis Flutter bersih**: `build/review-kifc-integration/analyze.log`.
- Render tambahan setelah perbaikan inset:33 keadaan Android logical411×731 dengan inset 52, ditambah matriks Babak 1 normal lima ukuran × tiga bahasa. Folder `build/review-kifc-g03/`; log `normal-viewports.log` berisi30 tes visual lulus.
- **APK debug berhasil dibangun**, `build/kifc-apk-insets.log`. APK [app-debug.apk](../../../build/app/outputs/flutter-apk/app-debug.apk),171657695 bytes. SHA-256 `2d732337859e2b4a5ca472d1655dd4344ecacc7b1a4d2ab24a6a5cf2f9e6bd8d`.
- `python tool/verify_apk.py` memeriksa44 aset offline beserta hash terhadap checkout, tidak ada MP4 mentah, dan marker kode debug terbaru. Hasil `apk-verification.json`:lulus. Uji fixture negatif memastikan pemeriksa menolak aset hilang/usang, kode debug usang, dan video mentah; `apk-verifier-test.log`:1 tes Python lulus.
- Browser: ketiga foto baru terdaftar pada manifest, HTTP200 dan hash cocok; `build/review-kifc-10/web-assets.json`. Edge menampilkan grid lengkap dan hasil1benar/1salah/3terlewat. Preview utama disegarkan: [browser-main-latest.png](../../../build/review-kifc-integration/browser-main-latest.png).
- Android emulator API35,1080×1920,density 420,font scale1.0; airplane mode1 dan Wi-Fi0. APK dipasang dan dibuka tanpa jaringan. Susun unsur, enam api, pengurangan Panas dan padam diperiksa melalui input serta screenshot emulator. Ini smoke test Babak 1, bukan klaim seluruh perjalanan APK sudah dimainkan.

## Bukti Android nyata

[Susun unsur](../../../build/review-kifc-integration/android-assembly-offline.png) · [Enam api](../../../build/review-kifc-integration/android-fire-offline.png) · [Demo](../../../build/review-kifc-integration/android-reduction-offline.png) · [Padam](../../../build/review-kifc-integration/android-extinguished-offline.png).

Screenshot Android berukuran1080×1920 fisik piksel. Screenshot widget dengan inset adalah411×731 logical piksel. Keduanya tidak membuktikan ukuran/jangkauan42 inci atau performa TV.

## Masalah lingkungan yang ditemukan dan ditangani

1. Emulator awal berhenti: driveC sempat tersisa sekitar 200 MB, log menyatakan disk tidak cukup. Emulator uji terpisah dibuat dari salinan data di `build/emulator-data`, dengan registry lokal `build/review-avds`; AVD asli tidak dipindahkan/dihapus. Opsi [direktori/image emulator](https://developer.android.com/studio/run/emulator-commandline) dipakai hanya untuk proses ini.
2. Tes paralel pertama gagal menyalin compiler output ke temporary directoryC. Percobaan berikutnya kehabisan memori saat emulator/Gradle dan runner masih aktif. Runner macet dihentikan, emulator selesai diuji lalu dimatikan, daemon Gradle dihentikan. Pengujian final berjalan serial dengan TEMP/TMP proses diarahkan ke `build/task-temp`, seluruh191 tes lulus. Tidak ada perubahan pengaturan sistem permanen atau penghapusan file pribadi.
3. APK build awal membawa keluaran20 Oktober yang usang meskipun perintah selesai. Hal ini terlihat dari screenshot dan isi ZIP tanpa aset baru. Build dipaksa ulang menggunakan `--dart-define=KIFC_REVISION=g03-insets`; kemudian aset dan kode paket diperiksa. Bukti APK/screenshot final di atas menggantikan hasil build awal; skrip verifikasi ditambahkan agar kasus itu terdeteksi.
4. APK baru mengungkap overflow46 logical px akibat cutout. Perbaikan dan regresinya tercatat pada [audit G03](kifc-g03-visual-audit.md).

## KIFC-11 dan alur/skor

Label bonus dampak diperbarui pada KIFC-10; rumus aktif tetap3+4+1+bonus≤1, maksimum 9. Tidak menghapus poin tindakan selama layar09 penggantinya belum disetujui. Dua opsi skor baru disiapkan dalam [usulan09](kifc-09-format-proposal.md). Babak 3 tetap ada sesuai instruksi pemilik. Idle15 detik pada hasil/penutup, penyegaran saat disentuh dan reset sesi diuji secara fungsional; kenyamanan membaca pada TV belum dinyatakan terbukti, sehingga11.04 tetap terbuka.

## Pekerjaan yang menunggu keputusan/perangkat

- KIFC-09/D-04 serta finalisasi skor11/X01/D-07.
- Durasi akhir tantangan30 detik/D-06 dan feedback gambut/D-05 setelah uji pengunjung.
- Audio/G04/D-08; paket konkret siap tanpa mengaktifkan suara.
- Dimensi/model player, tinggi pemasangan, speaker, uji jangkauan dan profil performa TV 42 inci/D-09; bukan sesuatu yang dapat disimpulkan dari viewport.
- Pengesahan naskah/terjemahan dan penilaian visual pemilik/klien.
- Rilis berikutnya menunggu instruksi push/deployment dan verifikasi site/commit yang tepat. APK saat ini debug untuk pengujian, bukan build rilis produksi.

Status integrasi **Ditinjau sebagian**. Seluruh pekerjaan implementasi/verifikasi yang sudah jelas dilanjutkan; bagian yang memerlukan keputusan di atas tidak ditandai selesai secara keliru.
