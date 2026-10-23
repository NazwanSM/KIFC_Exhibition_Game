# Preview web dengan kanvas portrait tetap

Tanggal: 23 Oktober 2026. Permintaan pemilik: tampilan dalam mockup tidak berubah susunan ketika ukuran browser berubah.

## Implementasi

`WebPortraitShell` memakai kanvas tetap 411 × 730,667 logical pixel (9:16). `FittedBox` menskalakan seluruh kanvas secara seragam ke ruang browser. Constraints dan MediaQuery di dalam permainan tetap sama; font, jarak, wrapping, dan posisi elemen tidak berganti breakpoint akibat resize browser. Radius sudut ikut diskalakan. Bingkai tetap di tengah dengan latar hijau pada ruang tersisa.

Pembungkus dipanggil hanya ketika `kIsWeb`; layout APK tetap menggunakan ukuran perangkat dan aturan jangkauan TV yang ada. Preview web ini mempertahankan komposisi kanvas referensi, bukan pengganti pengujian layout APK/TV fisik.

## Verifikasi

- Tes regresi mula-mula gagal pada implementasi lama: MediaQuery menjadi 488,25 × 868 ketika browser 1440 × 900, bukan ukuran kanvas tetap.
- Sesudah perubahan, tes resize memeriksa ukuran layout/MediaQuery konstan, rasio global 9:16, tidak terpotong viewport, dan tombol tetap bisa ditekan setelah lima resize.
- Seluruh suite saat perubahan produk selesai: 120 tes lulus. Setelah menambahkan matriks bukti, 16 tes preview lulus (15 bahasa/ukuran + 1 resize/interaksi). [Log suite](../../../build/web-preview-tests.log), [log preview](../../../build/web-preview-capture.log).
- `flutter analyze`: No issues found. `git diff --check`: tidak ada kesalahan whitespace.
- Screenshot browser nyata disimpan dan ditinjau: [Indonesia, viewport terukur 1000 × 750](../../../build/review-web-fixed/browser-id-1000x750.png). Ukuran terukur berbeda dari pengaturan preview yang diminta; gunakan dimensi gambar, bukan label pengaturan, sebagai sumber ukuran screenshot browser ini.
- Matriks di bawah adalah **render widget Flutter** dengan font/foto aktual, bukan screenshot browser atau foto TV. Sampel Indonesia desktop, Inggris mobile, dan Korea 4K diperiksa visual; seluruh kombinasi diuji tidak mengalami exception layout. Tidak ada pengujian fisik TV atau deployment pada pekerjaan ini.

## Bukti render tiga bahasa

| Viewport | Indonesia | Inggris | Korea |
|---|---|---|---|
| 1440x900 | [ID](../../../build/review-web-fixed/welcome-id-1440x900.png) | [EN](../../../build/review-web-fixed/welcome-en-1440x900.png) | [KO](../../../build/review-web-fixed/welcome-ko-1440x900.png) |
| 800x600 | [ID](../../../build/review-web-fixed/welcome-id-800x600.png) | [EN](../../../build/review-web-fixed/welcome-en-800x600.png) | [KO](../../../build/review-web-fixed/welcome-ko-800x600.png) |
| 390x844 | [ID](../../../build/review-web-fixed/welcome-id-390x844.png) | [EN](../../../build/review-web-fixed/welcome-en-390x844.png) | [KO](../../../build/review-web-fixed/welcome-ko-390x844.png) |
| 1080x1920 | [ID](../../../build/review-web-fixed/welcome-id-1080x1920.png) | [EN](../../../build/review-web-fixed/welcome-en-1080x1920.png) | [KO](../../../build/review-web-fixed/welcome-ko-1080x1920.png) |
| 2160x3840 | [ID](../../../build/review-web-fixed/welcome-id-2160x3840.png) | [EN](../../../build/review-web-fixed/welcome-en-2160x3840.png) | [KO](../../../build/review-web-fixed/welcome-ko-2160x3840.png) |

Regenerasi dengan PowerShell:

```powershell
$env:KIFC_CAPTURE='1'
$env:KIFC_CAPTURE_DIR='build/review-web-fixed'
flutter test test/web_portrait_shell_test.dart --reporter expanded
```

File `build/` merupakan artefak lokal yang diabaikan Git.
