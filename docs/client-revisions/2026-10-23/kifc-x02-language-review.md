# KIFC-X02 — Naskah tiga bahasa dan istilah

24 Oktober 2026. Inventaris aktif: pembuka; instruksi/salah/parsial/lengkap susun unsur; penjelasan segitiga api; tiga demo pengurangan; tiga kartu Babak2; kuis gambut (awal/hint/benar/salah kedua); empat situasi penyebab Babak3; keputusan tindakan lama yang masih dipertahankan; tantangan dampak/ulasan; hasil; penutup; mulai ulang.

Indonesia memakai naskah klien pada bagian yang tersedia dan salinan vendor untuk hint/penjelasan tambahan. Inggris dan Korea adalah terjemahan vendor untuk ditinjau, belum dinyatakan disahkan klien atau penutur Korea. Bagian KIFC-09 belum menggantikan materi tindakan, karena format/naskah detail belum diputuskan. Peta narasi lama tetap dapat ditelusuri melalui tracker18Oktober dan `app_locale.dart`; entri kamus historis yang tidak dirender bukan materi aktif.

| Indonesia | English | 한국어 |
|---|---|---|
| Panas | Heat | 열 |
| Bahan bakar | Fuel | 연료 |
| Oksigen | Oxygen | 산소 |
| Air | Water | 물 |
| Udara | Air | 공기 |
| Hutan rawa gambut | Peat swamp forest | 이탄습지 숲 |
| Kabut asap | Haze | 연무 |
| Kerusakan ekosistem | Ecosystem damage | 생태계 훼손 |
| Emisi karbon tinggi | High carbon emissions | 많은 탄소 배출 |
| Penurunan permukaan tanah/subsidens | Lower ground surface/subsidence | 지표면 높이 감소/지반 침하 |
| Cadangan karbon gambut | Peat carbon stores | 이탄의 탄소 저장량 |

Skrip menjelaskan bara di bawah permukaan, sulitnya pemadaman, dan potensi api kembali sesuai materi KIFC. Demo oksigen tetap menjelaskan bahwa udara diam mengandung oksigen; pembatasan oksigen di lahan terbuka memiliki batas dan bukan anjuran mengatasi kebakaran besar sendiri. Tidak ada voice-over.

## Verifikasi

- `test/korean_flow_test.dart`: dua alur lengkap411×731 dan1080×1920, dari memilih bahasa → drag salah/benar → feedback → tiga demo → bacaan → hint kuis/benar → empat situasi → tindakan → empat dampak → ulasan → skor9 → penutup → mulai ulang. Semua lulus dalam `build/kifc-korean-flow.log`.
- Setiap tahap Korea diperiksa agar tidak ada kata Latin yang tertinggal pada teks pemain, kecuali merek KIFC dan pilihan bahasa/nama lembaga. Pemeriksaan bukan penilaian mutu bahasa oleh penutur asli.
- Tes sebelumnya mencakup pergantian judul langsung, teks dinamis, bonus desimal, lima ukuran dan tiga bahasa. Font Archivo/NotoSansKR dibundel offline.
- Analisis bersih: `build/review-kifc-integration/analyze.log`.

Bukti render perjalanan Korea: [pembuka411](../../../build/review-kifc-integration/ko-411-welcome.png), [feedback unsur](../../../build/review-kifc-integration/ko-411-triangle-complete.png), [penjelasan1080](../../../build/review-kifc-integration/ko-1080-fire-explanation.png), [bacaan](../../../build/review-kifc-integration/ko-1080-karhutla-prevention.png), [situasi Babak3](../../../build/review-kifc-integration/ko-1080-cause-correct.png), [hasil](../../../build/review-kifc-integration/ko-1080-score.png), [penutup](../../../build/review-kifc-integration/ko-411-closing.png), [ulang sesi](../../../build/review-kifc-integration/ko-1080-fresh-replay.png). Screenshot lima ukuran per layar tersimpan pada indeks tiket01–08/10/G02 yang tertaut di tracker. Semua ini render widget Flutter, bukan foto TV fisik.

Status **Ditinjau** untuk naskah aktif. Pengesahan terjemahan klien/penutur Korea dan materi pengganti09 tetap terbuka.
