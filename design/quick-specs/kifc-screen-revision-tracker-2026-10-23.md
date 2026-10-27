# Tracker revisi layar game dari KIFC

Tanggal pencatatan: **23 Oktober 2026**. Tanggal ini adalah tanggal penerimaan/pencatatan, bukan asumsi tanggal penulisan dokumen klien.

Sumber utama: [Revisi_Game_Untuk_Vendor.docx](../../docs/client-revisions/2026-10-23/Revisi_Game_Untuk_Vendor.docx). Salinan sumber diarsipkan tanpa perubahan; SHA-256: `d4b9bfbb92db72a3776b4a0490866596fec18dbc3790703eef5f080d9ab310e2`.

Dokumen sumber berisi **11 bagian layar dengan 11 screenshot serta 4 catatan lintas game**. Seluruh catatan, screenshot, dan penandaan jawaban sudah dibaca. Tidak ditemukan komentar Word atau perubahan terlacak; catatan revisi berada di isi tabel. Naskah pengganti dari KIFC disalin dalam blok kutipan di bawah dengan isi kalimat dipertahankan.

Tracker ini mencatat pekerjaan baru dari dokumen KIFC. **KIFC-01 sampai11 sudah diterapkan dan berada dalam peninjauan.** Riwayat pekerjaan sebelumnya tetap ada di [tracker 18 Oktober](client-revision-tracker-2026-10-18.md). Keputusan terbaru yang jelas dalam dokumen KIFC menjadi acuan untuk revisi terkait; alternatif tidak dianggap otomatis disetujui.

## Cara menggunakan tracker

- Status: `Siap`, `Siap sebagian`, `Perlu kajian`, `Menunggu keputusan`, `Dikerjakan`, `Ditinjau`, `Selesai`.
- ID `KIFC-01` sampai `KIFC-11` mengikuti nomor bagian dalam DOCX, **bukan nomor babak game**. ID turunan seperti `KIFC-02.03` adalah pekerjaan yang dapat diperiksa satu per satu.
- `G` menandai pekerjaan lintas game; `X` menandai integrasi, bahasa, dan verifikasi. `D` menandai keputusan yang belum tersedia.
- Centang subpekerjaan setelah implementasi dan pemeriksaan yang relevan. Tutup tiket setelah kriteria penerimaannya terpenuhi dan bukti dicatat. Jangan mencentang implementasi hanya karena rancangan atau asetnya sudah disiapkan.
- Untuk setiap tiket, isi log di akhir file dengan commit, hasil pemeriksaan, lokasi screenshot/rekaman, serta keterbatasannya. Pemeriksaan viewport/emulator tidak membuktikan kenyamanan jangkauan TV fisik.
- Cakupan: **18 kelompok pekerjaan; 16 Ditinjau, 2 Ditinjau sebagian, 0 Menunggu keputusan, 0 Selesai/disahkan klien**. Sebagian permintaan melanjutkan fitur yang sudah ada; keberadaannya tetap perlu diperiksa terhadap kebutuhan baru.
- Sesuai permintaan pemilik proyek, setiap revisi disertai screenshot beberapa ukuran portrait, terutama simulasi TV Full HD 1080×1920 dan 4K 2160×3840. Catat bahasa, sumber gambar, dan batas pemeriksaannya; jangan menyebut render viewport sebagai foto TV fisik.

## Daftar pekerjaan per layar

| ID | Layar atau cakupan | Status terkini | Ketergantungan utama |
|---|---|---|---|
| KIFC-01 | Tampilan awal | Ditinjau | Implementasi dan 16 screenshot siap; penilaian pemilik serta TV fisik menunggu |
| KIFC-02 | Menyusun tiga unsur api | Ditinjau | Tiga slot dipertahankan; aset dan layout baru siap ditinjau; 60 render dan tes tersedia |
| KIFC-03 | Penjelasan segitiga api | Ditinjau | Narasi utama, panel di atas dan urutan unsur konsisten; bukti tiga bahasa tersedia |
| KIFC-04 | Simulasi mengurangi unsur api | Ditinjau | Koreksi25Oktober: pasangan kiri/tengah/kanan padam kumulatif6→4→2→0;276tes,120render dan rekaman browser tersedia; pengesahan/uji TV fisik terbuka |
| KIFC-05 | Pengertian kebakaran hutan | Ditinjau | Naskah KIFC dan 15 screenshot siap |
| KIFC-06 | Penyebab kebakaran hutan | Ditinjau | Kartu kedua diubah ke penyebab; 15 screenshot siap |
| KIFC-07 | Pentingnya pencegahan kebakaran hutan | Ditinjau | 4 pilar kerugian diterapkan; 15 screenshot siap |
| KIFC-08 | Kuis kebakaran hutan rawa gambut | Ditinjau | Feedback benar/salah kedua15detik atau sentuh untuk lanjut; satu retry tetap; naskah salah kedua vendor masih perlu ditinjau melalui D-05 |
| KIFC-09 | Karakteristik kebakaran ekosistem gambut | Ditinjau | Tiga kartu1–3 berputar, tanpa skor;60 render dan alur tiga bahasa diuji |
| KIFC-10 | Tantangan mengenali dampak kebakaran | Ditinjau | Implementasi/foto/3 bahasa/60 render tersedia; pemilik menetapkan30detik pada25Oktober melalui D-06; skor8 dipetakan melalui D-07 |
| KIFC-11 | Layar hasil akhir | Ditinjau | Skor maksimum8; feedback/hasil15detik atau sentuh untuk lanjut lebih cepat sesuai klarifikasi25Oktober; uji TV fisik tetap X03 |
| KIFC-G01 | Variasi interaksi, transisi, dan respons sentuhan | Ditinjau | Pemetaan interaksi, gerakan maskot/dialog/kontrol/slot/hasil dan pembatalan timer diverifikasi;254 tes lulus;81 render serta rekaman browser tersedia |
| KIFC-G02 | Animasi dan latar bergerak | Ditinjau sebagian | Video pemilik, fallback, reduced motion dan offline diuji; profil TV fisik menunggu D-09 |
| KIFC-G03 | Pengayaan visual seluruh layar | Ditinjau | Audit per layar,33 render inset serta APK offline; overflow Android diperbaiki |
| KIFC-G04 | Musik, suara alam, efek suara, dan kontrol audio | Ditinjau | Koreksi interaksi/error web,239 tes,53 aset APK serta alur/audio native tiga bahasa diperiksa; akustik TV fisik menunggu D-09 |
| KIFC-X01 | Alur, penomoran babak, dan perhitungan skor | Ditinjau | Urutan dipertahankan, kartu09 tanpa skor, maksimum8;212 tes lulus |
| KIFC-X02 | Naskah tiga bahasa dan konsistensi istilah | Ditinjau | Inventaris/glosarium serta alur Korea diperiksa; materi09 sudah tiga bahasa; validasi klien/penutur menunggu |
| KIFC-X03 | Verifikasi, perangkat, dan rilis | Ditinjau sebagian | E2E 25 Oktober: 313 tes, browser/APK release final ID/EN/KO, 53 aset dan 951 render; paket review lokal siap. TV fisik, signing produksi dan publikasi terbaru tetap terbuka |

## KIFC-01 Tampilan awal

**Sumber:** bagian 01, screenshot 01. **Pemetaan saat ini:** `_WelcomePage`.

- [x] **KIFC-01.01** Pertahankan foto hutan yang sedang digunakan.
- [x] **KIFC-01.02** Tambahkan gradasi gelap tipis pada area teks saja; jangan menggelapkan seluruh foto secara berlebihan.
- [x] **KIFC-01.03** Perjelas hierarki ukuran dan posisi judul “Fire Prevention Challenge” agar menjadi fokus utama.
- [x] **KIFC-01.04** Seimbangkan jarak judul, deskripsi, maskot, dan tombol.
- [x] **KIFC-01.05** Rapikan bentuk, ukuran, dan warna kotak dialog; sesuaikan padding teks serta jarak antarbaris.
- [x] **KIFC-01.06** Pertahankan ukuran besar tombol “Mulai Tantangan”; perjelas kontras, label, serta respons saat disentuh.
- [x] **KIFC-01.07** Periksa komposisi, warna, dan jarak antarelemen dengan acuan **TV sentuh 42 inci portrait** melalui simulasi viewport Full HD/4K. Uji fisik tetap terbuka pada D-09 dan X-03.

**Kriteria penerimaan:** judul terbaca jelas di atas foto, percakapan maskot menyatu dengan komposisi, tombol langsung terlihat dan memberi respons sentuhan yang jelas. Penyesuaian tetap mengikuti preferensi pemilik proyek terhadap tombol dominan hijau dengan gradasi lembut; sumber tidak meminta gradasi tombol yang lebih kuat.

**Catatan:** 42 inci adalah informasi perangkat baru dari dokumen; resolusi dan tinggi pemasangan belum disebutkan. Jangan menyamakan diagonal 42 inci dengan ukuran area sentuh dalam piksel.

**Implementasi dan bukti, 23 Oktober:** tint seluruh foto dikurangi, gradasi difokuskan pada area teks, hierarki judul serta jarak dialog diperbaiki, dan tombol tetap besar dengan gradasi hijau lembut. Respons tekan diberi pengecilan sesaat; pembatalan sentuhan tidak memulai permainan. Label bahasa dibuat satu baris; glyph serta bobot Hangul diperbaiki setelah peninjauan gambar. Tersedia 15 screenshot halaman pembuka (tiga bahasa × lima ukuran) ditambah keadaan tombol ditekan, semuanya sudah ditinjau. Analisis Flutter bersih; seluruh 43 tes lulus. [Indeks screenshot dan batas validasi](../../docs/client-revisions/2026-10-23/kifc-01-visual-review.md). Status Ditinjau: menunggu penilaian pemilik proyek dan pengujian TV fisik. Belum ada APK/deployment baru untuk tiket ini.

## KIFC-02 Menyusun tiga unsur api

**Sumber:** bagian 02, screenshot 02. **Pemetaan saat ini:** `triangleBuild`, `_DropSlot`, `_FirePiece`, `_PieceCard`.

- [x] **KIFC-02.01** Pastikan **semua kartu gambar dapat diseret**, termasuk pengecoh.
- [x] **KIFC-02.02** Pemain hanya dapat melanjutkan setelah ketiga unsur yang benar ditempatkan. Jangan menganggap tiga drop sembarang sebagai penyelesaian.
- [x] **KIFC-02.03** Pada drop yang salah, tampilkan alasan singkat dan beri kesempatan mencoba kembali; jawaban salah tidak mengisi unsur atau membuka kelanjutan.
- [x] **KIFC-02.04** Setelah ketiga unsur benar, tampilkan animasi api **pada gambar utama**.
- [x] **KIFC-02.05** Ganti “Panas matahari” dengan contoh panas/penyulut yang lebih jelas. Kandidat dari KIFC: percikan api, panas akibat gesekan, atau percikan akibat korsleting listrik. Pilihan aset final mengikuti D-10.
- [x] **KIFC-02.06** Ganti visual oksigen agar lebih mudah dipahami. Tetap jelaskan bahwa oksigen ada dalam udara; jangan memberi kesan angin harus ada agar api menyala.
- [x] **KIFC-02.07** Pasang penjelasan untuk kartu Air dan Hujan sesuai naskah di bawah.
- [x] **KIFC-02.08** Tindak lanjuti saran mengganti “Udara dingin” dengan “Batu”, berikut aset, label, dan penjelasannya. Alasannya: udara dingin tetap mengandung oksigen dan membingungkan sebagai pengecoh.
- [x] **KIFC-02.09** Pasang feedback penyelesaian yang diberikan KIFC; pastikan waktu tampil cukup untuk membaca seluruh penjelasan.
- [x] **KIFC-02.10** Siapkan pembahasan alternatif drop langsung ke gambar utama, termasuk rancangan respons saat kartu benar/salah dijatuhkan. Implementasikan alternatif hanya setelah D-01 disetujui.

