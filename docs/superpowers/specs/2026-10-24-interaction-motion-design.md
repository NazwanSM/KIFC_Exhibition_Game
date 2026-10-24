# Gerakan interaksi KIFC-G01

Pemilik meminta tambahan animasi yang terasa interaktif dan halus, terutama kemunculan feedback maskot. Instruksi sebelumnya mengizinkan implementasi langsung secara native, dengan bukti visual dan commit per tiket. Pilihan berikut merupakan keputusan implementasi untuk ditinjau melalui hasil.

## Arah

Gunakan gerakan singkat yang menjelaskan respons: maskot masuk lembut, balon menyusul, kartu unsur mengonfirmasi penempatan, kontrol sedikit tertekan, dan rincian hasil muncul berurutan. Teks selalu hadir utuh; tidak ada efek mengetik yang menunda membaca. Pertahankan urutan, skor, ukuran kartu, cropping, posisi tombol serta perilaku tap-anywhere. Tidak menambahkan aset, dependensi, suara atau loop dekoratif baru.

## Pendekatan

- Dipilih: komponen Flutter bersama dengan transformasi/opacity, durasi 180–420 ms, selesai lalu diam. Menggunakan aset maskot yang tersedia.
- Tidak dipilih: animasi skeletal/video maskot; membutuhkan aset baru dan decode tambahan.
- Tidak dipilih: gerakan berulang, partikel atau confetti; tidak membantu membaca maupun pemilihan jawaban.

## Perilaku

1. `MotionReveal` menjaga ruang layout, semantik dan state anak. Masuk pada mount atau perubahan trigger yang bermakna; rebuild countdown, audio dan hover tidak mengulang animasi. Durasi 320 ms, maskot 380 ms. Jeda bubble 55 ms dan rincian skor maksimum 180 ms.
2. Maskot bergeser dari bawah 16 px dan scale .98 menuju ukuran aslinya. Transformasi berada di dalam crop lama; logo tidak dibalik. Balon memakai pergeseran vertikal 8 px tanpa perubahan ukuran/layout akhir.
3. Percakapan awal/penutup, bacaan, feedback benar/salah/assembly, penjelasan demo dan ulasan akhir memakai masuk yang konsisten. Perubahan teks memutar respons baru, tidak menumpuk pesan lama.
4. Slot yang terisi mengonfirmasi penempatan dengan scale .94 ke 1, tanpa kategori tersembunyi atau api sebelum 3/3. Penanda pilihan tampil singkat; tantangan akhir tetap netral sebelum deadline.
5. `PressFeedback` memberi scale .98 saat pointer menekan, pulih pada up/cancel/nonaktif; tidak memiliki gesture recognizer atau callback gameplay sendiri. Tombol Material tetap menangani semantik, keyboard dan aktivasi.
6. Skor akhir langsung menampilkan nilai sebenarnya. Panel dan rincian masuk berurutan; tidak menghitung angka palsu dan tidak mengulang saat idle countdown berubah.
7. `disableAnimations` menampilkan keadaan akhir seketika, termasuk bila preferensi berubah saat animasi berjalan. Tidak menambah timer/callback tertunda, sehingga navigasi cepat dan dispose aman.

## Verifikasi

Uji kontrak replay/reduced motion/state/hit testing/cancel; regresi alur tiga bahasa, skor, audio dan timer. Capture UI Flutter beberapa ukuran portrait termasuk 1080×1920 dan 2160×3840 serta periksa frame di tengah gerakan. Rekam interaksi browser nyata untuk membuktikan gerakan, karena screenshot keadaan akhir saja tidak cukup. Bukti viewport bukan validasi TV fisik atau pengukuran FPS.
