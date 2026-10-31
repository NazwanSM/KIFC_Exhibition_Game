# KIFC-R30-12 — Riset awal suara dan audisi

Diperiksa 31 Oktober 2026. Status: dua sampel suara gratis dibuat secara lokal; belum dipilih. Tiga bahasa dan pelafalan perlu didengarkan sebelum keputusan.

## Kandidat audisi

1. **Azure Speech, `en-US-AndrewMultilingualNeural`** sebagai kandidat satu identitas suara lintas bahasa; dokumentasi Microsoft mencantumkan `id-ID`, `en-US`, dan `ko-KR` untuk voice ini. Ini dugaan awal, bukan penilaian suara: aksen, karakter dan pelafalan tetap harus didengarkan. Ketersediaan voice bergantung region/resource.
2. Pembanding voice lokal: `id-ID-ArdiNeural`, `en-US-GuyNeural`, dan `ko-KR-InJoonNeural`. Identitas tiap bahasa berbeda, tetapi dapat dibandingkan untuk kealamian bahasa. Semua adalah kandidat, bukan pilihan final.

Sumber: [daftar voice Azure](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/language-support?tabs=tts) dan [bahasa voice multilingual](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-synthesis-markup-voice#multilingual-voices-with-the-lang-element). Voice dan bahasa tetap perlu dicek pada resource yang benar.

## Akses, biaya, dan ketentuan

- Tidak ditemukan konfigurasi resource Azure Speech melalui pemeriksaan nama variabel lingkungan; keberadaan akun lain belum diketahui. Jangan memasukkan kunci ke repo atau chat.
- [Harga Speech Microsoft](https://azure.microsoft.com/en-us/pricing/details/speech/) mencantumkan kuota F0 neural 0,5 juta karakter per bulan pada saat diperiksa; kelayakan, region, limit, serta tarif berbayar bergantung resource/akun. Ini bukan jaminan akun memiliki kuota atau bahwa semua model/region gratis. Biaya aktual dan mata uang belum diverifikasi.
- Lima draf masing-masing berisi sekitar 715 karakter ID, 643 EN dan 299 KO (1.657 total, hitungan teks Python; belum termasuk SSML, ulangan, dan audisi). Pemakaian ditagihkan menurut aturan penyedia; [rincian karakter](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/text-to-speech#pricing-note). Sesi ulangan menambah pemakaian.
- [Transparency note Microsoft](https://learn.microsoft.com/en-us/azure/foundry/responsible-ai/speech-service/text-to-speech/transparency-note) menyebut penggunaan prebuilt neural voice dalam aplikasi yang kontennya ditentukan pelanggan dan tunduk pada ketentuan Azure. Izin distribusi untuk kontrak, tier, dan wilayah akun yang dipakai masih harus diverifikasi; tidak mengklaim hak universal atau menetapkan biaya final.
- Azure Speech SDK mendokumentasikan [event WordBoundary](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/how-to-speech-synthesis), namun ketersediaan dan kecocokan timing harus dibuktikan untuk voice dan bahasa yang terpilih; validasi Korea/eojel pada tiket 13.

## Langkah audisi

Buat klip pendek sapaan dan kalimat uji dari `naskah.md` untuk tiap locale; bandingkan kandidat multilingual dengan pembanding lokal bila akses tersedia. Simpan provider, voice ID, locale, region, teks, setting, durasi, hash dan perkiraan penggunaan tiap klip. Periksa karhutla, gambut dan Manggala Agni; minta pemilik menilai karakter suara sebelum produksi 15 klip. Jika Azure tak tersedia, pilih alternatif setelah memeriksa izin distribusi dan biaya; jangan memakai layanan demo tak resmi sebagai lisensi produksi.

## Audisi gratis — Supertonic 3

Pengguna meminta opsi gratis terlebih dahulu. Supertonic 3 oleh Supertone mendukung ID/EN/KO dan berjalan di CPU lokal setelah mengunduh model; tidak ada panggilan API atau biaya per karakter pada pembuatan sampel ini. Sumber: [model resmi](https://huggingface.co/Supertone/supertonic-3). Kode contoh MIT; bobot model menggunakan [BigScience Open RAIL-M](https://huggingface.co/Supertone/supertonic-3/blob/main/LICENSE), yang memiliki batasan penggunaan. Pasal 6 menyatakan pemberi lisensi tidak mengklaim hak atas output dengan ketentuan lisensi tetap berlaku; tinjau ketentuan lengkap untuk proyek/distribusi sebelum produksi.

Sampel **M1** dan **M2**, versi SDK 1.3.1, model supertonic-3, dibuat lokal menggunakan teks sapaan draf; preset sama untuk ketiga bahasa, 8 langkah dan speed 1.05. Setiap trek gabungan mengurutkan Indonesia, Inggris, Korea dengan jeda 0,8 detik. File individual, durasi dan SHA-256 tercatat dalam [manifest](audition-supertonic3/manifest.json). Delapan MP3 lulus decode, enam WAV asal memiliki sinyal bukan hening. Belum dinilai kualitas, pelafalan, kecocokan karakter, hak distribusi spesifik proyek, maupun timing kata; tidak ada audio dimasukkan ke aplikasi. Jangan menandai kandidat sebagai dipilih sebelum pemilik mendengarkan.

- [Dengarkan M1 — ID / EN / KO](audition-supertonic3/M1-id-en-ko.mp3)
- [Dengarkan M2 — ID / EN / KO](audition-supertonic3/M2-id-en-ko.mp3)

Sebagai alternatif, Azure F0 mencantumkan kuota gratis terbatas (lihat bagian akses), tetapi resource belum tersedia; jangan menyamakan kuota tersebut dengan akses gratis tanpa syarat. Supertonic tidak menjamin timestamp kata melalui proses audisi yang dipakai; untuk subtitle tiket 13 diperlukan alignment nyata dan validasi terpisah.

## Audisi lanjutan — karakter lebih ramah/lembut

Pemilik menilai kompatibilitas M1/M2 baik, tetapi meminta karakter lebih ramah atau lembut. Tiga preset lain dipersiapkan untuk dibandingkan: M3, M4, M5, semuanya dari Supertonic 3. Gunakan teks sapaan yang sama dan urutan ID → EN → KO. Kecepatan 1.0 (contoh sebelumnya 1.05); perbedaan tempo harus dipertimbangkan ketika membandingkan karakter. Preset dipilih sebagai kandidat, belum dinilai secara subjektif lebih ramah/lembut.

- [M3](audition-supertonic3-soft/M3-id-en-ko.mp3)
- [M4](audition-supertonic3-soft/M4-id-en-ko.mp3)
- [M5](audition-supertonic3-soft/M5-id-en-ko.mp3)

Seluruh 12 MP3 (9 individual dan 3 gabungan) lolos decode; sembilan audio sumber tidak hening. [Manifest](audition-supertonic3-soft/manifest.json) mencatat voice, teks, locale, durasi, dan hash. Hasil belum diuji penutur Korea atau disetujui pemilik; belum dipakai di game.