**Naskah pilihan tidak sesuai:**

| Kartu | Penjelasan dari sumber |
|---|---|
| Air | Air bukan salah satu unsur dalam Segitiga Api. |
| Hujan | Hujan bukan salah satu unsur dalam Segitiga Api. |
| Batu, sebagai pengganti yang disarankan | Batu bukan unsur yang dicari dalam Segitiga Api. |

**Feedback ketika seluruh unsur benar:**

> Tepat! Api dapat menyala ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Ketiga unsur ini disebut Segitiga Api. Mengurangi salah satu unsur dapat membantu mengendalikan api.

**Alternatif dari KIFC, belum merupakan keputusan:** hapus tiga kotak berlabel Panas, Bahan Bakar, dan Oksigen; kartu diseret langsung ke gambar utama; api muncul setelah tiga unsur benar terkumpul. Jangan menerapkan format slot dan format drop langsung sebagai dua kewajiban sekaligus.

**Kriteria penerimaan:** seluruh kartu dapat dicoba; hanya panas, bahan bakar, dan oksigen yang memenuhi penyelesaian; setiap kesalahan memiliki alasan; api serta feedback penyelesaian muncul sesudah unsur lengkap. Materi, gambar, dan label cocok satu sama lain.

**Implementasi dan bukti, 23 Oktober:** sesuai instruksi pemilik, tiga slot dipertahankan; alternatif drop langsung ke foto hanya dicatat sebagai perbandingan dalam rancangan. Tampilan assembly kini memakai judul “Pilih tiga unsur api.” dan instruksi “Seret tiga foto yang tepat ke tempat kosong.”, panel hutan Kalimantan proporsional, tiga slot kosong setara, serta enam kartu seragam. Label kategori tidak ditampilkan sebelum terisi. Unsur yang benar dapat masuk ke tempat kosong mana pun; tidak ada kategori tersembunyi. Maskot menjadi setengah badan besar di tepi bawah, dengan balon teks dinaikkan. Foto diberi filter runtime ringan dan label diperjelas. Sumber panas diganti percikan akibat gesekan, udara dingin diganti batu, dan oksigen memakai konteks udara terbuka dengan label serta cue O₂. Kredit aset dicatat di ASSET_SOURCES. Foto udara adalah ilustrasi konteks, bukan foto molekul oksigen.

Seluruh kartu awal dapat diseret. Air/hujan/batu mendapat alasan naskah KIFC; pilihan benar tidak dinilai salah hanya karena posisi slot; duplikasi tidak menambah unsur. Api hanya muncul setelah tiga unsur lengkap. Saat masih memilih, kartu terpakai ditandai centang; setelah ketiganya lengkap, bank pilihan disembunyikan dan tiga unsur dirangkum pada slot untuk memberi ruang penjelasan. Preview drag mengikuti ukuran kartu asli pada layar terskala. Feedback penyelesaian memakai naskah penuh KIFC, lalu lanjut otomatis setelah 14 detik (durasi implementasi vendor, masih dapat ditinjau melalui uji baca). Foto/slot bersama pada penjelasan dan demo berikutnya ikut diselaraskan, panel tetap 190 logical px; narasi KIFC-03 dan keputusan konsep KIFC-04 belum dikerjakan.

Analisis bersih, **151 tes lulus**, dan **60 render** empat keadaan × tiga bahasa × lima ukuran tersimpan. [Rancangan dan pelaksanaan](../../docs/client-revisions/2026-10-23/kifc-02-layout-plan.md), [indeks screenshot, pemeriksaan, dan batas bukti](../../docs/client-revisions/2026-10-23/kifc-02-visual-review.md). Status Ditinjau; penilaian pemilik, penutur Korea dan uji TV fisik masih terbuka. [Koreksi placeholder/maskot serta bukti gambar web](../../docs/client-revisions/2026-10-23/kifc-02-empty-slots-review.md). Server web dimulai ulang sepenuhnya; ketiga aset baru sudah diuji melalui manifest, HTTP 200, hash file dan screenshot browser; belum ada deployment atau APK baru.

## KIFC-03 Penjelasan segitiga api

**Sumber:** bagian 03, screenshot 03. **Pemetaan saat ini:** `triangleExplanation`.

- [x] **KIFC-03.01** Ganti judul dan subjudul dengan naskah berikut.
- [x] **KIFC-03.02** Pilih **satu** narasi maskot melalui D-02; jangan menampilkan versi panjang dan singkat sekaligus.
- [x] **KIFC-03.03** Kurangi ruang kosong di tengah layar.
- [x] **KIFC-03.04** Perbesar maskot serta area narasi secara proporsional, dengan keterbacaan dan jangkauan kontrol tetap terjaga.
- [x] **KIFC-03.05** Perjelas label tiga kartu di bagian bawah tanpa membuat layout terlalu padat; selaraskan gambar dengan perubahan KIFC-02.

**Judul:**

> Api Dapat Muncul Saat Tiga Unsur Bertemu

**Subjudul:**

> Kebakaran dapat terjadi di mana saja jika panas yang cukup, bahan bakar, dan oksigen bertemu.

**Narasi maskot utama:**

> Kebakaran dapat terjadi ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Aktivitas manusia dapat mempertemukan ketiga unsur tersebut. Karena itu, pencegahan penting dilakukan agar kebakaran tidak terjadi.

**Alternatif jika ruang terbatas:**

> Api dapat muncul ketika panas yang cukup, bahan bakar, dan oksigen bertemu. Aktivitas manusia dapat menjadi pemicunya.

**Kriteria penerimaan:** satu narasi terpilih tampil utuh, label kartu jelas, maskot proporsional, dan ruang tengah digunakan lebih baik. Jika KIFC-04 dihapus, tombol menuju simulasi pada layar ini harus diubah melalui X-01.

**Implementasi 23 Oktober:** judul/subjudul KIFC dan satu narasi utama tampil utuh dalam tiga bahasa. Panel 190 logical px dipindahkan ke atas narasi; susunan foto mengikuti posisi terakhir pemain, tanpa menukar kategori saat perpindahan. Karena judul baru lebih panjang, posisi vertikal dapat bergeser mengikuti teks, tetapi urutan konten dan ukuran panel tetap konsisten. Narasi tepat di bawah panel, maskot presenting setengah badan berada di dasar layar, tombol lanjut dinaikkan ke area sentuh. Label kartu tetap kontras. Setelah assembly lengkap, sentuhan pada konten/latar melanjutkan; Kembali/Ulangi tetap bekerja sebagai kontrolnya sendiri. Drop terakhir tidak melewati feedback. Timer otomatis 14 detik tetap menjadi fallback dan dibatalkan saat navigasi. Narasi KIFC-03 tetap maju manual. KIFC-04 belum diubah. **151 tes lulus**, analisis bersih; [indeks screenshot dan verifikasi](../../docs/client-revisions/2026-10-23/kifc-03-continuity-review.md). Status Ditinjau, belum diuji pada TV fisik.

## KIFC-04 Simulasi mengurangi unsur api

**Sumber:** bagian04, screenshot04. **Pemetaan:** `breakTriangle`, demo tanpa skor. **Status:** Ditinjau setelah audit khusus25Oktober; belum disahkan klien/diuji pada TV fisik.

**Masalah KIFC:** tujuan pembelajaran dan hubungan pilihan unsur dengan perubahan api belum jelas. Audit25Oktober juga menemukan pengulangan unsur yang diabaikan serta waktu baca terakhir hanya2,6detik. Sebelumnya checklist tidak diselaraskan dengan checkpoint mockup; catatan mockup saja belum menutup kekurangan tersebut.

- [x] **KIFC-04.01** [Konsep perbaikan](kifc-04-reduction-review-2026-10-25.md) mencatat tujuan belajar, tindakan, respons dan narasi setiap unsur.
- [x] **KIFC-04.02** Alternatif penghapusan beserta dampak pada CTA, navigasi dan materi dicatat dalam konsep; tidak diterapkan.
- [x] **KIFC-04.03** D-03 mengikuti keputusan langsung pemilik24Oktober: pertahankan demo, perbaiki berdasarkan mockup, dan jaga urutan layar. Ini keputusan pemilik untuk implementasi, bukan klaim pembahasan/pengesahan final KIFC.
- [x] **KIFC-04.04** Setiap unsur memadamkan dua api di atasnya: Panas kiri, Bahan bakar tengah, Oksigen kanan. Area padam tetap padam, sehingga6→4→2→0; urutan pilihan bebas. Penjelasan unsur serta batas penerapan oksigen di lahan terbuka tetap tersedia.
- **KIFC-04.05 — Tidak berlaku:** cabang menghapus layar tidak dipilih, sehingga rute penghapusan tidak perlu diterapkan.
- [x] **KIFC-04.06** Sentuhan ulang mempertahankan area padam tanpa penyalaan kembali atau penambahan progres. Ulangi memulihkan enam api/0/3 serta membatalkan callback lama. Demo tidak memberi poin atau label benar/salah.
- [x] **KIFC-04.07** Setelah3/3, Lanjut dan sentuhan latar tersedia; fallback otomatis15detik mengikuti klarifikasi25Oktober. Memilih unsur lagi memberi15detik untuk penjelasan terakhir; urutan tetap menuju kartu definisi.
- [x] **KIFC-04.08** Reduced motion dan penghentian rekaman yang telah padam diperiksa;120 render lima ukuran/tiga bahasa dan rekaman browser tersedia.

**Bukti terbaru:** [review pemadaman kumulatif, screenshot dan rekaman](../../docs/client-revisions/2026-10-25/kifc-04-spatial-reduction-review.md). Panel tetap248/216logicalpx dan pilihan tidak diperkecil. Pembagian tiga area merupakan ilustrasi interaksi, bukan pembagian unsur tunggal pada kebakaran nyata. [Audit sebelumnya](../../docs/client-revisions/2026-10-25/kifc-04-reduction-review.md) disimpan sebagai riwayat; pola seluruh-api/replay diganti arahan kumulatif terbaru.

**Masih terbuka:** pengesahan akhir KIFC/penutur serta uji waktu baca, jangkauan dan performa TV42inci fisik. Klarifikasi25Oktober menetapkan15detik dengan opsi lanjut lebih cepat melalui sentuhan; pemeriksaan viewport tidak menggantikan uji fisik. Koreksi25Oktober belum dimasukkan ke APK/deployment publik sebelumnya.

## KIFC-05 Pengertian kebakaran hutan

**Sumber:** bagian 05, screenshot 05. **Pemetaan saat ini:** kartu Babak 2 pertama, `karhutla-definition`.

