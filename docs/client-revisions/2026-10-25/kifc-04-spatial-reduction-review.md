# KIFC-04 — pemadaman per area secara kumulatif

Pemeriksaan 25 Oktober 2026. Status **Ditinjau**. Arahan pemilik: “Tetap padam; setiap pilihan memadamkan dua api tambahan.” Catatan ini menggantikan respons seluruh api dan replay pada [review sebelumnya](kifc-04-reduction-review.md).

## Perilaku yang diterapkan

| Pilihan | Area yang dipadamkan | Titik api |
|---|---|---|
| Panas | Kiri, di atas pilihan Panas | 0–1 |
| Bahan bakar | Tengah, di atas pilihan Bahan bakar | 2–3 |
| Oksigen | Kanan, di atas pilihan Oksigen | 4–5 |

Enam api menjadi empat, dua, lalu habis setelah tiga pilihan berbeda. Pemain bebas menentukan urutan. Pasangan sebelumnya tetap padam; menyentuh pilihan yang sama tidak menyalakan api kembali atau menambah progres. Ulangi mengembalikan enam api dan progres 0/3.

Setiap pasangan mengecil dan meredup selama satu detik. Pilihan cepat meneruskan intensitas saat itu tanpa lonjakan penyalaan kembali. Rekaman api yang telah padam berhenti; reduced motion langsung menampilkan hasil akhir. Kartu unsur yang sudah dicoba tetap redup dan tombolnya tetap terpilih. Penjelasan mengikuti pilihan terakhir.

Instruksi diperbarui dalam Indonesia, Inggris dan Korea agar hubungan tombol dengan dua api di atasnya jelas. Pembagian tiga area adalah ilustrasi interaksi; bukan pernyataan bahwa api di tiap area hanya memiliki satu unsur. Narasi pendinginan, bahan bakar serta keterbatasan pembatasan oksigen di lahan terbuka tetap tersedia.

Panel, kartu dan posisi enam titik tetap memakai komponen/aset bersama. Skor, urutan layar, audio netral demo, tombol Lanjut setelah 3/3 dan fallback otomatis 14 detik tidak berubah. Reset serta navigasi membatalkan callback lama.

## Pemeriksaan

- **276 tes Flutter lulus**, `flutter test --no-pub --concurrency=1 --reporter expanded`. Log: `build/kifc-04-spatial-regression.log`.
- Analisis bersih: `build/kifc-04-spatial-analysis.log`.
- Kontrak lama terlebih dahulu gagal: setelah Panas seluruh enam api padam, sedangkan empat seharusnya tetap menyala. Bukti: `build/kifc-04-spatial-red.log`.
- Regresi memeriksa mask intensitas 6→4→2→0, urutan kanan dahulu, pilihan berulang, reset, pilihan cepat, timer, reduced motion serta penghentian ticker titik padam.
- **120 render Flutter**: delapan keadaan × tiga bahasa × lima ukuran portrait (360×640, 411×731, 720×1280, 1080×1920, 2160×3840). [Indeks screenshot](../../../build/review-kifc-04-spatial-2026-10-25/evidence-index.json).

| Keadaan | Full HD portrait | 4K portrait |
|---|---|---|
| Panas: tersisa empat api | [Indonesia](../../../build/review-kifc-04-spatial-2026-10-25/heat-out-id-1080x1920.png) | [Korea](../../../build/review-kifc-04-spatial-2026-10-25/heat-out-ko-2160x3840.png) |
| Bahan bakar: tersisa dua api | [Indonesia](../../../build/review-kifc-04-spatial-2026-10-25/fuel-out-id-1080x1920.png) | [Korea](../../../build/review-kifc-04-spatial-2026-10-25/fuel-out-ko-2160x3840.png) |
| Oksigen: seluruh api padam | [Indonesia](../../../build/review-kifc-04-spatial-2026-10-25/oxygen-out-id-1080x1920.png) | [Inggris](../../../build/review-kifc-04-spatial-2026-10-25/oxygen-out-en-2160x3840.png) |

Bukti browser nyata disimpan bersama indeks: `browser-*.png`, `browser-cumulative.mp4` dan `browser-checks.json`. Browser pengganti memakai Playwright CLI setelah T3 preview dua kali gagal dengan “Preview automation snapshot timed out after 15000ms.” Video tidak mengukur FPS aplikasi atau performa TV fisik.

Uji portrait Full HD/4K merupakan pemeriksaan render untuk target TV 42 inci; bukan pengujian jangkauan, ukuran fisik, akustik atau performa TV. Tinggi pemasangan masih belum diketahui. Pengesahan klien/penutur Korea tetap terbuka. Perubahan ini lokal; belum dibuat APK, push atau deployment baru.
