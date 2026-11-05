# Tracker revisi Korea lengkap dari PDF — 5 November 2026

Sumber: `revisi game korean version.pdf`, 26 halaman. SHA-256: `bb8f46c48260f60ec75fd5c9bd1d24c3c7fff8632dd97b58747c765db35698ea`.

Status awal dicatat sebelum implementasi: **34 item teks/layout belum diterapkan; 2 halaman acuan visual sudah diperiksa; regenerasi audio Korea belum dikerjakan.**

Kolom revisi bertulisan Korea menjadi acuan. Keterangan Indonesia dalam tanda kurung tidak dimasukkan ke game. Susunan baris dikunci mengikuti baris Korea pada PDF; judul Babak 3 satu baris. PDF hlm. 6 memberi revisi pada subjudul yang berada di atas bubble bacaan kedua sesuai screenshot.

| ID | Halaman PDF | Status |
| --- | --- | --- |
| welcome | 1 | [x] Diterapkan; lolos 5 ukuran |
| assembly-partial | 2 | [x] Diterapkan; lolos 5 ukuran |
| assembly-complete | 3 | [x] Diterapkan; lolos 5 ukuran |
| triangle-explanation | 4 | [x] Diterapkan; lolos 5 ukuran |
| reading-1-subtitle | 5 | [x] Diterapkan; lolos 5 ukuran |
| reading-2-subtitle | 6 | [x] Diterapkan; lolos 5 ukuran |
| reading-2-body | 6 | [x] Diterapkan; lolos 5 ukuran |
| reading-3-body | 7 | [x] Diterapkan; lolos 5 ukuran |
| risk-correct | 9 | [x] Diterapkan; lolos 5 ukuran |
| risk-hint | 10 | [x] Diterapkan; lolos 5 ukuran |
| cause-title | 11 | [x] Diterapkan; lolos 5 ukuran |
| cause-1-situation | 11 | [x] Diterapkan; lolos 5 ukuran |
| cause-1-correct | 12 | [x] Diterapkan; lolos 5 ukuran |
| cause-2-correct | 14 | [x] Diterapkan; lolos 5 ukuran |
| cause-3-correct | 17 | [x] Diterapkan; lolos 5 ukuran |
| cause-4-situation | 18 | [x] Diterapkan; lolos 5 ukuran |
| cause-4-reason | 18, 19 | [x] Diterapkan; lolos 5 ukuran |
| cause-4-summary | 18, 19 | [x] Diterapkan; lolos 5 ukuran |
| peat-complete | 20 | [x] Diterapkan; lolos 5 ukuran |
| safety | 21 | [x] Diterapkan; lolos 5 ukuran |
| closing | 22 | [x] Diterapkan; lolos 5 ukuran |
| final-F01 | 23 | [x] Diterapkan; lolos 5 ukuran |
| final-F02 | 23 | [x] Diterapkan; lolos 5 ukuran |
| final-F03 | 23, 24 | [x] Diterapkan; lolos 5 ukuran |
| final-F04 | 24 | [x] Diterapkan; lolos 5 ukuran |
| final-F05 | 24 | [x] Diterapkan; lolos 5 ukuran |
| final-F06 | 25 | [x] Diterapkan; lolos 5 ukuran |
| final-F07 | 25 | [x] Diterapkan; lolos 5 ukuran |
| final-F08 | 25, 26 | [x] Diterapkan; lolos 5 ukuran |
| final-F09 | 26 | [x] Diterapkan; lolos 5 ukuran |
| cause-1-wrong | 13 | [x] Diterapkan; lolos 5 ukuran |
| cause-2-wrong | 15 | [x] Diterapkan; lolos 5 ukuran |
| cause-4-correct | 19 | [x] Diterapkan; lolos 5 ukuran |
| cause-4-wrong | 18 | [x] Diterapkan; lolos 5 ukuran |
| reference-8 | 8 | Diperiksa; tidak ada teks pengganti |
| reference-16 | 16 | Diperiksa; tidak ada teks pengganti |
| audio-ko-regenerate | 1, 6–7, 22 | [x] Rekaman baru diterima dan terintegrasi 5 November |

## Hasil implementasi

34 item diterapkan ke 58 kunci terjemahan. Audit 250 kondisi layar mencakup semua item pada 360×640, 411×731, 720×1280, 1080×1920, dan 2160×3840: tidak ada kata terbelah, baris PDF terbungkus ulang, teks melampaui batas horizontal, atau exception layout. [Bukti setiap item dan perbandingan tiga bahasa](../../docs/client-revisions/2026-11-05/korean-full-pdf/README.md). Siap ditinjau pemilik/klien; jumlah status tiket Oktober tidak berubah.

Pemeriksaan akhir: 485 tes Flutter lulus, analisis bersih, build web release berhasil. Integritas digest MP3 dan cue bacaan (9 entri) lulus.

## Catatan audio - pembaruan 5 November

Instruksi tunda sebelumnya digantikan oleh empat MP3 hasil regenerasi yang dikirim pemilik. Keempat rekaman telah dipasang; bacaan kedua dan ketiga Babak 2 menggunakan durasi, hash dan cue kata rekaman baru. Catatan audio lama/provisional dihapus dari runtime. Teks dan baris PDF tetap utuh.

- [x] Welcome Korea baru dipasang.
- [x] Bacaan kedua Babak 2 Korea baru dipasang.
- [x] Bacaan ketiga Babak 2 Korea baru dipasang.
- [x] Closing Korea baru dipasang.
- [x] Alignment dari rekaman baru dibuat; tes terkontrol menguji teks bertahap, status bicara maskot, dan jeda lanjut 1 detik pada lima ukuran layar.

Ada satu batas per bacaan yang diestimasi di dalam kata gabungan ASR; review pendengaran dapat menyempurnakannya. Screenshot menggunakan fallback statis, bukan bukti gerak mulut WebGL atau speaker perangkat. Android/TV fisik tetap ditunda. [Bukti dan batas validasi audio baru](../../docs/client-revisions/2026-11-05/korean-audio-refresh/README.md).

Commit implementasi PDF: `4ebf03cfb646986054cc5458695668cccc73d285`.

Validasi pembaruan audio: 496 tes Flutter lulus, analisis bersih, build web berhasil; 4 hash MP3 dalam bundle web cocok.

Commit integrasi audio dan timing: `4e855d7a6be8f3bb7a61fbaee3713923d1a747eb`.