- [x] **KIFC-05.01** Ganti judul dengan naskah di bawah.
- [x] **KIFC-05.02** Ganti narasi maskot dengan definisi KIFC di bawah.
- [x] **KIFC-05.03** Pertahankan penyajian singkat dan mudah dibaca; pastikan subjudul/pengantar lama tidak membuat definisi baru tidak konsisten.

**Implementasi dan bukti, 23 Oktober:** Judul baru dan definisi karhutla KIFC diterapkan pada kartu pertama Babak 2. Tersedia terjemahan Inggris dan Korea yang selaras. 15 screenshot (3 bahasa x 5 ukuran) tersimpan di uild/review-chapter2-score/. [Indeks bukti](../../docs/client-revisions/2026-10-23/kifc-05-06-07-11-visual-review.md). Status Ditinjau.

**Judul:**

> Tapi, Apa Itu Kebakaran Hutan?

**Narasi maskot:**

> Kebakaran hutan adalah peristiwa terbakarnya vegetasi dan bahan organik di kawasan hutan, dengan api yang menyebar secara bebas dan tidak terkendali.

**Kriteria penerimaan:** judul dan definisi baru tampil utuh pada kartu pertama; tetap berupa bacaan bersama maskot, tanpa menambahkan kuis pada definisi ini.

## KIFC-06 Penyebab kebakaran hutan

**Sumber:** bagian 06, screenshot 06. **Pemetaan saat ini:** kartu Babak 2 kedua, yang sekarang ber-ID `karhutla-impact` dan berjudul “Mengapa perlu dicegah?”. Ini **bukan** kuis penyebab Babak 3.

- [x] **KIFC-06.01** Ubah fungsi kartu kedua dari pembahasan dampak menjadi pembahasan **penyebab**.
- [x] **KIFC-06.02** Ganti seluruh judul, subjudul, serta narasi dengan naskah berikut.
- [x] **KIFC-06.03** Sesuaikan ID/kunci konten, terjemahan, rujukan, dan tes agar nama lama `impact` tidak mengakibatkan salah pemetaan.

**Judul:**

> Mengapa Kebakaran Hutan Bisa Terjadi?

**Subjudul:**

> Kebakaran hutan dapat terjadi ketika tiga unsur api bertemu.

**Narasi maskot:**

> Kebakaran hutan dapat terjadi ketika panas yang cukup, bahan bakar, dan oksigen bertemu dalam kondisi yang memungkinkan api menyala. Aktivitas manusia dapat mempertemukan ketiga unsur tersebut sehingga meningkatkan risiko kebakaran.

**Kriteria penerimaan:** judul, subjudul, dan narasi membahas penyebab secara konsisten; urutan kartu definisi → penyebab tetap terbaca sebagai satu penjelasan.

## KIFC-07 Pentingnya pencegahan kebakaran hutan

**Sumber:** bagian 07, screenshot 07. **Pemetaan saat ini:** kartu Babak 2 ketiga, `karhutla-prevention`, yang sekarang berjudul “Cegah sebelum membesar.”

- [x] **KIFC-07.01** Ganti judul dan narasi dengan naskah berikut.
- [x] **KIFC-07.02** Tampilkan keempat aspek dampak secara jelas: **ekologis, ekonomi, sosial budaya, dan politik**.
- [x] **KIFC-07.03** Pertahankan kalimat utuh yang menghubungkan kerusakan akibat kebakaran dengan terganggunya fungsi hutan.
- [x] **KIFC-07.04** Sesuaikan pengantar serta label tombol menuju kuis berikutnya. Label lama “Lihat Risikonya” perlu ditinjau karena KIFC-08 membahas jenis hutan gambut, bukan kuis risiko lama.

**Implementasi dan bukti, 23 Oktober:** Judul dan narasi pentingnya pencegahan diterapkan dengan menampilkan keempat aspek kerugian secara utuh beserta terjemahan Inggris dan Korea. 15 screenshot tersimpan. [Indeks bukti](../../docs/client-revisions/2026-10-23/kifc-05-06-07-11-visual-review.md). Status Ditinjau.

**Judul:**

> Mengapa Kebakaran Hutan Perlu Kita Cegah?

**Narasi maskot:**

> Kebakaran hutan merusak lingkungan dan menimbulkan kerugian ekologis, ekonomi, sosial budaya, serta politik. Kerusakan tersebut mengganggu kemampuan hutan untuk menjalankan fungsinya dengan baik.

**Kriteria penerimaan:** keempat aspek tidak hilang atau digabung menjadi sekadar “lingkungan dan masyarakat”; hubungan dampak dengan fungsi hutan tetap tersampaikan. Label transisi sesuai materi berikutnya.

## KIFC-08 Kuis kebakaran pada hutan rawa gambut

**Sumber:** bagian 08, screenshot 08. **Pemetaan saat ini:** `_RiskPage`, kuis “Di mana api lebih mudah muncul?” dengan tiga pilihan kondisi. Kuis lama diganti, bukan ditambah sebagai kuis keempat yang tidak diminta.

- [x] **KIFC-08.01** Ganti pertanyaan dan subjudul dengan naskah berikut.
- [x] **KIFC-08.02** Ganti tiga pilihan kondisi menjadi tiga jenis hutan di bawah; gunakan **pilihan tunggal**.
- [x] **KIFC-08.03** Tetapkan hanya **B. Hutan rawa gambut** sebagai jawaban benar; sesuaikan foto agar tidak menyesatkan label jenis hutan.
- [x] **KIFC-08.04** Ganti feedback benar dan feedback salah dengan naskah KIFC.
- [x] **KIFC-08.05** Selaraskan model jawaban, hint, pengungkapan jawaban, dan tes yang masih mengacu pada `dryVegetationWithIgnition`.
- [x] **KIFC-08.06** Pastikan penjelasan panjang tentang bara bawah permukaan selesai dibaca sebelum berpindah. Tetapkan perilaku salah kedua dan durasi feedback melalui D-05, bukan memakai 2 detik tanpa pemeriksaan.

**Pertanyaan:**

> Pada jenis hutan manakah kebakaran dapat membara di bawah permukaan tanah sehingga sulit dipadamkan?

**Subjudul:**

> Pilih jenis hutan yang memiliki lapisan gambut.

| Pilihan | Isi | Kunci |
|---|---|---|
| A | Hutan mangrove | Salah |
| B | Hutan rawa gambut | Benar |
| C | Hutan pada tanah mineral | Salah |

**Feedback benar:**

> Tepat! Kebakaran di hutan rawa gambut yang mengering sulit dipadamkan karena api dapat membara di bawah permukaan tanah. Bara sulit terdeteksi dan dapat memicu api kembali meskipun api di permukaan sudah padam.

**Feedback salah/petunjuk mencoba kembali:**

> Belum tepat. Coba ingat jenis hutan yang memiliki lapisan tanah organik tebal. Api dapat membara di dalam lapisan tersebut sehingga sulit dipadamkan.

**Kriteria penerimaan:** hanya B dinilai benar; A/C memberi petunjuk yang tepat; penjelasan membedakan gambut yang mengering, bara bawah permukaan, kesulitan deteksi/pemadaman, dan kemungkinan menyala kembali. Sumber belum memberikan teks khusus setelah kesempatan kedua gagal.

**Implementasi dan bukti, 23 Oktober:** kuis kondisi lama diganti tiga jenis hutan; hanya B benar. Pertanyaan, subjudul, feedback benar, dan hint Indonesia mengikuti naskah sumber. Inggris dan Korea tersedia, termasuk font Hangul offline. Foto mangrove dan hutan daratan diperbarui; foto merupakan ilustrasi habitat, bukan bukti identifikasi tanah. Salah pertama menunggu satu kesempatan lagi; salah kedua membuka B dan mengunci pilihan. Jawaban benar juga mengunci pilihan. Sesuai koreksi pemilik, judul dan subjudul tetap utuh setelah menjawab; area feedback benar disusun di samping maskot tanpa mengecilkan kartu jawaban. Setelah jawaban benar, sentuhan berikutnya di mana pun pada layar game langsung menuju Babak 3, dengan timer 18 detik tetap sebagai cadangan. Maskot salah di kiri bawah dan benar di kanan bawah. Sesuai koreksi pemilik terbaru, feedback benar berada di kiri maskot, dengan balon dinaikkan menjauh dari tepi bawah; ukuran kartu jawaban tetap 72 logical pixel di semua keadaan.

**D-05, penerapan sementara untuk ditinjau:** feedback benar 18 detik, salah kedua 12 detik, lalu otomatis ke Babak 3; hint pertama tidak dibatasi timer. Naskah salah kedua disusun vendor dan belum merupakan persetujuan KIFC. Durasi diperpanjang dari 4,5 detik untuk memberi ruang membaca naskah baru; kenyamanan baca pengguna nyata masih perlu dinilai. Seluruh 119 tes lulus dan analisis Flutter bersih. Tersedia 60 render Flutter (empat keadaan × tiga bahasa × lima ukuran), termasuk Full HD dan 4K. [Indeks screenshot, pemeriksaan, dan batas bukti](../../docs/client-revisions/2026-10-23/kifc-08-visual-review.md). Status Ditinjau; belum ada deployment/APK baru atau uji TV fisik untuk tiket ini.

## KIFC-09 Karakteristik kebakaran ekosistem gambut

**Sumber:** bagian 09, screenshot 09. **Pemetaan saat ini:** `_PeatCharacteristics`, menggantikan `_StopDecision` pada posisi yang sama di Babak4.

**Keputusan pemilik24Oktober:** tiga kartu bernomor1–3 dibalik saat disentuh untuk membuka informasi. Bagian ini bukan soal dan tidak masuk skor. Ketiga fakta klien dipertahankan; format kini diterapkan, dengan lanjut manual setelah ketiganya dibuka.

- [x] **KIFC-09.01** Siapkan penggantian materi “Batasi rambatan api” menjadi karakteristik kebakaran pada ekosistem gambut.
- [x] **KIFC-09.02** Gunakan judul dan tiga informasi berikut sebagai dasar pembahasan.
- [x] **KIFC-09.03** Ajukan format **tiga kartu informasi yang dapat disentuh** atau **kuis pilihan jamak**; bahas dan catat keputusan D-04 serta tindak lanjut materi KIFC.
- [x] **KIFC-09.04** Terapkan format yang disepakati. Ketiga pernyataan benar; jangan membuat pilihan tunggal dengan hanya satu jawaban dianggap benar.
- [x] **KIFC-09.05** Tentukan syarat melanjutkan, feedback, serta apakah layar informatif atau bernilai skor. Selaraskan hasil keseluruhan melalui X-01.
- [x] **KIFC-09.06** Ganti pilihan, foto/simulasi, dan feedback lama tentang “Pisahkan bahan bakar”, “Dekati api”, serta “Tambahkan bahan bakar” pada layar ini sesuai konsep baru.

**Judul:**

> Apa Saja Karakteristik Kebakaran di Ekosistem Gambut?

**Informasi wajib:**

1. Api dapat membara di bawah permukaan tanah.
2. Kebakaran sulit dipadamkan.
3. Api dapat menyala kembali.

