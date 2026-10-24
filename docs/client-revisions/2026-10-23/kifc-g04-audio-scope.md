# KIFC-G04 — Cakupan audio untuk keputusan

Draf awal24Oktober 2026. **Diperbarui: pemilik meminta melanjutkan audio dan memakai rekaman yang diunduh dari internet. PaketC sedang diterapkan; penundaan di paragraf berikut merupakan riwayat keputusan lama.** Permintaan dokumen baru mencakup musik, suara alam, efek, volume dan mute. Keputusan langsung pemilik sebelumnya: “Untuk suara sepertinya kita lakukan nanti saja karena perlu development dan cost yang bertambah”. Karena cakupan/biaya belum dibahas ulang, permainan tetap tanpa suara. Tidak ada voice-over maskot atau aset berbayar yang ditambahkan.

## Paket yang dapat dipilih

| Paket | Isi | Implikasi |
|---|---|---|
| A — Teks dan animasi saat ini | Tidak ada audio | Tidak memerlukan speaker, perizinan audio, kontrol volume, atau perubahan bundel |
| B — Efek interaksi saja | Sentuhan tombol, drop/selection, penyelesaian; penanda dipilih tidak boleh membocorkan benar/salah sebelum ulasan | Membutuhkan aset berlisensi, pemutar offline Android/web, volume/mute, penanganan spam tap, lifecycle dan reset |
| C — Musik dan alam + efek | PaketB ditambah musik lembut dan ambience hutan yang relevan | Membutuhkan uji akustik ruang pameran, loop mulus, keseimbangan level serta memori/performa perangkat |

Voice-over tidak termasuk ketiga paket dan tidak ditambahkan otomatis. Belum ada estimasi biaya yang disepakati.

## Kriteria implementasi bila disetujui

- Semua aset lokal/offline, lisensi serta perubahan tercatat di ASSET_SOURCES.md; aset berbayar membutuhkan keputusan pemilik.
- Volume/mute terlihat dan mudah dijangkau; nilai awal/persistensi dan kewenangan pengaturan diputuskan sebelum penerapan.
- Audio web dimulai setelah aksi pengunjung; mute tetap efektif saat bahasa/halaman/sesi berubah. Pause ketika aplikasi tidak aktif, pulihkan sesuai status mute.
- Pemilihan dampak memberi suara netral. Bunyi benar/salah hanya sesudah hasil dibuka.
- Tidak menumpuk suara akibat tap cepat; musik/alam tidak menutupi efek ataupun kegiatan ruang pameran.
- Uji speaker/perangkat pemasangan nyata, Android offline, web autoplay, sesi ulang, keluar/masuk aplikasi, reduced motion tidak otomatis berarti mute.

## Informasi yang diperlukan

D-08: paket, anggaran aset/development, persetujuan memperluas tahap tanpa suara. D-09: modelTV/player, speaker dan kondisi ruang pameran. Setelah itu dapat dibuat bukti audio/rekaman; screenshot saja tidak membuktikan kualitas audio.


## Keputusan implementasi terbaru

Instruksi langsung pemilik membuka kembali G04. Musik+nature+efek (paketC), seluruh aset internet CC0, tidak ada pembelian/generasi/voice-over. Pengaturan dalam aplikasi: master45%, musik35%, alam45%, efek70%; gain dikalikan master. Nilai bertahan selama aplikasi hidup, termasuk ganti bahasa dan ulang sesi. Saat aplikasi dibuka ulang kembali ke default. Audio dimulai setelah interaksi. Speaker/tinggi pemasangan dan level akustik TV tetap perlu uji fisik; bukan penghalang implementasi offline awal. [Rencana dan pemeriksaan](../../superpowers/plans/2026-10-24-kifc-g04-audio.md).
