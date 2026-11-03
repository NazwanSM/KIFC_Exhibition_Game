# Maskot ulasan dampak dan posisi feedback â€” 3 November 2026

Ulasan dampak Babak 4 kini memakai komponen maskot besar setengah badan yang sama dengan kartu karakteristik gambut. Hasil sempurna tetap kanan, hasil lainnya tetap kiri. Bubble berada di bawah hitungan jawaban; bagian bawah maskot mendekati tombol tanpa menutupnya. Grid, label, pilihan dan skor dipertahankan.

Pada jawaban benar Babak 3, inset maskot berubah dari -24 menjadi -64 logical pixels, sehingga bergerak 40 logical pixels lebih ke kanan. Posisi salah dan feedback kuis Babak 2 tetap memakai inset sebelumnya.

## Bukti

- [Ulasan dampak Full HD](widget/impact-review-id-1080x1920.png).
- [Ulasan dampak layar kecil](widget/impact-half-body-id-411x731.png).
- [Feedback benar Babak 3](widget/cause-right-id-411x731.png).
- [Indeks capture dan dimensi](evidence-index.json): widget render, memakai poster statis dari GLB; bukan foto TV atau bukti playback 3D.

Matriks pemeriksaan memakai lima ukuran portrait (360Ã—640, 411Ã—731, 720Ã—1280, 1080Ã—1920, 2160Ã—3840), Indonesia/Inggris/Korea, serta hasil benar/salah dan dampak sempurna/campuran. Test baru memeriksa crop setengah badan dan anchor kanan. Log pengujian akhir dicatat di folder ini setelah pemeriksaan selesai.

## Build dan sumber

Build web release terbaru berada di build/browser-perf/layout-review, build ID mascot_layout_followup_v3_20261103. Web review lokal diperbarui pada port 8791 setelah build berhasil. Optimasi performa sebelumnya dipertahankan; GLB, tekstur, kamera dan klip tidak diubah. Android tetap ditunda; tidak ada build APK/deployment baru.

layout.patch mengisolasi perubahan layout terhadap snapshot setelah optimasi browser sebelumnya (fixture build/browser-perf/patch-check-final). Source working tree masih mencakup integrasi R30-17â€“19 yang belum ditutup; checkpoint bukti ini bukan pernyataan bahwa seluruh integrasi berada pada clean HEAD.

## Hasil akhir

468 tes regresi lulus, 32 tes layout/capture lulus, analisis bersih dan build web release berhasil. Pemeriksaan geometri memastikan maskot ulasan berakhir di atas tombol. Ulasan memakai crop key tersendiri agar audit maskot tepi layar tidak diterapkan pada maskot di atas tombol. Suite capture berbagi nama impact-review; nama tersebut dapat merepresentasikan hasil sempurna atau kosong.