**Usulan awal vendor untuk dibahas, bukan instruksi KIFC:** tiga kartu yang membuka penjelasan/animasi tentang bara bawah permukaan, kesulitan pemadaman, dan kemunculan api kembali. Format ini dapat membantu membedakan ketiga ciri tanpa menjadikannya tiga jawaban yang saling meniadakan. Naskah detail dan aset masih perlu disepakati.

**Kriteria penerimaan:** konten serta format disetujui, ketiga karakteristik tersampaikan sebagai fakta yang sama-sama benar, dan skor tidak lagi memakai asumsi bahwa pemain memilih satu “tindakan aman” pada materi yang telah diganti.

## KIFC-10 Tantangan mengenali dampak kebakaran

**Sumber:** bagian 10, screenshot 10. **Pemetaan saat ini:** `_FinalChallenge`, `_ImpactToken`, `_FinalReviewDialogue`, timer dan ulasan tantangan akhir.

- [x] **KIFC-10.01** Ganti fokus tantangan dari **risiko kebakaran** menjadi **dampak kebakaran hutan, khususnya ekosistem gambut**.
- [x] **KIFC-10.02** Ganti pertanyaan dan instruksi dengan naskah berikut.
- [x] **KIFC-10.03** Ganti keenam pilihan beserta foto/visual dan labelnya; jangan hanya mengganti judul di atas grid lama.
- [x] **KIFC-10.04** Terapkan empat kunci benar dan dua pengecoh sesuai tabel di bawah.
- [x] **KIFC-10.05** Durasi diperpanjang menjadi30detik dan ditetapkan pemilik pada25Oktober: “KIFC-10 iyaa sepertinya sudah cukup30detik”. D-06 tertutup untuk pemilihan durasi; uji kenyamanan TV fisik tetap dicatat terpisah pada X03.
- [x] **KIFC-10.06** Sesuaikan angka, lingkaran timer, awal/akhir countdown, batas warna, dan penguncian input terhadap durasi baru. Batas hijau/kuning/merah lama perlu ditinjau, bukan diam-diam dianggap sesuai.
- [x] **KIFC-10.07** Ubah ulasan maskot, jumlah benar/salah/terlewat, penanda gambar, skor babak, bonus, dan seluruh pesan yang masih menyebut risiko lama.
- [x] **KIFC-10.08** Pertahankan kemampuan membatalkan pilihan dan penilaian setelah waktu habis sebagai acuan keputusan terdahulu, kecuali D-07 menyetujui perubahan. Jangan membocorkan jawaban ketika pemain sedang memilih.

**Pertanyaan:**

> Apa Saja Dampak Kebakaran Hutan pada Ekosistem Gambut?

**Instruksi:**

> Pilih semua dampak yang sesuai.

| Pilihan | Status jawaban dari dokumen |
|---|---|
| Kabut asap. | Benar, disorot hijau |
| Kerusakan ekosistem. | Benar, disorot hijau |
| Emisi karbon tinggi. | Benar, disorot hijau |
| Penurunan tinggi permukaan tanah atau subsidens. | Benar, disorot hijau |
| Peningkatan kualitas udara. | Salah/pengecoh, disorot merah |
| Peningkatan cadangan karbon dalam tanah gambut. | Salah/pengecoh, disorot merah |

**Penting:** warna hijau/merah di DOCX adalah **kunci bagi vendor**. Dokumen tidak memerintahkan menampilkan kunci tersebut sebelum pemain selesai memilih. Penandaan ini sudah diperiksa pada format highlight asli Word, bukan disimpulkan dari urutan opsi saja.

**Kriteria penerimaan:** keenam pilihan baru tampil dan dinilai benar, waktu lebih panjang dari versi lama serta mempunyai dasar uji, ring mengikuti total durasi baru, dan ulasan menjelaskan dampak yang dipilih/terlewat dengan tepat. Naskah feedback per dampak belum diberikan dalam sumber dan perlu disiapkan serta ditinjau.

## KIFC-11 Layar hasil akhir

**Sumber:** bagian 11, screenshot 11. **Pemetaan saat ini:** `_ScorePage`, bukan otomatis `_ClosingPage` setelah tombol Selesai.

- [x] **KIFC-11.01** Tambahkan pesan penutup berikut pada layar hasil yang menampilkan skor.
- [x] **KIFC-11.02** Letakkan pada area yang mudah terlihat dan dibaca tanpa mengganggu skor, “Selesai”, serta “Main Lagi”.
- [x] **KIFC-11.03** Setelah X-01 diputuskan, sesuaikan label baris skor, maksimum nilai, bonus, dan kategori hasil yang terdampak pergantian materi.
- [x] **KIFC-11.04** Sesuai klarifikasi25Oktober, hasil dan penutup maju otomatis setelah15detik atau bisa dilanjutkan lebih cepat melalui sentuhan. Masing-masing mendapat timer baru; dialog terbuka menjeda sisa waktu. Kenyamanan TV fisik tetap melalui X03.

**Pesan dari KIFC:**

> Mencegah Kebakaran Lebih Baik daripada Memadamkan.

**Kriteria penerimaan:** kalimat muncul pada layar hasil akhir yang dimaksud screenshot, terbaca utuh, serta skor dan kedua tombol tetap jelas dan dapat digunakan. Perubahan timer idle merupakan dampak yang perlu dikaji, bukan angka baru yang ditentukan dokumen.

## Catatan lintas game

### KIFC-G01 Variasi interaksi dan respons

**Sumber:** catatan tambahan paragraf 1.

- [x] **KIFC-G01.01** Petakan variasi interaksi sesuai tujuan tiap layar agar permainan tidak monoton; pertahankan layar definisi/penjelasan sebagai bacaan kecuali ada keputusan baru.
- [x] **KIFC-G01.02** Tambahkan/perhalus transisi antarhalaman yang membantu pemain memahami perpindahan.
- [x] **KIFC-G01.03** Berikan respons visual pada sentuhan tombol, pemilihan jawaban, drag-and-drop, dan penyelesaian tantangan.
- [x] **KIFC-G01.04** Jaga respons tetap cepat dan cegah input atau transisi ganda. Bedakan penanda “dipilih” dari penanda “benar” pada tantangan yang menunda penilaian.

**Kriteria penerimaan:** ada respons yang dapat diamati untuk tiap tindakan utama tanpa memperlambat alur atau membocorkan kunci.

### KIFC-G02 Animasi dan latar bergerak

**Sumber:** catatan tambahan paragraf 2.

- [x] **KIFC-G02.01** Usulkan bagian yang memperoleh manfaat dari gerakan; bedakan animasi pembelajaran dari dekorasi.
- [x] **KIFC-G02.02** Kajilah animasi 3D **atau** video sebagai kandidat latar pada bagian yang sesuai; dokumen meminta pertimbangan, bukan mewajibkan keduanya atau seluruh layar memakai video.
- [ ] **KIFC-G02.03** Catat aset, ukuran file, ketersediaan offline, dukungan perangkat, dan hasil ukur performa sebelum memilih pendekatan.
- [x] **KIFC-G02.04** Pastikan gerakan halus dan tidak mengganggu keterbacaan teks; sediakan tampilan statis yang layak bila gerakan dikurangi atau pemutaran gagal.
- [x] **KIFC-G02.05** Bahas D-08 sebelum menghidupkan kembali efek dekoratif terus-menerus. Fog sebelumnya diminta dihapus karena tidak terlihat dan performa emulator pernah dikeluhkan.

**Kriteria penerimaan:** arah gerakan disepakati, media berjalan pada perangkat sasaran, teks tetap jelas, dan tidak muncul penurunan respons sentuhan yang mengganggu.

### KIFC-G03 Pengayaan visual seluruh layar

**Sumber:** catatan tambahan paragraf 3.

- [x] **KIFC-G03.01** Tinjau setiap layar yang masih terasa polos dan catat kebutuhan visualnya.
- [x] **KIFC-G03.02** Tambahkan elemen relevan seperti suasana hutan, detail lingkungan, atau animasi pendukung sesuai materi layar; gunakan visual gambut pada bagian yang mengajarkannya.
- [x] **KIFC-G03.03** Pertahankan komposisi rapi, mudah dipahami, dan tidak terlalu ramai. Motif latar yang sudah disetujui tidak otomatis harus ditambah kepadatannya.
- [x] **KIFC-G03.04** Periksa kesesuaian foto, label, crop, proporsi maskot, dan keterbacaan pilihan panjang.

**Kriteria penerimaan:** tiap tambahan memiliki hubungan dengan materi atau suasana; konten utama dan area sentuh tetap jelas.

### KIFC-G04 Musik dan suara

**Sumber:** catatan tambahan paragraf 4.

- [x] **KIFC-G04.01** Bahas cakupan audio baru melalui D-08; sebelumnya tahap teks tanpa suara telah disepakati karena pengembangan dan biaya.
- [x] **KIFC-G04.02** Siapkan musik latar yang sesuai suasana hutan dan tema permainan.
- [x] **KIFC-G04.03** Tambahkan suara alam.
- [x] **KIFC-G04.04** Tambahkan efek saat tombol disentuh, jawaban dipilih, serta tantangan diselesaikan.
- [x] **KIFC-G04.05** Atur level musik, ambience, dan efek agar nyaman serta tidak mengganggu narasi maupun kegiatan ruang pameran.
- [x] **KIFC-G04.06** Sediakan pengaturan volume dan tombol untuk menonaktifkan suara, dengan status yang mudah dipahami.
- [x] **KIFC-G04.07** Pastikan aset berlisensi sesuai penggunaan, dibundel offline, dan terdokumentasi di `ASSET_SOURCES.md`; periksa perilaku Android/web, autoplay setelah interaksi, ulang sesi, dan keluar aplikasi.

**Kriteria penerimaan:** musik, suara alam, dan efek yang disepakati berfungsi; volume/mute benar-benar mengontrol output; audio tidak bertumpuk saat sesi diulang. **Sumber tidak secara eksplisit meminta rekaman suara maskot atau text-to-speech**; jangan menganggap keduanya termasuk otomatis.

## Integrasi yang diperlukan agar revisi lengkap

Bagian ini adalah pekerjaan turunan dari perubahan konten, bukan kutipan permintaan tambahan klien.

### KIFC-X01 Alur dan skor

- [x] **KIFC-X01.01** Tetapkan alur setelah keputusan simulasi KIFC-04 dan format KIFC-09 tersedia. Urutan bagian DOCX adalah urutan identifikasi layar, bukan bukti bahwa layar lain harus dihapus.
- [x] **KIFC-X01.02** Konfirmasikan nasib kuis penyebab manusia/alam di **Babak 3**, yang tidak mempunyai bagian revisi dalam DOCX ini. Jangan menghapus, mengganti, atau melewatinya hanya karena tidak tercantum.
- [x] **KIFC-X01.03** Selaraskan nomor babak, indikator progres, pengantar, label tombol, navigasi kembali, ulang sesi, dan akhir permainan.
- [x] **KIFC-X01.04** Putuskan aturan skor setelah layar “Memilih tindakan aman” diganti informasi/kuis gambut. Keputusan24Oktober: hapus poin tindakan, sehingga maksimum8 = susun unsur3 + penyebab4 + bonus akhir1; kartu informasi tidak memiliki baris skor.
- [x] **KIFC-X01.05** Tinjau bonus serta penalti tantangan dampak. Ada empat jawaban benar, tetapi aturan benar +1/salah −1, minimum 0, dan bonus skor/4 merupakan keputusan lama, bukan aturan baru yang tertulis dalam DOCX.
- [x] **KIFC-X01.06** Sesuaikan ambang kategori hasil, label baris skor, penyimpanan state, serta tes perhitungan setelah D-07 diputuskan.
- [x] **KIFC-X01.07** Perbarui aturan proyek/spesifikasi lama yang benar-benar digantikan keputusan baru; tandai bagian superseded tanpa menghapus riwayat.
- [x] **KIFC-X01.08** Sesuai klarifikasi25Oktober, feedback/hasil menunggu maksimal15detik dan bisa dilanjutkan lebih cepat dengan sentuhan terpisah. Konten/latar bisa melanjutkan setelah aktivitas lengkap; retry, kontrol khusus, modal dan tantangan aktif tidak dilewati. Timer lama dibatalkan saat lanjut/reset; alur/skor tetap.

