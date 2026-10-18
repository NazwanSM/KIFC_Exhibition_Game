# Revisi Alur Pameran KIFC — Spesifikasi Desain

**Tanggal:** 18 Oktober 2026  
**Status:** Disetujui untuk perencanaan implementasi  
**Melaksanakan tiket:** REV-02 pada [tracker revisi klien](../../../design/quick-specs/client-revision-tracker-2026-10-18.md)

## Tujuan

Menyusun ulang pengalaman permainan agar pengunjung mencoba konsep tiga unsur api lebih dahulu, kemudian memahami maknanya melalui penjelasan singkat. Alur harus mengurangi layar dan tombol perantara, tetapi tetap memberi pengunjung kendali ketika membaca materi.

## Batasan dan keputusan

- Aplikasi tetap terdiri dari empat babak dan ditujukan untuk TV touchscreen portrait tanpa suara.
- Babak 2 lama menjadi Babak 1. Babak 1 lama menjadi Babak 2.
- Aktivitas menyusun tiga unsur api dan demo mengurangi unsur tetap ada. Bentuk visualnya tidak lagi diwajibkan sebagai segitiga.
- Istilah dan makna **segitiga api** dijelaskan dalam Babak 1, setelah pemain berhasil menyusun ketiga unsur. Istilahnya tetap digunakan meskipun susunan visual berbentuk kartu atau daftar.
- Definisi karhutla tidak lagi memakai aktivitas hotspot. Materi ditampilkan dalam 2–3 kartu pendek dengan maskot dan tombol `Lanjut`.
- Setelah pemain menyelesaikan aktivitas atau menjawab benar, feedback singkat kemudian membawa pemain maju otomatis. Tombol yang hanya berfungsi sebagai pintu masuk ke aktivitas berikutnya dihilangkan.
- Naskah yang dipakai sebelum materi klien tersedia harus ditandai sebagai sementara dan dapat diganti tanpa mengubah struktur layar.
- Maskot, bahasa Korea, desain pattern latar, dan aturan kesempatan kedua diimplementasikan oleh tiket terpisah. Alur ini menyediakan tempat kemunculannya, tetapi tidak mengunci bentuk visual atau naskah akhirnya.

## Masalah alur saat ini

Alur sekarang memiliki 13 keadaan layar utama. Empat bagian mengharuskan pemain memasuki aktivitas berikutnya lewat layar pembuka dan tombol khusus: pengenalan tiga unsur api, kuis penyebab, visual rambatan api, serta sejumlah tombol lanjutan setelah aktivitas selesai. Selain menambah ketukan, pemisahan itu membuat penjelasan karhutla muncul sebelum pengalaman yang bisa dirujuk pemain.

Perubahan ini tidak menghapus materi keselamatan. Ia menghapus atau menggabungkan keadaan navigasi yang tidak membawa informasi atau aktivitas baru. Penjelasan yang perlu dibaca tetap menggunakan kontrol eksplisit supaya pengunjung tidak kehilangan waktu membacanya.

## Alur yang disetujui

### Pembuka

Halaman pembuka tetap memilih bahasa dan memulai sesi. Indikator menyatakan empat babak. Tombol utama akan diposisikan ulang pada REV-09.

### Babak 1 — Tiga unsur api

1. **Susun unsur api.** Pemain langsung menerima instruksi singkat untuk menempatkan panas, bahan bakar, dan oksigen pada susunan kartu/daftar. Petunjuk interaksi ada pada layar yang sama; tidak ada layar “kenali segitiga api” sebelumnya.
2. **Hasil susunan.** Setelah tiga unsur lengkap, api terlihat menyala dan muncul feedback singkat secara otomatis.
3. **Penjelasan segitiga api.** Maskot menjelaskan bahwa panas, bahan bakar, dan oksigen adalah tiga unsur yang membuat api dapat menyala serta terus membakar. Ketiganya dikenal sebagai *segitiga api*, walaupun pengalaman ini menyajikannya sebagai kartu atau daftar. Pengunjung menekan `Lanjut` setelah membaca kartu singkat ini.
4. **Kurangi satu unsur.** Pemain bebas memilih panas, bahan bakar, atau oksigen untuk melihat cara kerja pencegahan. Aktivitas ini tetap demo tanpa benar/salah dan tidak diberi skor. Setelah pengunjung memilih atau setelah jeda yang sesuai implementasi, alur dapat berlanjut ke Babak 2 tanpa tombol “Kenali Penyebabnya”.

Babak ini memenuhi prinsip “main dahulu, lalu penjelasan”: pemain sudah melihat api terbentuk sebelum istilah dan mekanismenya diterangkan.

### Babak 2 — Karhutla dan risiko awal

1. **Kartu maskot 1: definisi.** Menjelaskan pengertian karhutla.
2. **Kartu maskot 2: dampak.** Menjelaskan akibat bagi hutan, lahan, dan warga.
3. **Kartu maskot 3: pencegahan.** Menjelaskan bahwa pencegahan dilakukan sebelum api membesar dan menyebar. Kartu ketiga opsional jika narasi klien dapat disampaikan jelas dalam dua kartu.
4. **Pilih kondisi berisiko.** Pemain memilih satu dari tiga kondisi visual. Layar ini tetap mengajarkan bahan kering dan sumber penyulut. Detail salah pertama dan kesempatan kedua mengikuti REV-01.

Setiap kartu hanya menyampaikan satu gagasan dan menggunakan tombol `Lanjut` yang jelas. Tombol ini adalah kontrol membaca, bukan pintu masuk yang menyembunyikan aktivitas.

