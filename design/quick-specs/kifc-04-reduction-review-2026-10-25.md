# KIFC-04 — hubungan pilihan unsur dan perubahan api

> Riwayat sebelum arahan kumulatif terbaru. Respons seluruh-api dan replay di bawah sudah diganti: setiap pilihan baru memadamkan dua api di areanya, dan area sebelumnya tetap padam. Lihat [implementasi serta bukti terbaru](../../docs/client-revisions/2026-10-25/kifc-04-spatial-reduction-review.md).

## Dasar dan keputusan

DOCX bagian 04 meminta tujuan belajar yang jelas, perubahan visual yang mudah diamati dan penjelasan per unsur. Alternatifnya menghapus demo jika mengulang penjelasan. Pada24 Oktober pemilik sudah meminta mempertahankan serta memperbaiki keempat keadaan Babak1 berdasarkan mockup dan tidak mengubah urutan. Arah dipertahankan mengikuti instruksi pemilik; ini tidak disebut sebagai persetujuan final KIFC.

Alternatif penghapusan: langsung dari penjelasan segitiga api ke bacaan karhutla, menghapus CTA demo serta rute kembali dan memindahkan prinsip pencegahan ke narasi. Tidak dipilih karena menghilangkan kesempatan membandingkan akibat mengurangi setiap unsur dan bertentangan dengan instruksi urutan terbaru. KIFC-04.05 tidak berlaku pada cabang dipertahankan.

## Temuan audit25 Oktober

- Checklist04 tidak diselaraskan dengan checkpoint mockup; laporan umum menyamarkan status yang belum diperiksa khusus.
- Ketiga pilihan hanya menggeser urutan fade enam api; hubungan pilihan dengan respons sulit dibedakan.
- Sentuhan ulang pada unsur yang sama diabaikan.
- Setelah pilihan ketiga, auto-lanjut2,6 detik tidak memberi waktu yang memadai untuk membaca penjelasan terakhir, terutama setelah2,2 detik animasi ulang.

## Perbaikan terarah

Tujuan belajar: dari tiga unsur yang membuat api menyala, pemain memahami bahwa pendinginan, pemisahan bahan bakar dan pembatasan oksigen mempunyai mekanisme yang berbeda.

| Pilihan | Respons ilustratif | Penjelasan |
|---|---|---|
| Panas | Enam nyala mereda bersama, mengecil menuju pangkal | Bahan yang terbakar didinginkan sampai tidak cukup panas untuk bertahan |
| Bahan bakar | Titik-titik api melemah terpisah dengan jeda lebih jelas | Jarak bahan kering menghambat rambatan; bahan yang sedang terbakar tetap perlu dipadamkan |
| Oksigen | Nyala bertahan lebih lama pada fase awal, kemudian cepat meredup | Pembatasan oksigen di sumber api; sulit dilakukan pada lahan terbuka dan tidak sama dengan menghentikan angin |

Perbedaan waktu adalah **ilustrasi interaksi, bukan perbandingan kecepatan/metode pemadaman lapangan**. Tidak menambahkan air pada foto hutan atau memberi kesan seluruh hutan dapat ditutup kedap udara. Enam rekaman dan panel248/216 logical px dipakai ulang; badge menyebut unsur yang sedang dikurangi.

Unsur yang sama dapat disentuh lagi; progres menghitung tiga unsur berbeda dan tetap tanpa skor. Pergantian cepat menjaga intensitas saat ini, lalu padam; setelah padam penyalaan ulang berlangsung halus. Tombol Ulangi memulihkan demo 0/3 dan membatalkan timer, tanpa mengubah poin susunan unsur sebelumnya.

Setelah 3/3, Lanjut tersedia di samping progres. Alur otomatis tetap berjalan sebagai fallback setelah 14 detik dari eksplorasi terakhir. Angka14 detik merupakan pilihan implementasi untuk ditinjau, bukan hasil uji baca TV fisik. Memilih ulang atau Ulangi membatalkan timer lama; kelanjutan manual juga membatalkannya. Urutan layar tidak berubah.

## Pemeriksaan yang harus diselesaikan

- [x] Tes gagal→lulus untuk pengulangan unsur, perbedaan respons, waktu baca, Ulangi dan pembatalan callback.
- [x] Naskah/status tiga bahasa, seluruh alur dan skor, audio netral serta reduced motion.
- [x] Render lima ukuran portrait × tiga bahasa: awal, tiap unsur di tengah animasi/padam dan3/3; inspeksi gambar FullHD/4K serta rekaman browser nyata.
- [x] Analisis/regresi, indeks bukti, pembaruan checklist04 dengan pembeda selesai implementasi/cabang tidak berlaku/validasi klien dan TV fisik.
- [x] Commit khusus KIFC-04 dan catat hash; tidak memasukkan laporan mingguan pemilik.


Verifikasi akhir:275 tes Flutter lulus; analisis bersih;120 render, inspeksi gambar dan rekaman browser nyata tersedia. Status implementasi Ditinjau, dengan batas TV fisik/pengesahan klien tertulis pada review.
