# KIFC-04 — simulasi pengurangan unsur

Tanggal pemeriksaan 25 Oktober 2026. Status: **Ditinjau**; implementasi dan pemeriksaan lokal selesai, pengesahan klien/TV fisik tetap terbuka.

Commit implementasi, tes dan bukti: `a7b6fa7` pada `main`.

## Mengapa diperiksa ulang

Layar dasarnya sudah masuk checkpoint mockup24 Oktober, tetapi belum ada audit khusus KIFC-04 yang menyelaraskan checklist dan kriteria DOCX. Pernyataan bahwa seluruh implementasi layar sudah tersedia terlalu umum. Audit ini menemukan kekurangan nyata, bukan hanya checkbox yang tertinggal: perbedaan respons antarpilihan kurang terlihat, sentuhan ulang unsur yang sama diabaikan, dan auto-lanjut2,6 detik terlalu dekat dengan akhir animasi sehingga penjelasan terakhir cepat terlewati.

Sumber: DOCX bagian 04, instruksi pemilik24 Oktober untuk mempertahankan demo/urutan dan koreksi pemilik25 Oktober. [Rancangan dan pembahasan alternatif](../../../design/quick-specs/kifc-04-reduction-review-2026-10-25.md) mencatat tujuan belajar, pemetaan tindakan/respons, alternatif penghapusan dan alasan cabang dipertahankan. Tidak mengklaim pengesahan akhir KIFC.

## Perubahan

- Pendinginan melemahkan seluruh nyala secara bersamaan; pengurangan bahan bakar memutus titik-titik nyala dengan jeda yang jelas; pembatasan oksigen memakai fase redup yang berbeda. Ketiganya tetap memakai enam titik rekaman bersama dan padam bertahap. Perbedaan timing adalah ilustrasi interaksi, bukan data/perbandingan kecepatan pemadaman lapangan.
- Badge gambar menyebut unsur yang dikurangi dalam Indonesia/Inggris/Korea. Narasi membedakan pendinginan, jarak bahan kering dan pembatasan oksigen; batas penerapan oksigen di lahan terbuka tetap tertulis.
- Sentuh unsur yang sama untuk memutar demonstrasinya lagi. Percobaan berulang tidak menambah progres; tiga unsur berbeda tetap menjadi syarat kelanjutan. Pergantian cepat mempertahankan intensitas nyala saat itu; setelah padam penyalaan ulang bertahap.
- Ulangi memulihkan 0/3, memulihkan api dan membatalkan auto-lanjut lama tanpa mengubah skor susunan unsur.
- Setelah 3/3, Lanjut tersedia di samping progres. Fallback otomatis tetap berjalan setelah 14 detik dari eksplorasi terakhir; angka ini pilihan implementasi untuk ditinjau, bukan hasil pengukuran waktu baca TV fisik. Memilih ulang, Ulangi, Kembali dan Lanjut membatalkan callback lama sesuai tindakan.
- Panel tetap248 logical px/216pada viewport pendek; kartu dan pilihan tetap berukuran semula. Jarak footer dan padding narasi pada layar pendek disesuaikan setelah menemukan overflow10px. Tidak ada teks pembelajaran yang dipotong untuk mengatasi overflow.
- Reduced motion menyelesaikan reduksi seketika dan menghentikan ticker transisinya. Rekaman titik api yang telah padam dihentikan selama menunggu pengguna, lalu aktif lagi ketika demo dipulihkan.

Urutan layar, maksimum8poin, audio netral demo serta mekanisme layar lain dipertahankan. Helper perjalanan tiga bahasa diperbarui untuk memakai Lanjut pada demo dan memeriksa kartu definisi sebagai tujuan yang benar.

## Bukti

Direktori: `build/review-kifc-04-2026-10-25/`. [Indeks120 screenshot](../../../build/review-kifc-04-2026-10-25/evidence-index.json).

120 render UI Flutter =5 ukuran portrait ×3 bahasa ×8 keadaan: awal; panas berubah/padam; bahan bakar berubah/padam; oksigen berubah/padam; pengulangan. Ukuran360×640,411×731,720×1280,1080×1920,2160×3840. Metadata per gambar menyatakan widget render dan bukan foto TV fisik.

