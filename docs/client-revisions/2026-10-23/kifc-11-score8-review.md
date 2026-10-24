# KIFC-11 — Hasil akhir setelah kartu informasi tanpa skor

24 Oktober 2026. Keputusan pemilik bahwa KIFC-09 bukan soal diterapkan pada seluruh perhitungan, bukan hanya menyembunyikan nilai pada kartu.

## Skor aktif

| Bagian | Maksimum |
|---|---:|
| Menyusun unsur | 3 |
| Mengenali penyebab | 4 |
| Bonus mengenali dampak | 1 |
| Kartu karakteristik gambut | 0 — tidak ditampilkan sebagai baris skor |
| **Total** | **8** |

Tantangan dampak tetap memberi+1 benar/−1 salah, minimum0, lalu hasil dibagi4 menjadi bonus0–1. Membuka/menutup/membaca ulang kartu tidak menambah poin dan tidak mengurangi bonus. Tidak ada lagi baris “Memilih tindakan aman” atau maksimum9 pada hasil aktif. Pesan penutup KIFC, Selesai, Main Lagi, dan kembali ke awal tetap tersedia.

Kategori memakai proporsi capaian sebelumnya: tertinggi≥8/9 dari maksimum, menengah≥6/9 dari maksimum. Pada maksimum8 dengan langkah nilai0.25, batas yang dapat diraih adalah7.25 dan5.5. Ini keputusan implementasi vendor untuk mempertahankan tingkat capaian yang setara, bukan mengubah bobot kuis lain.

| Batas yang diuji lewat permainan lengkap | Hasil |
|---|---|
| 7 | Menengah |
| 7.25 | Tertinggi |
| 5.25 | Coba lagi |
| 5.5 | Menengah |

Dua tes batas gagal pada ambang angka lama sebelum perubahan (`build/kifc11-score-red.log`), lalu empat kasus lulus (`build/kifc11-score-green.log`). Setiap kasus membuka ulang kartu pertama untuk membuktikan tidak ada poin tambahan.

## Bukti tampilan

Render Flutter lima ukuran × tiga bahasa tersedia pada `build/review-kifc-11-score8/`. Awalan `impact-score` menunjukkan hasil setelah tantangan dampak, dari fixture yang mulai di kartu informasi; nilai dasar unsur/penyebab pada fixture itu0. Perjalanan penuh dan tes batas menguji nilai aktual7/7.25/5.25/5.5 serta nilai sempurna8.

- [Hasil FullHD Indonesia](../../../build/review-kifc-11-score8/impact-score-id-1080x1920.png), [4K Korea](../../../build/review-kifc-11-score8/impact-score-ko-2160x3840.png), [360×640 Inggris](../../../build/review-kifc-11-score8/impact-score-en-360x640.png).
- [Kategori7.25 dari perjalanan lengkap](../../../build/review-kifc-11-score8/id-411-score-category-7-25.png), [kategori5.5](../../../build/review-kifc-11-score8/id-411-score-category-5-5.png).
- [Kartu informasi sebelum/sesudah dibuka dan animasi](kifc-09-flip-review.md).

## Pemeriksaan dan build

19 tes visual/batas lulus (`build/kifc11-visual.log`), termasuk15 kombinasi ukuran/bahasa. Analisis bersih (`build/review-kifc-11-score8/analyze.log`). Seluruh **212 tes Flutter lulus**; log regresi final: `suite.log` pada folder yang sama. Pemeriksa APK mempunyai satu tes negatif yang lulus.

APK debug terbaru: [app-debug.apk](../../../build/app/outputs/flutter-apk/app-debug.apk),171646861 bytes; SHA-256 `ac3aa53481fdcc2aa8e68f2f0b87154fb8e95da4f9bb21849352a47d2e3cb260`. Build dipaksa mengompilasi kode baru dengan `KIFC_REVISION=a11eb8b-score8`;44 aset offline/hash dan marker kode kartu diperiksa oleh `tool/verify_apk.py`, hasil lulus di `build/review-kifc-09/apk-verification.json`. Tidak ada APK lama yang dianggap sebagai revisi ini. APK ini dibangun/diverifikasi paketnya, belum dimainkan ulang di emulator setelah perubahan09/11; bukti interaksi revisi ini berasal dari browser dan widget Flutter.

Status KIFC-11.03 diterapkan. Idle15detik dan refresh saat sentuhan tetap diuji fungsional; kenyamanan membaca/jangkauan TV fisik pada11.04 masih terbuka. Tidak ada push/deploy atau audio baru.
