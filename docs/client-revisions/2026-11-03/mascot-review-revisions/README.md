# Revisi maskot dan proporsi Karhutla — 3 November

Paket runtime kini berasal dari `Camera_Facing_Revisions/Review/Manggala_CAMERA_FACING_REVISIONS_REVIEW.glb`, disalin tanpa perubahan ke `assets/models/manggala_camera_facing_revisions.glb`. Laporan sumber dibaca sebelum integrasi. Paket baru mencakup Talk menghadap kamera, Happy dengan tepuk tangan terus-menerus, dan Feedback silang tangan. Enam klip sumber, material, tekstur, badge, skin, morph dan kamera dipertahankan; varian silent ditambahkan kembali. Semua konsumen `GameMascot` memakai runtime yang sama dan tujuh poster telah diekspor ulang dari GLB baru. [Validasi aset](asset-validation.json).

## Pemuatan

Perubahan klip sekarang memakai API `animationName` pada renderer yang sudah dimuat; sebelumnya setiap perubahan klip membuang renderer dan membuka GLB lagi. Identitas widget maskot juga dipertahankan antara tiga bacaan Karhutla. Aset model dan JavaScript native mulai dibaca di latar belakang dari awal game dan disimpan dalam cache sesi, sehingga WebView berikutnya tidak mengulang pembacaan bundle.

[Pengujian web](retention-web.txt) menunjukkan elemen yang sama masih dimuat, tidak ada event load tambahan, dan klip berganti ke Talk. Uji terakhir mencatat sekitar 632 ms dari aksi tombol sampai pengamatan state; angka ini mencakup input/UI, bukan benchmark GPU atau jaminan waktu semua perangkat. Uji sebelumnya sekitar 243 ms. Ukuran GLB runtime berkurang dari 7.098.024 menjadi 6.726.328 byte.

Pergantian ke halaman yang membentuk renderer baru masih dapat memerlukan parsing/render awal. Optimasi ini belum membuat satu renderer global untuk seluruh game dan tidak menjanjikan nol loading pada semua transisi.

## Tampilan

Label “Menyiapkan narasi…” beserta padanan Inggris/Korea dihapus. Area bubble tetap menyediakan ruang paragraf lengkap tanpa placeholder selama persiapan; akses lanjut dan fallback jika audio gagal tetap tersedia. Tinggi maskot bacaan naik dari 170 menjadi 210 pada layout ringkas dan 250 pada layout normal; lebar slot 122/140. Teks bubble dan subtitle memakai 12,5 dengan jarak baris bubble 1,35. Tombol tetap mempertahankan ukurannya.

[Contoh Talk aktif](talk-active-web.png) · [Bacaan Indonesia 1080](web-id-1080-card2.jpg) · [Korea 2160](web-ko-2160-card1.jpg) · [Happy revisi](../../../../assets/images/mascot3d/success.png).

## Verifikasi dan batas

- 107 tes regresi lulus, termasuk layout tiga bahasa pada berbagai ukuran, alur permainan, narasi dan interupsi. Analisis Flutter bersih.
- 21 screenshot web pada lima viewport portrait dan tiga bahasa; bacaan 2/3 dicapture juga pada 1080×1920. Metadata mentah: [captures.txt](captures.txt). Screenshot adalah Flutter web, bukan TV fisik.
- Build web berhasil. Semua poster baru diverifikasi hash, dan bundle web dibangun ulang setelah ekspor gambar.
- APK debug `1.0.9-mascot-review+2026110321` dibangun, GLB terbaru serta penghapusan label diperiksa di dalam APK, lalu dipasang pada Android terhubung.
- Pemeriksaan lanjutan pada TECNO LG7n Android 12, 720×1640: [Talk dan teks](android-reading-18.png), [bacaan berikutnya](android-reading-32.png), serta [Happy pada jawaban benar](android-happy.png). [Data Happy](android-happy.json) menunjukkan perubahan quaternion lengan selama klip aktif.
- [Retensi renderer Android](android-retention.json): setelah pemuatan awal selesai, WebView yang sama tetap aktif melalui perpindahan otomatis ke bacaan berikutnya; klip mulai ulang tanpa event load tambahan. Sampel transisi awal dari halaman Segitiga Api disimpan dalam berkas tetapi tidak dihitung sebagai retensi antarbacaan. Satu event load awal yang terlambat masuk dicatat sebagai baseline, bukan sebagai pemuatan ulang. Alat inspeksi kini memilih WebView yang masih terpasang dan terlihat, sehingga konteks debug halaman lama tidak ikut dinilai.
- Aplikasi dikembalikan ke welcome setelah pengujian. Pengujian pada ponsel ini tidak menggantikan uji performa dan jangkauan TV pameran.

Perubahan masih di working tree bersama integrasi tiket 17–19; belum dibuat commit per tiket.
