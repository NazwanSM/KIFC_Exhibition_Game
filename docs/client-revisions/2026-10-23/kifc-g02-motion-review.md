# KIFC-G02 — Animasi pembelajaran dan fallback

24 Oktober 2026. Animasi dipakai untuk menunjukkan perubahan pembelajaran: api muncul setelah tiga unsur lengkap, padam bertahap saat satu unsur dikurangi, serta berhenti menjalar ketika bahan bakar dipisahkan. Transisi halaman dan pilihan singkat membantu membaca respons. Fog tidak dipasang di layar mana pun; tidak ditambah dekorasi bergerak terus-menerus.

Video pilihan pemilik dikonversi menjadi WebP ber-alpha, sehingga tidak bergantung pada codec/autoplay video platform. Babak 1 memakai tiga loop160×240,15 fps,total1.76 MB dari sumber237888.mp4; enam titik berbagi tiga fase. Simulasi rambatan lama memakai480×180,15 fps,sekitar 7.15 MB. Poster statis tersedia dan seluruhnya offline. MP4 sumber tidak ikut bundel. Sumber dan proses konversi ada di ASSET_SOURCES.md. Tidak diperlukan aset3D baru untuk menyampaikan materi saat ini.

Perbaikan audit: bila rekaman tidak tersedia atau gagal didekode, `FireLoop` sekarang menampilkan poster lokal. Mode reduced motion memakai poster sejak awal. Pemutaran dihentikan ketika tersembunyi atau aplikasi tidak aktif. Materi tetap dapat digunakan tanpa gerakan.

## Bukti

- 20 tes terarah lulus (`build/kifc-g02.log`): decoding alpha/perubahan frame, lifecycle, reduced motion, fallback nyata ketika path animasi sengaja salah, enam jangkar, transisi padam, serta15 kombinasi viewport/bahasa.
- Analisis bersih: `build/review-kifc-g02/analyze.log`.
-[Fallback komponen800×600](../../../build/review-kifc-g02/offline-fire-fallback.png): rekaman sengaja tidak tersedia, poster berhasil didekode. Background file transparan; ini render komponen, bukan foto/halaman TV.
-[Penjelasan FullHD Indonesia](../../../build/review-kifc-g02/explanation-id-1080x1920.png), [demo FullHD](../../../build/review-kifc-g02/reduction-before-id-1080x1920.png), [padam4K Korea](../../../build/review-kifc-g02/reduction-extinguished-ko-2160x3840.png). Folder yang sama mencakup360×640,411×731,720×1280,1080×1920,2160×3840 dan tiga bahasa.

Ukuran aset dan tes codec bukan hasil ukur FPS/GPU/memori TV. Profil performa AndroidTV fisik tetap terbuka pada D-09; G02.03 belum ditutup penuh. Tidak ada suara, push atau deployment.
