# KIFC-02 — koreksi aset, placeholder, maskot dan instruksi

> Pembaruan khusus keadaan selesai: [feedback di bawah unsur dan maskot lebih besar](kifc-02-raised-completion-review.md). Bukti di bawah tetap disimpan sebagai riwayat.

Tanggal: 23 Oktober 2026. Status: **Ditinjau**; implementasi lokal diperbarui sesuai empat catatan pemilik.

## Perubahan

1. **Tiga gambar web diperbaiki.** File percikan, kanopi/oksigen dan batu ada di disk tetapi server lama memberi HTTP 404; ketiganya juga tidak ada dalam manifest aset yang disajikan. Hot restart kode tidak membangun ulang bundel server yang sudah berjalan. Server dihentikan dan dijalankan ulang sepenuhnya. Kini ketiganya ada dalam manifest, HTTP 200, header JPEG valid, serta hash data HTTP sama dengan file lokal. [Hasil pemeriksaan](../../../build/kifc-02-web-assets.json). Screenshot browser juga menunjukkan ketiganya berhasil dirender.
2. **Placeholder tanpa label kategori.** Sebelum terisi hanya ada petunjuk netral “Taruh di sini”. Ketiga tempat setara: unsur api yang benar dan belum dipakai boleh masuk ke posisi kosong mana pun. Tidak ada kategori tersembunyi yang harus ditebak. Air, hujan, batu dan duplikasi tidak menambah jumlah unsur. Setelah terisi, foto dan kategori yang sesuai pilihan ditampilkan sebagai pembelajaran.
3. **Maskot setengah badan besar.** Memakai susunan seperti feedback lainnya, mencapai tepi bawah tanpa potongan pinggang menggantung. Pose menjelaskan untuk awal/progres, petunjuk untuk salah, dan berhasil untuk lengkap. Balon teks diberi jarak dari tepi bawah; pose awal juga diberi inset agar siluetnya tidak terpotong horizontal. Lebar area maskot diuji minimal 35% lebar viewport.
4. **Instruksi diperjelas.** Judul: “Pilih tiga unsur api.” Subjudul: “Seret tiga foto yang tepat ke tempat kosong.” Inggris dan Korea ikut diperbarui. Ukuran kartu saat memilih tetap sama. Ketika ketiga unsur lengkap, bank enam pilihan digantikan fokus rangkuman tiga foto terpasang dan penjelasan maskot, sehingga tidak perlu mengecilkan kartu untuk memuat penjelasan panjang.

Panel bersama tetap 190 logical px, rasio kartu 1,8:1, tiga unsur benar memberi tiga poin, serta api hanya muncul setelah tiga unsur benar yang berbeda terkumpul. Waktu baca otomatis 14 detik tetap tersedia; keputusan materi KIFC-03/04 tidak diubah.

## Verifikasi

- `flutter analyze`: **No issues found**. [Log](../../../build/kifc-02-empty-slots-analyze.log).
- Seluruh suite: **151 tes lulus**. [Log](../../../build/kifc-02-empty-slots-suite.log).
- Matriks assembly: **15 tes lulus**, menghasilkan 60 render. [Log](../../../build/kifc-02-empty-slots-capture.log). Mencakup judul/subjudul baru, tidak ada label kategori pada placeholder kosong, penerimaan urutan bebas (panas di tengah lalu kayu di kiri), semua pengecoh, api/timer, lebar maskot, crop di dasar viewport, serta skala preview drag dan tidak adanya overflow/scroll.
- Sampel visual ditinjau: awal Indonesia 411, salah Indonesia 360, lengkap Indonesia 411, lengkap Korea 4K, serta browser nyata di bawah. Terjemahan Korea belum ditinjau penutur.
- Tidak ada deployment atau APK baru. Kenyamanan jangkauan pada TV fisik tetap memerlukan ukuran panel dan tinggi pemasangan.

## Bukti browser nyata

[Halaman awal assembly: ketiga foto tampil, placeholder tanpa nama, maskot besar](../../../build/review-kifc-02-empty-slots/browser-initial-id-674x923.png). Screenshot browser 674 × 923 piksel, viewport CSS terukur 539 × 738 dan DPR 1,25. Browser memakai bingkai 9:16 dengan kanvas tetap; ini bukan simulasi TV atau foto hardware.

## Indeks 60 render Flutter

Render widget Flutter aktual, DPR 1 dan font/foto lokal, bukan screenshot browser/emulator. Full HD dan 4K portrait mensimulasikan resolusi TV 42 inci; tidak membuktikan jangkauan atau performa perangkat fisik.

| Viewport portrait | Bahasa | Awal | Salah | Dua unsur | Lengkap |
|---|---|---|---|---|---|
| 360x640 | ID | [Lihat](../../../build/review-kifc-02-empty-slots/initial-id-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-id-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-id-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-id-360x640.png) |
| 360x640 | EN | [Lihat](../../../build/review-kifc-02-empty-slots/initial-en-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-en-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-en-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-en-360x640.png) |
| 360x640 | KO | [Lihat](../../../build/review-kifc-02-empty-slots/initial-ko-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-ko-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-ko-360x640.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-ko-360x640.png) |
| 411x731 | ID | [Lihat](../../../build/review-kifc-02-empty-slots/initial-id-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-id-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-id-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-id-411x731.png) |
| 411x731 | EN | [Lihat](../../../build/review-kifc-02-empty-slots/initial-en-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-en-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-en-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-en-411x731.png) |
| 411x731 | KO | [Lihat](../../../build/review-kifc-02-empty-slots/initial-ko-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-ko-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-ko-411x731.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-ko-411x731.png) |
| 720x1280 | ID | [Lihat](../../../build/review-kifc-02-empty-slots/initial-id-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-id-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-id-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-id-720x1280.png) |
| 720x1280 | EN | [Lihat](../../../build/review-kifc-02-empty-slots/initial-en-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-en-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-en-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-en-720x1280.png) |
| 720x1280 | KO | [Lihat](../../../build/review-kifc-02-empty-slots/initial-ko-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-ko-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-ko-720x1280.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-ko-720x1280.png) |
| 1080x1920 | ID | [Lihat](../../../build/review-kifc-02-empty-slots/initial-id-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-id-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-id-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-id-1080x1920.png) |
| 1080x1920 | EN | [Lihat](../../../build/review-kifc-02-empty-slots/initial-en-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-en-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-en-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-en-1080x1920.png) |
| 1080x1920 | KO | [Lihat](../../../build/review-kifc-02-empty-slots/initial-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-ko-1080x1920.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-ko-1080x1920.png) |
| 2160x3840 | ID | [Lihat](../../../build/review-kifc-02-empty-slots/initial-id-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-id-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-id-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-id-2160x3840.png) |
| 2160x3840 | EN | [Lihat](../../../build/review-kifc-02-empty-slots/initial-en-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-en-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-en-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-en-2160x3840.png) |
| 2160x3840 | KO | [Lihat](../../../build/review-kifc-02-empty-slots/initial-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/incorrect-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/partial-ko-2160x3840.png) | [Lihat](../../../build/review-kifc-02-empty-slots/complete-ko-2160x3840.png) |

Regenerasi render lokal:

```powershell
$env:KIFC_CAPTURE='1'
$env:KIFC_CAPTURE_DIR='build/review-kifc-02-empty-slots'
flutter test test/assembly_review_test.dart --reporter expanded
```

Folder build diabaikan Git. Screenshot browser disimpan terpisah dari hasil render widget. Bukti versi sebelumnya tetap tersedia.