**Kriteria penerimaan:** alur dan skor mempunyai keputusan tertulis; tidak ada materi yang hilang tanpa persetujuan atau skor dari aktivitas yang sudah tidak ada.

### KIFC-X02 Bahasa dan naskah

- [x] **KIFC-X02.01** Jadikan naskah Indonesia KIFC dalam tracker ini sebagai acuan konten baru; catat perubahan editorial yang memengaruhi isi untuk ditinjau.
- [x] **KIFC-X02.02** Terjemahkan judul, subjudul, narasi, pilihan, feedback, pesan hasil, dan kontrol audio baru ke Inggris serta Korea. Sumber kali ini hanya memberi naskah Indonesia.
- [x] **KIFC-X02.03** Selaraskan istilah kebakaran hutan, gambut, bara bawah permukaan, emisi karbon, dan subsidens. Bedakan “Air” sebagai water dari “udara” sebagai air dalam versi Inggris.
- [x] **KIFC-X02.04** Cek kamus dan teks dinamis: perubahan literal Indonesia tidak boleh membuat terjemahan Korea jatuh kembali ke bahasa Indonesia.
- [x] **KIFC-X02.05** Periksa judul langsung berubah saat bahasa dipilih, pemenggalan teks, Hangul offline, serta pilihan/narasi terpanjang di ketiga bahasa.
- [x] **KIFC-X02.06** Catat status review/persetujuan per bahasa dan hubungkan naskah baru dengan inventaris REV-08 lama; diterimanya dokumen ini tidak berarti seluruh materi akhir sudah disetujui, terutama bagian 09 serta opsi alternatif.

**Kriteria penerimaan:** ketiga bahasa selaras dengan materi baru, tanpa teks lama yang tersisa atau karakter hilang, dan status naskah jelas.

### KIFC-X03 Verifikasi dan rilis

- [x] **KIFC-X03.01** Buat matriks cakupan untuk 11 layar, layar yang tetap ada seperti Babak 3, serta audio/animasi lintas layar.
- [x] **KIFC-X03.02** Uji alur lengkap ketiga bahasa: susun benar/salah, retry, tiga kartu bacaan, kuis gambut, format karakteristik terpilih, tantangan dampak, ulasan, hasil, dan ulang sesi.
- [x] **KIFC-X03.03** Uji timer/feedback panjang, tidak adanya input ganda, pembatalan pilihan, perpindahan otomatis/manual yang disepakati, tombol kembali, serta reset tanpa skor/audio/animasi tersisa.
- [ ] **KIFC-X03.04** Periksa crop, ukuran teks, maskot, visual baru, animasi, dan tombol pada viewport portrait; lakukan uji sentuhan langsung pada TV 42 inci setelah perangkat dan pemasangan diketahui.
- [ ] **KIFC-X03.05** Bagian fungsional APK/web telah diuji:53 aset, tiga bahasa native, volume/mute/zero/background/replay. Pengukuran performa perangkat target tetap terbuka; FPS emulator tidak dinyatakan lulus. [Bukti terbaru](../../docs/client-revisions/2026-10-23/kifc-x03-latest-apk-review.md).
- [x] **KIFC-X03.06** Jalankan analisis Flutter dan tes regresi yang relevan; simpan hasil dan screenshot/rekaman setiap layar yang berubah.
- [x] **KIFC-X03.07** APK pengujian dan GitHub Pages diterbitkan; workflow239tes sukses, commit57f0467 dan site pertama benar,53 aset manifest serta9 hash audio terverifikasi. APK prarilis/debug dengan checksum server cocok; paket produksi dengan kunci pemilik tetap terpisah.

**Kriteria penerimaan:** ada bukti per tiket serta satu sesi terpadu tanpa penghalang; batas uji fisik, materi yang masih sementara, dan isu terbuka dilaporkan jelas.

## Keputusan yang masih diperlukan

| ID | Hal yang belum diputuskan | Dasar dan tindakan berikutnya |
|---|---|---|
| D-01 | Tiga slot berlabel atau drop langsung ke gambar utama? | Pemilik menyetujui arah pengerjaan tiga slot sebelum KIFC-02 dimulai. Tiga slot dipertahankan; koreksi pemilik terbaru menghapus label kategori pada placeholder dan membuat semua posisi menerima unsur benar yang belum dipakai. Drop langsung ke gambar utama tetap tidak diaktifkan. |
| D-02 | Narasi panjang atau singkat untuk penjelasan segitiga api? | Vendor menerapkan narasi utama secara utuh, satu versi pada semua ukuran. Dapat ditinjau pemilik/KIFC; alternatif singkat tidak ditampilkan. |
| D-03 | Simulasi pengurangan unsur diperbaiki atau dihapus? | Pemilik pada24Oktober meminta memperbaiki layar ini berdasarkan mockup, mempertahankan urutan, dan animasi hingga padam. Cabang dipertahankan diterapkan; penghapusan tidak dilakukan. |
| D-04 | Format karakteristik gambut | Diputuskan langsung pemilik24Oktober: tiga kartu1–3 berputar saat disentuh, membuka informasi, bukan soal/tanpa skor. Lanjut manual setelah semua dibuka; implementasi siap ditinjau. |
| D-05 | Perilaku setelah salah kedua pada kuis gambut serta waktu baca feedback? | Klarifikasi25Oktober menetapkan feedback benar/salah kedua15detik dengan opsi sentuh untuk lanjut lebih cepat. Hint pertama tetap menunggu satu retry. Naskah salah kedua dibuat vendor karena sumber belum memberikannya; naskah tambahan masih menunggu penilaian KIFC, sedangkan durasi/perilaku kelanjutan sudah diputuskan. |
| D-06 | Berapa durasi baru tantangan dampak dan kapan countdown mulai? | Pemilik menetapkan30detik pada25Oktober. Countdown tetap dimulai setelah foto/transisi siap. Hijau >15, kuning15–10, merah≤9. Stopwatch, ring dan batas pemilihan telah diuji. D-06 selesai sebagai keputusan durasi; tidak mengklaim uji TV fisik. |
| D-07 | Aturan skor, penalti, bonus, dan maksimum setelah materi diganti? | Dipetakan24Oktober sesuai09 tanpa skor: maksimum8. Aturan dampak lama tetap+1 benar/−1 salah, minimum0, bonus hasil/4 (maksimum1); pilihan netral sebelum ulasan dipertahankan. Kategori mengikuti proporsi lama8/9 dan6/9, diuji pada batas7/7.25/5.25/5.5; siap ditinjau pemilik. |
| D-08 | Cakupan audio, animasi, 3D/video, aset, dan dampak biaya/performa? | Pemilik24Oktober meminta melanjutkan audio dan memakai aset internet yang diunduh. Musik+suara alam+efek diterapkan dengan aset CC0, volume/mute dan offline. Tidak ada aset berbayar, generasi suara mentah atau voice-over; fog tetap dihapus. Penilaian speaker/akustik ruang tetap melalui D-09. |
| D-09 | Resolusi, sistem/perangkat, tinggi pemasangan, speaker, dan posisi pengguna TV 42 inci? | Diagonal dan orientasi sudah disebut. Data lain diperlukan untuk uji jangkauan, audio, dan performa fisik. |
| D-10 | Visual sumber panas, oksigen, serta pengganti udara dingin yang dipakai? | KIFC-02 memakai foto percikan gerinda (gesekan), konteks kanopi/udara dengan cue O₂, dan batu. Aset dibundel offline, sumber/lisensi dicatat, grading runtime ringan diterapkan. Pilihan aset vendor siap dinilai pemilik/KIFC. |
| D-11 | Apakah kuis penyebab manusia/alam Babak 3 tetap ada? | Pemilik meminta urutan layar tetap seperti sebelumnya pada24Oktober; Babak3 dipertahankan. |

## Urutan pengerjaan yang disarankan

1. Catat keputusan D-01 sampai D-04 dan D-11 untuk mengunci struktur. Mulai inventaris aset dan kajian audio/gerak secara bersamaan bila diperlukan, tanpa menunda perubahan teks yang sudah jelas.
2. Kerjakan naskah dan pemetaan KIFC-05, KIFC-06, KIFC-07, pesan KIFC-11, serta terjemahannya. Pastikan kartu kedua dan ketiga tidak tertukar.
3. Kerjakan KIFC-02 dan KIFC-03, lalu cabang KIFC-04 yang disepakati. Periksa aset dan mekanisme sebelum memperhalus dekorasi.
4. Ganti kuis pada KIFC-08, terapkan hasil pembahasan KIFC-09, lalu kerjakan KIFC-10 dengan durasi hasil uji. Finalkan skor dan alur X-01.
5. Rapikan KIFC-01 serta visual/respons lintas layar. Integrasikan audio/gerak sesuai cakupan yang disepakati dan hasil ukur perangkat.
6. Jalankan X-03, tutup tiket berdasarkan bukti, lalu rilis. Ulangi pemeriksaan yang terdampak jika materi KIFC lanjutan masuk.

Urutan ini adalah saran implementasi, bukan tenggat atau persetujuan terhadap alternatif.

## Log keputusan dan bukti pekerjaan

