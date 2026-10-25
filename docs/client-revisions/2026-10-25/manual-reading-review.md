# Feedback dan hasil — waktu baca bebas, sentuh untuk lanjut

Arahan pemilik 25 Oktober 2026: KIFC-10 cukup30detik; setiap feedback/hasil harus bisa dibaca dahulu dan dapat dilanjutkan cepat dengan menyentuh layar. Status **Ditinjau** setelah implementasi/pemeriksaan lokal. Keputusan durasi KIFC-10 dicatat terpisah pada commit `4d04fbb`.

## Perilaku

Timer perpindahan feedback2/12/14/18detik serta reset hasil/penutup15detik dihapus. Bacaan tetap tampil sampai pengguna memilih lanjut. Sentuh konten atau area kosong pada layar game untuk maju satu langkah. Tombol yang sudah ada tetap dapat digunakan.

| Keadaan | Kelanjutan |
|---|---|
| Susun unsur lengkap | Sentuh layar menuju penjelasan segitiga api |
| Penjelasan segitiga api | Sentuh layar atau CTA menuju demo |
| Demo pengurangan3/3 | Sentuh layar atau Lanjut menuju bacaan karhutla |
| Kartu bacaan karhutla | Satu sentuhan untuk satu kartu, lalu kuis |
| Kuis gambut benar atau salah kedua | Sentuh layar menuju Babak3 |
| Feedback kuis penyebab benar/salah | Sentuh layar menuju situasi berikutnya; setelah situasi4 menuju kartu karakteristik |
| Ketiga kartu karakteristik telah dibuka | Sentuh latar atau CTA untuk membuka tantangan; menyentuh kartu tetap membalik kartu |
| Ulasan dampak | Sentuh layar atau CTA menuju skor |
| Skor | Sentuh layar atau Selesai menuju penutup |
| Penutup | Sentuh layar atau Jelajahi Pameran menuju pembuka |

Aktivitas belum lengkap, petunjuk salah pertama dan tantangan30detik yang sedang berjalan tidak dapat dilewati dengan sentuhan latar. Retry tetap tersedia. Tombol Kembali/Beranda, Ulangi, Main Lagi, audio dan kredit foto menjalankan aksinya sendiri; modal tidak memajukan halaman di belakangnya. Gesture jawaban/drop/flip terakhir hanya menampilkan feedback; perlu sentuhan terpisah untuk melanjutkan. Urutan, skor, geometri komponen serta pemadaman kumulatif6→4→2→0 dipertahankan.

Notice hasil/penutup kini mengajak pengguna menyentuh layar setelah membaca, dalam Indonesia/Inggris/Korea. Satu callback kelanjutan dipakai bersama; timer countdown tantangan tetap bekerja seperti sebelumnya. Tidak menambah aset/dependensi.

## Pemeriksaan dan bukti

- **302 tes Flutter lulus** pada kode akhir: `build/manual-reading-final-regression.log`. Analisis bersih: `build/manual-reading-final-analysis.log`; format dan `git diff --check` bersih.
- Delapan tes perilaku baru terlebih dahulu gagal pada kode lama: `build/manual-reading-red.log`. Menunggu60detik masih dipotong timer atau lapisan tap menutupi kontrol. Tes akhir mencakup11kasus terarah: waktu baca, benar/salah/retry, pilihan terakhir, satu tap satu langkah, modal, reset/replay serta semantics.
- Pemeriksaan browser menemukan label seluruh halaman tergabung saat tap diaktifkan, memicu error scheduler web. Regresi semantics terlebih dahulu gagal (`build/manual-reading-semantics-red.log`). Container semantics kini stabil dengan node bacaan terpisah; callback sentuh tersedia untuk aksesibilitas tanpa menggabungkan seluruh isi. Pemeriksaan browser setelah perbaikan tidak mengulang exception scheduler tersebut.
- **105 screenshot render Flutter**: tujuh keadaan × tiga bahasa × lima ukuran portrait (360×640,411×731,720×1280,1080×1920,2160×3840), setelah60detik waktu uji. [Indeks dan metadata](../../../build/review-manual-reading-2026-10-25/evidence-index.json).
- Browser Chrome nyata pada720×1280CSS: feedback salah tetap di situasi1 setelah6detik; tap maju satu situasi; tap sebelum menjawab tidak melewati soal; feedback berikutnya dapat ditutup dengan tap terpisah setelah100ms. Ulasan→skor→penutup→pembuka berjalan dengan tap, skor/penutup bertahan20detik masing-masing, modal kredit/audio tidak memajukan halaman.
- [Rekaman feedback](../../../build/review-manual-reading-2026-10-25/browser-feedback-verified.mp4), [rekaman hasil/penutup](../../../build/review-manual-reading-2026-10-25/browser-results-verified.mp4), [pemeriksaan browser](../../../build/review-manual-reading-2026-10-25/browser-checks.json). Playwright CLI digunakan setelah T3 preview dua kali gagal dengan “Preview automation snapshot timed out after15000ms.”

| Contoh screenshot | Full HD portrait | 4K portrait |
|---|---|---|
| Feedback salah | [Indonesia](../../../build/review-manual-reading-2026-10-25/cause-wrong-id-1080x1920.png) | [Korea](../../../build/review-manual-reading-2026-10-25/cause-wrong-ko-2160x3840.png) |
| Hasil akhir | [Indonesia](../../../build/review-manual-reading-2026-10-25/score-id-1080x1920.png) | [Korea](../../../build/review-manual-reading-2026-10-25/score-ko-2160x3840.png) |
| Penutup | [Indonesia](../../../build/review-manual-reading-2026-10-25/closing-id-1080x1920.png) | [Inggris](../../../build/review-manual-reading-2026-10-25/closing-en-2160x3840.png) |

## Batas hasil

Pada sesi browser hasil tercatat satu `WebAudioError / PIPELINE_ERROR_READ` untuk `forest-birds.mp3`. Network menunjukkan `204 Intercepted by the IDM Advanced Integration` untuk aset audio, termasuk burung, lalu respons200. Ini bukti gangguan ekstensi IDM pada sesi pengujian; tidak dinyatakan sebagai validasi audio bersih atau perbaikan audio. Log permintaan/console disimpan bersama bukti; pengaturan browser milik pengguna tidak diubah. Efek tap dan navigasi tetap berjalan pada pengujian tersebut.

Screenshot Full HD/4K adalah simulasi viewport untuk target TV42inci, bukan foto/pengujian jangkauan atau performa TV fisik. Validasi penutur Korea/KIFC serta perangkat fisik tetap terbuka. Belum membuat APK, push atau deployment baru.