### Babak 3 — Penyebab kebakaran

1. **Situasi penyebab.** Pemain langsung melihat situasi pertama dan memilih apakah pemicunya aktivitas manusia atau faktor alam. Instruksi tersedia di bagian atas layar yang sama.
2. **Situasi berikutnya.** Setelah feedback, aplikasi berpindah otomatis ke situasi berikutnya. Tidak ada layar “Lihat Situasinya” dan tidak ada halaman ringkasan babak terpisah.
3. **Penghubung ke babak 4.** Feedback pada situasi terakhir merangkum bahwa mengenali penyebab membantu mencegah kebakaran, kemudian berpindah ke Babak 4.

### Babak 4 — Batasi rambatan api dan tantangan akhir

1. **Rambatan dan pilihan aman.** Visual api menjalar dan pilihan tindakan aman hadir pada satu pengalaman yang sama. Pengunjung tidak perlu membuka layar pengantar lalu memulai pilihan secara terpisah.
2. **Hasil tindakan.** Respons visual menunjukkan apakah rambatan berhenti atau berlanjut. Penanganan jawaban salah mengikuti REV-01.
3. **Temukan risiko kebakaran.** Tantangan akhir bertimer tetap dimulai otomatis setelah aset siap. Aturan skornya tidak berubah dalam tiket ini.
4. **Hasil dan penutup.** Skor dan halaman penutup tetap memberi kontrol eksplisit untuk mengulang permainan atau kembali ke beranda/pameran.

## Keadaan layar yang digabungkan

| Keadaan saat ini | Perlakuan baru | Alasan |
|---|---|---|
| Pengenalan tiga unsur api | Menjadi kartu penjelasan “segitiga api” setelah hasil susunan Babak 1 | Pemain mendapat konteks dari apa yang baru dilakukan, tetapi istilah teknisnya tetap diajarkan. |
| Tombol menuju risiko dan tiga unsur | Dihilangkan; perpindahan terjadi setelah feedback | Tidak menambah informasi atau pilihan pemain. |
| Pengantar penyebab dan tombol “Lihat Situasinya” | Digabung ke situasi penyebab pertama | Instruksi dan aktivitas dapat tampil bersama. |
| Ringkasan penyebab | Digabung ke feedback situasi terakhir | Pesan tetap tersampaikan tanpa halaman transisi. |
| Pengantar api menjalar dan tombol memilih tindakan | Digabung ke layar pilihan tindakan | Visual dapat menjadi konteks langsung untuk keputusan. |
| Hotspot “Apa itu karhutla?” | Diganti 2–3 kartu penjelasan maskot | Memenuhi revisi klien tanpa aktivitas yang tidak diperlukan. |

## Kontrak naskah sementara

Sebelum narasi klien diterima, setiap kartu dan feedback memakai naskah kerja singkat yang memiliki `id` tetap. Ketika klien mengirim naskah, penggantian dilakukan per `id`, bahasa, dan kartu tanpa mengubah urutan babak, kondisi perpindahan, ataupun logika permainan. Materi final dapat menambah atau menghapus kartu ketiga Babak 2 selama tiap kartu tetap menyampaikan satu gagasan dan tidak menambah interaksi baru.

## Dampak implementasi

- Model keadaan halaman di `lib/features/game/exhibition_game.dart` perlu disusun kembali. Halaman intro yang berdiri sendiri akan dihapus atau digabung ke halaman aktivitas terkait.
- Indikator progres, judul, kata penghubung, dan perhitungan skor per babak harus merujuk ke urutan baru.
- Tes alur di `test/game_flow_test.dart` harus menjalankan urutan baru serta memeriksa bahwa layar yang digabung tidak lagi membutuhkan tombol perantara.
- Aturan visual lama yang secara eksplisit mewajibkan susunan segitiga harus diperbarui saat REV-06 diterapkan.

## Kriteria penerimaan REV-02

- Babak 1 mengawali sesi dengan aktivitas tiga unsur api, lalu memberi kartu penjelasan segitiga api dan demo pengurangan unsur.
- Babak 2 menyediakan 2–3 kartu penjelasan karhutla yang dikendalikan pengunjung, kemudian aktivitas memilih kondisi berisiko.
- Tidak ada layar pembuka atau tombol khusus yang hanya dibutuhkan untuk memasuki aktivitas penyebab atau pilihan tindakan aman.
- Setiap aktivitas memiliki instruksi yang cukup di layar aktifnya.
- Urutan baru tetap berakhir pada tantangan akhir, skor, dan penutup.
- Naskah kartu dapat diganti ketika narasi klien tiba tanpa menata ulang flow.

## Di luar cakupan spesifikasi ini

- Bentuk kartu/daftar untuk tiga unsur api (REV-06).
- Aset, pose, dan integrasi visual maskot (REV-04).
- Kesempatan kedua, clue, dan durasi feedback (REV-01).
- Bahasa Korea (REV-03), pattern latar (REV-05), serta posisi tombol pembuka (REV-09).

## Riwayat keputusan

| Tanggal | Keputusan |
|---|---|
| 2026-10-18 | Disetujui menukar Babak 1 dan Babak 2, lalu merapikan seluruh flow agar tidak menggantung. |
| 2026-10-18 | Disetujui mengganti penjelasan karhutla dengan beberapa kartu pendek; naskah final akan diselaraskan dengan narasi klien. |
| 2026-10-18 | Disetujui menjelaskan konsep segitiga api dalam Babak 1, setelah pemain menyusun tiga unsur. |
