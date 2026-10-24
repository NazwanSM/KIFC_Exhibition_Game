# KIFC-09 — gambar kartu dan percakapan maskot

24 Oktober2026. Koreksi langsung pemilik setelah review kartu pertama.

- Tiga sampul memakai foto berbeda: bara/asap gambut, serasah kering, dan detail nyala api. Foto konteks menggunakan aset offline yang sudah berlisensi di ASSET_SOURCES; bukan bukti visual langsung seluruh mekanisme di balik kartu.
- Crop memakai cover dengan proporsi asli dan titik fokus sesuai foto; grading serta gradasi gelap menyatukan warna dan menjaga angka1–3 terbaca.
- Memakai kembali komponen feedback yang sudah ada: balon berbingkai netral, maskot presenting setengah badan lebih besar di kiri, teks di kanan. Tidak menambahkan warna benar/salah.
- Penghitung kartu dihapus dari tampilan. State baca tetap disimpan untuk mengaktifkan CTA setelah ketiga kartu pernah dibuka. Membalik ulang tetap tanpa skor.

## Bukti tampilan

60 render Flutter: empat keadaan (front, flip, partial, read), tiga bahasa, lima ukuran360×640,411×731,720×1280,1080×1920,2160×3840. Folder: `build/review-kifc-09-visual-refinement/`. Ini simulasi viewport, bukan foto/uji jangkauan TV42inci fisik.

- [Awal411×731 Indonesia](../../../build/review-kifc-09-visual-refinement/peat-cards-front-id-411x731.png)
- [FullHD Indonesia](../../../build/review-kifc-09-visual-refinement/peat-cards-front-id-1080x1920.png)
- [4K Inggris](../../../build/review-kifc-09-visual-refinement/peat-cards-front-en-2160x3840.png)
- [Semua dibuka Korea360×640](../../../build/review-kifc-09-visual-refinement/peat-cards-read-ko-360x640.png)

Pemeriksaan visual mencakup angka/kontras, tiga foto berbeda, balon dan crop maskot, teks Korea, posisi CTA serta tidak adanya penghitung. Tidak ada aset baru, perubahan urutan, audio, skor, APK atau deployment pada koreksi ini.

Pemeriksaan akhir:17 tes kartu/visual lulus dan21 tes perjalanan lengkap/akhir/Korea lulus. Analisis Flutter bersih. Log pada `D:/KIFC-review-temp/cards-regression-final.log` (bagian17 tes kartu), `cards-journey-final.log` dan `cards-analyze-final.log`. Percobaan paralel sempat kehabisan memori; pengulangan berurutan selesai. Assertion crop pada helper alur diperbarui agar membedakan companion kartu yang berada di atas CTA dari feedback soal yang mencapai tepi layar.