| Tanggal | ID | Keputusan atau hasil | Bukti | Status |
|---|---|---|---|---|
| 2026-10-23 | Analisis sumber | Sebelas bagian layar, sebelas screenshot, empat catatan global, serta kunci highlight hijau/merah diperiksa; sumber diarsipkan identik. | DOCX tertaut di awal tracker; SHA-256 cocok | Pencatatan selesai; implementasi belum dimulai |
| 2026-10-23 | KIFC-01 | Halaman pembuka diperbarui; label bahasa dan bobot Hangul diperbaiki. Analisis bersih dan 43 tes lulus. Screenshot tiap revisi menjadi kebutuhan tetap. | `build/review-kifc-01/`; indeks bukti tertaut pada tiket | Ditinjau; uji fisik TV dan penilaian pemilik belum selesai |
| 2026-10-23 | KIFC-05, 06, 07, 11 | Naskah Babak 2 (definisi, penyebab, pencegahan) dan pesan penutup layar skor diterapkan dalam 3 bahasa. Analisis bersih dan 104 tes lulus. 60 screenshot tersimpan. | uild/review-chapter2-score/; [indeks bukti](../../docs/client-revisions/2026-10-23/kifc-05-06-07-11-visual-review.md) | Ditinjau |
| 2026-10-23 | KIFC-08 | Kuis gambut tiga bahasa, foto habitat, satu retry, pengungkapan B, feedback panjang serta penguncian input diterapkan. Analisis bersih; 119 tes lulus. D-05 sementara: 18/12 detik. | `build/review-kifc-08/`; [60 screenshot dan batas bukti](../../docs/client-revisions/2026-10-23/kifc-08-visual-review.md) | Ditinjau; durasi/naskah salah kedua dan uji TV fisik belum disetujui |
| 2026-10-23 | KIFC-08, koreksi interaksi | Judul/subjudul dipertahankan pada seluruh keadaan. Setelah benar, sentuhan berikutnya di seluruh layar melanjutkan dan membatalkan timer lama. Feedback dirapikan untuk layar kecil. | [60 render terbaru dan verifikasi](../../docs/client-revisions/2026-10-23/kifc-08-stable-heading-review.md) | Ditinjau; implementasi lokal |
| 2026-10-23 | KIFC-08, ukuran pilihan dan feedback | Kartu tetap 72 logical px setelah memilih; feedback benar ditempatkan di kiri maskot dan diratakan ke bawah. Judul/subjudul tetap, tap untuk lanjut masih aktif. | [60 render terbaru](../../docs/client-revisions/2026-10-23/kifc-08-side-feedback-review.md) | Ditinjau; lokal |
| 2026-10-23 | KIFC-08, jangkauan feedback | Balon benar/hint/reveal dinaikkan; maskot tetap di tepi bawah. Pada viewport TV jarak bawah balon minimal 7,5% tinggi layar; pilihan tetap 72 logical px dan tidak tertutup. | [60 render dan verifikasi terbaru](../../docs/client-revisions/2026-10-23/kifc-08-raised-feedback-review.md) | Ditinjau; uji fisik TV masih terbuka |
| 2026-10-23 | KIFC-02 | Layout tiga slot diperjelas, foto/crop/filter diselaraskan, percikan/udara/batu diterapkan. Semua pengecoh bisa dicoba, alasan spesifik dan feedback KIFC tersedia dalam tiga bahasa. Preview drag mengikuti skala. 151 tes lulus dan analisis bersih. | [60 render dan bukti](../../docs/client-revisions/2026-10-23/kifc-02-visual-review.md); baseline tersimpan terpisah | Ditinjau; lokal |
| 2026-10-23 | KIFC-02, koreksi pemilik | Tiga aset 404 karena bundel web lama dipulihkan melalui restart penuh dan diverifikasi manifest/HTTP/hash/browser. Placeholder tanpa label dan tanpa kategori tersembunyi; maskot setengah badan besar, instruksi diperjelas. 151 tes lulus. | [Bukti browser dan 60 render](../../docs/client-revisions/2026-10-23/kifc-02-empty-slots-review.md) | Ditinjau; lokal |
| — | D-01 s.d. D-11 | Isi setelah pembahasan yang relevan | Tautan persetujuan/catatan | Belum diputuskan |
| — | Tiket yang belum memiliki log implementasi | Isi per tiket, bukan satu klaim umum untuk semua layar | Commit, hasil pemeriksaan, screenshot/rekaman, perangkat | Belum dikerjakan |

### Pembaruan KIFC-02: feedback penyelesaian

- [x] Penjelasan tepat di bawah panel tiga unsur, dengan maskot sukses lebih besar dan tetap mencapai dasar layar.
- [x] Diperiksa lima ukuran portrait × tiga bahasa, termasuk 1080×1920 dan 2160×3840; 151 tes lulus.
- Bukti: [review dan screenshot](../../docs/client-revisions/2026-10-23/kifc-02-raised-completion-review.md). Status tetap Ditinjau; uji fisik TV belum dilakukan.

### Pembaruan lintas layar — rekaman api pemilik

- [x] Animasi api lama diganti rekaman `33072-395456627.mp4` pada assembly, penjelasan, demo pengurangan unsur, dan rambatan/sekat bakar.
- [x] Turunan transparan offline, rasio asli terjaga; panel tiga unsur tetap 190px, nyala berada di atas kartu dengan jarak yang jelas.
- [x] Api hanya tampil saat unsur lengkap; menyusut ketika satu unsur berkurang; batas rambatan berhenti sebelum sekat.
- [x] Poster untuk reduced motion, jeda saat tersembunyi/tidak aktif; sumber dan proses konversi dicatat di ASSET_SOURCES.md.
- [x] 168 tes lulus dan analisis bersih; bukti UI tiga bahasa/lima ukuran, termasuk Full HD/4K portrait. Server web dimulai ulang, aset terverifikasi manifest/HTTP/hash dan screenshot browser tersedia.
- Bukti: [rekaman api dan indeks screenshot](../../docs/client-revisions/2026-10-23/recorded-fire-review.md). Status Ditinjau; belum ada APK/deployment baru atau uji performa TV fisik. Perubahan aset ini tidak menutup keputusan konsep KIFC-04.

### Babak1 — mockup24Oktober, implementasi dan bukti

Empat keadaan layar direvisi tanpa mengubah urutan. Panel diperbesar, dropzone diperjelas, maskot diperkecil, ruang kosong demo dihilangkan. Enam titik api dari237888.mp4 berbagi komponen dan padam bertahap; tiga fase video berbeda, loop~1.76MB, sumber74.7MB tidak dibundel. Keputusan D-03 kini mengikuti instruksi langsung pemilik untuk mempertahankan serta memperbaiki demo. [Bukti screenshot semua ukuran/bahasa](../../docs/client-revisions/2026-10-23/chapter1-mockup-review-2026-10-24.md). 170tes lulus; status Ditinjau, uji TVfisik masih terbuka.


### Commit dan bukti 24 Oktober

- `2f17fc2` — checkpoint revisi terdahulu yang semula belum di-commit, termasuk empat layar Babak1 sesuai mockup. 170 tes lulus; [bukti Babak1](../../docs/client-revisions/2026-10-23/chapter1-mockup-review-2026-10-24.md). Commit ini sengaja mengelompokkan akumulasi lama; tiket berikutnya dicatat terpisah.
- `2f2cb9b` — KIFC-10: enam dampak/foto, terjemahan, ulasan, bonus berlabel dampak, dan timer30 detik sementara diterapkan. 185 tes lulus; [60 render, verifikasi dan batas bukti](../../docs/client-revisions/2026-10-23/kifc-10-impact-review.md). KIFC-10.05 tetap terbuka untuk durasi final pada TV fisik; D-07 tetap terbuka untuk aturan akhir.

- `28cd71d` — KIFC-G02: audit gerakan dan fallback poster saat rekaman gagal dimuat.20 tes terarah lulus, analisis bersih, [bukti15 kombinasi ukuran/bahasa dan fallback](../../docs/client-revisions/2026-10-23/kifc-g02-motion-review.md). G02.03 masih menunggu pengukuran performa TV; tidak ada fog/audio baru.

- `4a37ad8` — KIFC-X02: inventaris aktif, glosarium, status naskah, serta dua alur Korea lengkap dengan pemeriksaan teks tertinggal dan reset sesi. Tes lulus dan analisis bersih; [indeks bukti bahasa](../../docs/client-revisions/2026-10-23/kifc-x02-language-review.md). Review penutur Korea/klien tetap terbuka.

- `2f13709` — KIFC-09, persiapan: [usulan konkret dua format, naskah kartu, syarat lanjut dan konsekuensi skor](../../docs/client-revisions/2026-10-23/kifc-09-format-proposal.md) siap. Belum diterapkan; D-04/D-07 memerlukan keputusan klien. Urutan dan materi aktif tetap dipertahankan.

- `01f2693` — KIFC-G03: audit seluruh layar dan perbaikan overflow Android akibat cutout.33 render inset tiga bahasa dan APK offline tersedia; [audit visual serta bukti](../../docs/client-revisions/2026-10-23/kifc-g03-visual-audit.md). Preset kartu, urutan dan interaksi dipertahankan.

- `ca92786` — KIFC-G01: pemetaan variasi interaksi, transisi, respons sentuhan dan penguncian/pembatalan callback selesai diaudit terhadap implementasi.191 tes lulus; [rincian interaksi dan bukti](../../docs/client-revisions/2026-10-23/kifc-g01-interaction-review.md). Status Ditinjau.

- `105e32b` — KIFC-G04, persiapan: [cakupan konkret paket audio dan kriteria uji](../../docs/client-revisions/2026-10-23/kifc-g04-audio-scope.md) siap; tidak mengaktifkan suara sebelum D-08. Keputusan penundaan suara dari pemilik tetap berlaku.

- `d4ebbb2` — KIFC-X03:191 tes Flutter dan1 tes pemeriksa APK lulus, analisis bersih, APK debug/44 aset terverifikasi, smoke Android offline serta matriks cakupan siap. [Verifikasi integrasi, screenshot dan batas hasil](../../docs/client-revisions/2026-10-23/kifc-x03-integration-review.md). KIFC11: label dampak sudah diperbarui; rumus dan waktu baca TV tetap menunggu keputusan/uji. Tidak ada push/deployment.


## Ringkasan commit per tiket — 24 Oktober 2026

| Tiket/cakupan | Commit | Hasil |
|---|---|---|
| Checkpoint akumulasi sebelumnya + mockup Babak1 | `2f17fc2` | Revisi01–08 terdahulu dan empat keadaan Babak1; checkpoint awal diungkapkan sebagai kelompok |
| KIFC-10 | `2f2cb9b` | Tantangan dampak, foto offline, tiga bahasa, timer/ulasan; label bonus11 ikut selaras |
| KIFC-G02 | `28cd71d` | Fallback poster animasi dan audit gerakan |
| KIFC-X02 | `4a37ad8` | Alur Korea lengkap, pemeriksaan teks, inventaris/glosarium |
| KIFC-09 persiapan | `2f13709` | Dua usulan format/skor, belum mengganti layar aktif |
| KIFC-G03 | `01f2693` | Perbaikan inset/overflow Android, audit visual dan bukti APK |
| KIFC-G01 | `ca92786` | Pemetaan dan audit interaksi, respons serta transisi |
| KIFC-G04 persiapan | `105e32b` | Riwayat paket audio sebelum instruksi melanjutkan |
| KIFC-G04 implementasi | `5c8e282` | Musik/alam/efek internet CC0 offline, kontrol volume/mute,235 tes serta bukti web/Android |
| KIFC-09 implementasi | `a11eb8b` | Tiga kartu berputar, tanpa skor,60 render dan browser |
| KIFC-11 skor | `e3fb941` | Maksimum8, kategori proporsional,212 tes Flutter dan APK terbaru |
| KIFC-X01 integrasi | `c156395` | Urutan dipertahankan, aturan skor/state ditelusuri, spesifikasi lama ditandai superseded |
| KIFC-X03 | `d4ebbb2` | Pemeriksa APK, matriks integrasi,191 tes Flutter/1 tes Python,44 aset offline dan bukti |

Branch lokal: **main**. Belum push/deploy pada rangkaian pekerjaan ini. APK debug terbaru memuat kartu09 dan kategori skor8; build/hash serta batas verifikasi tercatat pada review KIFC-11. Preview web utama tetap pada http://localhost:8080/. AVD pengujian sudah dimatikan setelah bukti disimpan; data uji berada pada build di driveD, AVD asli tidak dipindahkan.

