# KIFC-10 — Tantangan dampak kebakaran

Implementasi lokal 24 Oktober 2026. Urutan layar dipertahankan. Naskah pertanyaan dan enam label Indonesia mengikuti dokumen klien; versi Inggris/Korea diselaraskan. Empat dampak: kabut asap, kerusakan ekosistem, emisi karbon tinggi, subsidens. Dua pengecoh: peningkatan kualitas udara dan cadangan karbon gambut.

Pilihan dapat dibatalkan dan tetap netral selama countdown. Setelah waktu habis, grid tetap di tempatnya; hasil menandai pilihan benar, salah, dan dampak terlewat. Maskot memberi penjelasan sesuai hasil. Foto diberi crop dan filter seragam, dengan sumber/lisensi di ASSET_SOURCES.md serta tombol informasi pada ulasan.

Durasi vendor sementara **30 detik**, dimulai setelah foto selesai dimuat dan transisi tampil selesai. Lingkaran mengikuti stopwatch yang sama dengan batas input. Hijau >15 detik, kuning 15–10, merah ≤9; input terkunci tepat pada deadline. D-06 masih menunggu uji membaca pada TV fisik. Aturan skor lama dipertahankan: +1 benar, −1 salah, minimum0; bonus hasil/4, maksimum keseluruhan9. Label bonus kini menyebut dampak; finalisasi aturan KIFC-11 menunggu keputusan KIFC-09/D-07.

## Bukti tampilan

Sumber utama: render widget Flutter dengan font/aset produksi, 5 ukuran × 3 bahasa × 4 keadaan = **60 screenshot** di `build/review-kifc-10/`. Awalan file: `impact-play`, `impact-selected`, `impact-review`, `impact-score`; bahasa `id`, `en`, `ko`; ukuran360×640,411×731,720×1280,1080×1920,2160×3840.

| Keadaan | Full HD Indonesia | 4K Korea | Layar kecil Inggris |
|---|---|---|---|
| Bermain | [1080×1920](../../../build/review-kifc-10/impact-play-id-1080x1920.png) | [2160×3840](../../../build/review-kifc-10/impact-play-ko-2160x3840.png) | [360×640](../../../build/review-kifc-10/impact-play-en-360x640.png) |
| Dipilih netral | [1080×1920](../../../build/review-kifc-10/impact-selected-id-1080x1920.png) | [2160×3840](../../../build/review-kifc-10/impact-selected-ko-2160x3840.png) | [360×640](../../../build/review-kifc-10/impact-selected-en-360x640.png) |
| Ulasan | [1080×1920](../../../build/review-kifc-10/impact-review-id-1080x1920.png) | [2160×3840](../../../build/review-kifc-10/impact-review-ko-2160x3840.png) | [360×640](../../../build/review-kifc-10/impact-review-en-360x640.png) |
| Hasil | [1080×1920](../../../build/review-kifc-10/impact-score-id-1080x1920.png) | [2160×3840](../../../build/review-kifc-10/impact-score-ko-2160x3840.png) | [360×640](../../../build/review-kifc-10/impact-score-en-360x640.png) |

Browser Edge aktual 1890×1042 CSS px: [bermain](../../../build/review-kifc-10/browser-play-id.png), [ulasan](../../../build/review-kifc-10/browser-review-id.png). Alur dari keputusan tindakan ke countdown30 detik, dua pilihan netral, lalu hasil1 benar/1 salah/3 terlewat terverifikasi.

## Pemeriksaan

- `test/impact_review_test.dart`:15 kombinasi ukuran/bahasa, label utuh tanpa ellipsis, pilihan netral, dua hasil ulasan, grid tidak bergeser, kredit foto dapat dibuka, lanjut ke hasil.
- `test/game_flow_test.dart`: toggle, deadline, hitungan benar/salah/terlewat, skor/penalti, warna dan progres timer, reduced motion, alur lengkap Indonesia/Inggris.
- Seluruh185 tes lulus: `build/review-kifc-10/suite.log`. Analisis Flutter bersih: `analyze.log`.
- Server web direstart penuh setelah aset ditambahkan. Manifest, HTTP200 dan SHA-256 ketiga foto diperiksa dalam `web-assets.json`.
- `tool/review.dart` adalah entry point bukti browser terpisah pada8081, memakai komponen produksi. Aplikasi normal pada8080 tetap mulai dari pembuka; tidak ada perubahan urutan produksi.

Batas bukti: resolusi viewport bukan ukuran/jangkauan fisik TV42inci. Belum ada uji TV fisik, APK terbaru, pengukuran performa perangkat, push atau deployment. Foto subsidens adalah contoh historis AS, foto kerusakan ekosistem dari Malaysia, citra asap dari Sumatra; bukan dokumentasi satu lokasi KIFC. Status **Ditinjau**, D-06/D-07 tetap terbuka.
