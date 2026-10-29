# Alternatif musik untuk KIFC

> Preferensi terbaru pemilik: A cukup disukai; B dan C sangat tidak disukai. Rekomendasi A+B di catatan historis ini dibatalkan. Lihat [kurasi putaran kedua](round-2/README.md) yang mengikuti A.

Kurasi 29 Oktober 2026 untuk menanggapi permintaan musik yang lebih dinamis, sedikit dramatis, serta membangun semangat saat tantangan. Belum ada penggantian aset runtime, perubahan mixer, APK baru, atau deployment.

## Temuan awal

Musik saat ini memakai **Forest Ambience oleh TinyWorlds** dari [OpenGameArt](https://opengameart.org/content/forest-ambience), berlisensi CC0. Aset dinormalisasi sekitar -23 LUFS; level awal musik 25% dan master 65%. Nilai tersebut merupakan gain aplikasi, bukan ukuran kenyaringan speaker TV. Backend saat ini menggunakan satu musik loop untuk seluruh alur, sehingga belum ada perubahan musik khusus saat memasuki tantangan.

## Tiga pilihan untuk didengarkan

| Pilihan | Rekaman dan sumber | Arah yang bisa dicoba |
|---|---|---|
| A | [Treasure Hunter - TAD](https://opengameart.org/content/treasure-hunter) | Orkestra petualangan dengan violin dan drum menurut tag kreator; kandidat untuk permainan utama atau tantangan yang tetap terasa bersahabat. |
| B | [Determined Pursuit - Emma_MA](https://opengameart.org/content/determined-pursuit-epic-orchestra-loop) | Orkestra dengan strings, horn, dan drum; kreator menyebut penggunaan untuk berpacu dengan waktu. Kandidat khusus tantangan 30 detik; perlu dinilai apakah ketegangannya terlalu kuat untuk pengunjung. |
| C | [Heat Adventure - MintoDog](https://opengameart.org/content/heat-adventure) | Gitar elektrik untuk suasana petualangan, loop dengan nama berkas BPM 135. Alternatif bila klien menginginkan karakter lebih modern daripada orkestra. |

Karakter di atas adalah arah kurasi berdasarkan keterangan kreator, bukan hasil uji pendengaran pada TV. Tidak ada klaim musik tertentu pasti paling sesuai sebelum klien membandingkannya dalam konteks game.

Ketiga halaman sumber mencantumkan **CC0** saat diperiksa. [Ringkasan resmi CC0](https://creativecommons.org/publicdomain/zero/1.0/) memperbolehkan penyalinan, modifikasi, distribusi, dan pemakaian komersial tanpa meminta izin hak cipta. Nama kreator dan asal tetap dicatat. Bukti hash, URL berkas, dan persiapan audio ada di [sources.json](sources.json); halaman sumber asli dan rekaman unduhan disimpan di `build/music-options-2026-10-29/`.

## Isi contoh audio

- Masing-masing cuplikan 30 detik dari awal rekaman sumber.
- Normalisasi dua tahap ditargetkan ke -18 LUFS, true peak -2 dBTP, LRA 11, lalu fade-in 0,05 detik dan fade-out 0,4 detik. Hasil encoding MP3 perlu diukur lagi untuk melihat penyimpangan aktual.
- Stereo MP3 44,1 kHz, 96 kbps. Contoh bukan audio yang dibuat secara generatif.
- Cuplikan untuk perbandingan memiliki akhir fade; jangan memakai potongan ini sebagai loop runtime karena sambungannya belum disiapkan.
- Tidak dicampur dengan efek tombol atau suasana hutan. Keseimbangan dengan efek, kualitas loop asli, transisi halaman, dan kenyamanan speaker TV tetap perlu diuji setelah pilihan disepakati.

## Rekomendasi susunan musik

Gunakan **A sebagai arah permainan utama dan B sebagai arah tantangan akhir**, dengan volume lebih rendah saat halaman penjelasan. C menjadi alternatif bila klien lebih menyukai gitar. Ini usulan untuk didengarkan, bukan keputusan penerapan.

Jika disetujui, integrasi mencakup transisi volume sekitar 0,5-1 detik tanpa menumpuk loop, pengurangan musik saat membaca hasil, serta mempertahankan mute, pengaturan per lapisan, lifecycle, replay, dan aset offline. Efek interaksi tetap harus terdengar jelas. Musik atau efek pilihan tantangan tidak boleh membocorkan benar/salah sebelum waktunya habis. Tidak perlu mempercepat rekaman terus-menerus untuk menciptakan ketegangan; nilai dulu perubahan aransemen dan dinamika aslinya.

## Pesan yang bisa diteruskan ke klien

> Bisa, kami siapkan beberapa alternatif untuk dibandingkan. Arahnya musik petualangan yang lebih berenergi saat bermain, lalu musik yang sedikit lebih dramatis saat masuk tantangan. Pada bagian membaca penjelasan dan hasil, musik akan tetap lebih tenang agar nyaman. Kami siapkan tiga cuplikan, masing-masing 30 detik, supaya bisa dipilih karakter yang paling sesuai sebelum diterapkan ke game.