Pekerjaan tertunda yang tidak boleh dianggap implementasi selesai: penilaian akustik audio pada perangkat fisik/D-09, penilaian waktu baca D-05/D-06 dan jangkauan/performa TV D-09, pengesahan naskah/visual klien, serta rilis berikutnya. Seluruh persiapan konkret dan bukti lokal tertaut pada tiket masing-masing.


### Keputusan dan implementasi KIFC-09 — 24 Oktober

Commit `a11eb8b`: pemilik memilih kartu1–3 yang berputar dan membuka informasi, tanpa penilaian. Pertanyaan tindakan lama serta poinnya dihapus; maksimum sementara8 sebelum kategori hasil diselaraskan pada KIFC-11. [Indeks60 render, browser dan pemeriksaan](../../docs/client-revisions/2026-10-23/kifc-09-flip-review.md). Seluruh208 tes Flutter lulus dan analisis bersih. Tidak ada perubahan urutan layar, audio, push atau deployment.


### KIFC-11 — pemetaan maksimum8

Poin tindakan dihapus karena09 merupakan informasi, bukan soal. Maksimum8 = unsur3 + penyebab4 + bonus dampak≤1. Ambang kategori mengikuti rasio lama8/9 dan6/9; nilai7.25/7/5.5/5.25 diuji pada perjalanan lengkap dengan baca ulang kartu. [Screenshot hasil dan pemeriksaan](../../docs/client-revisions/2026-10-23/kifc-11-score8-review.md). KIFC-11.04 tetap menunggu uji baca TV fisik; tidak mengubah idle15detik tanpa bukti kebutuhan.


### KIFC-X01 — alur dan skor terintegrasi

Urutan layar dipertahankan: pembuka → susun unsur/feedback → penjelasan → demo pengurangan → bacaan Babak2 → kuis gambut → penyebab Babak3 → kartu karakteristik Babak4 → tantangan dampak → ulasan → hasil/penutup. KIFC-04 dan Babak3 tetap ada. Tiga kartu09 dibaca tanpa penilaian, lalu lanjut manual. Back/reset membatalkan proses persiapan serta menghapus progres kartu sesuai sesi. Skor dan kategori diuji pada perjalanan penuh, termasuk Korea.

Commit `a11eb8b` (KIFC-09) dan `e3fb941` (KIFC-11):212 tes Flutter lulus, analisis bersih, bukti lima ukuran/tiga bahasa tersedia. [Review kartu](../../docs/client-revisions/2026-10-23/kifc-09-flip-review.md), [hasil/skor8](../../docs/client-revisions/2026-10-23/kifc-11-score8-review.md). X01 Ditinjau; tidak menyatakan persetujuan klien atau kenyamanan TV fisik sudah selesai.


### KIFC-09 — koreksi foto dan dialog maskot

Tiga sampul foto berbeda diterapkan dengan grading seragam. Dialog menggunakan komponen feedback berbingkai netral, maskot presenting setengah badan lebih besar di kiri. Penghitung kartu dihapus; syarat lanjut setelah tiga kartu dibuka serta skor8 tetap. [60 render, lima ukuran dan tiga bahasa](../../docs/client-revisions/2026-10-23/kifc-09-visual-refinement.md). Status Ditinjau; bukti viewport tidak menggantikan uji TV fisik.

Commit koreksi KIFC-09: `13d3547`.17 tes kartu/visual dan21 tes perjalanan lengkap/Korea lulus; analisis bersih. Tidak ada push/deployment.


### KIFC-G04 — audio internet offline,24Oktober

Instruksi langsung pemilik membuka kembali audio dan meminta unduhan internet. Musik TinyWorlds, burung Joseph Sardin dan efek Kenney (CC0) diterapkan, total8 aset/1.21MB. Tombol speaker di seluruh layar, master/musik/alam/efek serta mute; nilai bertahan selama aplikasi hidup dan mulai setelah interaksi. Pilihan tantangan akhir netral, tanpa bocoran jawaban. Dua loop dan satu kanal efek dipakai ulang; pause pada inactive, tidak menumpuk saat ulang sesi.

235 tes Flutter lulus, analisis bersih,60 render lima ukuran/tiga bahasa tersedia. Pemutaran nyata web dan Android offline (airplane1/Wi-Fi0) menunjukkan playing, mute/master0 pause, resume dan efek tombol. APK/52 aset/hash diverifikasi. [Bukti lengkap, sumber, screenshot dan batas hasil](../../docs/client-revisions/2026-10-23/kifc-g04-audio-review.md). G04 Ditinjau; level/kenyamanan speaker TV42inci masih perlu uji fisik. X03.02 kini diperiksa lewat alur otomatis lengkap tiga bahasa; perjalanan manual seluruh layar APK tetap dicatat terpisah. Tidak ada push/deploy.

Commit implementasi KIFC-G04: `5c8e282` (branch main).235 tes Flutter lulus;6 tes audio terarah diulang setelah pemeriksaan perangkat dan tetap lulus. Analisis final bersih. APK debug,52 aset offline,60 render, pemutaran web dan smoke audio Android tercatat pada review. Belum push/deploy.


### KIFC-G04 — koreksi interaksi dan error web

Laporan pemilik: efek terlalu pelan, sejumlah tombol tidak berbunyi, dan audio kadang berhenti pada web. Klik diganti rekaman lebih panjang, level efek dinaikkan, tombol navigasi/dialog/penutup dan lanjut layar dilengkapi, akhir kuis memakai cue khusus. Semantics juga mengaktifkan audio. Sumber efek dimuat sekali dalam pemutar tetap; kegagalan satu cue tidak mematikan latar dan pemakaian berikutnya memulihkannya.239tes lulus, analisis bersih,60 render lima ukuran/tiga bahasa serta pemutaran/pemulihan browser nyata tersedia. [Rincian, screenshot dan batas bukti](../../docs/client-revisions/2026-10-23/kifc-g04-audio-feedback.md). APK belum dibangun ulang pada koreksi web ini. Status Ditinjau; kenyamanan speaker TV fisik masih terbuka. Tidak ada push/deployment.

Commit koreksi audio web KIFC-G04: `e8f471f` pada main.239tes lulus,17tes visual diulang, analisis bersih; bukti pemulihan dan akhir kuis pada Chromium terlampir. Belum push/deploy.


### KIFC-X03 — APK setelah koreksi audio

APK debug172309275bytes, SHA256 `33f9719443910319ff9c6dfb1e2fc6b0b560617c6affbd1774b6761e756f8bf6`,53 aset offline cocok. Tiga perjalanan native ID/EN/KO lulus sampai8/8, penutup dan replay0/3; finish masing-masing sekali, sumber disiapkan sekali sepanjang replay. Native mute/master0/background/resume serta persistensi saat pindah bahasa diperiksa.102 screenshot perjalanan1080p, enam pembanding720p dan satu pembuka4K tersedia. Tambahan4K membentur alokasi host; app tetap hidup dan override dipulihkan. [Bukti APK dan screenshot](../../docs/client-revisions/2026-10-23/kifc-x03-latest-apk-review.md), [observasi performa dengan batas NOT ASSESSED](../../production/polish/android-emulator-report-2026-10-24.md). Analisis bersih; tidak mengubah Dart/aturan game. Publikasi web/APK pengujian dicatat setelah diperiksa. Uji fisik TV, waktu baca, akustik, validasi naskah dan paket produksi bertanda tangan pemilik tetap terbuka.


