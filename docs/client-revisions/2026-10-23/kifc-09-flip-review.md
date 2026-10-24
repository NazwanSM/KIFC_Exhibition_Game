# KIFC-09 — Tiga kartu balik tanpa skor

Implementasi 24 Oktober 2026 mengikuti keputusan langsung pemilik: kartu bernomor1–3 berputar saat disentuh dan membuka informasi; bukan soal dan tidak memperoleh poin.

## Perilaku

- Tiga kartu lebar disusun vertikal agar informasi tetap terbaca pada layar portrait kecil maupun TV. Sisi depan hanya nomor1–3 dengan foto gambut yang sudah dibundel; sisi belakang menampilkan tiga fakta klien secara utuh.
- Sentuh kembali untuk membalik ulang. Tidak ada batas waktu membaca, jawaban benar/salah, penalti, atau tanda centang penilaian.
- Tombol **Kenali Dampaknya** aktif setelah ketiga kartu pernah dibuka. Membalik kembali tidak menghapus progres membaca. Syarat tiga kartu dibuka dan susunan vertikal adalah keputusan implementasi vendor; ini bukan kuis.
- Urutan tetap: Babak3 → informasi karakteristik gambut → tantangan dampak → ulasan → hasil. Tombol lanjut manual memakai pemuat aset tantangan yang sudah ada. Sentuhan ganda tidak membuat dua perpindahan.
- Pergi kembali/mulai ulang menghapus state kartu. Tidak ada callback otomatis dari layar tindakan lama yang tertinggal.
- Bahasa Indonesia mengikuti tiga pernyataan klien: api dapat membara di bawah permukaan tanah; kebakaran sulit dipadamkan; api dapat menyala kembali. Inggris/Korea diselaraskan dan menggunakan font offline yang sama.

## Animasi dan aksesibilitas

Komponen `PeatCharacteristicCard` menggunakan putaran perspektif420ms. Teks belakang dikoreksi orientasinya sehingga tidak tercermin; hanya sisi yang aktif dibaca teknologi bantu. Label kartu berupa tombol bernomor dengan instruksi atau informasi yang sedang terbuka. Mode gerakan dikurangi membuka informasi langsung tanpa putaran. Tap cepat dapat membalik kembali tanpa menghitung kartu yang sama lebih dari sekali. Tidak ada animasi yang terus berjalan ketika kartu diam.

## Dampak skor

Poin “Memilih tindakan aman” dihapus bersama layar pertanyaan lamanya. Maksimum menjadi8: susun unsur3, penyebab4, bonus dampak≤1. Aturan tantangan dampak tetap+1 benar/−1 salah/minimum0, bonus hasil/4. Penyesuaian kategori hasil secara proporsional ditangani dalam commit lanjutan KIFC-11/X01.

## Bukti tampilan

`build/review-kifc-09/` memuat render Flutter: depan, tengah putaran, sebagian terbuka, dan semua terbuka, masing-masing tiga bahasa × lima ukuran =60 screenshot. Ini simulasi viewport, bukan foto TV fisik42inci.

| Keadaan | Full HD Indonesia | 4K Korea | Layar kecil Inggris |
|---|---|---|---|
| Depan | [1080×1920](../../../build/review-kifc-09/peat-cards-front-id-1080x1920.png) | [2160×3840](../../../build/review-kifc-09/peat-cards-front-ko-2160x3840.png) | [360×640](../../../build/review-kifc-09/peat-cards-front-en-360x640.png) |
| Berputar | [1080×1920](../../../build/review-kifc-09/peat-cards-flip-id-1080x1920.png) | [2160×3840](../../../build/review-kifc-09/peat-cards-flip-ko-2160x3840.png) | [360×640](../../../build/review-kifc-09/peat-cards-flip-en-360x640.png) |
| Terbuka | [1080×1920](../../../build/review-kifc-09/peat-cards-read-id-1080x1920.png) | [2160×3840](../../../build/review-kifc-09/peat-cards-read-ko-2160x3840.png) | [360×640](../../../build/review-kifc-09/peat-cards-read-en-360x640.png) |

Browser Edge aktual: [depan](../../../build/review-kifc-09/browser-front.png), [semua informasi terbuka](../../../build/review-kifc-09/browser-read.png). Tiga tombol bernomor berhasil membuka informasi dan mengaktifkan CTA. Browser review memakai entry point pengujian pada8081; produksi tetap mulai dari pembuka pada8080.

## Pemeriksaan

- Tes pertama gagal karena kartu/CTA memang belum ada: `build/kifc09-red.log`.
- Seluruh208 tes Flutter lulus: `build/review-kifc-09/suite.log`.
- Tes kartu mencakup15 kombinasi ukuran/bahasa, isi fakta utuh, progres unik, baca ulang, ukuran kartu stabil, tidak ada timer40detik, rapid tap, reduced motion dan label semantik. Insets Android juga diuji dalam tiga bahasa.
- Alur lengkap ID/EN/KO diperbarui: tidak lagi memilih tindakan aman, membuka kartu lalu melanjutkan manual; skor tidak memperoleh poin dari layar ini.
- Analisis Flutter bersih. Generated review/test listener di build dikecualikan dari analisis, tanpa menonaktifkan lint kode aplikasi.

Batas: belum ada uji jangkauan/performa TV fisik atau pengesahan terjemahan oleh penutur Korea. Tidak menambah audio atau mengubah urutan layar. Belum push/deploy.
