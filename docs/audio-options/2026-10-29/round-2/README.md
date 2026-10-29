# Musik orkestra yang mengikuti pilihan A

## Preferensi pemilik

Pemilik cukup menyukai **Treasure Hunter (A)** dan sangat tidak menyukai **Determined Pursuit (B)** serta **Heat Adventure (C)**. Rekomendasi A+B dari putaran pertama tidak berlaku lagi. B dan C tidak disertakan dalam paket putaran kedua. Musik di game belum diubah.

## Arah yang dicari

Mengikuti instrumen dan karakter petualangan A: orkestra dengan melodi yang jelas, strings dan perkusi, untuk mendukung foto hutan, maskot ranger yang ramah, serta aktivitas edukasi. Peningkatan energi tantangan sebaiknya tetap dalam keluarga musik tersebut. Kandidat dipilih dari keterangan kreator dan hubungan resmi dengan A, bukan semata-mata judul yang bertema hutan.

Lingkungan alat tidak mendukung input pendengaran audio. Karena itu, penilaian kecocokan berikut merupakan kurasi berdasarkan informasi kreator, struktur lisensi, dan preferensi A yang diberikan pemilik; bukan klaim bahwa seluruh rekaman telah didengarkan atau diuji pada speaker TV. Cuplikan dan halaman perbandingan dengan gambar game disiapkan untuk penilaian pendengaran pemilik/klien.

| Urutan | Rekaman | Alasan dipilih | Catatan |
|---|---|---|---|
| A1, prioritas utama | [The Path to the Nebula (Treasure Hunter Long Ver.) - TAD](https://opengameart.org/content/the-path-to-the-nebula-treasure-hunter-long-ver) | Versi panjang resmi dari A, komposer yang sama. Mempertahankan hubungan paling langsung dengan pilihan yang sudah disukai, sambil menyediakan bagian tambahan. | Bukan lagu baru yang sepenuhnya berbeda. Ada contoh 0-30 detik dan 45-75 detik untuk membandingkan pengembangannya. CC BY 4.0, wajib kredit. |
| A2, alternatif lagu baru | [adventure bgm idea - syncopika](https://opengameart.org/content/adventure-bgm-idea) | Kreator menandai orkestra, petualangan, dan march. Kandidat untuk menjaga rasa bergerak dan eksplorasi yang searah dengan A. | Perlu dinilai apakah ritme marsnya cocok dengan tone edukasi, bukan dianggap otomatis pas. CC BY 4.0, wajib kredit. |
| A3, alternatif bertema eksplorasi satwa | [safari - syncopika](https://opengameart.org/content/safari) | Kreator menandai orkestra, strings, dan brass; tema safari menjadi kandidat pendamping visual hutan dan maskot ranger. | Tema safari tidak berarti musik tradisional Indonesia atau rekaman alam Indonesia. Perlu dinilai agar tidak terasa seperti taman safari atau terlalu megah. CC BY 3.0, wajib kredit. |

**Rekomendasi utama: bandingkan A1 dahulu dengan A asli.** Ini kandidat dengan bukti kemiripan paling kuat. A2 dan A3 hanya alternatif lagu baru, bukan hasil final yang dijamin sesuai selera. Jika A asli tetap lebih cocok, pertahankan A dan atur dinamika volumenya per tahap alih-alih memaksakan penggantian.

## Cara membandingkan

Ekstrak ZIP lalu buka `Dengarkan-dengan-Tampilan-Game.html`. Pilih contoh musik, lalu ganti gambar Pembuka, Susun unsur, dan Tantangan untuk membandingkannya sambil melihat UI game. Gambar adalah render UI Flutter aktual, bukan rekaman aplikasi yang sudah memakai musik baru. Pergantian gambar bersifat manual; tidak mengubah halaman atau state game.

- Lima contoh audio: A asli, A1 awal, A1 bagian tambahan, A2, dan A3. Semuanya sekitar 30 detik.
- Contoh baru ditargetkan ke -18 LUFS/-2 dBTP dengan normalisasi dua tahap, fade-in 0,05 detik dan fade-out 0,4 detik, MP3 stereo 44,1 kHz/96 kbps. A asli memakai contoh terverifikasi putaran pertama dengan persiapan sama.
- Pengukuran setelah encoding, asal berkas, waktu cuplikan, dan hash disimpan dalam `sources.json`.
- Cuplikan bukan loop runtime final. Jika dipilih, gunakan sumber penuh dan siapkan sambungan, transisi, serta mix efek interaksi secara terpisah.
- Ini musik unduhan, bukan musik generatif. Berkas sumber penuh dan salinan halaman lisensi disimpan di `build/music-options-2026-10-29-round2/`.

## Kredit dan lisensi

Tiap contoh memiliki kredit kreator, judul, tautan sumber, tautan lisensi, serta keterangan pengolahan di halaman pemutar dan `sources.json`. TAD meminta kredit **TAD MILLER www.youtube.com/c/Tadon**. syncopika meminta nama **syncopika**. Pertahankan kredit ini jika rekaman dipakai pada game, termasuk tautan lisensi dan keterangan perubahan. Tidak ada kesan bahwa kreator mendukung proyek ini.

- [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/)
- A asli tetap [CC0](https://opengameart.org/content/treasure-hunter); lisensi A asli tidak boleh disamakan dengan versi panjang A1.

Sumber diperiksa 29 Oktober 2026. Setelah pemilik memilih, uji dalam game diperlukan untuk keseimbangan musik/efek, pengulangan, perpindahan halaman, mute, lifecycle, replay, operasi offline, dan speaker TV. Tidak ada APK baru atau deployment pada tahap kurasi ini.