| Contoh keadaan | Full HD portrait | 4K portrait |
|---|---|---|
| Awal | [Indonesia](../../../build/review-kifc-04-2026-10-25/initial-id-1080x1920.png) | [Korea](../../../build/review-kifc-04-2026-10-25/initial-ko-2160x3840.png) |
| Panas berubah | [Indonesia](../../../build/review-kifc-04-2026-10-25/heat-changing-id-1080x1920.png) | [Inggris](../../../build/review-kifc-04-2026-10-25/heat-changing-en-2160x3840.png) |
| Bahan bakar berubah | [Indonesia](../../../build/review-kifc-04-2026-10-25/fuel-changing-id-1080x1920.png) | [Korea](../../../build/review-kifc-04-2026-10-25/fuel-changing-ko-2160x3840.png) |
| Tiga unsur dicoba, siap lanjut | [Indonesia](../../../build/review-kifc-04-2026-10-25/oxygen-out-id-1080x1920.png) | [Korea](../../../build/review-kifc-04-2026-10-25/oxygen-out-ko-2160x3840.png) |
| Pengulangan | [Indonesia](../../../build/review-kifc-04-2026-10-25/replay-id-1080x1920.png) | [Inggris](../../../build/review-kifc-04-2026-10-25/replay-en-2160x3840.png) |

[Perbandingan layar pendek360×640](../../../build/review-kifc-04-2026-10-25/oxygen-out-id-360x640.png). Gambar bahan bakar Full HD, oksigen layar pendek dan oksigen Korea4K diperiksa langsung. Pemeriksaan otomatis meliputi seluruh kombinasi; tidak menyatakan seluruh120 gambar diperiksa satu per satu pada resolusi penuh.

## Verifikasi dan batas

**275 tes Flutter lulus** pada kode akhir (`build/kifc-04-regression-final.log`); analisis bersih (`build/kifc-04-analysis-final.log`), format/diff bersih dan sintaks helper Android diperiksa. Delapan tes terarah lulus pada `build/kifc-04-targeted-final.log`.

Pengujian khusus mencakup pengulangan unsur tanpa poin tambahan, perbedaan respons, kesempatan membaca, kelanjutan manual/otomatis, pembatalan timer, Ulangi, reduced motion dan penghentian rekaman setelah padam. Kasus pengulangan/perbedaan respons, reduced-motion ticker dan penghentian rekaman diperiksa gagal sebelum perbaikannya. Render awal menemukan overflow10px di360×640; spacing dikoreksi dan tiga bahasa pada ukuran itu diperiksa ulang, kemudian seluruh matriks lulus dalam regresi akhir.

Browser Chromium nyata: [rekaman19,7 detik](../../../build/review-kifc-04-2026-10-25/reduction-browser.mp4), [keadaan3/3](../../../build/review-kifc-04-2026-10-25/browser-complete.png), [catatan pemeriksaan](../../../build/review-kifc-04-2026-10-25/browser-checks.json). Urutan Panas→Panas lagi→Ulangi→Bahan bakar→Panas→Oksigen→Lanjut mencapai kartu definisi yang benar; tidak ada error console/request gagal pada snapshot pemeriksaan. Viewport720×1280CSSpx, raster rekaman900×1600 karenaDPR 1,25, memakai shell web 411×730,67 logical px. Contact sheet rekaman diperiksa langsung. Rekaman memakai sampling capture adaptif; framerate file bukan pengukuran FPS aplikasi.

Preview langsung halaman: http://localhost:8083/?page=breakTriangle&lang=id (`tool/review.dart`, entry pengujian terpisah dari build normal).

Uji viewport dan browser tidak membuktikan FPS, jangkauan sentuhan, tinggi pemasangan atau waktu baca pada TV 42 inci fisik. Persetujuan akhir KIFC/penutur tetap terbuka. Belum ada APK/deployment baru untuk koreksi25 Oktober ini.
