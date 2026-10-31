# KIFC-R30-12 — Riset awal suara dan audisi

Diperiksa 31 Oktober 2026. Status: riset dan naskah disiapkan; belum ada audio yang disintesis atau dipilih. Tiga bahasa dan pelafalan perlu didengarkan sebelum keputusan.

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
