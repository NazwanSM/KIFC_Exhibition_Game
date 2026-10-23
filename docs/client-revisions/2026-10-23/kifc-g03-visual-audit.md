# KIFC-G03 — Audit visual dan inset Android

24 Oktober 2026. Audit memakai render tiap tiket yang telah dibuat serta perjalanan game dan APK debug nyata. Tidak menambah kepadatan pola yang sudah disetujui atau mengganti foto tanpa tujuan materi.

| Layar | Komposisi dan visual yang diperiksa | Bukti |
|---|---|---|
| Pembuka | Foto gambut tetap penuh, gradasi area teks, host berdialog, label bahasa utuh, CTA besar | KIFC-01 dan `android-welcome-offline.png` |
| Susun unsur | Tiga slot sama besar, kategori hanya setelah terisi, bank foto satu rasio/grading; api menunggu3/3 | KIFC-02; mockup Babak1; `android-assembly-offline.png` |
| Segitiga api | Hutan/floor dan unsur konsisten; enam api tidak menutupi kartu; CTA/maskot terpisah | KIFC-03; `android-fire-offline.png` |
| Kurangi unsur | Panel sejajar layar sebelumnya, pilihan satu baris, penjelasan dekat hutan, tanpa ruang kosong atas berlebihan | KIFC-04; `android-reduction-offline.png`, `android-extinguished-offline.png` |
| Definisi, penyebab, pencegahan | Foto/naskah/host berhubungan, bacaan pendek manual; empat aspek kerugian tetap lengkap | indeks KIFC-05/06/07 |
| Kuis gambut | Tiga habitat tidak tertukar; foto cover tanpa stretch; feedback terangkat, jawaban tidak mengecil | indeks KIFC-08 |
| Situasi manusia/alam | Foto tiap situasi, dua pilihan besar, feedback mascot di sisi sesuai hasil | perjalanan lengkap ID/EN/KO |
| Tindakan lama (calon09) | Simulasi lapangan, tiga tindakan, hint/reveal; dipertahankan sambil menunggu D-04 | indeks perjalanan; bukan implementasi pengganti09 |
| Dampak/ulasan | Enam visual berbeda, crop/filter seragam, label panjang utuh, penanda netral lalu benar/salah/terlewat | indeks KIFC-10 |
| Hasil/penutup | Skor, pesan KIFC, dua CTA serta dialog host tetap terbaca | KIFC-11; perjalanan Korea |

## Temuan yang diperbaiki

APK Android pada1080×1920, density420 (sekitar411×731 logical px) mempunyai cutout atas sekitar52logical px. `SafeArea` mengurangi ruang aktual tetapi sebelumnya ukuran `MediaQuery` masih setinggi layar penuh. Ukuran panel/spacing normal dipilih walaupun ruang yang tersisa memerlukan versi compact. Akibatnya susun unsur overflow46logical px dan maskot menabrak kartu.

`TouchscreenArea` kini meneruskan ukuran ruang aman aktual kepada turunannya. Pemilihan compact di layar memakai tinggi yang tersedia setelah inset, bukan tinggi panel penuh. Preset hutan tetap248normal/216compact, rasio/ukuran relatif kartu tetap1.8:1; tidak mengubah urutan atau mekanisme. Semua layar terkait ikut diperiksa untuk mencegah regresi.

## Bukti dan pemeriksaan

- `test/android_insets_test.dart`:3 tes bahasa, masing-masing11 keadaan layar dengan inset52;33 render tersimpan di `build/review-kifc-g03/`. [Susun ID](../../../build/review-kifc-g03/android-inset-assembly-id.png), [lengkap KO](../../../build/review-kifc-g03/android-inset-complete-ko.png), [demo EN](../../../build/review-kifc-g03/android-inset-breakTriangle-en.png).
- Tampilan tanpa inset diuji ulang melalui seluruh suite, termasuk lima viewport/tiga bahasa pada tes visual yang sudah ada. Seluruh191 tes lulus dalam `build/review-kifc-integration/suite-d-drive.log`.
- APK offline1080×1920: [susun unsur](../../../build/review-kifc-integration/android-assembly-offline.png), [api](../../../build/review-kifc-integration/android-fire-offline.png), [demo](../../../build/review-kifc-integration/android-reduction-offline.png), [padam](../../../build/review-kifc-integration/android-extinguished-offline.png). Semua foto/animasi/font berasal dari bundel lokal, mode pesawat aktif dan Wi-Fi mati. Penyeretan3unsur dan pilihan Panas dilakukan lewat input emulator.
- Analisis bersih: `build/review-kifc-integration/analyze.log`. Log aplikasi Android tersimpan; pencarian overflow/asset error/fatal pada potongan log setelah perbaikan tidak menemukan hasil.

Bukti APK berbeda dari widget render dan bukan foto TV42inci. Stabilitas jangka panjang, FPS/GPU TV dan jangkauan fisik masih perlu perangkat. Foto Malaysia/AS pada tantangan dampak dijelaskan sebagai contoh, bukan lokasi Indonesia; kandidat pengganti dokumentasi lokal dapat dinilai klien tanpa menunda fungsi offline yang tersedia.