Commit verifikasi KIFC-X03: `57f0467` pada main. [Workflow deploy sukses](https://github.com/NazwanSM/KIFC_Exhibition_Game/actions/runs/40075079187),239 tes CI lulus. [Site pertama](https://nazwansm.github.io/KIFC_Exhibition_Game/) terdeploy dari57f0467,53 entri aset/9 hash audio cocok serta pemutaran/mute publik diperiksa. [Prarilis APK pengujian dan20 screenshot](https://github.com/NazwanSM/KIFC_Exhibition_Game/releases/tag/review-2026-10-24-audio) sudah diunggah; digest/ukuran server cocok lokal. [Rincian publikasi](../../docs/client-revisions/2026-10-23/kifc-x03-latest-apk-review.md). X03.07 selesai untuk rilis pengujian; X03 keseluruhan masih sebagian karena TV fisik/performa produksi belum dinilai.


### KIFC-G01 — penyempurnaan animasi interaksi dan feedback

Permintaan pemilik24Oktober: tambahkan gerakan yang lebih interaktif dan halus, terutama kemunculan feedback maskot. Maskot/balon masuk berurutan, kontrol merespons tekanan, slot/penanda pilihan memberi konfirmasi singkat, penjelasan demo berganti lembut dan rincian hasil muncul bertahap. Empat pose disiapkan sejak awal untuk menghindari kemunculan terlambat setelah bubble. Tidak ada loop dekoratif baru; reduced motion langsung ke keadaan akhir, timer/state/skor/urutan tetap.

254 tes Flutter lulus pada kode akhir, analisis bersih,81 render (360×640/1080×1920/2160×3840 × tiga bahasa × sembilan keadaan) serta rekaman browser nyata tersedia. [Review, screenshot dan rekaman](../../docs/client-revisions/2026-10-23/kifc-g01-interaction-motion-review.md). Status G01 tetap Ditinjau; uji TV fisik/performa tetap terbuka. **Revisi gerakan ini masih lokal; Pages/APK prarilis57f0467 sebelumnya belum memuatnya.**

Commit implementasi dan bukti KIFC-G01: `531a0da` pada `main`. Preview utama lokal dimulai ulang memakai `lib/main.dart` pada http://localhost:8080/; entry review terpisah hanya digunakan untuk merekam keadaan layar.


### KIFC-04 — audit khusus dan perbaikan25Oktober

Menindaklanjuti koreksi pemilik: checklist04 sebelumnya tidak sinkron dan laporan umum terlalu menyamaratakan kelengkapan. Audit terhadap DOCX menemukan respons yang hampir sama, sentuhan ulang diabaikan serta auto-lanjut2,6detik yang terlalu singkat. Koreksi kini mencakup respons ilustratif berbeda, replay, Ulangi, badge unsur tiga bahasa, kelanjutan manual setelah3/3 dan fallback14detik yang dibatalkan saat eksplorasi/navigasi baru. Rekaman padam berhenti; reduced motion tidak menjalankan ticker tersembunyi. [Review dan bukti](../../docs/client-revisions/2026-10-25/kifc-04-reduction-review.md). Cabang penghapusan ditandai tidak berlaku, bukan dibiarkan sebagai pekerjaan tertunda. Status Ditinjau, tidak mengklaim pengesahan KIFC atau uji TV fisik.

Verifikasi KIFC-04 pada kode akhir:275tes Flutter lulus, analisis bersih;120render dan perjalanan browser ulang/reset/3pilihan/Lanjut diperiksa. Tidak ada APK/deployment baru untuk koreksi ini.

Commit khusus koreksi KIFC-04: `a7b6fa7` pada `main`, mencakup implementasi, tes regresi dan catatan bukti. Checklist04 kini selaras dengan cabang dipertahankan; penghapusan ditandai tidak berlaku.


### KIFC-04 — koreksi pemadaman per area secara kumulatif,25Oktober

Pemilik menilai perbedaan respons sebelumnya belum terlihat dan meminta dua api per area. Klarifikasi eksplisit: “Tetap padam; setiap pilihan memadamkan dua api tambahan.” Panas memadamkan kiri, Bahan bakar tengah, Oksigen kanan. Setiap pilihan baru mengurangi dua api; pilihan berulang tidak menyalakan kembali atau menambah progres. Ulangi memulihkan seluruh enam api. Kartu yang pernah dipakai tetap redup; instruksi tiga bahasa menjelaskan pasangan api di atas pilihan.

276tes lulus, analisis bersih,120render lima ukuran/tiga bahasa serta browser nyata (0error/0warning) diperiksa. Alur Lanjut tetap menuju kartu definisi; fallback14detik, skor dan urutan dipertahankan. [Review terbaru dan bukti](../../docs/client-revisions/2026-10-25/kifc-04-spatial-reduction-review.md). Belum APK/push/deploy atau uji TV fisik.

Commit koreksi kumulatif KIFC-04: `78eb6c9` pada `main`.


### KIFC-10 — keputusan durasi final,25Oktober

Pemilik menyatakan30detik cukup. Nilai yang sudah diterapkan dipertahankan; KIFC-10.05 dan D-06 ditutup sebagai keputusan durasi. Tidak ada perubahan aturan skor, awal countdown, ring atau warna. Uji TV fisik tetap bagian X03.


### KIFC-X01/G01 dan KIFC-11 — feedback serta hasil menunggu sentuhan,25Oktober

Pemilik meminta waktu membaca dahulu sekaligus kelanjutan cepat dengan menyentuh layar. Timer feedback2/12/14/18detik serta reset skor/penutup15detik dihapus. Kelanjutan latar tersedia setelah aktivitas lengkap dan pada bacaan/ulasan/hasil; jawaban/drop terakhir tidak sekaligus menutup feedback. Kembali/Ulangi/Main Lagi/audio/kredit foto/kartu tetap mendapat prioritas. Hint pertama serta aktivitas/tantangan aktif tidak dapat dilewati.

302tes Flutter lulus pada kode akhir, analisis bersih;105render lima ukuran/tiga bahasa dan perjalanan browser nyata diperiksa. Struktur semantics web diperbaiki setelah pemeriksaan menemukan penggabungan node/error scheduler. [Review dan bukti](../../docs/client-revisions/2026-10-25/manual-reading-review.md). KIFC-11 kini Ditinjau untuk implementasi; TV fisik tetap X03. Keputusan ini menggantikan semua durasi feedback/reset hasil dalam log historis, tanpa mengubah urutan atau skor.

Catatan lingkungan G04: saat uji browser terdapat satu error sumber suara burung. Network mencatat204 “Intercepted by the IDM Advanced Integration”, disusul200. Ini bukan klaim audio sudah bersih atau bug aplikasi telah diperbaiki; log/batas hasil tersedia di review. Pengaturan ekstensi pengguna tidak diubah. Belum APK/push/deploy baru.

Commit keputusan durasi KIFC-10: `4d04fbb` pada `main`.

Commit kelanjutan membaca/manual KIFC-X01/G01/11: `635d303` pada `main`.


### KIFC-X01/G01/11 — klarifikasi feedback15detik dan sentuhan cepat,25Oktober

Pemilik mengoreksi penafsiran tanpa batas waktu: “kalau ada feedback dan hasil itu tetep ada waktunya sekitar15detik tapi bisa dilanjutkan dengan menekan layar”. Timer bersama15detik kini diterapkan pada feedback selesai, ulasan dampak, skor dan penutup. Sentuhan memajukan lebih cepat dan membatalkan deadline lama. Dialog terbuka/aplikasi tidak aktif menjeda sisa waktu. Bacaan penjelasan, kartu informasi dan hint percobaan pertama tetap manual; tantangan akhir tetap30detik.

[Review terbaru dan bukti](../../docs/client-revisions/2026-10-25/feedback15-review.md) menggantikan aturan tanpa timer pada log sebelumnya. Tidak mengubah urutan, skor, foto atau geometri komponen. Belum APK/push/deploy baru.

Verifikasi koreksi15detik:313tes Flutter lulus, analisis bersih,105render lima ukuran/tiga bahasa diperiksa. Browser menunjukkan feedback tetap pada14detik, lanjut otomatis sekitar15detik, sentuhan cepat serta pembatalan deadline lama berfungsi.

Commit koreksi feedback/hasil15detik: `876cafa` pada `main`.

### Pengujian menyeluruh dan paket review klien — 25 Oktober

313 tes Flutter dan analisis lulus. Browser release serta APK debug offline melewati alur penuh ID/EN/KO; APK release final setelah koreksi label diuji ulang tiga bahasa sampai 8/8, penutup dan replay 0/3. 53 hash aset cocok; 9 sumber audio decode/playback dan kontrol diperiksa, termasuk mute/master 0/layer, pause/resume native serta pemulihan efek setelah 503 buatan. Feedback 15 detik/dialog/sentuhan dan tantangan 30 detik dipertahankan. 951 render berdimensi tervalidasi serta inspeksi representatif seluruh tahap utama tersedia.

Nama launcher internal diperbaiki melalui commit `5d101d6`; alat QA disesuaikan dengan timer/transisi dan pelaporan release tanpa counter debug. [Laporan lengkap](../../docs/client-revisions/2026-10-25/end-to-end-review.md), [hasil mesin](../../production/qa/e2e-results-2026-10-25.json), [paket klien](../../build/review-e2e-2026-10-25/KIFC-Client-Update-2026-10-25.zip) memuat APK release review 1.0.1 (20261025), PDF, 37 PNG asli dan checksum. SHA256 APK `e01e1367d5ec3e47fecddf870361ec764c6dc3ef440611087049130ac4ba4fba`.

Tidak ditemukan penghambat pada skenario akhir. Status pengesahan klien tidak otomatis ditutup: TV 42 inci fisik, performa, akustik, naskah/terjemahan, kunci signing produksi dan publikasi terbaru tetap terbuka. Tidak ada push/deploy pada sesi ini.

Commit QA dan paket review: `98b6e79` pada `main`; koreksi launcher terpisah `5d101d6`. ZIP final 95.469.426 byte, SHA256 `a7b89a5d782b4fa675cc1849086488fe01ab1fa18f7a837beab2277b1c2f8753`; seluruh checksum, CRC/salinan ZIP dan PDF 2 halaman diverifikasi.


### KIFC-09/03 — penempatan maskot, bubble dan tombol, 25 Oktober

KIFC-09: bubble dipusatkan sejajar dengan maskot dan celah sebelum tombol dihapus, sehingga crop badan menyentuh tombol. Commit `2e4eb17`. KIFC-03: maskot presenting di kiri, CTA di kanan dengan label satu baris; posisi vertikal adaptif menjaga jangkauan tengah pada simulasi TV. Commit `6960a02`.

64 tes terarah lulus, analisis akhir bersih, 75 render fokus tiga bahasa/lima ukuran portrait tersedia. APK release 1.0.2 (20261026) dibangun ulang dan dipasang di emulator; smoke native Inggris memeriksa kedua layar, termasuk koordinat CTA kanan dan bubble yang sudah turun. AOT pada tiga ABI diverifikasi memuat key UI baru setelah cache awal sempat menghasilkan kode lama. 53 hash aset cocok; SHA256 APK final `7ea9d3e3fe32d49ae58e3b7ce1c15650cfc5472bef23a870c10b17f3cdd9941d`.

[Review09](../../docs/client-revisions/2026-10-25/mascot-card-alignment-review.md), [review03](../../docs/client-revisions/2026-10-25/triangle-cta-alignment-review.md), [hasil](../../docs/client-revisions/2026-10-25/mascot-alignment-results.json), [indeks screenshot](../../build/review-mascot-alignment-2026-10-25/evidence-index.json). Web lokal dibangun ulang; tidak push/deploy. Paket ZIP E2E sebelumnya tetap merupakan bukti sebelum minor revision ini dan tidak ditimpa. TV fisik tetap belum diuji.

### Tambahan BRAND-01 — ikon aplikasi yang disetujui, 27 Oktober

Pemilik proyek menyetujui konsep maskot minimalis v3 dan meminta penerapan. Ikon telah dipasang pada launcher Android legacy/adaptive, favicon, ikon pemasangan web/maskable, dan Apple touch icon. Metadata nama/warna web serta gambar header README disesuaikan. Commit implementasi `7d8926e` pada `main` lokal; ini tambahan branding dari percakapan, bukan perubahan status persetujuan 18 kelompok tiket DOCX.

Analisis bersih, 17 tes pembuka/shell web lulus, build web dan APK review 1.0.3 (20261027) berhasil. Seluruh 16 ekspor dapat direproduksi; sepuluh PNG native cocok per piksel di APK, 53 aset runtime cocok, dan manifest/enam PNG web terverifikasi HTTP/hash. Ikon diperiksa pada launcher/App info emulator API35 1080×1920/density420; sentuhan ikon membuka permainan. [Review dan screenshot](../../docs/client-revisions/2026-10-27/app-icon-review.md), [hasil terstruktur](../../docs/client-revisions/2026-10-27/app-icon-results.json).

APK lokal: `build/review-app-icon-2026-10-27/KIFC-Review-1.0.3.apk`, SHA256 `dffab3b3299c25d43b50b1054a03e8a641b4dffc0de5c5d2190ea9fa852dd52d`. Sertifikat tetap Android Debug untuk review. Belum push/deploy; tidak ada perubahan kode Dart/gameplay atau pengujian TV fisik baru.

### KIFC-01 — bubble utuh dan sinkronisasi animasi, 27 Oktober

Laporan ekor welcome tertinggal saat pergantian bahasa ditangani bersama permintaan lanjutan agar bentuknya menyatu seperti chat bubble. Commit `5cd094f`: satu path untuk kotak/ekor/border/shadow di dalam satu `MotionReveal`, serta pemicu berbasis bahasa dan pesan untuk maskot/bubble. Perpindahan langsung Indonesia–Korea kini ikut memutar animasi; memilih bahasa aktif tidak mengulang. Arah kanan pada percakapan penutup juga diperiksa.

Tiga kasus direproduksi sebelum fix, kemudian 30 tes terkait lulus dan analisis bersih. Bukti terdiri dari 45 frame welcome (tiga bahasa × lima ukuran × tiga fase) dan tiga penutup, ditambah rekaman kontrol bahasa asli di browser. Build web release terverifikasi melalui hash bundle yang dilayani. APK review 1.0.4 (20261028) berhasil, tiga ABI memuat kelas bubble baru dan 53 hash aset cocok; runtime native/TV fisik tidak diuji ulang. [Review](../../docs/client-revisions/2026-10-27/welcome-bubble-review.md), [hasil](../../docs/client-revisions/2026-10-27/welcome-bubble-results.json), [rekaman browser](../../docs/client-revisions/2026-10-27/welcome-bubble/language-switch.mp4).

APK lokal `build/review-welcome-tail-2026-10-27/KIFC-Review-1.0.4.apk`, SHA256 `cef7eff623b50dcc26f4760e11eaddf65360d356cd90cb7e4c36f655f6b43a3f`, tetap sertifikat Android Debug. Fix ini masih lokal dan belum push/deploy; tidak mengubah skor, urutan layar, naskah, atau audio.
