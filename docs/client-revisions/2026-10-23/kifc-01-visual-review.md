# Bukti tampilan KIFC 01

Tanggal: 23 Oktober 2026. Layar: halaman pembuka. Status: **Ditinjau**. Acuan pekerjaan: [tracker KIFC-01](../../../design/quick-specs/kifc-screen-revision-tracker-2026-10-23.md#kifc-01-tampilan-awal).

## Perubahan yang diperiksa

Foto hutan dipertahankan. Tint menyeluruh dikurangi dan lapisan gradasi gelap difokuskan pada area judul/percakapan. Judul diperkuat; label identitas, jarak antarelemen, padding dialog, garis bingkai, dan bayangan diselaraskan. Tombol tetap besar dan memakai gradasi hijau lembut, dengan respons tekan berupa pengecilan sesaat dan ink feedback bawaan.

Label bahasa dibuat satu baris. Label 한국어 selalu memakai font Hangul, termasuk ketika Indonesia/Inggris aktif. Bobot font Korea ditetapkan melalui sumbu font variabel agar judul dan label tebal benar-benar terbaca. Tata letak penutup tidak dirancang ulang sebagai bagian tiket ini.

## Sumber dan batas bukti

Semua PNG di bawah adalah **hasil render UI Flutter yang sebenarnya melalui widget test**, memakai aset serta font aplikasi, pada ukuran viewport yang tertulis dan device pixel ratio 1. Gambar bukan mockup, foto TV, atau tangkapan emulator. Masing-masing ukuran dirender sendiri; gambar kecil bukan sekadar hasil resize screenshot 4K.

TV sasaran berukuran 42 inci portrait, tetapi resolusi, densitas, dan tinggi pemasangan belum diketahui. Ukuran Full HD dan 4K merupakan dua simulasi viewport portrait 9:16 untuk peninjauan. Keterbacaan dan kenyamanan jangkauan fisik masih memerlukan pengujian pada panel sebenarnya.

## Screenshot halaman pembuka

| Viewport portrait | Indonesia | Inggris | Korea |
|---|---|---|---|
| 360×640 | [Lihat](../../../build/review-kifc-01/id-360x640.png) | [Lihat](../../../build/review-kifc-01/en-360x640.png) | [Lihat](../../../build/review-kifc-01/ko-360x640.png) |
| 411×731 | [Lihat](../../../build/review-kifc-01/id-411x731.png) | [Lihat](../../../build/review-kifc-01/en-411x731.png) | [Lihat](../../../build/review-kifc-01/ko-411x731.png) |
| 720×1280 | [Lihat](../../../build/review-kifc-01/id-720x1280.png) | [Lihat](../../../build/review-kifc-01/en-720x1280.png) | [Lihat](../../../build/review-kifc-01/ko-720x1280.png) |
| 1080×1920, simulasi TV Full HD | [Lihat](../../../build/review-kifc-01/id-1080x1920.png) | [Lihat](../../../build/review-kifc-01/en-1080x1920.png) | [Lihat](../../../build/review-kifc-01/ko-1080x1920.png) |
| 2160×3840, simulasi TV 4K | [Lihat](../../../build/review-kifc-01/id-2160x3840.png) | [Lihat](../../../build/review-kifc-01/en-2160x3840.png) | [Lihat](../../../build/review-kifc-01/ko-2160x3840.png) |

Respons saat tombol disentuh: [screenshot tombol ditekan pada 411×731](../../../build/review-kifc-01/id-411x731-pressed.png).

Seluruh 15 tampilan dan satu keadaan tombol ditekan sudah dibuka untuk peninjauan visual. Label bahasa, judul, dialog, gambar maskot, dan tombol tampil utuh. Screenshot percobaan awal yang masih memperlihatkan glyph kotak/bobot Korea terlalu tipis telah diganti dengan hasil render setelah perbaikan.

## Pemeriksaan dan pengukuran

- `flutter analyze --no-pub`: tidak ada masalah.
- `flutter test --no-pub`: **43 tes lulus**, termasuk 16 pemeriksaan khusus halaman pembuka.
- Matriks halaman pembuka mencakup 5 ukuran × 3 bahasa: tidak ada overflow, pilihan bahasa satu baris, urutan judul → percakapan → tombol terjaga, tombol terlihat dan dapat disentuh tanpa scrolling, serta tindakan mulai membuka aktivitas.
- Respons tekan diperiksa saat pointer ditahan; pembatalan sentuhan mengembalikan ukuran tombol dan tidak memulai tantangan.
- Pada simulasi Full HD, tombol berukuran sekitar **801×159 piksel viewport**, dengan pusat vertikal di **77,1%** tinggi layar. Pada 4K, sekitar **1602×318**, dengan proporsi posisi yang sama. Ini pengukuran viewport, bukan ukuran sentuhan fisik dalam sentimeter.
- Metrik tiap gambar disimpan pada file JSON dengan nama yang sama di `build/review-kifc-01/`.

## Membuat ulang bukti

Jalankan di root proyek menggunakan PowerShell:

```powershell
$env:KIFC_CAPTURE = '1'
flutter test --no-pub test/welcome_review_test.dart
Remove-Item Env:KIFC_CAPTURE
```

Folder `build/review-kifc-01/` berisi artefak lokal yang tidak masuk Git. Pertahankan folder ini selama proses review; `flutter clean` dapat menghapusnya.

## Hal yang belum diklaim selesai

Persetujuan visual pemilik proyek, uji TV fisik 42 inci, dan kepastian resolusi/tinggi pemasangan masih terbuka. Perubahan ini belum dibuild ulang ke APK atau dipush/deploy; bukti di atas berasal dari kode lokal terbaru.
