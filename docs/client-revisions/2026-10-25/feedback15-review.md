# Feedback dan hasil —15detik atau sentuh untuk lanjut

Klarifikasi pemilik25Oktober2026: “kalau ada feedback dan hasil itu tetep ada waktunya sekitar15detik tapi bisa dilanjutkan dengan menekan layar”. Ini menggantikan penafsiran vendor tanpa batas waktu pada [implementasi sebelumnya](manual-reading-review.md). Status **Ditinjau** setelah implementasi/pemeriksaan lokal.

Commit implementasi/tes: `876cafa` pada `main`.

## Perilaku terkini

- Feedback assembly lengkap, demo pengurangan3/3, jawaban kuis gambut yang selesai (benar/salah kedua), serta feedback benar/salah kuis penyebab maju otomatis setelah15detik. Sentuhan konten/latar mempercepat kelanjutan; gesture jawaban terakhir tetap hanya membuka feedback.
- Ulasan dampak→skor→penutup→pembuka masing-masing mempunyai waktu15detik sendiri. Sentuhan dapat memajukan setiap tahap lebih cepat. Notice skor/penutup menampilkan sisa detik dalam Indonesia/Inggris/Korea.
- Hint salah pertama tetap memberi satu percobaan lagi. Aktivitas belum lengkap dan tantangan aktif tidak dapat dilewati. Bacaan penjelasan dan kartu informasi tetap dilanjutkan manual; countdown tantangan akhir tetap30detik.
- Dialog audio/kredit yang terbuka dan aplikasi yang tidak aktif menjeda sisa waktu baca. Timer sebelumnya dibatalkan saat lanjut manual, reset, navigasi dan dispose; deadline lama tidak memajukan halaman berikutnya.
- Memilih unsur demo lagi setelah3/3 memberi15detik untuk penjelasan pilihan terakhir. Pemadaman api tetap kumulatif6→4→2→0, tanpa penyalaan kembali kecuali Ulangi.

Komponen bersama, foto, ukuran kartu/panel, mekanisme sentuh, semantics terpisah, skor dan urutan layar dipertahankan. Tidak menambah aset/dependensi atau mengubah pengaturan browser pengguna.

## Verifikasi

- **313 tes Flutter lulus** pada kode akhir (`build/feedback15-regression.log`). Analisis bersih (`build/feedback15-analysis.log`); format/diff diperiksa.
- Kontrak15detik lebih dahulu diuji terhadap implementasi tanpa timer:6kasus gagal dan2kasus yang sudah berfungsi tetap lulus (`build/feedback15-red.log`). Tes timer akhir mencakup11kasus, termasuk batas14999ms→15000ms, benar/salah, seluruh hasil, assembly, kuis gambut, retry, dialog dan pembatalan deadline lama. Regresi demo juga memeriksa fallback15detik serta Ulangi.
- **105 screenshot Flutter**:7keadaan ×3bahasa ×5ukuran portrait360×640,411×731,720×1280,1080×1920,2160×3840. Capture sekitar3detik setelah feedback/hasil tampil; angka12pada notice adalah sisa dari15detik. [Indeks dan metadata](../../../build/review-feedback15-2026-10-25/evidence-index.json).
- Browser nyata720×1280CSS: feedback salah masih tampil pada14detik dan situasi berikutnya terdeteksi sekitar15,49detik sejak awal klik (termasuk pemrosesan klik/transisi). Feedback berikutnya dapat dilanjutkan melalui sentuhan terpisah setelah100ms; sesudah16detik soal berikutnya tetap menunggu jawaban, membuktikan timer lama dibatalkan.
- Pada browser, skor berpindah otomatis ke penutup sekitar15detik; sentuhan berikutnya mempercepat penutup→pembuka. Screenshot memperlihatkan sisa waktu yang berubah.
- [Rekaman timer dan sentuhan](../../../build/review-feedback15-2026-10-25/browser-timer-and-tap.mp4), [rekaman hasil](../../../build/review-feedback15-2026-10-25/browser-results-timer.mp4), [catatan pemeriksaan browser](../../../build/review-feedback15-2026-10-25/browser-checks.json). Playwright CLI dipakai setelah preview bawaan dua kali gagal dengan “Preview automation snapshot timed out after15000ms.”

| Keadaan | Full HD portrait | 4K portrait |
|---|---|---|
| Feedback salah | [Indonesia](../../../build/review-feedback15-2026-10-25/cause-wrong-id-1080x1920.png) | [Korea](../../../build/review-feedback15-2026-10-25/cause-wrong-ko-2160x3840.png) |
| Hasil dan sisa waktu | [Indonesia](../../../build/review-feedback15-2026-10-25/score-id-1080x1920.png) | [Korea](../../../build/review-feedback15-2026-10-25/score-ko-2160x3840.png) |
| Penutup | [Indonesia](../../../build/review-feedback15-2026-10-25/closing-id-1080x1920.png) | [Korea](../../../build/review-feedback15-2026-10-25/closing-ko-2160x3840.png) |

Pemeriksaan viewport bukan uji TV42inci fisik, jangkauan atau FPS. Pengesahan KIFC/penutur serta perangkat fisik tetap terbuka. Pada sesi ini juga tercatat dua log exception sumber suara burung (`PIPELINE_ERROR_READ`), dengan intersepsi IDM pada log network. Navigasi/timer tetap berjalan; ini bukan validasi audio bersih atau perbaikan audio. Console level error/warning bernilai0, tetapi log exception audio tetap disimpan dan tidak diabaikan. Belum membuat APK, push atau deployment baru.
